//
//  AVpalyerView.m
//  CodeAVPlayer
//
//  Created by zkingsoft on 2018/4/25.
//  Copyright © 2018年 code. All rights reserved.
//

#import "AVplayerView.h"
#import "DpxSizeConvert.h"

@interface AVplayerView()

@property (nonatomic , strong) AVPlayer *player;

@property (nonatomic , strong) AVPlayerLayer *playerLayer;

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) UIView *toolView;

@property (nonatomic , strong) UIButton *playerPauseBtn;

@property (nonatomic , strong) UIButton *miniMaxBtn;

@property (nonatomic , strong) UISlider *progressSliser;

@property (nonatomic , strong) UILabel *timeLabel;

// 记录当前是否显示了工具栏
@property (assign, nonatomic) BOOL isShowToolView;

/* 定时器, 用作更新播放进度 */
@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation AVplayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    
    self.toolView.alpha = 0;
    self.isShowToolView = NO;
    
    [self removeProgressTimer];
    [self addProgressTimer];
    
    self.playerPauseBtn.selected = YES;
    [self miniMaxBtn];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 设置播放的视频
- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}

- (void)addProgressTimer {
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:(NSRunLoopCommonModes)];
}

- (void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressTimer {
    self.timeLabel.text = [self timeString];
    
    self.progressSliser.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}

- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dMin, (long)dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long)cMin, (long)cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}


/**
 触摸事件
 
 @param sender sender
 */
- (void)tapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.toolView.alpha = 0;
            self.isShowToolView = NO;
        } else {
            self.toolView.alpha = 1;
            self.isShowToolView = YES;
        }
    }];
}


/**
 暂停按钮点击事件
 
 @param sender button
 */
- (void)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        
        [self addProgressTimer];
    } else {
        [self.player pause];
        
        [self removeProgressTimer];
    }
}

- (void)slider {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSliser.value;
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)startSlider {
    [self removeProgressTimer];
}

- (void)sliderValuChange {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSliser.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

// 切换屏幕的方向
- (void)switchOrientation:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(playerViewDidClickFullScreen:)]) {
        [self.delegate playerViewDidClickFullScreen:sender.selected];
    }
}

#pragma mark - lazyLoad
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        _timeLabel.font = FontOfSize(dpxWSize(32));
        
        CGFloat x = CGRectGetMaxX(self.progressSliser.frame) + dpxWSize(15);
        CGFloat y = (dpxWSize(100) - CGRectGetHeight(_timeLabel.frame)) / 2;
        _timeLabel.frame  = CGRectMake(x, y, dpxWSize(200), CGRectGetHeight(_timeLabel.frame));
        
        [self.toolView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setImage:[UIImage imageNamed:@"bg_media_default"]];
        [self addSubview:_imageView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_imageView addGestureRecognizer:tapGestureRecognizer];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
        [_toolView setBackgroundColor:[UIColor grayColor]];
        
        CGFloat height = dpxWSize(100);
        CGFloat y = self.frame.size.height - height;
        _toolView.frame = CGRectMake(0, y, self.frame.size.width, height);
        [self addSubview:_toolView];
    }
    return _toolView;
}

- (UIButton *)playerPauseBtn {
    if (!_playerPauseBtn) {
        _playerPauseBtn = [[UIButton alloc] init];
        [_playerPauseBtn setBackgroundImage:[UIImage imageNamed:@"full_play_btn_hl"] forState:UIControlStateNormal];
        [_playerPauseBtn setBackgroundImage:[UIImage imageNamed:@"full_pause_btn_hl"] forState:UIControlStateSelected];
        [_playerPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat height = dpxWSize(100);
        _playerPauseBtn.frame = CGRectMake(0, 0, height, height);
        
        [self.toolView addSubview:_playerPauseBtn];
    }
    return _playerPauseBtn;
}

- (UIButton *)miniMaxBtn {
    if (!_miniMaxBtn) {
        _miniMaxBtn = [[UIButton alloc] init];
        [_miniMaxBtn setBackgroundImage:[UIImage imageNamed:@"full_minimize_btn_hl"] forState:UIControlStateNormal];
        [_miniMaxBtn addTarget:self action:@selector(switchOrientation:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat height = dpxWSize(100);
        _miniMaxBtn.frame = CGRectMake(self.frame.size.width - height, 0, height, height);
        
        [self.toolView addSubview:_miniMaxBtn];
    }
    return _miniMaxBtn;
}

- (UISlider *)progressSliser {
    if (!_progressSliser) {
        _progressSliser = [[UISlider alloc] init];
        [_progressSliser setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
        [_progressSliser setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
        [_progressSliser setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
        //
        [_progressSliser addTarget:self action:@selector(sliderValuChange) forControlEvents:UIControlEventValueChanged];
        [_progressSliser addTarget:self action:@selector(startSlider) forControlEvents:UIControlEventTouchDown];
        [_progressSliser addTarget:self action:@selector(slider) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGFloat width = self.frame.size.width - dpxWSize(100) * 2 - dpxWSize(35) - dpxWSize(200);
        CGFloat y = (dpxWSize(100) - CGRectGetHeight(_progressSliser.frame)) / 2;
        
        _progressSliser.frame = CGRectMake(CGRectGetMaxX(self.playerPauseBtn.frame) - dpxWSize(10), y, width, CGRectGetHeight(_progressSliser.frame));
        
        [self.toolView addSubview:_progressSliser];
    }
    return _progressSliser;
}

@end

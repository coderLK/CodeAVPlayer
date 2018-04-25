//
//  VIdeoPlayViewController.m
//  CodeAVPlayer
//
//  Created by zkingsoft on 2018/4/25.
//  Copyright © 2018年 code. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "AVplayerView.h"

@interface VideoPlayViewController ()<AVPlayerViewDelegate>

@property (nonatomic , strong) AVplayerView *playerView;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)dismissClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.playerView.frame = self.view.bounds;
}


- (void)setVideoUrl:(NSString *)videoUrl
{
    if (!videoUrl.length) {
        return;
    }
    
    _videoUrl = videoUrl.copy;
    
    NSURL *url = [NSURL URLWithString:_videoUrl];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.playerView.playerItem = item;
}

- (AVplayerView *)playerView
{
    if(_playerView == nil)
    {
        _playerView = [[AVplayerView alloc] initWithFrame:self.view.bounds];
        _playerView.delegate = self;
        [self.view addSubview:_playerView];
    }
    return _playerView;
}


#pragma mark - NJPlayerViewDelegate
- (void)playerViewDidClickFullScreen:(BOOL)isFull
{
    [self dismissClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  AVpalyerView.h
//  CodeAVPlayer
//
//  Created by zkingsoft on 2018/4/25.
//  Copyright © 2018年 code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol AVPlayerViewDelegate <NSObject>

@optional

- (void)playerViewDidClickFullScreen:(BOOL)isFull;

@end

@interface AVplayerView : UIView

@property (nonatomic , weak) id<AVPlayerViewDelegate>delegate;

@property (nonatomic , strong) AVPlayerItem *playerItem;

@end

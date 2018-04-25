//
//  ViewController.m
//  CodeAVPlayer
//
//  Created by zkingsoft on 2018/4/25.
//  Copyright © 2018年 code. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitle:@"视频播放" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)pushVC {
    VideoPlayViewController *videoVc = [[VideoPlayViewController alloc] init];
    videoVc.videoUrl = @"http://wvideo.spriteapp.cn/video/2018/0419/c29ae3e8437b11e892f5842b2b4c75ab_wpd.mp4";
    
    [self presentViewController:videoVc animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

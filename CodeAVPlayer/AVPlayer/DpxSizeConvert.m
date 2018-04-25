//
//  DpxSizeConvert.m
//  CodeAVPlayer
//
//  Created by zkingsoft on 2018/4/25.
//  Copyright © 2018年 code. All rights reserved.
//

#import "DpxSizeConvert.h"


@implementation DpxSizeConvert

+(CGFloat)dpxHightSize:(CGFloat)dpx {
    if (IPHONE_6) {                     //PT 375 * 667   ，PX 750x1334 320x568
        //        return dpx/1334 * 667.0;
        return dpx * 667.0/1920;
        
    }else if (IPHONE_5) {
        return dpx * 568.0/1920;
    }else if (IPHONE_X) {
        return dpx * 812 / 1920;
    }else {
        return dpx/1920 * 736.0;        //PT 414 * 736 , PX 1080x1920
    }
}
+(CGFloat)dpxWidthSize:(CGFloat)dpx  {
    if (IPHONE_6) {
        //        return dpx/720 * 375.0;
        return dpx * 375.0/1080.0;
    }else if (IPHONE_5) {
        return dpx * 320.0/1080.0;
    }
    else{
        return dpx/1080 * 414.0;
    }
}


+(CGFloat)dpx_1242_WidthSize:(CGFloat)dpx  {
    if (IPHONE_6) {
        //        return dpx/720 * 375.0;
        return dpx * 375.0/1242.0;
    }else if (IPHONE_5) {
        return dpx * 320.0/1242.0;
    }
    else{
        return dpx/1242.0 * 414.0;
    }
}

@end

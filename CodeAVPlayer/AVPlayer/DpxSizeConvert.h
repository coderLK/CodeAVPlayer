//
//  DpxSizeConvert.h
//  CodeAVPlayer
//
//  Created by zkingsoft on 2018/4/25.
//  Copyright © 2018年 code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DpxSizeConvert : NSObject

#define FontOfSize(i) [UIFont systemFontOfSize:i]

#define IPHONE_4S (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)
#define IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < DBL_EPSILON)
#define IPHONE_6P (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < DBL_EPSILON)
#define IPHONE_X (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)812) < DBL_EPSILON)

#define dpxHSize(size) [DpxSizeConvert dpxHightSize:size]
#define dpxWSize(size) [DpxSizeConvert dpxWidthSize:size]
#define dpxW1242Size(size) [DpxSizeConvert dpx_1242_WidthSize:size]

+(CGFloat)dpxHightSize:(CGFloat)dpx ;
+(CGFloat)dpxWidthSize:(CGFloat)dpx ;
+(CGFloat)dpx_1242_WidthSize:(CGFloat)dpx;

@end

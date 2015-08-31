//
//  UIColor+LIPRGB8Bit.m
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "UIColor+LIPRGB8Bit.h"

@implementation UIColor (LIPRGB8Bit)
#pragma mark - Public Interface

+ (UIColor *)colorWith8BitRed:(CGFloat)red
                        green:(CGFloat)green
                         blue:(CGFloat)blue
                        alpha:(CGFloat)alpha {
    float denominator = 255.f;
    return [UIColor colorWithRed:red/denominator
                           green:green/denominator
                            blue:blue/denominator
                           alpha:alpha];
}
@end

//
//  UIColor+LIPRGB8Bit.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LIPRGB8Bit)
+ (UIColor *)colorWith8BitRed:(CGFloat)red
                        green:(CGFloat)green
                         blue:(CGFloat)blue
                        alpha:(CGFloat)alpha;
@end

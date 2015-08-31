//
//  LIPGeometry.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGPoint LIPCGPointAdd(const CGPoint a, const CGPoint b);
extern CGPoint LIPCGPointSubtract(const CGPoint minuend, const CGPoint subtrahend);
extern CGFloat LIPDegreesToRadians(const CGFloat degrees);
extern CGRect LIPCGRectExtendedOutOfBounds(const CGRect rect,
                                           const CGRect bounds,
                                           const CGPoint translation);
//
//  LIPGeometry.m
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "LIPGeometry.h"

#pragma mark - Public Interface

CGPoint LIPCGPointAdd(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x + b.x,
                       a.y + b.y);
}

CGPoint LIPCGPointSubtract(const CGPoint minuend, const CGPoint subtrahend) {
    return CGPointMake(minuend.x - subtrahend.x,
                       minuend.y - subtrahend.y);
}

CGFloat LIPDegreesToRadians(const CGFloat degrees) {
    return degrees * (M_PI/180.0);
}

CGRect LIPCGRectExtendedOutOfBounds(const CGRect rect,
                                    const CGRect bounds,
                                    const CGPoint translation) {
    CGRect destination = rect;
    while (!CGRectIsNull(CGRectIntersection(bounds, destination))) {
        destination = CGRectMake(CGRectGetMinX(destination) + translation.x,
                                 CGRectGetMinY(destination) + translation.y,
                                 CGRectGetWidth(destination),
                                 CGRectGetHeight(destination));
    }
    
    return destination;
}

//
//  LIPSwipeDirection.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//


#import <Foundation/Foundation.h>

/*!
 * LIPSwipeDirection represents the direction of a swipe. For example,
 * `LIPSwipeToChooseView` considers a swipe to the left as negative,
 * and a swipe to the right as positive.
 */
typedef NS_ENUM(NSInteger, LIPSwipeDirection) {
    LIPSwipeDirectionNone   = 1,
    LIPSwipeDirectionLeft   = 1 << 1,
    LIPSwipeDirectionRight  = 1 << 2,
    LIPSwipeDirectionUp     = 1 << 3,
    LIPSwipeDirectionDown   = 1 << 4
};
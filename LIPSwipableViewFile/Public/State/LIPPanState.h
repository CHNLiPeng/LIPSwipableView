//
//  LIPPanState.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LIPSwipeDirection.h"
/*!
 * An object representing the state of the current pan gesture.
 * This is provided as an argument to `LIPSwipeToChooseOnPanBlock` callbacks.
 */

@interface LIPPanState : NSObject


/*!
 * The view being panned.
 */
@property (nonatomic, strong) UIView *view;

/*!
 * The direction of the current pan. Note that a direction of `LIPSwipeDirectionRight`
 * does not imply that the threshold has been reached.
 */
@property (nonatomic, assign) LIPSwipeDirection direction;

/*!
 * The ratio of the threshold that has been reached. This can take on any value
 * between `0.0f` and `1.0f`, with `1.0f` meaning the threshold has been reached.
 * A `thresholdRatio` of `1.0f` implies that were the user to end the pan gesture,
 * the current direction would be chosen.
 */
@property (nonatomic, assign) CGFloat thresholdRatio;
@end

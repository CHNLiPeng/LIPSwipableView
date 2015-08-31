//
//  UIView+LIPSwipeToChoose.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIPSwipeDirection.h"

@class LIPSwipeOptions;
/*!
 * The `UIView (LIPSwipeToChoose)` category adds a pan gesture recognizer
 * to any view, via the `lip_swipeToChooseSetup:` method. By specifying
 * blocks to be executed when the view is panned via an instance of
 * `LIPSwipeOptions`, you may add custom behavior based on the panning motion.
 *
 * This is a more generic version of the `LIPSwipeToChooseView` class.
 */

@interface UIView (LIPSwipeToChoose)


/*!
 * Adds swipe-to-choose functionality to an instance of `UIView`.
 * You may customize the selection threshold and other parameters by
 * setting the corresponding settings on the `options` argument.
 * Passing `nil` for the `options` parameter configures the view with
 * the default set of options.
 */
- (void)lip_swipeToChooseSetup:(LIPSwipeOptions *)options;

/*!
 * Programmatically swipes the view in the direction specified.
 *
 * Specifying a direction of LIPSwipeDirectionNone swipes the view
 * if the swipe threshold is currently exceeded, and returns it to
 * its original position otherwise.
 *
 * If you haven't called `lip_swipeToChooseSetup:` already, this will call
 * that method and perform setup using the default set of options.
 */
- (void)lip_swipe:(LIPSwipeDirection)direction;


- (void)lip_undoSwipe:(LIPSwipeDirection)direction;
@end

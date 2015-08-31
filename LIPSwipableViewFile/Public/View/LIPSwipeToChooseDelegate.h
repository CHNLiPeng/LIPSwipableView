//
//  LIPSwipeToChooseDelegate.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIPSwipeDirection.h"

/*!
 * Classes that adopt the `LIPSwipeToChooseDelegate` protcol may respond to
 * swipe events, such as when a view has been swiped and chosen, or when a
 * swipe has been cancelled and no choice has been made.
 *
 * To customize the animation and appearance of a LIPSwipeToChoose-based view,
 * use `LIPSwipeOptions` and the `-lip_swipeToChooseSetup:` method.
 */
@protocol LIPSwipeToChooseDelegate <NSObject>
@optional

/*!
 * Sent when a view was not swiped past the selection threshold. The view is
 * returned to its original position before this message is sent.
 */
- (void)viewDidCancelSwipe:(UIView *)view;

/*!
 * Sent before a choice is made. Return `NO` to prevent the choice from being made,
 * and `YES` otherwise.
 */
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(LIPSwipeDirection)direction;

/*!
 * Sent after a choice is made. When using the default `LIPSwipeOptions`, the `view`
 * is removed from the view hierarchy by the time this message is sent.
 */
- (void)view:(UIView *)view wasChosenWithDirection:(LIPSwipeDirection)direction;

@end

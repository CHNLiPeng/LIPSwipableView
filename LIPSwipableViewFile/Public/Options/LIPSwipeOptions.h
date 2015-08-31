//
//  LIPSwipeOptions.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIPSwipeDirection.h"
@class LIPPanState;
@class LIPSwipeResult;
@protocol LIPSwipeToChooseDelegate;

typedef void (^LIPSwipeToChooseOnPanBlock)(LIPPanState *state);
typedef void (^LIPSwipeToChooseOnChosenBlock)(LIPSwipeResult *state);
/*!
 * A set of options used to customize the behavior of the
 * `UIView (LIPSwipeToChoose)` category.
 */
@interface LIPSwipeOptions : NSObject



/*!
 * The delegate that receives messages pertaining to the swipe choices of the view.
 */
@property (nonatomic, weak) id<LIPSwipeToChooseDelegate> delegate;

/*!
 * The duration of the animation that occurs when a swipe is cancelled. By default, this
 * animation simply slides the view back to its original position. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) NSTimeInterval swipeCancelledAnimationDuration;

/*!
 * Animation options for the swipe-cancelled animation. Default values are provided in the
 * `-init` method.
 */
@property (nonatomic, assign) UIViewAnimationOptions swipeCancelledAnimationOptions;

/*!
 * THe duration of the animation that moves a view to its threshold, caused when `lip_swipe:`
 * is called. A default value is provided in the `-init` method.
 */
@property (nonatomic, assign) NSTimeInterval swipeAnimationDuration;

/**
 *  Directions that swipable
 */
@property (nonatomic,assign) LIPSwipeDirection swipableDirections;
/*!
 * Animation options for the animation that moves a view to its threshold, caused when
 * `lip_swipe:` is called. A default value is provided in the `-init` method.
 */
@property (nonatomic, assign) UIViewAnimationOptions swipeAnimationOptions;

/*!
 * The distance, in pixels, that a view must be panned in order to constitue a selection.
 * For example, if the `threshold` is `100.f`, panning the view `101.f` pixels to the right
 * is considered a selection in the `LIPSwipeDirectionRight` direction. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) CGFloat threshold;

/*!
 * When a view is panned, it is rotated slightly. Adjust this value to increase or decrease
 * the angle of rotation.
 */
@property (nonatomic, assign) CGFloat rotationFactor;

/*!
 * A callback to be executed when the view is panned. The block takes an instance of
 * `LIPPanState` as an argument. Use this `state` instance to determine the pan direction
 * and the distance until the threshold is reached.
 */
@property (nonatomic, copy) LIPSwipeToChooseOnPanBlock onPan;

/*!
 * A callback to be executed when the view is swiped and chosen. The default
 is the block returned by the `-exitScreenOnChosenWithDuration:block:` method.
 
 @warning that this block must execute the `LIPSwipeResult` argument's `onCompletion`
 block in order to properly notify the delegate of the swipe result.
 */
@property (nonatomic, copy) LIPSwipeToChooseOnChosenBlock onChosen;

/*!
 * The default callback for when a view is swiped an chosen. This callback moves the view
 * outside of the bounds of its parent view, then removes it from the view hierarchy.
 */
+ (LIPSwipeToChooseOnChosenBlock)exitScreenOnChosenWithDuration:(NSTimeInterval)duration
                                                        options:(UIViewAnimationOptions)options;
@end

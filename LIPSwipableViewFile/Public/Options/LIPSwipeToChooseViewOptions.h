//
//  LIPSwipeToChooseViewOptions.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIPSwipeOptions.h"
@class LIPPanState;
@class LIPSwipeResult;
@protocol LIPSwipeToChooseDelegate;

typedef void (^LIPSwipeToChooseOnPanBlock)(LIPPanState *state);
typedef void (^LIPSwipeToChooseOnChosenBlock)(LIPSwipeResult *state);

/*!
 * A set of options used to customize the behavior of the
 * `UIView (LIPSwipeToChoose)` category.
 */
@interface LIPSwipeToChooseViewOptions : NSObject
/*!
 * The delegate that receives messages pertaining to the swipe choices of the view.
 */
@property (nonatomic, weak) id<LIPSwipeToChooseDelegate> delegate;

/*!
 * The text displayed in the `likedView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, copy) NSString *likedText;

/*!
 * The color of the text and border of the `likedView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, strong) UIColor *likedColor;

/*!
 * The rotation angle of the `likedView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, assign) CGFloat likedRotationAngle;

/*!
 * The text displayed in the `nopeView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, copy) NSString *nopeText;

/*!
 * The color of the text and border of the `nopeView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, strong) UIColor *nopeColor;

/*!
 * The rotation angle of the `nopeView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, assign) CGFloat nopeRotationAngle;

/*!
 * The distance, in pixels, that a view must be panned in order to constitue a selection.
 * For example, if the `threshold` is `100.f`, panning the view `101.f` pixels to the right
 * is considered a selection in the `LIPSwipeDirectionRight` direction. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) CGFloat threshold;

/**
 *  Directions that swipable
 */
@property (nonatomic,assign) LIPSwipeDirection swipableDirections;
/*!
 * A callback to be executed when the view is panned. The block takes an instance of
 * `LIPPanState` as an argument. Use this `state` instance to determine the pan direction
 * and the distance until the threshold is reached.
 */
@property (nonatomic, copy) LIPSwipeToChooseOnPanBlock onPan;
@end

//
//  LIPSwipeResult.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIPSwipeDirection.h"

typedef void (^LIPSwipedOnCompletionBlock)(void);
@interface LIPSwipeResult : NSObject
/*!
 * The view that was swiped.
 */
@property (nonatomic, strong) UIView *view;

/*!
 * The translation of the swiped view; i.e.: the distance it has been panned
 * from its original location.
 */
@property (nonatomic, assign) CGPoint translation;

/*!
 * The final direction of the swipe.
 */
@property (nonatomic, assign) LIPSwipeDirection direction;

/*!
 * A callback to be executed after any animations performed by the `LIPSwipeOptions`
 * `onChosen` callback.
 */
@property (nonatomic, copy) LIPSwipedOnCompletionBlock onCompletion;
@end

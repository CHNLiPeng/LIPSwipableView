//
//  LIPSwipeToChooseView.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LIPSwipeToChooseViewOptions;
/*!
 * A `UIView` subclass that acts nearly identically to the swipe-to-choose
 * views in Tinder.app. Swipe right to "like", left to "dislike".
 */
@interface LIPSwipeToChooseView : UIView


/*!
 * The main image to be displayed and then "liked" or "disliked".
 */
@property (nonatomic, strong) UIImageView *imageView;

/*!
 * The "liked" view, which fades in as the `LIPSwipeToChooseView` is panned to the right.
 */
@property (nonatomic, strong) UIView *likedView;

/*!
 * The "nope" view, which fades in as the `LIPSwipeToChooseView` is panned to the left.
 */
@property (nonatomic, strong) UIView *nopeView;


@property (nonatomic,strong) UIView *upView;
/*!
 * The designated initializer takes a `frame` and a set of options to customize
 * the behavior of the view.
 */
- (instancetype)initWithFrame:(CGRect)frame
                      options:(LIPSwipeToChooseViewOptions *)options;


@end

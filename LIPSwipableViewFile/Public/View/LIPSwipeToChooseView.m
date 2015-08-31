//
//  LIPSwipeToChooseView.m
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "LIPSwipeToChooseView.h"
#import "LIPSwipeToChoose.h"
#import "LIPGeometry.h"
#import "UIView+LIPBorderedLabel.h"
#import "UIColor+LIPRGB8Bit.h"
#import <QuartzCore/QuartzCore.h>
static CGFloat const LIPSwipeToChooseViewHorizontalPadding = 10.f;
static CGFloat const LIPSwipeToChooseViewTopPadding = 20.f;
static CGFloat const LIPSwipeToChooseViewLabelWidth = 65.f;

@interface LIPSwipeToChooseView ()
@property (nonatomic, strong) LIPSwipeToChooseViewOptions *options;
@end
@implementation LIPSwipeToChooseView
#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame options:(LIPSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame];
    if (self) {
        _options = options ? options : [LIPSwipeToChooseViewOptions new];
        [self setupView];
        [self constructImageView];
        [self constructLikedView];
        [self constructNopeImageView];
        [self constructUpView];
        [self setupSwipeToChoose];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds=YES;
    self.layer.cornerRadius = 5.f;
    self.layer.borderWidth = 2.f;
    self.layer.borderColor = [UIColor colorWith8BitRed:220.f
                                                 green:220.f
                                                  blue:220.f
                                                 alpha:1.f].CGColor;
}

- (void)constructImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
}

- (void)constructLikedView {
    CGRect frame = CGRectMake(LIPSwipeToChooseViewHorizontalPadding,
                              LIPSwipeToChooseViewTopPadding,
                              CGRectGetMidX(_imageView.bounds),
                              LIPSwipeToChooseViewLabelWidth);
    self.likedView = [[UIView alloc] initWithFrame:frame];
    [self.likedView constructBorderedLabelWithText:self.options.likedText
                                             color:self.options.likedColor
                                             angle:self.options.likedRotationAngle];
    self.likedView.alpha = 0.f;
    [self.imageView addSubview:self.likedView];
}

- (void)constructUpView {
    CGRect frame = CGRectMake(0,0,
                              CGRectGetMidX(_imageView.bounds),
                              LIPSwipeToChooseViewLabelWidth);
    self.upView = [[UIView alloc] initWithFrame:frame];
    self.upView.center=CGPointMake(self.center.x, self.center.y);
    [self.upView constructBorderedLabelWithText:@"UP"
                                          color:self.options.likedColor
                                          angle:self.options.likedRotationAngle];
    self.upView.alpha = 0.f;
    [self.imageView addSubview:self.upView];
}
- (void)constructNopeImageView {
    CGFloat width = CGRectGetMidX(self.imageView.bounds);
    CGFloat xOrigin = CGRectGetMaxX(_imageView.bounds) - width - LIPSwipeToChooseViewHorizontalPadding;
    self.nopeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,
                                                                  LIPSwipeToChooseViewTopPadding,
                                                                  width,
                                                                  LIPSwipeToChooseViewLabelWidth)];
    [self.nopeView constructBorderedLabelWithText:self.options.nopeText
                                            color:self.options.nopeColor
                                            angle:self.options.nopeRotationAngle];
    self.nopeView.alpha = 0.f;
    [self.imageView addSubview:self.nopeView];
}

- (void)setupSwipeToChoose {
    LIPSwipeOptions *options = [LIPSwipeOptions new];
    options.delegate = self.options.delegate;
    options.threshold = self.options.threshold;
    options.swipableDirections=self.options.swipableDirections;
    __block UIView *likedImageView = self.likedView;
    __block UIView *nopeImageView = self.nopeView;
    __block UIView *upView = self.upView;
    options.onPan = ^(LIPPanState *state) {
        if (state.direction == LIPSwipeDirectionNone) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = 0.f;
            upView.alpha=0.f;
        } else if (state.direction == LIPSwipeDirectionLeft) {
            likedImageView.alpha = 0.f;
            upView.alpha=0.f;
            nopeImageView.alpha = state.thresholdRatio;
        } else if (state.direction == LIPSwipeDirectionRight) {
            likedImageView.alpha = state.thresholdRatio;
            nopeImageView.alpha = 0.f;
            upView.alpha=0.f;
        }else if (state.direction==LIPSwipeDirectionUp) {
            upView.alpha = state.thresholdRatio;
            nopeImageView.alpha = 0.f;
            likedImageView.alpha=0.f;
        }
        
        if (self.options.onPan) {
            self.options.onPan(state);
        }
    };
    
    [self lip_swipeToChooseSetup:options];
}
@end

//
//  LIPSwipeOptions.m
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "LIPSwipeOptions.h"
#import "LIPSwipeToChoose.h"
#import "LIPGeometry.h"
@implementation LIPSwipeOptions
#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _swipeCancelledAnimationDuration = 0.2;
        _swipeCancelledAnimationOptions = UIViewAnimationOptionCurveEaseOut;
        _swipeAnimationDuration = 0.1;
        _swipeAnimationOptions = UIViewAnimationOptionCurveEaseIn;
        _rotationFactor = 3.f;
        
        _onChosen = [[self class] exitScreenOnChosenWithDuration:0.1
                                                         options:UIViewAnimationOptionCurveLinear];
    }
    return self;
}

#pragma mark - Public Interface

+ (LIPSwipeToChooseOnChosenBlock)exitScreenOnChosenWithDuration:(NSTimeInterval)duration
                                                        options:(UIViewAnimationOptions)options {
    return ^(LIPSwipeResult *state) {
        CGRect destination = LIPCGRectExtendedOutOfBounds(state.view.frame,
                                                          state.view.superview.bounds,
                                                          state.translation);
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             state.view.frame = destination;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 [state.view removeFromSuperview];
                                 state.onCompletion();
                             }
                         }];
    };
}
@end

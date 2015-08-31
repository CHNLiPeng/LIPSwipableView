//
//  UIView+LIPSwipeToChoose.m
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "UIView+LIPSwipeToChoose.h"
#import "LIPSwipeToChoose.h"
#import "LIPViewState.h"
#import "LIPGeometry.h"
#import <objc/runtime.h>
#import "LIPSwipeToChooseDelegate.h"
const void * const LIPSwipeOptionsKey = &LIPSwipeOptionsKey;
const void * const LIPViewStateKey = &LIPViewStateKey;
@implementation UIView (LIPSwipeToChoose)
#pragma mark - Public Interface

- (void)lip_swipeToChooseSetup:(LIPSwipeOptions *)options {
    self.lip_options = options ? options : [LIPSwipeOptions new];
    self.lip_viewState = [LIPViewState new];
    self.lip_viewState.originalCenter = self.center;
    
    [self lip_setupPanGestureRecognizer];
}

- (void)lip_swipe:(LIPSwipeDirection)direction {
    [self lip_swipeToChooseSetupIfNecessary];
    
    // A swipe in no particular direction "finalizes" the swipe.
    if (direction == LIPSwipeDirectionNone) {
        [self lip_finalizePosition];
        return;
    }
    
    // Moves the view to the minimum point exceeding the threshold.
    // Transforms and executes pan callbacks as well.
    void (^animations)(void) = ^{
        CGPoint translation = [self lip_translationExceedingThreshold:self.lip_options.threshold
                                                            direction:direction];
        self.center = LIPCGPointAdd(self.center, translation);
        [self lip_rotateForTranslation:translation
                     rotationDirection:LIPRotationAwayFromCenter];
        [self lip_executeOnPanBlockForTranslation:translation];
    };
    
    // Finalize upon completion of the animations.
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished) { [self lip_finalizePosition]; }
    };
    
    [UIView animateWithDuration:self.lip_options.swipeAnimationDuration
                          delay:0.0
                        options:self.lip_options.swipeAnimationOptions
                     animations:animations
                     completion:completion];
}

- (void)lip_undoSwipe:(LIPSwipeDirection)undoDirection {
    CGPoint startPoint;
    switch (undoDirection) {
        case LIPSwipeDirectionLeft:
            startPoint = CGPointMake(0-self.bounds.size.width, self.center.y);
            break;
        case LIPSwipeDirectionRight:
            startPoint = CGPointMake(self.superview.bounds.size.width+self.bounds.size.width, self.center.y);
            break;
        case LIPSwipeDirectionUp:
            startPoint = CGPointMake(self.superview.center.x, 0-self.bounds.size.height);
            break;
        case LIPSwipeDirectionDown:
            startPoint = CGPointMake(self.superview.center.x, self.superview.bounds.size.height+self.bounds.size.height);
            break;
        default:
            break;
    }
    
    
    [self lip_rotateForTranslation:startPoint
                 rotationDirection:LIPRotationAwayFromCenter];
    self.center=startPoint;
    // Moves the view to the original position .
    void (^animations)(void) = ^{
        self.center=self.lip_viewState.originalCenter;
        self.transform=CGAffineTransformIdentity;
    };
    
    // Finalize upon completion of the animations.
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished) { [self lip_finalizePosition]; }
    };
    
    [UIView animateWithDuration:self.lip_options.swipeAnimationDuration
                          delay:0.0
                        options:self.lip_options.swipeAnimationOptions
                     animations:animations
                     completion:completion];
}
#pragma mark - Internal Methods

- (void)setLip_options:(LIPSwipeOptions *)options {
    objc_setAssociatedObject(self, LIPSwipeOptionsKey, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LIPSwipeOptions *)lip_options {
    return objc_getAssociatedObject(self, LIPSwipeOptionsKey);
}

- (void)setLip_viewState:(LIPViewState *)state {
    objc_setAssociatedObject(self, LIPViewStateKey, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LIPViewState *)lip_viewState {
    return objc_getAssociatedObject(self, LIPViewStateKey);
}

#pragma mark Setup

- (void)lip_swipeToChooseSetupIfNecessary {
    if (!self.lip_options || !self.lip_viewState) {
        [self lip_swipeToChooseSetup:nil];
    }
}

- (void)lip_setupPanGestureRecognizer {
    SEL action = @selector(lip_onSwipeToChoosePanGestureRecognizer:);
    UIPanGestureRecognizer *panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:action];
    [self addGestureRecognizer:panGestureRecognizer];
}
#pragma mark Gesture Recognizer Events

- (void)lip_onSwipeToChoosePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *view = panGestureRecognizer.view;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.lip_viewState.originalCenter = view.center;
        
        // If the pan gesture originated at the top half of the view, rotate the view
        // away from the center. Otherwise, rotate towards the center.
        if ([panGestureRecognizer locationInView:view].y < view.center.y) {
            self.lip_viewState.rotationDirection = LIPRotationAwayFromCenter;
        } else {
            self.lip_viewState.rotationDirection = LIPRotationTowardsCenter;
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Either move the view back to its original position or move it off screen.
        [self lip_finalizePosition];
    } else {
        // Update the position and transform. Then, notify any listeners of
        // the updates via the pan block.
        CGPoint translation = [panGestureRecognizer translationInView:view];
        view.center = LIPCGPointAdd(self.lip_viewState.originalCenter, translation);
        [self lip_rotateForTranslation:translation
                     rotationDirection:self.lip_viewState.rotationDirection];
        [self lip_executeOnPanBlockForTranslation:translation];
    }
}
#pragma mark Translation

- (void)lip_finalizePosition {
    LIPSwipeDirection direction = [self lip_directionOfExceededThreshold];
    switch (direction) {
        case LIPSwipeDirectionRight:
        case LIPSwipeDirectionLeft:
        case LIPSwipeDirectionUp:
        case LIPSwipeDirectionDown:{
            
            if (self.lip_options.swipableDirections & direction) {
                CGPoint translation = LIPCGPointSubtract(self.center,
                                                         self.lip_viewState.originalCenter);
                [self lip_exitSuperviewFromTranslation:translation];
            }else
            {
                [self lip_returnToOriginalCenter];
                [self lip_executeOnPanBlockForTranslation:CGPointZero];
            }
            
            break;
        }
        case LIPSwipeDirectionNone:
            [self lip_returnToOriginalCenter];
            [self lip_executeOnPanBlockForTranslation:CGPointZero];
            break;
    }
}

- (void)lip_returnToOriginalCenter {
    [UIView animateWithDuration:self.lip_options.swipeCancelledAnimationDuration
                          delay:0.0
                        options:self.lip_options.swipeCancelledAnimationOptions
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.center = self.lip_viewState.originalCenter;
                     } completion:^(BOOL finished) {
                         id<LIPSwipeToChooseDelegate> delegate = self.lip_options.delegate;
                         if ([delegate respondsToSelector:@selector(viewDidCancelSwipe:)]) {
                             [delegate viewDidCancelSwipe:self];
                         }
                     }];
}

- (void)lip_exitSuperviewFromTranslation:(CGPoint)translation {
    LIPSwipeDirection direction = [self lip_directionOfExceededThreshold];
    id<LIPSwipeToChooseDelegate> delegate = self.lip_options.delegate;
    if ([delegate respondsToSelector:@selector(view:shouldBeChosenWithDirection:)]) {
        BOOL should = [delegate view:self shouldBeChosenWithDirection:direction];
        if (!should) {
            return;
        }
    }
    
    LIPSwipeResult *state = [LIPSwipeResult new];
    state.view = self;
    state.translation = translation;
    state.direction = direction;
    state.onCompletion = ^{
        if ([delegate respondsToSelector:@selector(view:wasChosenWithDirection:)]) {
            [delegate view:self wasChosenWithDirection:direction];
        }
    };
    self.lip_options.onChosen(state);
}

- (void)lip_executeOnPanBlockForTranslation:(CGPoint)translation {
    if (self.lip_options.onPan) {
        CGFloat thresholdRatio;
        
        LIPSwipeDirection direction = LIPSwipeDirectionNone;
        BOOL xBiggerThany= fabsf(translation.x)>fabsf(translation.y);
        if (xBiggerThany) {
            
            
            thresholdRatio = MIN(1.f, fabsf(translation.x)/self.lip_options.threshold);
            if (translation.x > 0.f) {
                direction = LIPSwipeDirectionRight;
            } else if (translation.x < 0.f) {
                direction = LIPSwipeDirectionLeft;
            }
        }else
        {
            thresholdRatio = MIN(1.f, fabsf(translation.y)/self.lip_options.threshold);
            if (translation.y > 0.f) {
                direction = LIPSwipeDirectionDown;
            } else if (translation.y < 0.f) {
                direction = LIPSwipeDirectionUp;
            }
        }
        
        
        LIPPanState *state = [LIPPanState new];
        state.view = self;
        state.direction = direction;
        state.thresholdRatio = thresholdRatio;
        self.lip_options.onPan(state);
    }
}

#pragma mark Rotation

- (void)lip_rotateForTranslation:(CGPoint)translation
               rotationDirection:(LIPRotationDirection)rotationDirection {
    CGFloat rotation = LIPDegreesToRadians(translation.x/100 * self.lip_options.rotationFactor);
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                             rotationDirection * rotation);
}

#pragma mark Threshold

- (CGPoint)lip_translationExceedingThreshold:(CGFloat)threshold
                                   direction:(LIPSwipeDirection)direction {
    NSParameterAssert(direction != LIPSwipeDirectionNone);
    
    CGFloat offset = threshold + 1.f;
    switch (direction) {
        case LIPSwipeDirectionLeft:
            return CGPointMake(-offset, 0);
        case LIPSwipeDirectionRight:
            return CGPointMake(offset, 0);
            break;
        case LIPSwipeDirectionUp :
            return CGPointMake(0, -offset);
        case LIPSwipeDirectionDown:
            return CGPointMake(0, offset);
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Invallid direction argument."];
            return CGPointZero;
    }
}

- (LIPSwipeDirection)lip_directionOfExceededThreshold {
    if (self.center.x > self.lip_viewState.originalCenter.x + self.lip_options.threshold) {
        return LIPSwipeDirectionRight;
    } else if (self.center.x < self.lip_viewState.originalCenter.x - self.lip_options.threshold) {
        return LIPSwipeDirectionLeft;
    }else if (self.center.y<self.lip_viewState.originalCenter.y-self.lip_options.threshold) {
        return LIPSwipeDirectionUp;
    }else if (self.center.y>self.lip_viewState.originalCenter.y+self.lip_options.threshold) {
        return LIPSwipeDirectionDown;
    }
    else {
        return LIPSwipeDirectionNone;
    }
}
@end

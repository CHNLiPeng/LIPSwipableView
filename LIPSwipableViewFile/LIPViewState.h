//
//  LIPViewState.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LIPViewState : NSObject

typedef CGFloat LIPRotationDirection;
extern const LIPRotationDirection LIPRotationAwayFromCenter;
extern const LIPRotationDirection LIPRotationTowardsCenter;

/*!
 * The center of the view when the pan gesture began.
 */
@property (nonatomic, assign) CGPoint originalCenter;

/*!
 * When the pan gesture originates at the top half of the view, the view rotates
 * away from its original center, and this property takes on a value of 1.
 *
 * When the pan gesture originates at the bottom half, the view rotates toward its
 * original center, and this takes on a value of -1.
 */
@property (nonatomic, assign) LIPRotationDirection rotationDirection;

@end

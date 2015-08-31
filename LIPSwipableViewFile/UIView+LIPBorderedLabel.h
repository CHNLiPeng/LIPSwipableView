//
//  UIView+LIPBorderedLabel.h
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LIPBorderedLabel)
- (void)constructBorderedLabelWithText:(NSString *)text
                                 color:(UIColor *)color
                                 angle:(CGFloat)angle;
@end

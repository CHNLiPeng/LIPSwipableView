//
//  UIView+LIPBorderedLabel.m
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "UIView+LIPBorderedLabel.h"
#import "LIPGeometry.h"
@implementation UIView (LIPBorderedLabel)
- (void)constructBorderedLabelWithText:(NSString *)text
                                 color:(UIColor *)color
                                 angle:(CGFloat)angle {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 5.f;
    self.layer.cornerRadius = 10.f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = [text uppercaseString];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                 size:48.f];
    label.textColor = color;
    [self addSubview:label];
    
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                             LIPDegreesToRadians(angle));
}
@end

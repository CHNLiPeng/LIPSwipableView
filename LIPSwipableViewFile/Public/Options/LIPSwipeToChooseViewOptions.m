//
//  LIPSwipeToChooseViewOptions.m
//  LIPSwipableView
//
//  Created by lip on 15/8/11.
//  Copyright (c) 2015年 LiPeng. All rights reserved.
//

#import "LIPSwipeToChooseViewOptions.h"
#import "UIColor+LIPRGB8Bit.h"
@implementation LIPSwipeToChooseViewOptions
- (instancetype)init {
    self = [super init];
    if (self) {
        _likedText = [NSLocalizedString(@"liked", nil) uppercaseString];
        _likedColor = [UIColor colorWith8BitRed:29.f green:245.f blue:106.f alpha:1.f];
        _likedRotationAngle = -15.f;
        
        _nopeText = [NSLocalizedString(@"nope", nil) uppercaseString];
        _nopeColor = [UIColor colorWith8BitRed:247.f green:91.f blue:37.f alpha:1.f];
        _nopeRotationAngle = 15.f;
        
        _threshold = 100.f;
    }
    return self;
}
@end

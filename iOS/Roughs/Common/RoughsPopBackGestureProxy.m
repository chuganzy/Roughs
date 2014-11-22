//
// Created by Takeru Chuganji on 11/23/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "RoughsPopBackGestureProxy.h"

@implementation RoughsPopBackGestureProxy

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

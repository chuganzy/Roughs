//
// Created by Takeru Chuganji on 11/16/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HCPopBackGestureProxy/HCPopBackGestureProxy.h>

@interface ProjectViewController : UIViewController <UIWebViewDelegate, HCPopBackGestureProxyDelegate>
@property (nonatomic, copy) NSDictionary *project;
@end

//
// Created by Takeru Chuganji on 11/16/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "ProjectViewController.h"
#import "HCPopBackGestureProxy.h"

@interface ProjectViewController () <HCPopBackGestureProxyDelegate, UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic) BOOL evaluatedJavaScript;
@end


@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userAgent = self.project[@"user_agent"];
    if (userAgent) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                                  @"UserAgent" : userAgent
                                                                  }];
    }
    NSURL *url = [NSURL URLWithString:[self.project[@"project_url"] stringByAppendingString:@"?in_browser=1"]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [HCPopBackGestureProxy sharedInstance].viewController = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[HCPopBackGestureProxy sharedInstance] viewWillDisappear];
}

@end

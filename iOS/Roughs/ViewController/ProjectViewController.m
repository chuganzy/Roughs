//
// Created by Takeru Chuganji on 11/16/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "ProjectViewController.h"

@interface ProjectViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end


@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:self.project[@"project_url"]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"$(\"#install\").hide()"];
    [webView stringByEvaluatingJavaScriptFromString:@"new flviewer.Viewer(flviewerPrototypeBootstrapData, $(\"#flviewer\"), !0)"];
    [webView stringByEvaluatingJavaScriptFromString:@"$(\"#flviewer_device_wrap\").show()"];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion != UIEventSubtypeMotionShake) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

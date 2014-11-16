//
// Created by Takeru Chuganji on 11/16/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "APIClient.h"
#import <AFNetworking/AFNetworking.h>

@interface APIClient ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

static NSString *const kAPIClientAPIPath = @"api";

@implementation APIClient

+ (APIClient *)sharedClient {
    static APIClient *_instance = nil;
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *info = [NSBundle mainBundle].infoDictionary[@"Roughs"];
        NSString *baseURLString = info[@"BaseURL"];
        NSAssert(0 < [baseURLString length], @"BaseURL is required. Please setup Info.plist. More information is available on README.");
        NSURL *baseURL = [NSURL URLWithString:baseURLString];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        NSDictionary *basicAuth = info[@"BasicAuth"];
        NSString *userName = basicAuth[@"username"];
        NSString *password = basicAuth[@"password"];
        if ([userName length] && [password length]) {
            [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
        }
        self.sessionManager = manager;
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)method
                   parameters:(id)parameters
                      handler:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))handler {
    return [self.sessionManager GET:[kAPIClientAPIPath stringByAppendingString:method]
                         parameters:parameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                handler(task, responseObject, nil);
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                handler(task, nil, error);
                            }];
}

@end

//
// Created by Takeru Chuganji on 11/16/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APIClient : NSObject

+ (APIClient *)sharedClient;

- (NSURLSessionDataTask *)GET:(NSString *)method
                   parameters:(id)parameters
                      handler:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))handler;

@end

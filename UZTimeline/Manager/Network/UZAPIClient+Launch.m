//
//  UZAPIClient+Launch.m
//  maguanjiaios
//
//  Created by LiuXiaoyu on 1/10/16.
//  Copyright © 2016 cn.com.uzero. All rights reserved.
//

#import "UZAPIClient+Launch.h"

NSString *const HK_APP_LAUNCH   = @"appLaunch";//开机请求
NSString *const HK_GET_QNTOKEN  = @"getQiniuUploadToken";//获取七牛token

@implementation UZAPIClient (Launch)

- (NSURLSessionTask *)requestQNTokenWithSuccess:(void(^)(NSString *QNToken))success
                                        failure:(failureBlock)failure {
    return
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_GET_QNTOKEN
                                                  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                                                      NSString *value = responseObject[@"value"];
                                                      success(value);
                                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      failure(task, error);
                                                  }];
}

@end

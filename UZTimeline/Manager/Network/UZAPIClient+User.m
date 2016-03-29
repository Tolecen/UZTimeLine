//
//  UZAPIClient+User.m
//  maguanjiaios
//
//  Created by LiuXiaoyu on 1/5/16.
//  Copyright © 2016 cn.com.uzero. All rights reserved.
//

#import "UZAPIClient+User.h"

NSString *const HK_UPDATE_USER_AVATAR   = @"updateUserAvatar";//更新头像
NSString *const HK_UPDATE_USER_NAME     = @"updateUserName";//更新用户名
NSString *const HK_UPDATE_USER_PASSWORD = @"updateUserPwd";//更新密码


@implementation UZAPIClient (User)

- (NSURLSessionDataTask *)updateUserNameWithParameters:(NSDictionary *)params
                                               success:(successBlock)success
                                               failure:(failureBlock)failure {
    return
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_UPDATE_USER_NAME
                                                  parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                      success(task, responseObject);
                                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      failure(task, error);
                                                  }];
}

- (NSURLSessionDataTask *)updateUserPasswordWithParameters:(NSDictionary *)params
                                                   success:(successBlock)success
                                                   failure:(failureBlock)failure {
    return
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_UPDATE_USER_PASSWORD
                                                  parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                      success(task, responseObject);
                                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      failure(task, error);
                                                  }];
}

- (NSURLSessionDataTask *)updateUserAvatarWithParameters:(NSDictionary *)params
                                                 success:(successBlock)success
                                                 failure:(failureBlock)failure {
    return
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_UPDATE_USER_AVATAR
                                                  parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                      success(task, responseObject);
                                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      failure(task, error);
                                                  }];
}

@end

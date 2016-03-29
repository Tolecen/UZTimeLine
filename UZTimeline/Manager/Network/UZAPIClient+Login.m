//
//  UZAPIClient+Login.m
//  maguanjiaios
//
//  Created by LiuXiaoyu on 1/31/16.
//  Copyright © 2016 cn.com.uzero. All rights reserved.
//

#import "UZAPIClient+Login.h"

NSString *const HK_USER_LOGIN           = @"login";//登录
NSString *const HK_USER_LOGOUT          = @"logout";//登出
NSString *const HK_USER_REGISTER        = @"";//注册
NSString *const HK_SEND_ValidateCode    = @"sendValidateCode";//发送验证码
NSString *const HK_VERIFY_ValidateCode  = @"validateCode";//验证验证码


@implementation UZAPIClient (Login)

- (NSURLSessionDataTask *)sendValidateCodeWithParameters:(NSDictionary *)params
                                                 success:(void(^)(NSString *validateCode))success
                                                 failure:(failureBlock)failure {
    return
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_SEND_ValidateCode
                                                  parameters:params
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         NSString *value = [NSString stringWithFormat:@"%@",responseObject[@"value"]];
                                                         success(value);
                                                     }
                                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                         failure(task, error);
                                                     }];
}

- (NSURLSessionDataTask *)verifyValidateCodeWithParameters:(NSDictionary *)params
                                                   success:(void(^)(BOOL successValidate))success
                                                   failure:(failureBlock)failure {
    return
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_VERIFY_ValidateCode
                                                  parameters:params
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         NSString *value = [NSString stringWithFormat:@"%@",responseObject[@"value"]];
                                                         if ([value isEqualToString:@"1"]) {
                                                             success(YES);
                                                         } else {
                                                             success(NO);
                                                         }
                                                     }
                                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      failure(task, error);
                                                  }];
}
//
//- (NSURLSessionDataTask *)userLoginWithParameters:(NSDictionary *)params
//                                          success:(void(^)(HKUserModel *user))success
//                                          failure:(failureBlock)failure {
//    return
//    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_USER_LOGIN
//                                                  parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//                                                      JSONModelError *error = nil;
//                                                      HKUserModel *user = [[HKUserModel alloc] initWithDictionary:responseObject error:&error];
//                                                      if (user) {
//                                                          [[HKAppUserManager sharedManager] appSaveCurrentUserInfo:user];
//                                                          success(user);
//                                                      } else {
//                                                          failure(task, error);
//                                                      }
//                                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                                      failure(task, error);
//                                                  }];
//}
//
//- (NSURLSessionDataTask *)userRegisterWithParameters:(NSDictionary *)params
//                                             success:(void(^)(HKUserModel *user))success
//                                             failure:(failureBlock)failure {
//    return
//    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_USER_REGISTER
//                                                  parameters:params
//                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
//                                                         JSONModelError *error = nil;
//                                                         HKUserModel *user = [[HKUserModel alloc] initWithDictionary:responseObject error:&error];
//                                                         if (user) {
//                                                             [[HKAppUserManager sharedManager] appSaveCurrentUserInfo:user];
//                                                             success(user);
//                                                         } else {
//                                                             failure(task, error);
//                                                         }
//                                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                                         failure(task, error);
//                                                     }];
//}
//
//- (NSURLSessionDataTask *)userLogoutWithParameters:(NSDictionary *)params
//                                           success:(void(^)(NSString *userId))success
//                                           failure:(failureBlock)failure {
//    return
//    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:HK_USER_LOGOUT
//                                                  parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//                                                      NSString *value = [NSString stringWithFormat:@"%@",responseObject[@"value"]];
//                                                      [[HKAppUserManager sharedManager] appDeletePreviousUserInfo];
//                                                      success(value);
//                                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                                      failure(task, error);
//                                                  }];
//}

@end

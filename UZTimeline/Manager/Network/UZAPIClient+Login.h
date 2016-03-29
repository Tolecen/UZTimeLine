//
//  UZAPIClient+Login.h
//  maguanjiaios
//
//  Created by LiuXiaoyu on 1/31/16.
//  Copyright © 2016 cn.com.uzero. All rights reserved.
//

#import "UZAPIClient.h"

@interface UZAPIClient (Login)

- (NSURLSessionDataTask *)sendValidateCodeWithParameters:(NSDictionary *)params
                                                 success:(void(^)(NSString *validateCode))success
                                                 failure:(failureBlock)failure;

- (NSURLSessionDataTask *)verifyValidateCodeWithParameters:(NSDictionary *)params
                                                   success:(void(^)(BOOL successValidate))success
                                                   failure:(failureBlock)failure;
/*
- (NSURLSessionDataTask *)userLoginWithParameters:(NSDictionary *)params
                                          success:(void(^)(HKUserModel *user))success
                                          failure:(failureBlock)failure;

- (NSURLSessionDataTask *)userLogoutWithParameters:(NSDictionary *)params
                                           success:(void(^)(NSString *userId))success
                                           failure:(failureBlock)failure;

- (NSURLSessionDataTask *)userRegisterWithParameters:(NSDictionary *)params
                                             success:(void(^)(HKUserModel *user))success
                                             failure:(failureBlock)failure;
 */

@end

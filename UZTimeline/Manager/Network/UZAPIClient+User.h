//
//  UZAPIClient+User.h
//  maguanjiaios
//
//  Created by LiuXiaoyu on 1/5/16.
//  Copyright © 2016 cn.com.uzero. All rights reserved.
//

#import "UZAPIClient.h"

@interface UZAPIClient (User)

- (NSURLSessionDataTask *)updateUserNameWithParameters:(NSDictionary *)params
                                               success:(successBlock)success
                                               failure:(failureBlock)failure;

- (NSURLSessionDataTask *)updateUserAvatarWithParameters:(NSDictionary *)params
                                                 success:(successBlock)success
                                                 failure:(failureBlock)failure;

- (NSURLSessionDataTask *)updateUserPasswordWithParameters:(NSDictionary *)params
                                                   success:(successBlock)success
                                                   failure:(failureBlock)failure;

@end

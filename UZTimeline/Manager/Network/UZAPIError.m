//
//  UZAPIError.m
//  maguanjiaios
//
//  Created by LiuXiaoyu on 12/27/15.
//  Copyright © 2015 cn.com.uzero. All rights reserved.
//

#import "UZAPIError.h"

NSString * const UZInternalNetworkingErrorDomain = @"UZInternalNetworkingErrorDomain";
NSString * const UZAPIErrorDomain = @"UZAPIErrorDomain";

@implementation UZAPIError

+ (NSError *)UZAPIValueInvalidError {
    NSError *error = [NSError errorWithDomain:UZAPIErrorDomain
                                         code:UZAPIErrorCode_APIError
                                     userInfo:@{NSLocalizedDescriptionKey: @"返回数据格式错误"}];
    return error;
}

@end

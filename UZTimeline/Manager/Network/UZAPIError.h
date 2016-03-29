//
//  UZAPIError.h
//  maguanjiaios
//
//  Created by LiuXiaoyu on 12/27/15.
//  Copyright © 2015 cn.com.uzero. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UZInternalNetworkingErrorDomain;
extern NSString * const UZAPIErrorDomain;

typedef NS_ENUM(NSUInteger, UZAPIErrorCode) {
    UZAPIErrorCode_APIError = 9999
};

@interface UZAPIError : NSObject

+ (NSError *)UZAPIValueInvalidError;//返回数据中value字段不符合格式或者无效的错误

@end

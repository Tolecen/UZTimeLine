//
//  UZAPIClient.h
//  maguanjiaios
//
//  Created by LiuXiaoyu on 12/27/15.
//  Copyright © 2015 cn.com.uzero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "UZAPIError.h"

#define HK_COMMERIAL_LIST_REQUEST @"getCommercialList"
#define HK_UPDATEUSER_NAME_REQUEST @"updateUserName"

typedef void(^successBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^failureBlock)(NSURLSessionDataTask *task, NSError *error);

extern NSString * UZAPIAppServerBaseURLString;
extern NSString * UZAPIAppImgBaseURLString;
extern NSString *const UZAPIUploadServerBaseURLString;
extern NSString *const HK_QNTOKEN;


@interface UZAPIClient : AFHTTPSessionManager

@property (nonatomic, strong, readonly) NSMutableDictionary *commonParams;

+ (UZAPIClient *)clientForServerWithBaseURLString:(NSString *)server;

+ (UZAPIClient *)sharedClient;

- (NSMutableDictionary *)commonParams;

- (NSURLSessionDataTask *)postDefaultClientWithURLPath:(NSString *)path
                                            parameters:(NSDictionary *)parameters
                                               success:(successBlock)success
                                               failure:(failureBlock)failure;

- (NSURLSessionTask *)uploadFileFileName:(NSString *)fileName
                               imageData:(NSData *)imageData
                                 success:(void(^)(NSString *imageKey))success
                                 failure:(failureBlock)failure;

@end

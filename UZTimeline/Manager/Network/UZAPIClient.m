//
//  UZAPIClient.m
//  maguanjiaios
//
//  Created by LiuXiaoyu on 12/27/15.
//  Copyright © 2015 cn.com.uzero. All rights reserved.
//

#import "UZAPIClient.h"
#import "FWUtility.h"

static const CGFloat kUZDefaultTimeoutInterval = 15.f;
NSString *const kUZSuccessDataCode  = @"0";

#ifdef DEBUG
NSString *const UZAPIAppServerBaseURLString = @"http://120.24.16.64:9080/maguanjia";
NSString *const UZAPIUploadServerBaseURLString = @"http://m.ririzhuan.com";
#else
NSString *const UZAPIAppServerBaseURLString = @"http://120.24.16.64:9080/maguanjia";
NSString *const UZAPIUploadServerBaseURLString = @"http://m.ririzhuan.com";
#endif

NSString *const HK_QNTOKEN   = @"HK_QNTOKEN";
NSString *const HK_QNUPLOAD_FILE    = @"http://upload.qiniu.com";

@interface UZAPIClient()

@property (nonatomic, strong, readwrite) NSMutableDictionary *commonParams;

@end

@implementation UZAPIClient

#pragma mark -- Initial

+ (UZAPIClient *)clientForServerWithBaseURLString:(NSString *)server {
    static NSMutableDictionary * clients = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clients = [NSMutableDictionary dictionary];
    });
    if (clients[server]) {
        return clients[server];
    } else {
        UZAPIClient *client = [[UZAPIClient alloc] initWithBaseURL:[NSURL URLWithString:server]];
        clients[server] = client;
        return client;
    }
}

+ (UZAPIClient *)sharedClient {
    return [UZAPIClient clientForServerWithBaseURLString:UZAPIAppServerBaseURLString];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = kUZDefaultTimeoutInterval;
        NSSet *acceptableContentTypes = [self.responseSerializer acceptableContentTypes];
        acceptableContentTypes = [acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain",@"text/html"]];
        self.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    return self;
}

#pragma mark -- Post

- (NSString *)inner_CreatRelativePathWithRequestPath:(NSString *)path {
    return [NSString stringWithFormat:@"client?m=%@",path];
}

- (NSDictionary *)inner_AdditionDefaultParameters:(NSDictionary *)paramters {
    if (!paramters) {
        return [self commonParams].copy;
    }
    NSMutableDictionary *params = [self commonParams];
    params[@"params"] = paramters;
    return params.copy;
}

- (NSMutableDictionary *)commonParams {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *token = @"111";
    params[@"token"] = token;
    params[@"clientVersion"] = [FWUtility getAppVersion];//客户端版本
    params[@"apiVersion"] = @"1.0.0";//服务器版本
    params[@"client"] = @"ios";//客户端类型
    params[@"brand"] = @"apple";//设备厂商
    params[@"model"] = [FWUtility getDeviceModel];//客户端型号
    params[@"osVersion"] = [FWUtility getDeviceOS];//客户端系统版本
    params[@"channel"] = @"1";//渠道编号
    params[@"networkType"] = @([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);//网络类型
    params[@"mac"] = [FWUtility getMacAddress];//mac地址
    params[@"imei"] = @"thisisimei2";
    
    return params;
}

- (NSURLSessionDataTask *)postDefaultClientWithURLPath:(NSString *)path
                                            parameters:(NSDictionary *)parameters
                                               success:(successBlock)success
                                               failure:(failureBlock)failure {
    NSString *relativePath = [self inner_CreatRelativePathWithRequestPath:path];
    NSDictionary *params = [self inner_AdditionDefaultParameters:parameters];
    __weak __typeof(self) weakSelf = self;
    return
    [self POST:relativePath
    parameters:params
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           BOOL check_valid = [weakSelf inner_CheckSuccessResponseObjectValid:responseObject];
           if (check_valid) {
               success(task, responseObject);
           } else {
               NSError *error = [weakSelf inner_ConfigureErrorWithInvalidResponseObject:responseObject];
               failure(task, error);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           failure(task, error);
       }];
}

- (NSURLSessionTask *)uploadFileFileName:(NSString *)fileName
                               imageData:(NSData *)imageData
                                 success:(void(^)(NSString *imageKey))success
                                 failure:(failureBlock)failure {
    if (!fileName) {
        fileName = @"uploadAvatar.jpg";
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *QNToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"HK_QNTOKEN"];
    parameters[@"token"] = QNToken;
    parameters[@"key"] = fileName;
    
    return
    [[AFHTTPSessionManager manager] POST:HK_QNUPLOAD_FILE
                              parameters:parameters.copy
               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                   if (imageData) {
                       [formData appendPartWithFileData:imageData
                                                   name:@"file"
                                               fileName:fileName
                                               mimeType:@"image/jpeg"];
                   }
               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                   if (responseObject) {
                       NSString *key = responseObject[@"key"];
                       if (key && key.length > 0) {
                           success(key);
                       } else {
                       NSError *error = [self inner_ConfigureErrorWithInvalidResponseObject:nil];
                           failure(task, error);
                       }
                   } else {
                       NSError *error = [self inner_ConfigureErrorWithInvalidResponseObject:nil];
                       failure(task, error);
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure(task, error);
               }];
}

- (BOOL)inner_CheckSuccessResponseObjectValid:(id)responseObject {
    BOOL success_valid = NO;
    if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
        return success_valid;
    }
    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
    if ([code isEqualToString:kUZSuccessDataCode]) {
        success_valid = YES;
        return success_valid;
    }
    return success_valid;
}

- (NSError *)inner_ConfigureErrorWithInvalidResponseObject:(id)responseObject {
    NSError *error = [NSError errorWithDomain:UZAPIErrorDomain
                                         code:UZAPIErrorCode_APIError
                                     userInfo:@{NSLocalizedDescriptionKey : @""}];
    return error;
}

@end

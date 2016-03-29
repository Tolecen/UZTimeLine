//
//  UZAPIClient+Launch.h
//  maguanjiaios
//
//  Created by LiuXiaoyu on 1/10/16.
//  Copyright © 2016 cn.com.uzero. All rights reserved.
//

#import "UZAPIClient.h"

@interface UZAPIClient (Launch)

- (NSURLSessionTask *)requestQNTokenWithSuccess:(void(^)(NSString *QNToken))success
                                        failure:(failureBlock)failure;

@end

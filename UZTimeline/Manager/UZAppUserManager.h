//
//  UZAppUserManager.h
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZAppUserManager : NSObject

+ (void)appSaveCurrentUserInfo:(id)userModel;

+ (void)appDeletePreviousUserInfo;

+ (id)currentUser;//当前用户

+ (BOOL)isLogin;

@end

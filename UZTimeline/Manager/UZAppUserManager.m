//
//  UZAppUserManager.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZAppUserManager.h"
#import "LZKeychain.h"

NSString *const UZSaveUserKeyChainKey   = @"UZSaveUserKeyChainKey";

@implementation UZAppUserManager

+ (void)appSaveCurrentUserInfo:(id)userModel {
    [LZKeychain save:UZSaveUserKeyChainKey data:userModel];
}

+ (void)appDeletePreviousUserInfo {
    [LZKeychain keychainDelete:UZSaveUserKeyChainKey];
}

+ (id)currentUser {
    id userModel = [LZKeychain load:UZSaveUserKeyChainKey];
//    if (userModel && [userModel isKindOfClass:[HKUserModel class]]) {
//        return userModel;
//    }
    return userModel;
}

+ (BOOL)isLogin {
    id user = [UZAppUserManager currentUser];
    if (!user) {
        return NO;
    }
    return YES;
}

@end

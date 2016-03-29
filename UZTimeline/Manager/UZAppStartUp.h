//
//  UZAppStartUp.h
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UZAppStartUp : NSObject

@property (nonatomic, strong, readonly) UINavigationController *rootViewController;

+ (instancetype)appStartUp;

@end

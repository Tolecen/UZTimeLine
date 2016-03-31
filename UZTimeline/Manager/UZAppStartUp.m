//
//  UZAppStartUp.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZAppStartUp.h"
#import "UZNavigationController.h"
#import "UZTimelineVC.h"
#import "UIColor+YYAdd.h"

@interface UZAppStartUp()

@property (nonatomic, strong, readwrite) UZNavigationController *rootViewController;

@end

@implementation UZAppStartUp

+ (instancetype)appStartUp {
    static UZAppStartUp *_appStartUp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appStartUp = [[UZAppStartUp alloc] init];
    });
    return _appStartUp;
}

- (instancetype)init {
    if (self = [super init]) {
        [self inner_AppStartUp];
    }
    return self;
}

- (void)inner_AppStartUp {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"2dd3f6"]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    UZTimelineVC *viewController = [[UZTimelineVC alloc] init];
    UZNavigationController *navigationController = [[UZNavigationController alloc] initWithRootViewController:viewController];
    viewController.view.backgroundColor = [UIColor greenColor];
    self.rootViewController = navigationController;
}

@end

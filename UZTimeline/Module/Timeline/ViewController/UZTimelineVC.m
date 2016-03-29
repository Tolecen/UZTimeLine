//
//  UZTimelineVC.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZTimelineVC.h"
#import "UZNavigationController.h"
#import "UZLoginVC.h"
#import "UZAppUserManager.h"

@implementation UZTimelineVC

- (void)dealloc {
    
}

- (NSString *)title {
    return @"内容";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self inner_CheckUserLogin];
}

#pragma mark -- Login

- (void)inner_CheckUserLogin {
    BOOL isLogin = [UZAppUserManager isLogin];
    if (!isLogin) {
        UZLoginVC *loginVC = [[UZLoginVC alloc] init];
        UZNavigationController *navigationController = [[UZNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

@end

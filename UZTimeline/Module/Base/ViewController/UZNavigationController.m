//
//  UZNavigationController.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/28.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZNavigationController.h"

@interface UZNavigationController()<UIGestureRecognizerDelegate>

@end

@implementation UZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

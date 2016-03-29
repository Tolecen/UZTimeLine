//
//  UZLoginVC.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZLoginVC.h"
#import "UZRegisterVC.h"
#import "UZTextField+Extension.h"
#import "UIButton+Extension.h"
#import "Masonry.h"

@interface UZLoginVC()<UITextFieldDelegate>

@property (nonatomic, weak) UZTextField *accountTF;
@property (nonatomic, weak) UZTextField *passworkTF;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIButton *registeBtn;

@end

@implementation UZLoginVC

- (NSString *)title {
    return @"登录";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UZTextField *accountTF = [UZTextField createTextFieldWithPlaceholder:@"输入用户名"
                                                               leftImage:@"login_user_icon"];
    [self.view addSubview:accountTF];
    self.accountTF = accountTF;
    
    UZTextField *passworkTF = [UZTextField createTextFieldWithPlaceholder:@"输入密码"
                                                                leftImage:@"login_secret_icon"];
    [self.view addSubview:passworkTF];
    self.passworkTF = passworkTF;
    
    [accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    [passworkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(accountTF.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    UIButton *loginBtn = [UIButton createButtonWithTitle:@"登录"
                                                  target:self
                                                  action:@selector(inner_LoginAction:)];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIButton *registeBtn = [UIButton createButtonWithTitle:@"注册"
                                                    target:self
                                                    action:@selector(inner_RegisteAction:)];
    [self.view addSubview:registeBtn];
    self.registeBtn = registeBtn;
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 60) / 2;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(passworkTF.mas_bottom).offset(20);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(35);
    }];
    
    [registeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(passworkTF.mas_bottom).offset(20);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(35);
    }];
}

- (void)inner_LoginAction:(UIButton *)sender {
    
}

- (void)inner_RegisteAction:(UIButton *)sender {
    UZRegisterVC *regiserVC = [[UZRegisterVC alloc] init];
    [self.navigationController pushViewController:regiserVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end

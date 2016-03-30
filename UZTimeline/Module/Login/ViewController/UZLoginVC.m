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
#import "UZAPIClient.h"
#import "SFHFKeychainUtils.h"
#import "SVProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>

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
    
    if ([SFHFKeychainUtils getPasswordForUsername:UZAccount andServiceName:UZTimeLineSeivice error:nil]) {
        self.accountTF.text = [SFHFKeychainUtils getPasswordForUsername:UZAccount andServiceName:UZTimeLineSeivice error:nil];
    }
    
    UZTextField *passworkTF = [UZTextField createTextFieldWithPlaceholder:@"输入密码"
                                                                leftImage:@"login_secret_icon"];
    [self.view addSubview:passworkTF];
    passworkTF.secureTextEntry = YES;
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
    if (self.accountTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if (self.passworkTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    [self.accountTF resignFirstResponder];
    [self.passworkTF resignFirstResponder];
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.accountTF.text,@"username",[self md5Str:self.passworkTF.text],@"passwd", nil];
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:@"userLogin" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * uinfo = responseObject[@"data"];
        [SFHFKeychainUtils storeUsername:UZAccount andPassword:uinfo[@"username"] forServiceName:UZTimeLineSeivice updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:UZPWD andPassword:uinfo[@"passwd"] forServiceName:UZTimeLineSeivice updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:UZUserId andPassword:uinfo[@"user_id"] forServiceName:UZTimeLineSeivice updateExisting:YES error:nil];
        [SVProgressHUD dismiss];
        if (self.loginSuccess) {
            self.loginSuccess();
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSDictionary * dict = error.userInfo;
        [SVProgressHUD showErrorWithStatus:dict[@"message"]];
    }];
}


- (void)inner_RegisteAction:(UIButton *)sender {
    UZRegisterVC *regiserVC = [[UZRegisterVC alloc] init];
    [self.navigationController pushViewController:regiserVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(NSString *)md5Str:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    size_t len = strlen(cStr);
    CC_MD5(cStr, (unsigned int)len, md);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            md[0], md[1], md[2], md[3],
            md[4], md[5], md[6], md[7],
            md[8], md[9], md[10], md[11],
            md[12], md[13], md[14], md[15]
            ];
}

@end

//
//  UZRegisterVC.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZRegisterVC.h"
#import "UZTextField+Extension.h"
#import "UIButton+Extension.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "IdentifyingString.h"
#import "Common.h"
#import "UZAPIClient.h"
#import "SFHFKeychainUtils.h"
@interface UZRegisterVC()

@property (nonatomic, weak) UZTextField *phoneTF;
@property (nonatomic, weak) UZTextField *verifyCodeTF;
@property (nonatomic, weak) UZTextField *passworkTF;
@property (nonatomic, weak) UIButton *verifyBtn;
@property (nonatomic, weak) UIButton *registeBtn;

@end

@implementation UZRegisterVC

- (NSString *)title {
    return @"注册";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    UZTextField *phoneTF = [UZTextField createTextFieldWithPlaceholder:@"输入手机号"
                                                             leftImage:@"login_user_icon"];
    [self.view addSubview:phoneTF];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF = phoneTF;
    
    UZTextField *verifyCodeTF = [UZTextField createTextFieldWithPlaceholder:@"输入验证码"
                                                                  leftImage:@"verifycode_icon"];
    [self.view addSubview:verifyCodeTF];
    verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCodeTF = verifyCodeTF;
    
    UZTextField *passworkTF = [UZTextField createTextFieldWithPlaceholder:@"输入密码"
                                                                leftImage:@"login_secret_icon"];
    [self.view addSubview:passworkTF];
    passworkTF.secureTextEntry = YES;
    self.passworkTF = passworkTF;
    
    UIButton *verifyBtn = [UIButton createButtonWithTitle:@"获取验证码"
                                                  target:self
                                                  action:@selector(inner_GetVerifyCode:)];
    [self.view addSubview:verifyBtn];
    self.verifyBtn = verifyBtn;
    
    UIButton *registeBtn = [UIButton createButtonWithTitle:@"注册"
                                                    target:self
                                                    action:@selector(inner_RegisteAction:)];
    [self.view addSubview:registeBtn];
    self.registeBtn = registeBtn;
    
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    
    [verifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(10);
        make.right.mas_equalTo(verifyBtn.mas_left).offset(0);
        make.height.mas_equalTo(35);
    }];
    
    [passworkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(verifyCodeTF.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    [registeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(passworkTF.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
}

- (void)inner_GetVerifyCode:(UIButton *)sender {
    
}

- (void)inner_RegisteAction:(UIButton *)sender {
    if (self.phoneTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    else if (![IdentifyingString validateMobile:self.phoneTF.text])
    {
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    if (self.passworkTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    else if (self.passworkTF.text.length<4 || self.passworkTF.text.length>16) {
        [SVProgressHUD showErrorWithStatus:@"密码为4-16位"];
        return;
    }
    
    
    [self.phoneTF resignFirstResponder];
    [self.verifyCodeTF resignFirstResponder];
    [self.passworkTF resignFirstResponder];
    [SVProgressHUD showWithStatus:@"注册中..."];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneTF.text,@"username",self.phoneTF.text,@"mobile",[Common md5Str:self.passworkTF.text],@"passwd", nil];
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:@"userRegister" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * uinfo = responseObject[@"data"];
        [SFHFKeychainUtils storeUsername:UZAccount andPassword:uinfo[@"username"] forServiceName:UZTimeLineSeivice updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:UZPWD andPassword:uinfo[@"passwd"] forServiceName:UZTimeLineSeivice updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:UZUserId andPassword:uinfo[@"user_id"] forServiceName:UZTimeLineSeivice updateExisting:YES error:nil];
        [SVProgressHUD dismiss];
        if (self.regSuccess) {
            self.regSuccess();
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSDictionary * dict = error.userInfo;
        [SVProgressHUD showErrorWithStatus:dict[@"message"]];
    }];

    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end

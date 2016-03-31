//
//  IdentifyingString.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "IdentifyingString.h"

@implementation IdentifyingString


+(BOOL)validateMobile:(NSString* )mobile
{
    //手机号以13， 15，18，17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
+(BOOL)isValidatePassWord:(NSString*)password
{
    if (password.length>5) {
        NSString *passwordRegex = @"^[a-zA-Z0-9_]*$";
        NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
        return  [passwordTest evaluateWithObject:password];
    }
    return NO;
}
+(BOOL)isValidateIdentionCode:(NSString*)identionCode
{
    if (identionCode.length==4) {
        NSString *passwordRegex = @"^[0-9]*$";
        NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
        return  [passwordTest evaluateWithObject:identionCode];
    }
    return NO;
}
+(BOOL)isValidateAllSpace:(NSString*)str
{
    NSString* string = [str stringByReplacingOccurrencesOfString:@" "withString:@""];
    if (string.length>0) {
        return NO;
    }else
        return YES;
}
@end

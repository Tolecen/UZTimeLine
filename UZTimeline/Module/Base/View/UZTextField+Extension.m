//
//  UZTextField+Extension.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/28.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZTextField+Extension.h"
#import "UIColor+YYAdd.h"

@implementation UZTextField (Extension)

+ (UZTextField *)createTextFieldWithPlaceholder:(NSString *)placeholder
                                      leftImage:(NSString *)leftImage {
    UZTextField *textField = [[UZTextField alloc] initWithFrame:CGRectZero];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:15];
    UIImage *image = [UIImage imageNamed:@"textfield_background"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    textField.background = image;
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftImage]];
    textField.leftView = leftImageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField setValue:UIColorHex(0xdcdcdc) forKeyPath:@"_placeholderLabel.textColor"];
    return textField;
}

@end

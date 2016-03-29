//
//  UIButton+Extension.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/28.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIColor+YYAdd.h"

@implementation UIButton (Extension)

+ (UIButton *)createButtonWithTitle:(NSString *)title
                             target:(id)target
                             action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithHexString:@"0x3ED0F3"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 2.f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = .5;
    button.layer.borderColor = [UIColor colorWithHexString:@"0x3ED0F3"].CGColor;
    return button;
}

@end

//
//  UIButton+Extension.h
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/28.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+ (UIButton *)createButtonWithTitle:(NSString *)title
                             target:(id)target
                             action:(SEL)action;

@end

//
//  UZTextField.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/28.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZTextField.h"

@implementation UZTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(5, (bounds.size.height - 24) / 2, 24, 24);
    return inset;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect newBounds = CGRectMake(CGRectGetMinX(bounds) + 8, CGRectGetMinY(bounds), CGRectGetWidth(bounds) - 8, CGRectGetHeight(bounds));
    return CGRectInset( newBounds , 24 , 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect newBounds = CGRectMake(CGRectGetMinX(bounds) + 8, CGRectGetMinY(bounds), CGRectGetWidth(bounds) - 8, CGRectGetHeight(bounds));
    return CGRectInset( newBounds , 24 , 0 );
}

@end

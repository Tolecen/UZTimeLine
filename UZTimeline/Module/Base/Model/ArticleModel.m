//
//  ArticleModel.m
//  UZTimeline
//
//  Created by TaoXinle on 16/3/30.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel
+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *dic = @{@"author.file.key":@"avatarUrl",
                          @"author.nickname":@"userNickname"};
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}
@end

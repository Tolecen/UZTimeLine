//
//  ArticleModel.h
//  UZTimeline
//
//  Created by TaoXinle on 16/3/30.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "JSONModel.h"

@interface ArticleModel : JSONModel
@property (nonatomic,strong)NSString<Optional> * topic_id;
@property (nonatomic,strong)NSString<Optional> * topic_name;
@property (nonatomic,strong)NSString<Optional> * topic_intro;
@property (nonatomic,strong)NSDictionary<Optional> * tag;
@property (nonatomic,strong)NSArray<Optional> * files;
@property (nonatomic,strong)NSString<Optional> * created_time;
@end

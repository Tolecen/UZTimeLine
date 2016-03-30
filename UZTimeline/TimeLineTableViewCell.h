//
//  TimeLineTableViewCell.h
//  UZTimeline
//
//  Created by TaoXinle on 16/3/30.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"
@interface TimeLineTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UIButton * friendCircleBtn;
@property (nonatomic,strong)UIView * imgBGV;
@property (nonatomic,strong)UIView * lineV;
@property (nonatomic,assign)NSInteger cellIndex;
@property (nonatomic,strong)ArticleModel * article;

@property (nonatomic,copy)void(^imageClicked) (NSInteger cellIndex, int clickedImgIndex, NSArray * imgArray);
@property (nonatomic,copy)void(^shareBtnClicked) (NSInteger cellIndex, NSArray * imgArray, NSString * content);
@end

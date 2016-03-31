//
//  TimeLineTableViewCell.m
//  UZTimeline
//
//  Created by TaoXinle on 16/3/30.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "TimeLineTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UZAPIClient.h"
#import "Common.h"
@implementation TimeLineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        self.avatarIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.avatarIV.backgroundColor = [UIColor colorWithHexString:@"e1e0e0"];
        [self.contentView addSubview:self.avatarIV];
        
        UIImageView * maskV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [maskV setImage:[UIImage imageNamed:@"avatar_mask"]];
        [self.contentView addSubview:maskV];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
        self.nameL.numberOfLines = 0;
        self.nameL.lineBreakMode = NSLineBreakByCharWrapping;
        self.nameL.backgroundColor = [UIColor clearColor];
        self.nameL.textColor = [UIColor colorWithHexString:@"1cc1e4"];
        self.nameL.font = [UIFont boldSystemFontOfSize:15];
        self.nameL.text = @"大球和小球";
        [self.contentView addSubview:self.nameL];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, ContentLabelWidth, 20)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"3d3d3d"];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.text = @"默认文字";
        [self.contentView addSubview:self.contentLabel];
        
        
        
        
        float picWidth = (ContentLabelWidth-30-10)/3;
        
        self.imgBGV = [[UIView alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.contentLabel.frame)+10, kScreenWidth-60, picWidth*3+20)];
        self.imgBGV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imgBGV];
        
        for (int i = 0; i<9; i++) {
            UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0+5*(i%3-1+1)+picWidth*(i%3), picWidth*(int)(i/3)+5*(int)(i/3), picWidth, picWidth)];
            imgv.userInteractionEnabled = YES;
            imgv.backgroundColor = [UIColor colorWithHexString:@"e1e0e0"];
            imgv.tag = i+1;
            [self.imgBGV addSubview:imgv];
            
            UITapGestureRecognizer * tapZ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImageV:)];
            [imgv addGestureRecognizer:tapZ];
        }
        
        
//        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, CGRectGetMaxY(self.imgBGV.frame)+8, 200, 20)];
//        self.timeLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        self.timeLabel.backgroundColor = [UIColor clearColor];
//        self.timeLabel.textColor = [UIColor colorWithHexString:@"adafaf"];
//        self.timeLabel.font = [UIFont systemFontOfSize:12];
//        self.timeLabel.text = @"0000-0000";
//        [self.contentView addSubview:self.timeLabel];
        
        
        self.friendCircleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.friendCircleBtn setFrame:CGRectMake(kScreenWidth-15-40-5, CGRectGetMaxY(self.imgBGV.frame), 40, 40)];
        [self.friendCircleBtn setBackgroundImage:[UIImage imageNamed:@"share_share"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.friendCircleBtn];
        [self.friendCircleBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame)+10, kScreenWidth, 1)];
        self.lineV.backgroundColor = [UIColor colorWithHexString:@"e1e0e0"];
        self.lineV.alpha = 0.7;
        [self.contentView addSubview:self.lineV];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_/sq/80",UZAPIAppImgBaseURLString,self.article.avatarUrl]] placeholderImage:nil];
    self.nameL.text = self.article.userNickname;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:self.contentLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize nameSize = [self.article.topic_intro boundingRectWithSize:CGSizeMake(ContentLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.contentLabel.text = self.article.topic_intro;
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, nameSize.width, nameSize.height);
    
    float bgvH = 0.f;
    for (int i = 0; i<9; i++) {
        UIImageView * imgv = (UIImageView *)[self.imgBGV viewWithTag:i+1];
        if (i<self.article.files.count) {
            imgv.hidden = NO;
            NSDictionary * picDict = self.article.files[i];
            NSString * imgKey = picDict[@"key"];
            if (self.article.files.count==1) {
                float imgWidth = [picDict[@"width"] floatValue];
                float imgHeight = [picDict[@"height"] floatValue];
                float ratio = imgWidth/imgHeight;
                if (ratio>=1) {
                    [imgv setFrame:CGRectMake(imgv.frame.origin.x, imgv.frame.origin.y, ContentLabelWidth-50, (ContentLabelWidth-50)/ratio)];
                    NSString * imgUrl = [NSString stringWithFormat:@"%@%@_/fw/%d",UZAPIAppImgBaseURLString,imgKey,(int)kScreenWidth];
                    [imgv sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
                }
                else
                {
                    float maxH = ContentLabelWidth-100;
                    if (ratio>=0.2) {
                        [imgv setFrame:CGRectMake(imgv.frame.origin.x, imgv.frame.origin.y, maxH*ratio,maxH)];
                        NSString * imgUrl = [NSString stringWithFormat:@"%@%@_/fh/%d",UZAPIAppImgBaseURLString,imgKey,(int)kScreenWidth];
                        [imgv sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
                    }
                    else
                    {
                        [imgv setFrame:CGRectMake(imgv.frame.origin.x, imgv.frame.origin.y, maxH*0.2,maxH)];
                        NSString * imgUrl = [NSString stringWithFormat:@"%@%@_/fwfh/%dx%d",UZAPIAppImgBaseURLString,imgKey,(int)(kScreenWidth*0.2),(int)kScreenWidth];
                        [imgv sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
                    }
                }
            }
            else if(self.article.files.count==4 || self.article.files.count==2){
                float picWidth = (ContentLabelWidth-40-5)/2;
                [imgv setFrame:CGRectMake(0+5*(i%2-1+1)+picWidth*(i%2), picWidth*(int)(i/2)+5*(int)(i/2), picWidth, picWidth)];
                NSString * imgUrl = [NSString stringWithFormat:@"%@%@_/sq/180",UZAPIAppImgBaseURLString,imgKey];
                [imgv sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
            }
            else
            {
                float picWidth = (ContentLabelWidth-30-10)/3;
                [imgv setFrame:CGRectMake(0+5*(i%3-1+1)+picWidth*(i%3), picWidth*(int)(i/3)+5*(int)(i/3), picWidth, picWidth)];
                NSString * imgUrl = [NSString stringWithFormat:@"%@%@_/sq/150",UZAPIAppImgBaseURLString,imgKey];
                [imgv sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
                
//                NSLog(@"url:%@",imgUrl);
            }
            
           
//            NSString * imgUrl = [NSString stringWithFormat:@"%@%@",UZAPIAppImgBaseURLString,imgKey];
//            [imgv sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
            
            bgvH = CGRectGetMaxY(imgv.frame);
            
        }
        else{
            imgv.hidden = YES;
        }
        
        
    }
    
    [self.imgBGV setFrame:CGRectMake(60, CGRectGetMaxY(self.contentLabel.frame)+10, kScreenWidth-65, bgvH)];
//    [self.timeLabel setFrame:CGRectMake(15, CGRectGetMaxY(self.imgBGV.frame)+8, 200, 20)];
//    [self.timeLabel  setText:[Common dynamicMessageTime:self.article.created_time]];
    [self.friendCircleBtn setFrame:CGRectMake(kScreenWidth-10-40, CGRectGetMaxY(self.imgBGV.frame)-5, 40, 40)];
    [self.lineV setFrame:CGRectMake(5, CGRectGetMaxY(self.imgBGV.frame)+34, kScreenWidth-10, 1)];
}

-(void)tappedImageV:(UITapGestureRecognizer *)tap
{
    UIImageView * u = (UIImageView *)[tap view];
//    NSLog(@"%ld,",(long)u.tag);
    if (self.imageClicked) {
        self.imageClicked(self.cellIndex,(int)u.tag-1,self.article.files);
    }
}
-(void)shareBtnAction
{
    if (self.shareBtnClicked) {
        self.shareBtnClicked(self.cellIndex,self.article.files,self.article.topic_intro);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

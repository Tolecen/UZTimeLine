//
//  UZTimelineVC.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UZTimelineVC.h"
#import "UZNavigationController.h"
#import "UZLoginVC.h"
#import "UZAppUserManager.h"
#import "TimeLineTableViewCell.h"
#import "UZAPIClient.h"
#import "ArticleModel.h"
#import "SVProgressHUD.h"
#import "ACImageBrowser.h"
#import "SettingViewController.h"
#import "MJRefresh.h"
#import "SDWebImageDownloader.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "FWAlertHelper.h"

@interface UZTimelineVC()<UITableViewDelegate,UITableViewDataSource,ACImageBrowserDelegate,UIAlertViewDelegate>
{
    int pageIndex;
    int pageSize;
    NSMutableArray * savingImgArray;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation UZTimelineVC

- (void)dealloc {
    
}

- (NSString *)title {
    return @"TimeLine";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(toSettingPage)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
    pageIndex = 0;
    pageSize = 20;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    
    
   
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 0;
        [self getTimelineData];
    }];
    
    _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getTimelineData];
    }];
    
    BOOL isLogin = [UZAppUserManager isLogin];
    if (isLogin) {
        NSArray * localData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"localinfosave_%@",[UZAppUserManager getUserId]]];
        if (localData) {
            NSArray * tA = [NSMutableArray arrayWithArray:localData];
            if (!_dataArray) {
                _dataArray = [NSMutableArray array];
            }

            [_dataArray removeAllObjects];

            for (NSDictionary * dict in tA) {
                ArticleModel * article = [[ArticleModel alloc] initWithDictionary:dict error:nil];
                [_dataArray addObject:article];
            }

            [_tableView reloadData];
        }
        [_tableView.mj_header beginRefreshing];
    }
    
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray) {
        return _dataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray) {
        float cH = 35.f;
        ArticleModel * article = _dataArray[indexPath.row];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize nameSize = [article.topic_intro boundingRectWithSize:CGSizeMake(ContentLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        cH = cH + nameSize.height+10+35;
        
        float bgvH = 0.f;
        for (int i = 0; i<9; i++) {
            if (i<article.files.count) {
                NSDictionary * picDict = article.files[i];
                if (article.files.count==1) {
                    float imgWidth = [picDict[@"width"] floatValue];
                    float imgHeight = [picDict[@"height"] floatValue];
                    float ratio = imgWidth/imgHeight;
                    if (ratio>=1) {
                        bgvH = (ContentLabelWidth-50)/ratio;
                    }
                    else
                    {
                        float maxH = ContentLabelWidth-100;
                        bgvH = maxH;
                    }
                }
                else if (article.files.count==4 || article.files.count==2){
                    float picWidth = (ContentLabelWidth-40-5)/2;
                    bgvH = picWidth*(int)(i/2)+5*(int)(i/2) + picWidth;
                }
                else
                {
                    float picWidth = (ContentLabelWidth-30-10)/3;
                    bgvH = picWidth*(int)(i/3)+5*(int)(i/3) + picWidth;
                }
                
    
                
            }
            
            
        }
        
        cH = cH + bgvH;
        return cH;

    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TimeLinecell";
    TimeLineTableViewCell *hcell = (TimeLineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (hcell == nil) {
        hcell = [[TimeLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        hcell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    hcell.cellIndex = indexPath.row;
    hcell.article = _dataArray[indexPath.row];
    hcell.imageClicked = ^(NSInteger cellIndex, int clickedImgIndex, NSArray * imgArray){
        [self clickedPicIndex:clickedImgIndex withArray:imgArray];
    };
    hcell.shareBtnClicked = ^(NSInteger cellIndex, NSArray * imgArray, NSString * content){
        [self shareBtnToDoWithImgArray:imgArray content:content];
    };
    return hcell;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self inner_CheckUserLogin];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

#pragma mark -- Login

- (void)inner_CheckUserLogin {
    BOOL isLogin = [UZAppUserManager isLogin];
    if (!isLogin) {
        [_dataArray removeAllObjects];
        _dataArray = nil;
        [_tableView reloadData];
        
        UZLoginVC *loginVC = [[UZLoginVC alloc] init];
        loginVC.loginSuccess = ^(){
            NSArray * localData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"localinfosave_%@",[UZAppUserManager getUserId]]];
            if (localData) {
                NSArray * tA = [NSMutableArray arrayWithArray:localData];
                if (!_dataArray) {
                    _dataArray = [NSMutableArray array];
                }
                
                [_dataArray removeAllObjects];
                
                for (NSDictionary * dict in tA) {
                    ArticleModel * article = [[ArticleModel alloc] initWithDictionary:dict error:nil];
                    [_dataArray addObject:article];
                }
                
                [_tableView reloadData];
            }
            [_tableView.mj_header beginRefreshing];
        };
        UZNavigationController *navigationController = [[UZNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        
    }
}

-(void)getTimelineData
{
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageSize],@"pageSize",[NSString stringWithFormat:@"%d",pageIndex],@"page",[UZAppUserManager getUserId],@"userId", nil];
    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:@"getAllTopics" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * dataA = responseObject[@"data"];
        NSLog(@"dddd:%@",dataA);
        if (!_dataArray) {
            _dataArray = [NSMutableArray array];
        }
        if (pageIndex==0) {
            [_dataArray removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setObject:dataA forKey:[NSString stringWithFormat:@"localinfosave_%@",[UZAppUserManager getUserId]]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        for (NSDictionary * dict in dataA) {
            ArticleModel * article = [[ArticleModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:article];
        }
        
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        
        if (dataA.count>0) {
            pageIndex++;
            [_tableView.mj_footer endRefreshing];
        }
        else
        {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSDictionary * dict = error.userInfo;
        [SVProgressHUD showErrorWithStatus:dict[@"message"]];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];

}

-(void)clickedPicIndex:(int)index withArray:(NSArray *)array
{
    //    NSLog(@"clicked index %d , array:%@",index,array);
    NSMutableArray * photosURLArray = [NSMutableArray array];
    for (NSDictionary * picDict  in array) {
        NSString * imgKey = picDict[@"key"];
        NSString * imgUrl = [NSString stringWithFormat:@"%@%@",UZAPIAppImgBaseURLString,imgKey];
        NSURL *url = [NSURL URLWithString:imgUrl];
        [photosURLArray addObject:url];
    }
    
    ACImageBrowser *browser = [[ACImageBrowser alloc] initWithImagesURLArray:photosURLArray];
    browser.delegate = self;
    //browser.fullscreenEnable = NO;
    [browser setPageIndex:index];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.navigationBarHidden = YES;
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)shareBtnToDoWithImgArray:(NSArray *)imgArray content:(NSString *)content
{
    UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
    pasteboard.string = content;
    NSMutableArray * iArray = [NSMutableArray array];
    __block int i = 0;
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"下载原图1/%d...",(int)imgArray.count]];
    for (NSDictionary * picDict  in imgArray) {
        NSString * imgKey = picDict[@"key"];
        NSString * imgUrl = [NSString stringWithFormat:@"%@%@",UZAPIAppImgBaseURLString,imgKey];
        NSURL *url = [NSURL URLWithString:imgUrl];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (!error) {
                [iArray addObject:image];
                NSLog(@"error:%@,finished:%d",error,finished);
                if (i<9) {
                    i++;
                }
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"下载原图%d/%d...",i+1,(int)imgArray.count]];
                if (i==imgArray.count) {
                    [SVProgressHUD showWithStatus:@"保存图片..."];
                    //                dispatch_async(dispatch_get_main_queue(), ^{
                    [self saveImageWithImgArray:iArray];
                    
                    //                });
                    
                }
            }
            else
                [SVProgressHUD showErrorWithStatus:@"图片下载失败"];

        }];
    }
}
-(void)saveImageWithImgArray:(NSMutableArray *)array
{
    savingImgArray = array;
    [self saveNextImage];
//    __block int i = 0;
//    for (UIImage * image in array) {
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        // Request to save the image to camera roll
//        [library
//         writeImageToSavedPhotosAlbum:[image CGImage]
//         orientation:(ALAssetOrientation)image.imageOrientation
//         completionBlock:^(NSURL *assetURL, NSError *error){
//             if (!error) {
//                 i++;
//                 if (i==array.count) {
//                     [SVProgressHUD dismiss];
////                     [self shareToFriendCircleWithContent:content];
//                     
//                     [self performSelectorOnMainThread:@selector(shareToFriendCircleWithContent) withObject:nil waitUntilDone:YES];
//                 }
//             }
//             else {
//                 
//             }
//         }];
//    }
    
}

-(void)saveNextImage
{
    if (savingImgArray.count > 0) {
        UIImage *image = [savingImgArray objectAtIndex:0];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    }
    else {
        [self saveImageAllDone];
    }
}

-(void)saveImageAllDone
{
    [SVProgressHUD dismiss];
     [self performSelectorOnMainThread:@selector(shareToFriendCircleWithContent) withObject:nil waitUntilDone:YES];
}

-(void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        //NSLog(@"%@", error.localizedDescription);
    }
    else {
        [savingImgArray removeObjectAtIndex:0];
    }
    [self saveNextImage];
}

-(void)shareToFriendCircleWithContent
{
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发布到微信" message:@"全部图片已保存到相册，文字已复制到剪贴板！请打开微信到朋友圈粘贴文字和上传图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开微信", nil];
    [alert show];

}
-(void)dismissAtIndex:(NSInteger)index
{
    
}

-(void)toSettingPage
{
    SettingViewController * setV = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setV animated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://dl/moments"]];
    }
}

@end

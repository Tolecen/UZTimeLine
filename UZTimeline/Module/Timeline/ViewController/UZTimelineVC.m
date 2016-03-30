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
@interface UZTimelineVC()<UITableViewDelegate,UITableViewDataSource,ACImageBrowserDelegate>
{
    int pageIndex;
    int pageSize;
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
    
    self.view.backgroundColor = [UIColor colorWithRed:250 green:250 blue:250 alpha:1];
    
    
   
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:250 green:250 blue:250 alpha:1];
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
        float cH = 15.f;
        ArticleModel * article = _dataArray[indexPath.row];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize nameSize = [article.topic_intro boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
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
                        bgvH = (kScreenWidth-30-50)/ratio;
                    }
                    else
                    {
                        float maxH = kScreenWidth-30-100;
                        bgvH = maxH;
                    }
                }
                else
                {
                    float picWidth = (kScreenWidth-30-30-20)/3;
                    bgvH = picWidth*(int)(i/3)+10*(int)(i/3) + picWidth;
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
//        NSLog(@"dddd:%@",dataA);
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
        [_tableView.mj_footer endRefreshing];
        if (dataA.count>0) {
            pageIndex++;
        }
        else
        {
            
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
}
-(void)dismissAtIndex:(NSInteger)index
{
    
}

-(void)toSettingPage
{
    SettingViewController * setV = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setV animated:YES];
}

@end

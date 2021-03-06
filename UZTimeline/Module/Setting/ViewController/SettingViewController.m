//
//  ViewController.m
//  UZTimeline
//
//  Created by TaoXinle on 16/3/30.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "SettingViewController.h"
#import "SFHFKeychainUtils.h"
#import "FWAlertHelper.h"
#import "SVProgressHUD.h"
#import "SDImageCache.h"
@interface SettingViewController()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * myAccountName;
    NSInteger cacheSize;
}
@property (nonatomic,strong)UITableView * tableView;

@end
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    cacheSize = 0;
    
    myAccountName = [SFHFKeychainUtils getPasswordForUsername:UZAccount andServiceName:UZTimeLineSeivice error:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"settingcell";
    UITableViewCell *hcell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (hcell == nil) {
        hcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    hcell.textLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.section==0) {
        hcell.selectionStyle = UITableViewCellSelectionStyleNone;
        hcell.textLabel.text = [NSString stringWithFormat:@"用户名: %@",myAccountName];
        hcell.textLabel.textAlignment = NSTextAlignmentLeft;
        hcell.textLabel.textColor = [UIColor colorWithHexString:@"4c4c4c"];
    }
    else if (indexPath.section==1) {
        hcell.selectionStyle = UITableViewCellSelectionStyleNone;
        hcell.textLabel.text = [NSString stringWithFormat:@"清除缓存 (约%.2fM)",(double)cacheSize/1024/1024];
        hcell.textLabel.textAlignment = NSTextAlignmentLeft;
        hcell.textLabel.textColor = [UIColor colorWithHexString:@"4c4c4c"];
    }
    else
    {
        hcell.selectionStyle = UITableViewCellSelectionStyleGray;
        hcell.textLabel.text = @"退出账户";
        hcell.textLabel.textAlignment = NSTextAlignmentCenter;
        hcell.textLabel.textColor = [UIColor redColor];
    }
    return hcell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        [SVProgressHUD showWithStatus:@"清理中..."];
//        [[SDImageCache sharedImageCache] setMaxCacheSize:1];
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] cleanDiskManualWithCompletionBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"清理完成"];
            [self calCacheSize];
        }];
    }
    else if (indexPath.section==2) {
        [FWAlertHelper alertWithTitle:@"退出登录"
                              message:@"确认退出登录吗?"
                           completion:^(NSInteger buttonIndex, NSString *title) {
                               if ([title isEqualToString:@"确定"]) {
                                   [SFHFKeychainUtils deleteItemForUsername:UZPWD andServiceName:UZTimeLineSeivice error:nil];
                                   [SFHFKeychainUtils deleteItemForUsername:UZUserId andServiceName:UZTimeLineSeivice error:nil];
                                   [self.navigationController popToRootViewControllerAnimated:NO];
                                   
                               }
                           } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self calCacheSize];
}

-(void)calCacheSize
{
    cacheSize = [[SDImageCache sharedImageCache] getSize];
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AppDelegate.m
//  UZTimeline
//
//  Created by LiuXiaoyu on 2016/3/27.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "AppDelegate.h"
#import "UZAppStartUp.h"
#import "UZAPIClient.h"
#import "SFHFKeychainUtils.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    [self getRealURL];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UZAppStartUp *appStartUp = [UZAppStartUp appStartUp];
    self.window.rootViewController = appStartUp.rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)getRealURL
{
//    NSString * storeUrl = [SFHFKeychainUtils getPasswordForUsername:@"RealBaseUrl" andServiceName:UZTimeLineSeivice error:nil];
//    if (storeUrl && ![storeUrl containsString:@"ningweb"]) {
//        UZAPIAppServerBaseURLString =storeUrl;
//        UZAPIAppImgBaseURLString = [SFHFKeychainUtils getPasswordForUsername:@"ImgBaseUrl" andServiceName:UZTimeLineSeivice error:nil];
//        [UZAPIClient sharedClient].baseURL = [NSURL URLWithString:UZAPIAppServerBaseURLString];
//        return;
//    }
//    NSDictionary * dict = @{};
//    [[UZAPIClient sharedClient] postDefaultClientWithURLPath:@"getBaseUrl" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary * uinfo = responseObject[@"data"];
//        NSString * realBaseUrl = uinfo[@"base_url"];
//        NSString * imgBaseUrl = uinfo[@"image_url"];
//        UZAPIAppServerBaseURLString = realBaseUrl;
//        UZAPIAppImgBaseURLString = imgBaseUrl;
//        
//        [UZAPIClient sharedClient].baseURL = [NSURL URLWithString:realBaseUrl];
//        
//        [SFHFKeychainUtils storeUsername:@"RealBaseUrl" andPassword:realBaseUrl forServiceName:UZTimeLineSeivice updateExisting:YES error:nil];
//        [SFHFKeychainUtils storeUsername:@"ImgBaseUrl" andPassword:imgBaseUrl forServiceName:UZTimeLineSeivice updateExisting:YES error:nil];
//       
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//       
//    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

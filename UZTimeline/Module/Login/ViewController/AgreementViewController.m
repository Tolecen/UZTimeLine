//
//  AgreementViewController.m
//  CSLCPlay
//
//  Created by liwei on 15/12/3.
//  Copyright © 2015年 liwei. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户使用协议";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),
                                                                     CGRectGetHeight(self.view.frame) - 64)];
    webView.allowsInlineMediaPlayback = YES;
    webView.scalesPageToFit = YES;
    [webView setOpaque:NO];
    [webView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:webView];
    
    NSString *HTMLString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserAgreement" ofType:@"html"]
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    
    [webView loadHTMLString:HTMLString
                    baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

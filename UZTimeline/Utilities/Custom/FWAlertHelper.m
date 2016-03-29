//
//  FWAlertHelper.m
//  FWBaseAppTools
//
//  Created by 陈国双 on 4/23/15.
//  Copyright (c) 2015 freework. All rights reserved.
//

#import "FWAlertHelper.h"


@interface FWAlertHelper() <UIActionSheetDelegate, UIAlertViewDelegate>
{
    completionBlock _completion;
}

@property (nonatomic, copy) completionBlock completion;
@property (nonatomic, retain) NSMutableArray *actionsForIOS8Later;

@end

@implementation FWAlertHelper
@synthesize completion = _completion;

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            self.actionsForIOS8Later = [[[NSMutableArray alloc] init] autorelease];
        }
    }
    return self;
}

- (void)dealloc
{
    if (_completion) [_completion release];
    _completion = nil;
    [_actionsForIOS8Later release];
    [super dealloc];
}

+ (void)alertWithTitle:(NSString  *)title
               message:(NSString *)message
            completion:(completionBlock)completion
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitles, ...
{

    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion < 8.0f) {
        FWAlertHelper *alertDelegate = nil;
        if (completion) {
            alertDelegate = [[FWAlertHelper alloc] init];
            alertDelegate.completion = completion;
        }
        
        NSMutableArray *titles__ = [[NSMutableArray alloc] init];
        if (otherButtonTitles) {
            [titles__ addObject:otherButtonTitles];
            va_list args;
            va_start(args, otherButtonTitles);
            NSString *title__ = va_arg(args, NSString *);
            while (title__) {
                [titles__ addObject:title__];
                title__ = va_arg(args, NSString *);
            }
            va_end(args);
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:alertDelegate
                                                  cancelButtonTitle:cancelButtonTitle
                                                  otherButtonTitles:nil];
        if ([titles__ count] > 0) {
            for (NSString *title in titles__) {
                [alertView addButtonWithTitle:title];
            }
        }
        [alertView show];
        [alertView release];
    } else {
        __block FWAlertHelper *alertHelpter = [[FWAlertHelper alloc] init];
        if (completion) {
            alertHelpter.completion = completion;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];

        if (cancelButtonTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action) {
                                                                     [alertHelpter inner_ActionCallBackWithAction:action];
                                                                 }];
            [alertController addAction:cancelAction];
            [alertHelpter.actionsForIOS8Later addObject:cancelAction];
        }
        
        if (otherButtonTitles) {
            UIAlertAction *otherTitleAction = [UIAlertAction actionWithTitle:otherButtonTitles
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action) {
                                                                         [alertHelpter inner_ActionCallBackWithAction:action];
                                                                     }];
            [alertController addAction:otherTitleAction];
            va_list args;
            va_start(args, otherButtonTitles);
            NSString *title__ = va_arg(args, NSString *);
            while (title__) {
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title__
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        [alertHelpter inner_ActionCallBackWithAction:action];
                                                                    }];
                [alertController addAction:otherAction];
                [alertHelpter.actionsForIOS8Later addObject:otherAction];
                title__ = va_arg(args, NSString *);
            }
            va_end(args);
        }
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController
                                                                                     animated:YES
                                                                                   completion:nil];
    }
}

+ (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                       owner:(id)owner
                  completion:(completionBlock)completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion < 8.0f) {
        if (owner == nil || (![owner isKindOfClass:[UIView class]] && ![owner isKindOfClass:[UIViewController class]])) {
            return;
        }
        FWAlertHelper *alertDelegate = nil;
        if (completion) {
            alertDelegate = [[FWAlertHelper alloc] init];
            alertDelegate.completion = completion;
        }
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:alertDelegate
                                                        cancelButtonTitle:cancelButtonTitle
                                                   destructiveButtonTitle:destructiveButtonTitle
                                                        otherButtonTitles:nil];
        if (otherButtonTitles) {
            [actionSheet addButtonWithTitle:otherButtonTitles];
            va_list args;
            va_start(args, otherButtonTitles);
            NSString *title__ = va_arg(args, NSString *);
            while (title__) {
                [actionSheet addButtonWithTitle:title__];
                title__ = va_arg(args, NSString *);
            }
            va_end(args);
        }
        if ([owner isKindOfClass:[UIToolbar class]]) {
            [actionSheet showFromToolbar:(UIToolbar *)owner];
        } else if ([owner isKindOfClass:[UITabBar class]]) {
            [actionSheet showFromTabBar:(UITabBar *)owner];
        } else if ([owner isKindOfClass:[UIViewController class]]) {
            [actionSheet showInView:((UIViewController *)owner).view];
        } else {
            [actionSheet showInView:(UIView *)owner];
        }
        [actionSheet release];
    } else {
        __block FWAlertHelper *alertHelpter = [[FWAlertHelper alloc] init];
        if (completion) {
            alertHelpter.completion = completion;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        if (destructiveButtonTitle) {
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                                        style:UIAlertActionStyleDestructive
                                                                      handler:^(UIAlertAction *action) {
                                                                          [alertHelpter inner_ActionCallBackWithAction:action];
                                                                      }];
            [alertController addAction:destructiveAction];
            [alertHelpter.actionsForIOS8Later addObject:destructiveAction];
        }
        
        if (cancelButtonTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action) {
                                                                     [alertHelpter inner_ActionCallBackWithAction:action];
                                                                 }];
            [alertController addAction:cancelAction];
            [alertHelpter.actionsForIOS8Later addObject:cancelAction];
        }
        

        
        if (otherButtonTitles) {
            UIAlertAction *otherTitleAction = [UIAlertAction actionWithTitle:otherButtonTitles
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action) {
                                                                         [alertHelpter inner_ActionCallBackWithAction:action];
                                                                     }];
            [alertController addAction:otherTitleAction];
            [alertHelpter.actionsForIOS8Later addObject:otherTitleAction];
            va_list args;
            va_start(args, otherButtonTitles);
            NSString *title__ = va_arg(args, NSString *);
            while (title__) {
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title__
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        [alertHelpter inner_ActionCallBackWithAction:action];
                                                                    }];
                [alertController addAction:otherAction];
                [alertHelpter.actionsForIOS8Later addObject:otherAction];
                title__ = va_arg(args, NSString *);
            }
            va_end(args);
        }
        if (owner && [owner isKindOfClass:[UIViewController class]]) {
            [(UIViewController *)owner presentViewController:alertController
                                                     animated:YES
                                                   completion:nil];
            
        } else {
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController
                                                                                         animated:YES
                                                                                       completion:nil];
        }

    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completion) {
        self.completion(buttonIndex, [alertView buttonTitleAtIndex:buttonIndex]);
    }
    [self performSelector:@selector(inner_DelayRelease) withObject:nil afterDelay:0.005];
    
    
}

#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completion) {
        self.completion(buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    [self performSelector:@selector(inner_DelayRelease) withObject:nil afterDelay:0.005];
}

#pragma mark - 私有方法
- (void)inner_DelayRelease
{
    [self release];
}

- (void)inner_ActionCallBackWithAction:(UIAlertAction *)action
{
    if (self.completion) {
        NSInteger buttonIndex = [self.actionsForIOS8Later indexOfObject:action];
        self.completion(buttonIndex, action.title);
    }
    [self performSelector:@selector(inner_DelayRelease) withObject:nil afterDelay:0.005];
}

@end

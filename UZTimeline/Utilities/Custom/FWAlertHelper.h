//
//  FWAlertHelper.h
//  FWBaseAppTools
//
//  Created by 陈国双 on 4/23/15.
//  Copyright (c) 2015 freework. All rights reserved.
//  UIAlertView包装类
//*****************************************************************
//  version         author          date        status
//*****************************************************************
//  1.0.0           chen.gsh        2015-04-23  create
//*****************************************************************

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^completionBlock)(NSInteger buttonIndex, NSString *title);

@interface FWAlertHelper : NSObject

/*
 @brief:UIAlertView封装器.8.0以下使用UIAertView, 8.0及以上使用UIAlertController
 @param title:标题
 @param message:提示信息
 @param completion:回调
 @param cancelButtonTitle:取消的标题
 @param otherButtonTitles:其它标题的可变参数序列
 */
+ (void)alertWithTitle:(NSString  *)title
               message:(NSString *)message
            completion:(completionBlock)completion
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/*
 @brief:UIActionSheet封装器.8.0以下使用UIActionSheet, 8.0及以上使用UIAlertController
 @param title:标题
 @param message:提示信息
 @param owner:需要显示的父亲。8.0以下传view.UIViewController
 @param completion:回调
 @param cancelButtonTitle:取消的标题
 @param destructiveButtonTitle:红色高亮的按钮标题
 @param otherButtonTitles:其它标题的可变参数序列
 */
+ (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                       owner:(id)owner
                  completion:(completionBlock)completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

//
//  Common.h
//  WeShare
//
//  Created by Elliott on 13-5-7.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+(NSString *)getCurrentTime;
+(NSString *)noteContentMessageTime:(NSString *)messageTime;
+(NSString *)noteCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)dynamicListCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)dynamicMessageTime:(NSString *)messageTime;
+(NSString *)CurrentTime:(long)currentTime AndMessageTime:(long)messageTime;
+(NSDate *)getCurrentTimeFromString:(NSString *)datetime;
+(NSString *)getCurrentTimeFromString2:(NSDate *)datetime;
+(NSString *)getWeakDay:(NSDate *)datetime;
+(NSString *)getmessageTime:(NSDate *)date;
+(NSString *)getDateStringWithTimestamp:(NSString*)tamp;
+(NSString *)getExDateStringWithTimestamp:(NSString*)tamp;

@end

//
//  Common.m
//  WeShare
//
//  Created by Elliott on 13-5-7.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "Common.h"

@implementation Common

+(NSString *)getCurrentTime{
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",nowTime];
    
}
+(NSString *)getDateStringWithTimestamp:(NSString*)tamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[tamp  doubleValue]/1000];
    NSString *timespStr = [formatter stringFromDate:timesp];
    
    return timespStr;
}
+(NSString *)getExDateStringWithTimestamp:(NSString*)tamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[tamp  doubleValue]];
    NSString *timespStr = [formatter stringFromDate:timesp];
    NSString *nowDateStr = [formatter stringFromDate:[NSDate date]];
    if ([[timespStr substringToIndex:5] isEqualToString:[nowDateStr substringToIndex:5]]) {
        return [timespStr substringFromIndex:5];
    }
    else
        return timespStr;
    
//    return timespStr;
}

+(NSString *)noteContentMessageTime:(NSString *)messageTime
{
//    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
//    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [messageTime integerValue];
    int theCurrentT = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    if (theCurrentT-theMessageT<3600) {
        return [NSString stringWithFormat:@"%d分钟前",(theCurrentT-(int)theMessageT)/60==0?1:(theCurrentT-(int)theMessageT)/60];
    }
    if ([messageDateStr isEqualToString:currentStr]) {
        return [NSString stringWithFormat:@"今天%@",[[messageTime substringFromIndex:11] substringToIndex:5]];
    }
    if (theCurrentT-theMessageT<3600*48) {
        return [NSString stringWithFormat:@"昨天%@",[[messageTime substringFromIndex:11] substringToIndex:5]];
    }
    return messageTime;
}
+(NSString *)noteCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    
    int theCurrentT = [currentTime intValue];
    if (theCurrentT-theMessageT<3600) {
        return [NSString stringWithFormat:@"%d分钟前",(theCurrentT-(int)theMessageT)/60==0?1:(theCurrentT-(int)theMessageT)/60];
    }
    if ((theCurrentT-theMessageT)<3600*24) {
        return [NSString stringWithFormat:@"%d小时前",(theCurrentT-(int)theMessageT)/(3600)];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    return [messageDateStr substringFromIndex:5];
}
//动态时间格式
+(NSString *)dynamicListCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    int theCurrentT = [currentTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    if ([messageDateStr isEqualToString:currentStr]) {
        return @"今天";
    }
    if ([[messageDateStr substringToIndex:8] isEqualToString:[currentStr substringToIndex:8]]&&[[currentStr substringFromIndex:8]intValue] -[[messageDateStr substringFromIndex:8] intValue] == 1) {
        return @"昨天";
    }
    return [messageDateStr substringFromIndex:5];
}
+(NSString *)dynamicMessageTime:(NSString *)messageTime
{
    //    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    //    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    NSDate *date = [dateF dateFromString:messageTime];
    //    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    NSTimeInterval theMessageT = [messageTime doubleValue];
    
    
    double cha = (double)[[NSDate date] timeIntervalSince1970]-[messageTime doubleValue];
    double oneY = 24*3600*365;
    double oneD = 24*3600;
    if (cha<=0) {
        return @"刚刚";
    }
    else
    {
        if (cha>=oneY) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
            return messageDateStr;
        }
        else
        {
            if (cha>=oneD&&cha<oneY) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM-dd"];
                NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
                return messageDateStr;
            }
            else if (cha>=3600&&cha<oneD) {
                int hour = cha/3600;
                return [NSString stringWithFormat:@"%d小时前",hour];
            }
            else if (cha>=60&&cha<3600){
                int minute = cha/60;
                return [NSString stringWithFormat:@"%d分钟前",minute];
            }
            else
            {
                return @"刚刚";
            }
        }
    }
    
    
    /*
    NSString * finalTime;
    int theCurrentT = [currentTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSString *chaStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT - theMessageT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    if ([messageDateStr isEqualToString:currentStr]) {
        int hours = [[nowT substringToIndex:2] intValue];
        int msgHour = [[msgT substringToIndex:2] intValue];
        if (msgHour == hours) {
            int minutes = [[nowT substringFromIndex:3] intValue];
            int msgMin = [[msgT substringFromIndex:3] intValue];
            if (msgMin == minutes) {
                finalTime = @"1分钟内";
            }else{
                finalTime = ((minutes - msgMin)>0) ? [NSString stringWithFormat:@"%d分钟前",minutes - msgMin]:@"刚刚";
            }
        }else{
            finalTime = [NSString stringWithFormat:@"%d小时前",hours - msgHour];
        }
    }else if([[messageDateStr substringToIndex:5] isEqualToString:[currentStr substringToIndex:5]]){
        //        int msgDay = [[messageDateStr substringFromIndex:8] integerValue];
        //        int day = [[currentStr substringFromIndex:8] integerValue];
        finalTime = [messageDateStr substringFromIndex:5];
        //        finalTime = [NSString stringWithFormat:@"%d天前",day - msgDay];
    }else{
        finalTime = messageDateStr;
    }
     
     
    return finalTime;
     
     */
    
}
//首页显示时间格式
+(NSString *)CurrentTime:(long)currentTime AndMessageTime:(long)messageTime
{
    NSString * finalTime;
    long theCurrentT = [[NSDate date] timeIntervalSince1970];
    long theMessageT = messageTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    int msgHour = [[msgT substringToIndex:2] intValue];
    int hours = [[nowT substringToIndex:2] intValue];
    int minutes = [[nowT substringFromIndex:3] intValue];
    // NSLog(@"hours:%d,minutes:%d",hours,minutes);
    long currentDayBegin = theCurrentT-hours*3600-minutes*60;
    long yesterdayBegin = currentDayBegin-3600*24;
    long qiantianBegin = yesterdayBegin-3600*24;
    //今天
    if ([currentStr isEqualToString:messageDateStr]) {
        
        
        if (msgHour>0&&msgHour<11) {
            finalTime = [NSString stringWithFormat:@"早上 %@",msgT];
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = [NSString stringWithFormat:@"中午 %@",msgT];
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = [NSString stringWithFormat:@"下午 %@",msgT];
        }
        else{
            finalTime = [NSString stringWithFormat:@"晚上 %@",msgT];
        }
    }
    //昨天
    else if(theMessageT>=yesterdayBegin&&theMessageT<currentDayBegin){
        if (msgHour>0&&msgHour<11) {
            finalTime = @"昨天早上";
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = @"昨天中午";
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = @"昨天下午";
        }
        else{
            finalTime = @"昨天晚上";
        }
    }
    //前天
    else if (theMessageT>=qiantianBegin&&theMessageT<yesterdayBegin)
    {
        NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:theMessageT];
        NSString * weekday = [Common getWeakDay:msgDate];
        if (msgHour>0&&msgHour<11) {
            finalTime = [NSString stringWithFormat:@"%@早晨",weekday];
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = [NSString stringWithFormat:@"%@中午",weekday];
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = [NSString stringWithFormat:@"%@下午",weekday];
        }
        else{
            finalTime = [NSString stringWithFormat:@"%@晚上",weekday];
        }
    }
    //今年
    else if([[messageDateStr substringToIndex:4] isEqualToString:[currentStr substringToIndex:4]]){
        finalTime = [NSString stringWithFormat:@"%@月%@日",[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8]];
    }
    
    else
    {
        finalTime = messageDateStr;
    }
    // NSLog(@"finalTime:%@",finalTime);
    return finalTime;
}


+(NSDate *)getCurrentTimeFromString:(NSString *)datetime{
    //NSString* string = @"May 9, 2013, 2:28:19 PM";
    //NSString* string = @"MMM dd, yyyy, HH:mm:ss";
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"MMM dd, yyyy, h:mm:ss a"];
    NSDate* inputDate = [inputFormatter dateFromString:datetime];
    return inputDate;
}



//MM-dd
+(NSString *)getCurrentTimeFromString3:(NSDate *)datetime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:datetime];
    return currentDateStr;
}

//HH:MM
+(NSString *)getCurrentTimeFromString2:(NSDate *)datetime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:datetime];
    return currentDateStr;
}

+(NSString *)getWeakDay:(NSDate *)datetime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:datetime];
    switch ([comps weekday]) {
        case 1:
            return @"周日";break;
        case 2:
            return @"周一";break;
        case 3:
            return @"周二";break;
        case 4:
            return @"周三";break;
        case 5:
            return @"周四";break;
        case 6:
            return @"周五";break;
        case 7:
            return @"周六";break;
        default:
            return @"未知";break;
    }
}



@end

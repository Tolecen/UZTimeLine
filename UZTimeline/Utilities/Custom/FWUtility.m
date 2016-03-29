//
//  FWUtility.m
//  FWBase
//
//  Created by 国双陈 on 14/10/29.
//  Copyright (c) 2014年 陈国双. All rights reserved.
//  一些通用的函数, 和核心业务无关的函数
//////////////////////////////////////////////////////////////////
//	版本			时间				说明
//////////////////////////////////////////////////////////////////
//	1.0			2014-10-29		初版做成
//****************************************************************

#import "FWUtility.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreText/CoreText.h>
#import <zlib.h>
//HMAC必须
#include <CommonCrypto/CommonHMAC.h>
//MD5必须
#include <CommonCrypto/CommonDigest.h>
//DES必须
#include <CommonCrypto/CommonCryptor.h>
//
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/utsname.h>

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "GTMBase64.h"
#import "SFHFKeychainUtils.h"

static char *__uuidkey__ = NULL;

@implementation FWUtility

//字符串链接
+ (NSString *)stringCat:(NSString *)oneStr twoStr:(NSString *)twoStr
{
    NSString *tmpOne = oneStr;
    NSString *tmpTwo = twoStr;
    if (tmpOne == nil) {
        tmpOne = @"";
    }
    if (tmpTwo == nil) {
        tmpTwo = @"";
    }
    return [NSString stringWithFormat:@"%@%@", tmpOne, tmpTwo];
}

+ (NSString *)defaultStringWhenNil:(NSString *)source defaultString:(NSString *)defaultString
{
    return source == nil ? defaultString : source;
}

+ (BOOL)stringInArray:(NSArray *)source string:(NSString *)string
{
    BOOL founded = NO;
    for (int strIdx = 0; strIdx < [source count]; strIdx++) {
        id value = [source objectAtIndex:strIdx];
        if ([value isKindOfClass:[NSString class]]) {
            founded = [string isEqualToString:(NSString *)value];
            if (founded) {
                break;
            }
        }
    }
    return founded;
}

//encoding字符串
+ (NSString *)encodingString:(NSString *)sourceString encoding:(CFStringEncoding)encoding
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)sourceString, NULL, CFSTR(":/?#[]@!$&’()*+,;="), encoding);
    
    return [result autorelease];
}

+ (NSString *)encodingUTF8String:(NSString *)sourceString
{
    return [[self class] encodingString:sourceString encoding:kCFStringEncodingUTF8];
}

+ (NSString *)encodingGB2312String:(NSString *)sourceString
{
    return [[self class] encodingString:sourceString encoding:kCFStringEncodingGB_18030_2000];
}

+ (NSString *)trimString:(NSString *)sourceString
{
    return [sourceString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//将日期转换为字符串，给定一个格式（formatString）
+ (NSString *)dateToString:(NSDate *)date formatString:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *result = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return result;
}

+ (NSString *)dateToString_YMDHM:(NSDate *)date
{
    return [[self class] dateToString:date formatString:@"yyyy-MM-dd HH:mm"];
}

+ (NSString *)dateToString_YMD:(NSDate *)date
{
    return [[self class] dateToString:date formatString:@"yyyy-MM-dd"];
}

+ (NSString *)dateToString_HMS:(NSDate *)date
{
    return [[self class] dateToString:date formatString:@"HH:mm:ss"];
}

+ (NSString *)dateToString_HM:(NSDate *)date
{
    return [[self class] dateToString:date formatString:@"HH:mm"];
}

+ (NSDate *)stringToDate:(NSString *)source formatString:(NSString *)formatString  localeIdentifier:(NSString *)localeIdentifier
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    dateFormatter.locale = locale;
    [locale release];
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [dateFormatter dateFromString:source];
    [dateFormatter release];
    return date;
}

+ (NSString *)MD5String:(NSString *)sourceString
{
    if (!sourceString) {
        return nil;
    }
    if ([sourceString length] == 0) {
        return @"";
    }
    const char *strData = [sourceString UTF8String];
    unsigned char result[16] = {};
    CC_MD5(strData, (CC_LONG)strlen(strData), result);
    NSMutableString *strRst = [[NSMutableString alloc] init];
    for (int i = 0; i < 16; i++) {
        [strRst appendFormat:@"%02x", result[i]];
    }
    return [strRst autorelease];
}

//加密，解密
+ (NSString *)EncryptString:(NSString *)sourceString key:(NSString *)key algorithm:(FWCCAlgorithm)algorithm type:(FWUtilityEncryptType)type
{
    const void *vsourceString;
    size_t sourceStringBufferSize;
    
    NSData* data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    if (type == FWUtilityEncryptType_Base64Encoding) {
        data = [GTMBase64 encodeData:data];
    }
    
    sourceStringBufferSize = [data length];
    vsourceString = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (sourceStringBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = (uint8_t *)malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(kCCEncrypt,
                       algorithm,
                       kCCOptionECBMode | kCCOptionPKCS7Padding ,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vsourceString,
                       sourceStringBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    
    return result;
}

+ (NSString *)DecryptString:(NSString *)sourceString key:(NSString *)key algorithm:(FWCCAlgorithm)algorithm type:(FWUtilityDecryptType)type
{
    const void *vsourceString;
    size_t sourceStringBufferSize;
    
    NSData *EncryptData = [GTMBase64 decodeData:[sourceString dataUsingEncoding:NSUTF8StringEncoding]];
    sourceStringBufferSize = [EncryptData length];
    vsourceString = [EncryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (sourceStringBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = (uint8_t *)malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(kCCDecrypt,
                       algorithm,
                       kCCOptionECBMode | kCCOptionPKCS7Padding ,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vsourceString,
                       sourceStringBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    
    NSString *result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes]
                                              encoding:NSUTF8StringEncoding]
                        autorelease];
    if (type == FWUtilityDecryptType_Base64Encoding) {
        result = [[[NSString alloc] initWithData:[GTMBase64 decodeString:result] encoding:NSUTF8StringEncoding] autorelease];
    }
    return result;
}

+ (NSString *)EncryptString3DES:(NSString *)sourceString key:(NSString *)key
{
    return [[self class] EncryptString:sourceString key:key algorithm:kCCAlgorithm3DES type:FWUtilityEncryptType_Base64Encoding];
}

+ (NSString *)DecryptString3DES:(NSString *)sourceString key:(NSString *)key
{
    return [[self class] DecryptString:sourceString key:key algorithm:kCCAlgorithm3DES type:FWUtilityDecryptType_Base64Encoding];
}

+ (NSData *)HMAC_SHA1:(NSString *)data key:(NSString *)key
{
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [key UTF8String], [key length], [data UTF8String], [data length], buf);
    return [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
}
//目录处理
+ (NSString *)getHomeDirectoryPath
{
    return NSHomeDirectory();
}

+ (NSString *)getLibraryPath
{
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if ([Paths count] > 0) {
        NSString *path = [Paths objectAtIndex:0];
        return path;
    }
    return nil;
}

+ (NSString *)getTmpPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)getDocumentPath
{
    NSArray *paths = nil;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //得到文档目录
    NSString *documentsDirectory = @"";
    if ([paths count] > 0) {
        return [paths objectAtIndex:0];
    }
    return documentsDirectory;
}

+ (NSString *)getCachesPath
{
    NSArray *paths = nil;
    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //得到文档目录
    NSString *cachesDirectory = @"";
    if ([paths count] > 0) {
        cachesDirectory = [paths objectAtIndex:0];
    }
    return cachesDirectory;
}

+ (NSString *)getCustomPathWithParentPath:(NSString *)parentPath pathName:(NSString *)pathName
{
    NSString *customPath = [parentPath stringByAppendingPathComponent:pathName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:customPath]) {
        NSError *error = nil;
        if (![fm createDirectoryAtPath:customPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            return @"";
        }
    }
    
    return customPath;
}

+ (NSString *)getFileNameWithURLString:(NSString *)URLString basePath:(NSString *)basePath
{
    NSString *fileName = @"";
    if (URLString == nil) {
        return @"";
    }
    NSString *filePath = [[self class] getCustomPathWithParentPath:basePath pathName:@""];
    fileName = [filePath stringByAppendingPathComponent:[[self class] convertURLStringToFileName:URLString]];
    return fileName;
}

+ (NSString *)convertURLStringToFileName:(NSString *)URLString
{
    NSString *fileExtension = [URLString pathExtension];
    NSString *singleFileName = [URLString stringByDeletingPathExtension];
    singleFileName = [[self class] MD5String:singleFileName];
    return [[singleFileName stringByAppendingString:@"."] stringByAppendingString:fileExtension];
}

+ (BOOL)deleteFileWithURLString:(NSString *)URLString basePath:(NSString *)basePath
{
    BOOL rst = YES;
    NSString *fileName = [[self class] getFileNameWithURLString:URLString basePath:basePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName]) {
        NSError *error = nil;
        if (![fileManager removeItemAtPath:fileName error:&error]) {
            rst = NO;
        }
    }
    return rst;
}

//计算给定路径的总字节数
+ (double)computeFileBytesInPath:(NSString *)filePath
{
    double result = 0.0f;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:filePath];
        NSString *fileName = nil;
        while (fileName = [directoryEnumerator nextObject]) {
            NSString *fullFileName = [filePath stringByAppendingPathComponent:fileName];
            NSDictionary *fileAttr = [directoryEnumerator fileAttributes];
            NSString *fileType = [fileAttr objectForKey:NSFileType];
            if ([fileType isEqualToString:NSFileTypeDirectory]) {
                result += [[self class] computeFileBytesInPath:fullFileName];
            } else {
                NSNumber *number = [fileAttr objectForKey:NSFileSize];
                result += [number unsignedLongLongValue];
            }
        }
    }
    return result;
}

//移除给定路径中的所有文件
+ (void)removeAllFilesInPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:filePath];
        NSString *fileName = nil;
        while (fileName = [directoryEnumerator nextObject]) {
            NSString *fullFileName = [filePath stringByAppendingPathComponent:fileName];
            NSDictionary *fileAttr = [directoryEnumerator fileAttributes];
            NSString *fileType = [fileAttr objectForKey:NSFileType];
            if ([fileType isEqualToString:NSFileTypeDirectory]) {
                [[self class] removeAllFilesInPath:fullFileName];
            }
            NSError *error = nil;
            if (![fileManager removeItemAtPath:fullFileName error:&error]) {

            }
        }
    }
}

+ (NSString *)prettyBytes:(uint64_t)numBytes
{
    uint64_t const scale = 1024;
    char const * abbrevs[] = { "EB", "PB", "TB", "GB", "MB", "KB", "Bytes" };
    size_t numAbbrevs = sizeof(abbrevs) / sizeof(abbrevs[0]);
    uint64_t maximum = powl(scale, numAbbrevs-1);
    for (size_t i = 0; i < numAbbrevs-1; ++i) {
        if (numBytes > maximum) {
            return [NSString stringWithFormat:@"%.1f %s", numBytes / (double)maximum, abbrevs[i]];
        }
        maximum /= scale;
    }
    return [NSString stringWithFormat:@"%u Bytes", (unsigned)numBytes];
}

//总空间数量
+ (unsigned long long)totalDiskSpace
{

    NSError *error = nil;
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: &error];
    if (error){
        return 0;
    } else {
        return [[fattributes objectForKey: NSFileSystemSize] unsignedLongLongValue];
    }
}
//可用空间数量
+ (unsigned long long)freeDiskSpace
{
    NSError *error = nil;
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: &error];
    if (error) {
        return 0;
    } else {
        return [[fattributes objectForKey: NSFileSystemFreeSize] unsignedLongLongValue];
    }
}

//系统版本
+ (CGFloat)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

//计算文字的所用的Size
+ (CGSize)stringSize:(NSString *)string font:(UIFont *)font
{
    CGSize sizeResult = CGSizeZero;
    if ([[self class] systemVersion] >= 7.0f) {
        NSDictionary *dicAttri = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        sizeResult = [string sizeWithAttributes:dicAttri];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        sizeResult = [string sizeWithFont:font];
#endif
    }
    sizeResult.width = ceil(sizeResult.width);
    sizeResult.height = ceil(sizeResult.height);
    return sizeResult;
}

+ (CGSize)stringLinesSize:(NSString *)string font:(UIFont *)font clientSize:(CGSize)clientSize
{
    CGSize sizeResult = CGSizeZero;
    
    if ([[self class] systemVersion] >= 7.0f) {
        NSDictionary *dicAttri = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGRect rSize = [string boundingRectWithSize:clientSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:dicAttri
                                            context:NULL];
        sizeResult = rSize.size;
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        sizeResult = [string sizeWithFont:font
                        constrainedToSize:clientSize
                            lineBreakMode:NSLineBreakByTruncatingTail];
#endif
    }
    
    sizeResult.width = ceil(sizeResult.width);
    sizeResult.height = ceil(sizeResult.height);
    return sizeResult;
}

+ (CGSize)stringLinesSizeWithLineSpacing:(NSString *)string font:(UIFont *)font clientSize:(CGSize)clientSize lineSpacing:(CGFloat)lineSpacing
{
    CGSize sizeResult = CGSizeZero;
    if (string == nil || font == nil) {
        return sizeResult;
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setMaximumLineHeight:font.lineHeight];
    [paragraphStyle setMinimumLineHeight:font.lineHeight];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    NSRange attrRange = NSMakeRange(0, [attributedStr length]);
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attrRange];
    [attributedStr addAttribute:NSFontAttributeName value:font range:attrRange];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedStr);
    CGSize contentSize = clientSize;
    CGFloat sysVer = [[self class] systemVersion];
    if (sysVer < 7.0f) {
        contentSize.height += lineSpacing;
    }
    CFRange range = CFRangeMake(0, [attributedStr length]);
    sizeResult = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                              range,
                                                              NULL,
                                                              contentSize,
                                                              NULL);
    
    sizeResult.width = ceil(sizeResult.width);
    if (sizeResult.width < clientSize.width) {
        sizeResult.width = clientSize.width;
    }
    sizeResult.height = (NSInteger)(sizeResult.height);
    if (sysVer < 7.0f && sizeResult.height >= font.lineHeight * 2.0f) {
        //sizeResult.height += 2.0f;
    }
    //    sizeResult.height += lineSpacing;
    if (sizeResult.height > 0) {
        sizeResult.height += 2.0f;
    }
    
    sizeResult.width = (NSInteger)sizeResult.width;
    CFRelease(framesetter);
    [attributedStr release];
    [paragraphStyle release];
    
    return sizeResult;

}

//颜色处理
+ (UIColor *)intepreterColorWithAlpha:(const char *)color alpha:(float)alpha
{
    if (NULL == color)
    {
        return nil;
    }
    unsigned long len = strlen(color);
    int colorPos = 0;
    if (strncmp(color, "#", 1) == 0) {
        colorPos = 1;
    }
    unsigned long colorValue = strtoul(color + colorPos, NULL, 16);
    if ((len == 6 && colorPos == 0) ||
        (len == 7 && colorPos == 1))
    {
        return [[self class] colorFromInt:colorValue alpha:1];
    }

    return nil;
}

+ (UIColor *)intepreterColor:(const char *)color
{
    if (NULL == color)
    {
        return nil;
    }
    unsigned long len = strlen(color);
    int colorPos = 0;
    if (strncmp(color, "#", 1) == 0) {
        colorPos = 1;
    }
   
    unsigned long colorValue = strtoul(color + colorPos, NULL, 16);
    if ((len == 6 && colorPos == 0) ||
        (len == 7 && colorPos == 1))
    {
        return [[self class] colorFromInt:colorValue alpha:1];
    }
    else if ((len == 8 && colorPos == 0) ||
             (len == 9 && colorPos == 1))
    {
        return [[self class] colorFromInt:colorValue];
    }

    return nil;
}

+ (UIColor *)colorFromInt:(NSUInteger)color
{
    NSUInteger red = (color & 0xFF000000) >> 24;
    NSUInteger green = (color & 0x00FF0000) >> 16;
    NSUInteger blue = (color & 0x0000FF00) >> 8;
    NSUInteger alpha = (color & 0x000000FF);
    return [UIColor colorWithRed:red / 255.0f
                           green:green / 255.0f
                            blue:blue / 255.0f
                           alpha:alpha / 255.0f];
}

+ (UIColor *)colorFromInt:(NSUInteger)color alpha:(float)alpha
{
    NSUInteger red = (color & 0x00FF0000) >> 16;
    NSUInteger green = (color & 0x0000FF00) >> 8;
    NSUInteger blue = (color & 0x000000FF);
    NSUInteger alphaX = alpha * 255;
    if (alphaX > 255) {
        alphaX = 255;
    }
    NSUInteger result = (red << 24) | (green << 16) | (blue << 8) | alphaX;
    return [[self class] colorFromInt:result];
}

+ (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)getExecuteName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
}

+ (NSString *)getAppBuildInfo {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getBundleId
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)getDeviceOS
{
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@%@", device.systemName, device.systemVersion];
}

+ (NSString *)getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithUTF8String:systemInfo.machine];

}

+ (void)getCarrierName:(NSString **)carrierName isoCC:(NSString **)isoCC MCC:(NSString **)MCC MNC:(NSString **)MNC
{
    CTTelephonyNetworkInfo *newrokInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = newrokInfo.subscriberCellularProvider;
    if (carrierName) {
        *carrierName = carrier.carrierName;
    }
    if (isoCC) {
        *isoCC = carrier.isoCountryCode;
    }
    if (MCC) {
        *MCC = carrier.mobileCountryCode;
    }
    if (MNC) {
        *MNC = carrier.mobileNetworkCode;
    }
    [newrokInfo release];
}


+ (void)setUUIdKey:(NSString *)uuidKey
{
    if (uuidKey) {
        static dispatch_once_t onceToken_UUIDKey;
        dispatch_once(&onceToken_UUIDKey, ^{
            size_t UUIDKeyLen = strlen([uuidKey UTF8String]);
            __uuidkey__ = (char *)malloc(sizeof(char) * (strlen([uuidKey UTF8String]) + 1));
            memset(__uuidkey__, 0, UUIDKeyLen + 1);
            memcpy(__uuidkey__, [uuidKey UTF8String], UUIDKeyLen);
        });
    }
}

+ (NSString *)getUUID
{
    NSString *__Domain = (__uuidkey__ ? [FWUtility MD5String:[NSString stringWithUTF8String:__uuidkey__]] : [FWUtility MD5String:[[self class] getBundleId]]);
    NSString *__DomainService = @"cn.ifreework.app.tools";
    NSString * resultUDID = [SFHFKeychainUtils getPasswordForUsername:__Domain
                                                       andServiceName:__DomainService
                                                                error:nil];
    if (resultUDID == nil) {
        NSMutableString * udid = [NSMutableString stringWithString:@"iOS_"];
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuid__string = [(NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid) autorelease];
        CFRelease(uuid);
        [udid appendString:[FWUtility MD5String:uuid__string]];
        [SFHFKeychainUtils storeUsername:__Domain
                             andPassword:udid
                          forServiceName:__DomainService
                          updateExisting:YES
                                   error:nil];
        resultUDID = [NSString stringWithString:udid];
    }
    return resultUDID;
}

+ (NSString *)getIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                if (strcmp(cursor->ifa_name, "en0") == 0) {
                    char *zIPAddress = inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr);
                    NSString *ipAddress= [NSString stringWithUTF8String:zIPAddress];
                    return ipAddress;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    return @"0.0.0.0";
}

+ (NSString *)getMacAddress
{
    int                     mib[6];
    size_t                  len;
    char                    *buf;
    unsigned char           *ptr;
    struct if_msghdr        *ifm;
    struct sockaddr_dl      *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error/n");
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1/n");
        return @"";
    }
    
    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!/n");
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (unsigned long long)hex16StringToULongLong:(NSString *)hex16String
{
    NSUInteger result = 0;
    NSInteger bitIdx = 0;
    for (NSInteger cIdx = [hex16String length] - 1; cIdx >= 0; cIdx--) {
        unichar cPos = [hex16String characterAtIndex:cIdx];
        char cHexValue = 0;
        if (cPos >= '0' && cPos <='9') {
            cHexValue = cPos - '0';
        } else if (cPos >= 'A' && cPos <='F') {
            cHexValue = cPos - 'A' + 10;
        } else if (cPos >= 'a' && cPos <= 'f') {
            cHexValue = cPos - 'a' + 10;
        } else {
            break;
        }
        result += (cHexValue * pow(16, bitIdx));
        bitIdx++;
    }
    
    
    return result;
}

+ (unsigned long long)strToLong:(NSString *)string hex:(NSInteger)hex
{
    return (unsigned long long)strtoll([string UTF8String], NULL, (int)hex);
}

+ (NSString *)stringFromUnicode:(NSString *)unicode prefix:(NSString *)prefix
{
    NSString *strPrefix = (prefix == nil ? @"\\U" : prefix);
    NSString *unicode_temp = [unicode uppercaseString];
    if ([unicode_temp hasPrefix:strPrefix]) {
        unicode_temp = [unicode_temp substringFromIndex:2];
    }
    NSArray *unicodes = [[unicode_temp uppercaseString] componentsSeparatedByString:strPrefix];
    NSUInteger length = sizeof(unichar) * [unicodes count];
    unichar * pUnicodes = malloc(length);
    for (int cIdx = 0; cIdx < [unicodes count]; cIdx++) {
        NSString *cStr = [unicodes objectAtIndex:cIdx];
        unichar intRst = (unichar)[[self class] hex16StringToULongLong:cStr];
        pUnicodes[cIdx] = intRst;
    }
    NSString *source = [NSString stringWithCharacters:pUnicodes length:[unicodes count]];
    free(pUnicodes);
    return source;
}

+ (NSString *)unicodeFromString:(NSString *)string prefix:(NSString *)prefix align:(BOOL)align
{
    NSMutableString *unicodeString = [[NSMutableString alloc] init];
    NSString *strPrefix = (prefix == nil ? @"\\U" : prefix);
    for (int cIdx = 0; cIdx < [string length]; cIdx++) {
        unichar strChar = [string characterAtIndex:cIdx];
        if (align) {
            [unicodeString appendFormat:@"%@%04x",strPrefix, strChar];
        } else {
            [unicodeString appendFormat:@"%@%0x",strPrefix, strChar];
        }
    }
    return [unicodeString autorelease];
}

+ (NSString *)className:(NSString *)clsName prefix:(NSString *)prefix suffix:(NSString *)suffix
{
    if (clsName == nil) {
        return nil;
    }
    
    NSString *result = clsName;
    
    if (prefix && [result hasPrefix:prefix]) {
        result = [result substringFromIndex:[prefix length]];
    }
    
    if (suffix && [result hasSuffix:suffix]) {
        result = [result substringToIndex:[result length] - [suffix length]];
        
    }
    return result;
}

+ (CGFloat)statusBarHeightWithOrientation:(UIInterfaceOrientation)orientation
{
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return statusBarSize.height;
    } else {
        return statusBarSize.width;
    }
}

+ (UIImage *)launchImage
{
    /*
     LaunchImage-568h@2x.png
     LaunchImage-700-568h@2x.png
     LaunchImage-700-Landscape@2x~ipad.png
     LaunchImage-700-Landscape~ipad.png
     LaunchImage-700-Portrait@2x~ipad.png
     LaunchImage-700-Portrait~ipad.png
     LaunchImage-700@2x.png
     LaunchImage-Landscape@2x~ipad.png
     LaunchImage-Landscape~ipad.png
     LaunchImage-Portrait@2x~ipad.png
     LaunchImage-Portrait~ipad.png
     LaunchImage.png
     LaunchImage@2x.png
     */
    UIImage *image = nil;
    CGSize scrSize = [UIScreen mainScreen].preferredMode.size;
    CGFloat osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

    if (CGSizeEqualToSize(scrSize, CGSizeMake(320, 480))) {
        //3.5 low
        image = [UIImage imageNamed:@"LaunchImage"];
    } else if (CGSizeEqualToSize(scrSize, CGSizeMake(640, 960))) {
        if (osVersion < 7.0) {
            image = [UIImage imageNamed:@"LaunchImage"];
        } else {
            image = [UIImage imageNamed:@"LaunchImage-700"];
        }
    } else if (CGSizeEqualToSize(scrSize, CGSizeMake(640, 1136))) {
        //4
        image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    } else if (CGSizeEqualToSize(scrSize, CGSizeMake(750, 1334))) {
        //4.7
        image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (CGSizeEqualToSize(scrSize, CGSizeMake(1242, 2208))) {
        //5.5
        image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    } else if (CGSizeEqualToSize(scrSize, CGSizeMake(768, 1024))) {
        if (osVersion < 7.0) {
            image = [UIImage imageNamed:@"LaunchImage-Portrait~ipad"];
        } else {
            image = [UIImage imageNamed:@"LaunchImage-700-Landscape~ipad"];
        }
    } else if (CGSizeEqualToSize(scrSize, CGSizeMake(1536, 2048))) {
        if (osVersion < 7.0) {
            image = [UIImage imageNamed:@"LaunchImage-Portrait"];
        } else {
            image = [UIImage imageNamed:@"LaunchImage-700-Portrait"];
        }
    }
    
    return image;
}

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber
{
    NSError *error = nil;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"^1[358][0-9]\\d{8}$"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    if (error) {
        return NO;
    } else {
        NSInteger count = [regExp numberOfMatchesInString:phoneNumber
                                                  options:NSMatchingReportCompletion
                                                    range:NSMakeRange(0, [phoneNumber length])];
        return (count == 1);
    }
}

+ (BOOL)isValidEMail:(NSString *)email
{
    NSError *error = nil;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z1-9][A-Za-z0-9_\\.]*@[A-Za-z0-9\\.]*$"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    if (error) {
        return NO;
    } else {
        NSInteger count = [regExp numberOfMatchesInString:email
                                                  options:NSMatchingReportCompletion
                                                    range:NSMakeRange(0, [email length])];
        return (count == 1);
    }
}

@end

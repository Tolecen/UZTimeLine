//
//  FWUtility.h
//  FWBase
//
//  Created by 国双陈 on 14/10/29.
//  Copyright (c) 2014年 陈国双. All rights reserved.
//  一些通用的函数, 和核心业务无关的函数
//*****************************************************************
//  version         author          date        status
//*****************************************************************
//  1.0.0           chen.gsh        2014-10-29  create
//*****************************************************************

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/**
 *  简单字符串的加密解密输入与输出的枚举
 */
typedef NS_ENUM(NSUInteger, FWUtilityEncryptType)
{
    FWUtilityEncryptType_Normal = (1),
    FWUtilityEncryptType_Base64Encoding = (2)
};

typedef NS_ENUM(NSUInteger, FWUtilityDecryptType)
{
    FWUtilityDecryptType_Normal = (1),
    FWUtilityDecryptType_Base64Encoding = (2)
};


typedef NS_ENUM(NSUInteger, FWCCAlgorithm)
{
    FWCCAlgorithm_AES128 = 0,
    FWCCAlgorithm_AES = 0,
    FWCCAlgorithm_DES,
    FWCCAlgorithm_3DES,
    FWCCAlgorithm_CAST,
    FWCCAlgorithm_RC4,
    FWCCAlgorithm_RC2,
    FWCCAlgorithm_Blowfish
};


@interface FWUtility : NSObject

/**
 *  @brief:字符串链接
 *  @param oneStr:第一个字符串
 *  @param twoStr:第二个字符串
 *  @return:返回一个新的字符串
 */
+ (NSString *)stringCat:(NSString *)oneStr twoStr:(NSString *)twoStr;


/*
 @brief:当字符串为空的时候返回的值
 */
+ (NSString *)defaultStringWhenNil:(NSString *)source defaultString:(NSString *)defaultString;

/**
 *  @brief:在是数组中查找字符串
 *  @param source:执行查找操作的数组
 *  @param string:需要查找的字符串
 *  @return:查找成功返回YES,否则NO
 */
+ (BOOL)stringInArray:(NSArray *)source string:(NSString *)string;

/**
 *  @brief:encoding字符串
 *  @param sourceString:需要转换的字符串
 *  @param encoding:需要转换的编码
 *  @return:转换后的字符串
 */
+ (NSString *)encodingString:(NSString *)sourceString encoding:(CFStringEncoding)encoding;

/**
 *  @brief:encoding字符串使用UTF-8编码
 *  @param sourceString:需要转换的字符串
 *  @return:转换后的字符串
 */
+ (NSString *)encodingUTF8String:(NSString *)sourceString;

/**
 *  @brief:encoding字符串使用GB2312编码
 *  @param sourceString:需要转换的字符串
 *  @return:转换后的字符串
 */
+ (NSString *)encodingGB2312String:(NSString *)sourceString;

/**
 *  @brief:去掉字符串两端的空白符号（回车换行、空串、空字符）
 *  @param sourceStirng:需要去除的字符串
 *  @return:返回操作成功的字符串
 */
+ (NSString *)trimString:(NSString *)sourceString;

/**
 *  @brief:将日期转换为字符串，给定一个格式（formatString）
 *  @param date:需要格式化的日期对象
 *  @param formatString:格式化的类型
 *  @return:返回一个字符串
 */
+ (NSString *)dateToString:(NSDate *)date formatString:(NSString *)formatString;

/**
 *  @brief:将日期转换为字符串，给定一个格式（formatString）
 *  @param date:需要格式化的日期对象，基于yyyy-MM-dd HH:mm
 *  @return:返回一个字符串
 */
+ (NSString *)dateToString_YMDHM:(NSDate *)date;

/**
 *  @brief:将日期转换为字符串，给定一个格式（formatString）
 *  @param date:需要格式化的日期对象，基于 yyyy-MM-dd
 *  @return:返回一个字符串
 */
+ (NSString *)dateToString_YMD:(NSDate *)date;

/**
 *  @brief:将日期转换为字符串，给定一个格式（formatString）
 *  @param date:需要格式化的日期对象，基于HH:mm:ss
 *  @return:返回一个字符串
 */
+ (NSString *)dateToString_HMS:(NSDate *)date;

/**
 *  @brief:将日期转换为字符串，给定一个格式（formatString）
 *  @param date:需要格式化的日期对象，基于HH:mm
 *  @return:返回一个字符串
 */
+ (NSString *)dateToString_HM:(NSDate *)date;

/**
 *  @brief:将字符串转换为日期
 *  @param source:给定的字符串(带有时间格式)
 *  @param formatString:字符串使用的时间格式
 *  @param localeIdentifier:日期代表的地区
 *  @return:返回一个日期对象(可能为空)
 */
+ (NSDate *)stringToDate:(NSString *)source formatString:(NSString *)formatString localeIdentifier:(NSString *)localeIdentifier;

/**
 *  @brief:计算一个字符串的MD5码
 *  @param sourceString:需要执行MD5操作的字符串
 *  @return:返回一个md5的32位字符串
 */
+ (NSString *)MD5String:(NSString *)sourceString;

/**
 *  @brief:加密一个字符串
 *  @param sourceString:需要加密的字符串
 *  @param key:需要加密的key
 *  @param algorithm:加密的方式
 *  @param type:加密的类型(对加密后进行怎样的转换)
 *  @return:返回一个加密后字符串
 */
+ (NSString *)EncryptString:(NSString *)sourceString key:(NSString *)key algorithm:(FWCCAlgorithm)algorithm type:(FWUtilityEncryptType)type;

/**
 *  @brief:解密一个字符串
 *  @param sourceString:需要解密的字符串
 *  @param key:需要解密的key
 *  @param algorithm:解密的方式
 *  @param type:解密的类型(对解密前进行怎样的转换)
 *  @return:返回一个解密后字符串
 */
+ (NSString *)DecryptString:(NSString *)sourceString key:(NSString *)key algorithm:(FWCCAlgorithm)algorithm type:(FWUtilityDecryptType)type;

/**
 *  @brief:使用3DES加密一个字符串
 *  @param sourceString:需要加密的字符串
 *  @param key:需要加密的key
 *  @return:返回一个加密后字符串
 */
+ (NSString *)EncryptString3DES:(NSString *)sourceString key:(NSString *)key;

/**
 *  @brief:使用3DES解密一个字符串
 *  @param sourceString:需要解密的字符串
 *  @param key:需要解密的key
 *  @return:返回一个解密后字符串
 */
+ (NSString *)DecryptString3DES:(NSString *)sourceString key:(NSString *)key;

/**
 *  @brief:SHA1 处理
 *  @param data:处理的数据字符串
 *  @param key:处理的key
 *  @return:返回sha1处理后的NSData类型的对象
 */
+ (NSData *)HMAC_SHA1:(NSString *)data key:(NSString *)key;

/**
 *  @brief:目录处理,得到app路径
 *  @return:返回一个绝对目录
 */
+ (NSString *)getHomeDirectoryPath;

/**
 *  @brief:目录处理,得到路径/Library
 *  @return:返回一个绝对目录
 */
+ (NSString *)getLibraryPath;

/**
 *  @brief:目录处理,得到路径/Temp
 *  @return:返回一个绝对目录
 */
+ (NSString *)getTmpPath;

/**
 *  @brief:目录处理,得到路径/Document
 *  @return:返回一个绝对目录
 */
+ (NSString *)getDocumentPath;

/**
 *  @brief:目录处理,得到路径/Library/Caches
 */
+ (NSString *)getCachesPath;

/**
 *  @brief:目录处理,得到一个基于父目录的子目录
 *  @param parentPath:父目录绝对路径
 *  @param pathName:子目录
 *  @return:返回一个绝对目录
 */
+ (NSString *)getCustomPathWithParentPath:(NSString *)parentPath pathName:(NSString *)pathName;

/**
 *  @brief:根据URL和路径，来得到一个绝对路径的文件名
 *  @param URLString:给定的url字符串
 *  @param basePath:存放的路径
 *  @return:返回一个存放文件的绝对路径
 */
+ (NSString *)getFileNameWithURLString:(NSString *)URLString basePath:(NSString *)basePath;

/**
 *  @brief:将字符串转换为无路径的文件名
 *  @param URLString:对URLString进行编码处理返回一个文件名
 *  @return:返回一个无路径的文件名
 */
+ (NSString *)convertURLStringToFileName:(NSString *)URLString;

/**
 *  @brief:删除给定URL和存储路径的文件名
 *  @param URLString:删除url指定的缓存文件
 *  @param basePath:文件存放的路径
 *  @return:返回是否操作成功
 */
+ (BOOL)deleteFileWithURLString:(NSString *)URLString basePath:(NSString *)basePath;

/**
 *  @brief:计算给定路径的总字节数
 *  @param filePath:计算的路径
 *  @return:返回计算的字节总数
 */
+ (double)computeFileBytesInPath:(NSString *)filePath;

/**
 *  @brief:移除给定路径中的所有文件
 *  @param:filePath:需要操作的绝对路径
 */
+ (void)removeAllFilesInPath:(NSString *)filePath;

/**
 *  @brief:给定的字节数返回说明
 *  @param numBytes:字节数
 *  @return:返回一个字节数的文字说明
 */
+ (NSString *)prettyBytes:(uint64_t)numBytes;

/**
 *  @brief:总空间数量
 */
+ (unsigned long long)totalDiskSpace;

/**
 *  @brief:可用空间数量
 */
+ (unsigned long long)freeDiskSpace;

/**
 *  @brief:系统版本
 */
+ (CGFloat)systemVersion;

/**
 *  @brief:计算文字的所用的Size
 *  @param string:字符串
 *  @param font:字符串使用的字体
 *  @return:返回一个显示字符串的size
 */
+ (CGSize)stringSize:(NSString *)string font:(UIFont *)font;

/**
 *  @brief:计算文字的所用的Size
 *  @param string:字符串
 *  @param font:字符串使用的字体
 *  @param clientSize:字符串最大使用的size
 *  @return:返回一个显示字符串的size
 */
+ (CGSize)stringLinesSize:(NSString *)string font:(UIFont *)font clientSize:(CGSize)clientSize;

/**
 *  @brief:计算文字的所用的Size
 *  @param string:字符串
 *  @param font:字符串使用的字体
 *  @param clientSize:字符串最大使用的size
 *  @param lineSpacing:字符串的行间距
 *  @return:返回一个显示字符串的size
 */
+ (CGSize)stringLinesSizeWithLineSpacing:(NSString *)string font:(UIFont *)font clientSize:(CGSize)clientSize lineSpacing:(CGFloat)lineSpacing;

/**
 *  @brief:颜色值转换
 *  @param color:颜色字符串可能值(#121212, 121212)
 *  @param alpha:alpha值
 *  @return:返回一个UIColor实例
 */
+ (UIColor *)intepreterColorWithAlpha:(const char *)color alpha:(float)alpha;

/**
 *  @brief:颜色值转换, alpha为1
 *  @param color:颜色字符串可能值(#121212, 121212)
 *  @return:返回一个UIColor实例
 */
+ (UIColor *)intepreterColor:(const char *)color;

/**
 *  @brief:颜色值转换, alpha为1
 *  @param color:0xFFFFFF
 *  @return:返回一个UIColor实例
 */
+ (UIColor *)colorFromInt:(NSUInteger)color;

/**
 *  @brief:颜色值转换
 *  @param color:0xFFFFFF
 *  @param alpha:alpha值
 *  @return:返回一个UIColor实例
 */
+ (UIColor *)colorFromInt:(NSUInteger)color alpha:(float)alpha;

/**
 *  @brief:app版本
 */
+ (NSString *)getAppVersion;

/**
 *  @brief:app名字
 */
+ (NSString *)getAppName;

/**
 *  @brief:app构建版本
 */
+ (NSString *)getAppBuildInfo;

/**
 *  @brief:app版本target的名字
 */
+ (NSString *)getExecuteName;

/**
 *  @brief:appbundle的信息
 */
+ (NSString *)getBundleId;

/*
 @brief:设置存取取UUID的key,app启动期间仅仅执行一次
 @param uuidKey:UUID的key值,为空的情况下调用getBundleId
 */
+ (void)setUUIdKey:(NSString *)uuidKey;

/**
 *  @brief:设备相关,取设备的uuid
 */
+ (NSString *)getUUID;

/**
 *  @brief:设备相关,取设备os信息，return sample: iOS7.1
 */
+ (NSString *)getDeviceOS;

/**
 *  @brief:设备相关,取设备信息，return sample :iPhone5,1
 */
+ (NSString *)getDeviceModel;

/**
 *  @brief:运营商相关
 *  @param carrierName:sim卡对应的运营商名称
 *  @param isoCC:国际标准化的国家字母缩写
 *  @param MCC:国家的数字代号
 *  @param MNC:移动网络的数字代号
 */
+ (void)getCarrierName:(NSString **)carrierName isoCC:(NSString **)isoCC MCC:(NSString **)MCC MNC:(NSString **)MNC;

/**
 *  @brief:取得当前的ip地址
 */
+ (NSString *)getIPAddress;

/**
 *  @brief:取得当前的mac地址
 */
+ (NSString *)getMacAddress;

/*
 *  @brief:通过16进制字符串返回一个整形值
 *  @param hex16String:16进制的中字符串
 *  @return:返回一个无符号长整型值
 */
+ (unsigned long long)hex16StringToULongLong:(NSString *)hex16String;

/*
 *  @brief:通过16进制字符串返回一个整形值
 *  @param string:字符串
 *  @param hex:string所表示的进制
 *  @return:返回一个无符号长整型值
 */
+ (unsigned long long)strToLong:(NSString *)string hex:(NSInteger)hex;

/*
 *  @brief:通过unicode编码转换为字符串必须以\u开头
 *  @param unicode:unicode编码字符串
 *  @param prefix:前缀
 *  @return:返回一个实际的字符串
 */
+ (NSString *)stringFromUnicode:(NSString *)unicode prefix:(NSString *)prefix;

/*
 *  @brief:通过字符串获取unicode的编码串
 *  @param string:字符串
 *  @param prefix:前缀
 *  @return:返回一个unicode的编码串
 */
+ (NSString *)unicodeFromString:(NSString *)string prefix:(NSString *)prefix align:(BOOL)align;

/*
 @brief:返回一个去掉前缀和后缀后的类的抽象名称
 @param clsName:定义的类名
 @param prefix:前缀
 @param suffix:后缀
 @return:实体抽象名称
 */
+ (NSString *)className:(NSString *)clsName prefix:(NSString *)prefix suffix:(NSString *)suffix;

/*
 @brief:返回状态栏的高度
 @param orientation:方向
 @return:返回高度
 */
+ (CGFloat)statusBarHeightWithOrientation:(UIInterfaceOrientation)orientation;


/*
 @brief:返回启动页的图片的UIImage
 */
+ (UIImage *)launchImage;


/*
 @brief:是否为有效手机号码
 @param phoneNumber:手机号码
 */
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;

/*
 @brief:是否为有效的电子邮件
 @param email:电子邮件
 */
+ (BOOL)isValidEMail:(NSString *)email;



@end

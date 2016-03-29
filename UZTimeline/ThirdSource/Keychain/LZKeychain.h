//
//  LZKeychain.h
//  LaiZhuaniOS
//
//  Created by sdfsdf on 15/12/24.
//  Copyright © 2015年 sdfsdf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)keychainDelete:(NSString *)service;

@end

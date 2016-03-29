//
//  LZKeychain.m
//  LaiZhuaniOS
//
//  Created by sdfsdf on 15/12/24.
//  Copyright © 2015年 sdfsdf. All rights reserved.
//

#import "LZKeychain.h"

@implementation LZKeychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    OSStatus result;

    //Delete old item before add new item
    [LZKeychain keychainDelete:service];
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    result = SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    
}

+ (id)load:(NSString *)service {
    
//    dispatch_queue_t queue = dispatch_get_main_queue();
   __block id ret = nil;
//    dispatch_sync(queue, ^{
    
        NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
        //Configure the search setting
        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
        [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
        CFDataRef keyData = NULL;
        if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
            @try {
                ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
            } @catch (NSException *e) {
                NSLog(@"Unarchive of %@ failed: %@", service, e);
            } @finally {
            }
        }
        
//    });
    
    return ret;

}

+ (void)keychainDelete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end

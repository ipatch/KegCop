//
//  KeychainHelper.m
//  KegCop
//
//  Created by capin on 6/8/12.
//

#import "KeychainHelper.h"
#import <Security/Security.h>

@interface KeychainHelper ()
+ (NSMutableDictionary*)dictionaryForKey:(NSString*)aKey;
@end

@implementation KeychainHelper

static const NSString *SERVICE_NAME = @"com.chrisrjones.kegcop";

+ (NSMutableDictionary*)dictionaryForKey:(NSString*)aKey
{
    NSData *encodedKey = [aKey dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *searchDictionary = [NSMutableDictionary dictionary];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchDictionary setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:SERVICE_NAME forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

+ (NSString*)getPasswordForKey:(NSString*)aKey
{
    NSString *password = nil;
    
    NSMutableDictionary *searchDictionary = [self dictionaryForKey:aKey];
    
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    /*
    NSData *result = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, (CFTypeRef *)&result);
    
    if (result)
    {
        password = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
    }
    */
    
    CFTypeRef result = NULL;
    BOOL statusCode = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    if (statusCode == errSecSuccess) {
        NSData *resultData = CfBridgingRelease(result);
        password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];

    }
    
    return password;
}

+ (void)removePasswordForKey:(NSString*)aKey
{
    NSMutableDictionary *keyDictionary = [self dictionaryForKey:aKey];
    SecItemDelete((__bridge CFDictionaryRef)keyDictionary);
}

+ (void)setPassword:(NSString*)aPassword forKey:(NSString*)aKey
{
    [KeychainHelper removePasswordForKey:aKey];
    
    NSData *encodedPassword = [aPassword dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *keyDictionary = [self dictionaryForKey:aKey];
    [keyDictionary setObject:encodedPassword forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keyDictionary, nil);
}
@end
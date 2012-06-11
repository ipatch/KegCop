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

static const NSString *SERVICE_NAME = @"com.domain.myapplication";

+ (NSMutableDictionary*)dictionaryForKey:(NSString*)aKey
{
    NSData *encodedKey = [aKey dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *searchDictionary = [NSMutableDictionary dictionary];
    /*
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [searchDictionary setObject:encodedKey forKey:(id)kSecAttrGeneric];
    [searchDictionary setObject:encodedKey forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:SERVICE_NAME forKey:(id)kSecAttrService];
    */
    return searchDictionary;
}

+ (NSString*)getPasswordForKey:(NSString*)aKey
{
    NSString *password = nil;
    
    NSMutableDictionary *searchDictionary = [self dictionaryForKey:aKey];
    /*
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
     */
    /*
    NSData *result = nil;
    SecItemCopyMatching((CFDictionaryRef)searchDictionary, (CFTypeRef*)&result);
    
    if (result)
    {
        password = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
        [result release];
    }
    return password;
}

+ (void)removePasswordForKey:(NSString*)aKey
{
    NSMutableDictionary *keyDictionary = [self dictionaryForKey:aKey];
    SecItemDelete((CFDictionaryRef)keyDictionary);
}

+ (void)setPassword:(NSString*)aPassword forKey:(NSString*)aKey
{
    [KeychainHelper removePasswordForKey:aKey];
    
    NSData *encodedPassword = [aPassword dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *keyDictionary = [self dictionaryForKey:aKey];
    [keyDictionary setObject:encodedPassword forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keyDictionary, nil);
}
*/
}
@end


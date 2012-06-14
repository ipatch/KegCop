//
//  KeychainHelper.h
//  KegCop
//
//  Created by capin on 6/8/12.
//


@interface KeychainHelper : NSObject

+ (NSString*)getPasswordForKey:(NSString*)aKey;
+ (void)setPassword:(NSString*)aPassword forKey:(NSString*)aKey;
+ (void)removePasswordForKey:(NSString*)aKey;

@end

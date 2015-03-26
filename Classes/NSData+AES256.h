//
//  NSData+AES256.h
//  KegCop
//  Created by capin on 8/15/12.
//

// This file is a interface file which is a "category" for the class NSData
// categories - add functionality to existing classes.

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES256)

// the below lines of code are "signatures" for methods that extend the functionality of the NSData class.

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

// add the below method signature(s) to modularize func - decode base64 NSData
- (NSData *)base64DataFromString: (NSString *)string;
- (NSString*)base64forData:(NSData*)theData;

@end

//
//  Account.m
//  KegCop
//
//  Created by capin on 6/8/12.
//

#import "Account.h"
#import "KeychainHelper.h"


@implementation Account

- (NSString*)password 
{
    if (self.username)
        return [KeychainHelper getPasswordForKey:self.username];
    return nil;
}

-(NSString*)getPasswordFromKeychain
{
    if (self.username)
        return [KeychainHelper getPasswordForKey:self.username];
    return nil;
}

- (void)setPassword:(NSString*)aPassword 
{
    if (self.username) [KeychainHelper setPassword:aPassword forKey:self.username];
    
    
}
- (void)prepareForDeletion
{
    if (self.username) [KeychainHelper removePasswordForKey:self.username];
}
@end

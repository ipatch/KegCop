//
//  Account.h
//  KegCop
//
//  Created by capin on 6/8/12.
//

#import "AccountBase.h"

@interface Account : AccountBase {
    
}

// nonatomic - don't worry about multithreading

@property (nonatomic, assign) NSString *password;

-(NSString *)getPasswordFromKeychain; 

- (void)setPassword:(NSString*)aPassword;



@end
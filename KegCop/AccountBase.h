//
//  AccountBase.h
//  KegCop
//
//  Created by capin on 6/8/12.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AccountBase : NSManagedObject
{
    
}

@property (nonatomic, retain) NSString *username;

@property (nonatomic, retain) NSString *email;

@property (nonatomic, retain) NSNumber *phoneNumber;

@end

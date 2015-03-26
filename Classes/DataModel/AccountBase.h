//
//  AccountBase.h
//  KegCop
//
//  Created by capin on 6/8/12.
//

#import <CoreData/CoreData.h>

@interface AccountBase : NSManagedObject {

}

@property (nonatomic, retain) NSString *username;

@property (nonatomic, retain) NSString *email;

@property (nonatomic, retain) NSString *phoneNumber;

@property (nonatomic, retain) NSNumber *credit;         // int

@property (nonatomic, retain) NSString *rfid;

@property (nonatomic, retain) NSString *pin;

@property (nonatomic, retain) NSData *avatar;

@property (nonatomic, retain) NSDate *lastLogin;

@end

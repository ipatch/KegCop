//
//  AccountsDataModel.h
//  KegCop
//
//  Created by capin on 3/14/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AccountsDataModel : NSObject

+ (id)sharedDataModel;

@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)modelName;
- (NSString *)pathToModel;
- (NSString *)storeFilename;
- (NSString *)pathToLocalStore;

@end

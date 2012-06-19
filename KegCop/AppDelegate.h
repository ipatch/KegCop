//
//  AppDelegate.h
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
}

@property (strong, nonatomic) UIWindow *window;


// removed "readonly" 

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext; // gateway into saving objects, NOT thread safe
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel; // collection of entity descriptions
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory; // how the managedObjectModel finds where to save the sqlite database.




@end
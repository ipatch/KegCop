//
//  AppDelegate.h
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
}

// the below property is important
// http://developer.apple.com/library/ios/#releasenotes/Miscellaneous/RN-AdoptingStoryboards/_index.html

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext; // gateway into saving objects, NOT thread safe
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel; // collection of entity descriptions
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

// how the managedObjectModel finds where to save the sqlite database.
//- (NSURL *)applicationDocumentsDirectory;



@end
//
//  AppDelegate.m
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import "AppDelegate.h"
#import "ViewControllerWelcome.h"
#import "AccountsDataModel.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     ViewControllerWelcome *viewControllerWelcome = (ViewControllerWelcome *)[[ViewControllerWelcome alloc]init];
    
    NSManagedObjectContext *context = [[AccountsDataModel sharedDataModel] mainContext];
    if (context) {
        NSLog(@"Context is ready!");
    } else {
        NSLog(@"Context was nil :(");
    }
    
    [viewControllerWelcome setManagedObjectContext:context];
    
    // see this SO thread - stackoverflow.com/questions/1768881
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// code added to implement Core Data in Single View App
//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        } 
//    }
//}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (__managedObjectContext != nil) {
//        return __managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        __managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return __managedObjectContext;
//}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
//- (NSManagedObjectModel *)managedObjectModel
//{
//    if (__managedObjectModel != nil) {
//        return __managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Accounts" withExtension:@"momd"];
//    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return __managedObjectModel;
//}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (__persistentStoreCoordinator != nil) {
//        return __persistentStoreCoordinator;
//    }
//    
    // default sqlite file path
    // NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Accounts.sqlite"];
    
    
    
    // add conditional code for simulator and iDevice
//#if TARGET_IPHONE_SIMULATOR
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *docPath = [documentPaths objectAtIndex:0];
//    
//    NSURL *storeURL = [NSURL fileURLWithPath: [docPath stringByAppendingPathComponent:@"Accounts.sqlite"]];
//#else
//    // jailbroken path - /var/mobile/Library/Kegcop/
//    NSString *docPath = self.documentsDirectoryPath;
//    
//    NSURL *storeURL = [NSURL fileURLWithPath: [docPath stringByAppendingPathComponent:@"Accounts.sqlite"]];
//#endif
//    
//    // NSURL *storeURL = [NSURL fileURLWithPath: [docPath stringByAppendingPathComponent:@"Accounts.sqlite"]];
//    NSError *error = nil;
//    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }    
//    
//    return __persistentStoreCoordinator;
//}

//#pragma mark - Application's Documents directory
//
//// Returns the URL to the application's Documents directory.
//- (NSURL *)applicationDocumentsDirectory
//{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//// set path for documents in jailbreak environment
//-(NSString *)documentsDirectoryPath
//{
//#ifdef JAILBREAK
//    
//    NSString *documentPath =@"/var/mobile/Library/KegCop/";
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
//                                  withIntermediateDirectories:NO
//                                                   attributes:nil
//                                                        error:NULL];
//    }
//    
//    return documentPath;
//
//#else
//    
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    return [documentPaths objectAtIndex:0];
//
//#endif
//}
@end

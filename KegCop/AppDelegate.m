//
//  AppDelegate.m
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import "AppDelegate.h"
#import "AccountBase.h"
#import "ViewControllerWelcome.h"


/* Notes
 It loads the view controller and puts it into the window.
 
 1JAN13 - review / try to implement CoreDataHelper class into project / application.
 */


// hello chris


@implementation AppDelegate


@synthesize window = _window;

@synthesize managedObjectContext = __managedObjectContext; // gateway into saving objects, NOT thread safe
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // ViewControllerWelcome *viewControllerWelcome = (ViewControllerWelcome *)[[ViewControllerWelcome alloc]init];
    
//    NSManagedObjectContext *context = (NSManagedObjectContext *) [self managedObjectContext];
//    if (!context) {
//        NSLog(@"\nCould not create *context for self");
//    }
    
    //[viewControllerWelcome setManagedObjectContext:context];
    
    // Do I need to declare my view controllers here?
    
    // Pass the managed object context to the view controller.

//    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
//    
//    if (iOSDeviceScreenSize.height == 480)
//    {
//        // Instantiate a new storyboard object using the storyboard file named iPhoneLegacy
//        UIStoryboard *iPhoneLegacy = [UIStoryboard storyboardWithName:@"iPhoneLegacy" bundle:nil];
//        
//        // Instantiate the initial view controller object from the storyboard
//        UIViewController *ViewControllerWelcome = [iPhoneLegacy instantiateInitialViewController];
//        
//        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        
//        // Set the initial view controller to be the root view controller of the window object
//        self.window.rootViewController = ViewControllerWelcome;
//        
//        // set the window object to be the key window and show it
//        [self.window makeKeyAndVisible];
//    }
//    
//    if (iOSDeviceScreenSize.height == 968)
//    {
//        // Instantiate a new storyboard object using the storyboard file named iPhone4
//        UIStoryboard *iPhone4 = [UIStoryboard storyboardWithName:@"iPhone4" bundle:nil];
//        
//        UIViewController *ViewControllerWelcome = [iPhone4 instantiateInitialViewController];
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.window.rootViewController  = ViewControllerWelcome;
//        [self.window makeKeyAndVisible];
//    }
    
    
    
    // iPad Legacy 1024 x 768
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIStoryboard *storyboard;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
        
        NSLog(@"The size of result is %@",NSStringFromCGSize(result));
    
        if(result.height == 1024) {
            storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
            ViewControllerWelcome *ViewControllerWelcome = [storyboard instantiateInitialViewController];
            
            //–instantiateViewControllerWithIdentifier:
            
//            MyViewController *controller = (MyViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"<Controller ID>"];
            
            [self.window setRootViewController:ViewControllerWelcome];
            NSLog(@"iPad storyboard file loaded");
            
        }
    }
    
    
    // iPhone 5 1136 x 640
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIStoryboard *storyboard;
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 1136){
            storyboard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
            ViewControllerWelcome *ViewControllerWelcome = [storyboard instantiateInitialViewController];
            [self.window setRootViewController:ViewControllerWelcome];
            NSLog(@"iPhone5 storyboard file loaded");
        }
    }
    
    
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
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Accounts" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    // default sqlite file path
    // NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Accounts.sqlite"];
    
    
    
    // add conditional code for simulator and iDevice
#if TARGET_IPHONE_SIMULATOR
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [documentPaths objectAtIndex:0];
    
    NSURL *storeURL = [NSURL fileURLWithPath: [docPath stringByAppendingPathComponent:@"Accounts.sqlite"]];
#else
    // jailbroken path - /var/mobile/Library/Kegcop/
    NSString *docPath = self.documentsDirectoryPath;
    
    NSURL *storeURL = [NSURL fileURLWithPath: [docPath stringByAppendingPathComponent:@"Accounts.sqlite"]];
#endif
    
    // NSURL *storeURL = [NSURL fileURLWithPath: [docPath stringByAppendingPathComponent:@"Accounts.sqlite"]];
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// set path for documents in jailbreak environment
-(NSString *)documentsDirectoryPath
{
#ifdef JAILBREAK
    
    NSString *documentPath =@"/var/mobile/Library/KegCop/";
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    }
    
    return documentPath;

#else
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [documentPaths objectAtIndex:0];

#endif
}

@end

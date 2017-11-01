//
//  AppDelegate.m
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import "AppDelegate.h"
#import "ViewControllerWelcome.h"
#import "AccountsDataModel.h"
//#import <RestKit/RestKit.h>
#import "ViewControllerIntro.h"

@interface AppDelegate () {

}
@end

@implementation AppDelegate {

}

+ (id)sharedManager {
    static AppDelegate *sharedAppDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppDelegate = [[self alloc] init];
    });
    return sharedAppDelegate;
}

- (id)init {
    if (self = [super init]) {
#ifdef DEBUG
        NSLog(@"device token = %@",_deviceToken);
#endif
    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // set cache for intro view
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity: 20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
            (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    // could not access deviceToken from this method :'(
    
    // add RestKit singleton class for setting up base URI for app.
//    RKObjectManager *rkom = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://kegcop.chrisrjones.com"]];
    
    // Override point for customization after application launch.
//    _storyboard = [UIStoryboard storyboardWithName:@"iPhone"  bundle:[NSBundle mainBundle]];
//    UIViewController *vcWelcome = [_storyboard instantiateInitialViewController];
    ViewControllerIntro *vcIntro = [[ViewControllerIntro alloc] initWithNibName:@"ViewControllerIntro" bundle:nil];
    self.window.rootViewController = vcIntro;
    
    NSManagedObjectContext *context = [[AccountsDataModel sharedDataModel] mainContext];
    if (context) {
#ifdef DEBUG
        NSLog(@"Context is ready!");
#endif
    } else {
#ifdef DEBUG
        NSLog(@"Context was nil :(");
#endif
    }
    
    // see this SO thread - stackoverflow.com/questions/1768881
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    [self checkUseriCloudSync];
    
    // need to figure out how to fetch the DeviceID and append it to the file name
    NSString *idfv;
    
    // Specify how the keychain items can be access
    // Do this in your -application:didFinishLaunchingWithOptions: callback
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    
//    NSString *uuid;
    
    // get a password
    if ( (idfv = [SSKeychain passwordForService:@"com.chrisrjones.KegCop.idfv" account:@"com.chrisrjones.KegCop"]) == nil) {
        
        NSString *idfvString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        // set a password
        NSString *enteredPassword = idfvString;
        
        // set a password
        [SSKeychain setPassword:enteredPassword forService:@"com.chrisrjones.KegCop.idfv" account:@"com.chrisrjones.KegCop"];
    }
    // log the password
    NSLog(@"uniqueIDFV = %@",idfv);
    
    return YES;
}

- (BOOL)checkUseriCloudSync {
    NSString *userKey = @"com.chrisrjones.KegCop.user";
    NSString *KEYCHAIN_ACCOUNT_IDENTIFIER = @"com.chrisrjones.KegCop";
    NSString *localID = [SSKeychain passwordForService:userKey account:KEYCHAIN_ACCOUNT_IDENTIFIER];
    NSString *iCloudID = [[NSUbiquitousKeyValueStore defaultStore] stringForKey:userKey];
    
    if (!iCloudID) {
        // iCloud does not have the key saved, so we write the key to iCloud
        [[NSUbiquitousKeyValueStore defaultStore] setString:localID forKey:userKey];
        return YES;
    }
    
    if (!localID || [iCloudID isEqualToString:localID]) {
        return YES;
    }
    
    // both IDs exist, so we keep the one from iCloud since the functionality requires synchronization
    // before setting, so that means that it was the earliest one
    
//    [self handleMigration:userKey from:localID to:iCloudID];
    
    return NO;
}

//- (void) handleMigration:(NSString *):(NSString *):(NSString *) {
//    
//}

- (NSData *) obtainDeviceToken {
    return self.deviceToken;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
#ifdef DEBUG
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
#endif
    
    // save deviceToken to string
    _tokenString = [[[NSString stringWithFormat:@"%@", deviceToken] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>" ]] stringByReplacingOccurrencesOfString:@" " withString:@"" ];
#ifdef DEBUG
    NSLog(@"_tokenString = %@",_tokenString);
#endif
    
    // save string to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:_tokenString forKey:@"uniqueTokenString"];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
#endif
    
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

@end

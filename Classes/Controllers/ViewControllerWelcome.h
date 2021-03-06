//
//  ViewControllerWelcome.h
//  KegCop
//  Login / Sign Screen
//
//  Created by capin on 6/3/12.
//

#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>  // makes round buttons :)
#import "AppDelegate.h"
#import "Account.h"
#import "ViewControllerRootHome.h"
#import "NSData+AES256.h"
#import <dispatch/dispatch.h> // Grand Central Dispatch
#import "AFNetworking.h"
#import "AccountsDataModel.h"
#import "GlobalData.h"
#import "ViewControllerHome.h"

@class ViewControllerWelcome;

@interface ViewControllerWelcome : UIViewController <UITextFieldDelegate, ViewControllerHomeDelegate>
// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)processLogin:(id)sender;
- (IBAction)showForgotScene:(id)sender;
- (IBAction)showCreateScene:(id)sender;
- (IBAction)showAboutScreen:(id)sender;

// keyboard toolbar
- (IBAction) next:(id)sender;
- (IBAction) prev:(id)sender;

@end
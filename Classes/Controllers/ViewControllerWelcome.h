//
//  ViewControllerWelcome.h
//  KegCop
//  Login / Sign Screen - INITIAL VIEW THAT IS LOADED ON LAUNCH
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

@interface ViewControllerWelcome : UIViewController <ViewControllerHomeDelegate>


// Welcome screen
@property (weak, nonatomic) IBOutlet UIScrollView *welcomeScroller;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPin;
@property (weak, nonatomic) IBOutlet UILabel *wrongUserPin;
@property (weak, nonatomic) IBOutlet UIButton *welcomeLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *welcomeActivityIndicator;

// forgot username / pin button
@property (weak, nonatomic) IBOutlet UIButton *btnForgot;

@property (weak, nonatomic) IBOutlet UIButton *btnCreate;

// info button - located lower right
@property (weak, nonatomic) IBOutlet UIButton *welcomeAbout;

// this button is set to hidden by default - used for testing out new features
@property (weak, nonatomic) IBOutlet UIButton *dev;

// keyboard toolbar
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// end Welcome

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;

- (IBAction)processLogin:(id)sender;

- (IBAction)showForgotScene:(id)sender;

- (IBAction)showCreateScene:(id)sender;

- (IBAction)showAboutScreen:(id)sender;

// keyboard toolbar
- (IBAction) next:(id)sender;
- (IBAction) prev:(id)sender;

- (IBAction)processDev:(id)sender;

@end
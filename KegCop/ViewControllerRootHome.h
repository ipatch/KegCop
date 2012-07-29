//
//  ViewControllerRootHome.h
//  KegCop
//
//  Created by capin on 6/26/12.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Account.h"
#import "ViewControllerWelcome.h"
#import "ViewControllerLogs.h"
#import "ViewControllerCheckFlow.h"

@interface ViewControllerRootHome : UIViewController {
    
    UIButton *nuke;
    UITextField *tfEmail;
    UIButton *btnEmailSave;
    
    
}

// root Home View Controller - display elements

@property (weak, nonatomic) IBOutlet UIScrollView *rootHomeScroller;

@property (weak, nonatomic) IBOutlet UITextField *tfDeleteAccount;

@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAccount;

@property (weak, nonatomic) IBOutlet UIButton *btnDisplayAccount;

@property (weak, nonatomic) IBOutlet UIButton *btnDisplayEmail;

@property (weak, nonatomic) IBOutlet UITextView *tvDisplayAccount;

@property (weak, nonatomic) IBOutlet UILabel *lblArduinoGood;

@property (weak, nonatomic) IBOutlet UILabel *lblArduinoBad;

@property (weak, nonatomic) IBOutlet UISwitch *switchRfid;

@property (weak, nonatomic) IBOutlet UITextField *tfCreditUsername;

@property (weak, nonatomic) IBOutlet UITextField *tfCredit;

@property (weak, nonatomic) IBOutlet UIButton *btnAddCredit;

@property (weak, nonatomic) IBOutlet UILabel *lblCredit;

@property (weak, nonatomic) IBOutlet UILabel *lblRootCredit;

@property (weak, nonatomic) IBOutlet UIButton *btnLogout;


@property (weak, nonatomic) IBOutlet UIButton *btnCheckFlow;


@property (weak, nonatomic) IBOutlet UIButton *btnLogs;




// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


// methods

- (IBAction)displayAccount:(id)sender;

- (IBAction)displayEmail:(id)sender;

- (IBAction)deleteAccount:(id)sender;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)testArduinoConnection:(id)sender;

- (IBAction)saveMasterEmail;

- (IBAction)rfidOnOff;

- (IBAction)addCredit:(id)sender;

- (IBAction)logout:(id)sender;

- (IBAction)checkFlow:(id)sender;

- (IBAction)showLogs:(id)sender;




@end

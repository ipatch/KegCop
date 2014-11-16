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
#import "ViewControllerSerialConsole.h"
#import "KBFlowIndicator.h"

@interface ViewControllerRootHome : UIViewController <UITabBarDelegate, UITextFieldDelegate> {
    
    UIButton *nuke;
    UITextField *tfEmail;
    UIButton *btnEmailSave;
    UITabBar *tbRoot;
    UINavigationBar *navBar;
    
    
}

// root Home View Controller - display elements

@property (weak, nonatomic) IBOutlet UIScrollView *rootHomeScroller;

@property (weak, nonatomic) IBOutlet UITextField *tfDeleteAccount;

@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAccount;

@property (weak, nonatomic) IBOutlet UIButton *btnDisplayAccount;

@property (weak, nonatomic) IBOutlet UIButton *btnDisplayEmail;

@property (weak, nonatomic) IBOutlet UITextView *tvDisplayAccount;

@property (weak, nonatomic) IBOutlet UISwitch *switchRfid;

@property (weak, nonatomic) IBOutlet UITextField *tfCreditUsername;

@property (weak, nonatomic) IBOutlet UITextField *tfCredit;

@property (weak, nonatomic) IBOutlet UIButton *btnAddCredit;

@property (weak, nonatomic) IBOutlet UILabel *lblCredit;

@property (weak, nonatomic) IBOutlet UILabel *lblRootCredit;

@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckFlow;

@property (weak, nonatomic) IBOutlet UIButton *btnSerialConsole;

@property (weak, nonatomic) IBOutlet UIButton *btnLogs;

@property (weak, nonatomic) IBOutlet UIButton *btndev;

// added button to get to flow indicator scene
@property (weak, nonatomic) IBOutlet UIButton *btnFlowIndicator;

@property (weak, nonatomic) IBOutlet UITabBar *tbRoot;

// added first tabbaritem
@property (weak, nonatomic) IBOutlet UITabBarItem *tbiUsers;
@property (weak, nonatomic) IBOutlet UITabBarItem *tbiMisc;
@property (weak, nonatomic) IBOutlet UITabBarItem *tbiDev;


// added for debugging purposes (make work)

@property (weak, nonatomic) IBOutlet UILabel *lblArduinoGood;

@property (weak, nonatomic) IBOutlet UILabel *lblArduinoBad;

// added dev3 btn for CoreBluetooth testing.
@property (weak, nonatomic) IBOutlet UIButton *btnDev4;

// added navigation bar - 14NOV14
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;


// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


// methods

- (IBAction)displayAccount:(id)sender;

- (IBAction)displayEmail:(id)sender;

- (IBAction)deleteAccount:(id)sender;

//dismiss keyboard
- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)saveMasterEmail;

- (IBAction)rfidOnOff;

- (IBAction)addCredit:(id)sender;

- (IBAction)logout:(id)sender;

- (IBAction)checkFlow:(id)sender;

- (IBAction)showSerialConsole:(id)sender;

- (IBAction)showLogs:(id)sender;

- (IBAction)showDev:(id)sender;

- (IBAction)showDev4:(id)sender;

- (IBAction)showFlowIndicator:(id)sender;

// added for debugging purposes

- (IBAction)testArduinoConnection:(id)sender;




@end

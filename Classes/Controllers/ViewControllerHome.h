//
//  ViewControllerHome.h
//  KegCop
//
//  Created by capin on 6/20/12.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "AppDelegate.h"
#import "ViewControllerWelcome.h"
#import "JailbrokenSerial.h"
// add for CoreBluetooth functionality
#import "DFBlunoManager.h"
#import "ViewControllerAvatar4.h" // add this line to make delegation work :/



// want to configure iPod Touch in peripheral mode, and have microcontroller in central mode.
@interface ViewControllerHome : UIViewController <JailbrokenSerialDelegate, UITextFieldDelegate, DFBlunoDelegate, ViewControllerAvatar4Delegate>
{
    UIButton *removeAccount;
    UIAlertView *alert;
    NSString *username;
    UILabel *lblUSERNAME;
    // serial
    JailbrokenSerial *serial;
    NSMutableString *rfidbadgenumber;
    UIAlertView *alertrfid;
    NSMutableString *newrfidtagid;
    
    }


@property (weak, nonatomic) IBOutlet UIScrollView *homeScroller;
@property (weak, nonatomic) IBOutlet UILabel *lblUSERNAME;
@property (weak, nonatomic) IBOutlet UILabel *creditX;
@property (weak, nonatomic) IBOutlet UIButton *btndrinkbeer;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnTradeCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblTradeCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnAddRFID;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *idleTimerTime;
@property (weak, nonatomic) IBOutlet UIButton *captureAvatar;


//test
@property (weak, nonatomic) IBOutlet UIButton *btnTest;


// Core Bluetooth
@property(strong, nonatomic) DFBlunoManager *blunoManager;
@property(strong, nonatomic) DFBlunoDevice *blunoDev;

// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)removeAccount;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)tradeCredit:(id)sender;

- (IBAction)drinkBeer:(id)sender;

- (IBAction)addRFID:(id)sender;

- (IBAction)logout:(id)sender;

- (IBAction)addAvatar:(id)sender;

- (IBAction)showTestScene:(id)sender;
@end
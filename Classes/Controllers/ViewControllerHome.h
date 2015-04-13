//
//  ViewControllerHome.h
//  KegCop
//
//  Created by capin on 6/20/12.
//

@class ViewControllerHome;

@protocol ViewControllerHomeDelegate

-(NSString *) receiveUserName;

@end
// put protocol declaration def above imports
// see this SO thread, stackoverflow.com/questions/6447573
#import "Account.h"
#import "ViewControllerWelcome.h"
#import "DFBlunoManager.h"
#import "ViewControllerAvatar4.h"
#import "ViewControllerWelcome.h"

@interface ViewControllerHome : UIViewController <UITextFieldDelegate, DFBlunoDelegate, ViewControllerAvatar4Delegate>
{
    UIButton *removeAccount;
    UIAlertView *alert;
    NSString *username;
    UILabel *lblUSERNAME;
    NSMutableString *rfidbadgenumber;
    UIAlertView *alertrfid;
    NSMutableString *newrfidtagid;
}
@property (strong, nonatomic) id<ViewControllerHomeDelegate>delegate;
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
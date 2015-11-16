//
//  ViewControllerHome.h
//  KegCop
//
//  Created by capin on 6/20/12.
//

@class ViewControllerHome;

@protocol ViewControllerHomeDelegate <NSObject>

- (void) sendUserNameToWelcomeVC:(NSString *)_un;
- (void)addItemViewController:(ViewControllerHome *)controller didFinishEnteringItem:(NSString *)_un;
//- (void)addAvatarToViewControllerWelcome:(ViewControllerHome *)controller didFinishSendingItem:(UIImage *)_avatar;

@end
// put protocol declaration def above imports
// see this SO thread, stackoverflow.com/questions/6447573
#import "Account.h"
#import "ViewControllerWelcome.h"
#import "DFBlunoManager.h"
#import "ViewControllerAvatar4.h"
#import "ViewControllerWelcome.h"
#import <UIKit/UIKit.h>

@interface ViewControllerHome : UIViewController <UITextFieldDelegate, DFBlunoDelegate, ViewControllerAvatar4Delegate>
{
    UIButton *removeAccount;
    UIAlertView *alert;
    NSString *username;
    NSMutableString *rfidbadgenumber;
    UIAlertView *alertrfid;
    NSMutableString *newrfidtagid;
    id myDelegate;
}

@property (nonatomic, assign) id<ViewControllerHomeDelegate> myDelegate;

@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnTradeCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblTradeCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnAddRFID;

@property (weak, nonatomic) IBOutlet UILabel *idleTimerTime;
@property (weak, nonatomic) IBOutlet UIButton *captureAvatar;

@property (weak, nonatomic) IBOutlet UIButton *btnTest;

// Core Bluetooth
@property(strong, nonatomic) DFBlunoManager *blunoManager;
@property(strong, nonatomic) DFBlunoDevice *blunoDev;
// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSString *un;
@property (nonatomic, retain) UIImage *avatar;


- (IBAction)removeAccount;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)tradeCredit:(id)sender;
- (IBAction)drinkBeer:(id)sender;
- (IBAction)addRFID:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)addAvatar:(id)sender;
@end
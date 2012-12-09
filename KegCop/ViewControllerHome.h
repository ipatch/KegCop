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

@interface ViewControllerHome : UIViewController <JailbrokenSerialDelegate, UITextFieldDelegate>
{
    UIButton *removeAccount;
    UIAlertView *alert;
    NSString *username;
    UILabel *lblUSERNAME;
    // serial
    JailbrokenSerial *serial;
    NSMutableString *rfidbadgenumber;
    
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

// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)removeAccount;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)tradeCredit:(id)sender;

- (IBAction)drinkBeer:(id)sender;

- (IBAction)addRFID:(id)sender;

@end
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
// Added 6JAN14
#import <CoreBluetooth/CoreBluetooth.h>

// want to configure iPod Touch in peripheral mode, and have microcontroller in central mode.
@interface ViewControllerHome : UIViewController <JailbrokenSerialDelegate, UITextFieldDelegate, CBPeripheralManagerDelegate>
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

// Core Bluetooth
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sendDataIndex;


// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)removeAccount;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)tradeCredit:(id)sender;

- (IBAction)drinkBeer:(id)sender;

- (IBAction)addRFID:(id)sender;

- (IBAction)logout:(id)sender;

@end
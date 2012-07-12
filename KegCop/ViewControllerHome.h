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

@interface ViewControllerHome : UIViewController
{
    UIButton *removeAccount;
    UIAlertView *alert;
    NSString *username;
    UILabel *lblUSERNAME;
}
@property (weak, nonatomic) IBOutlet UIScrollView *homeScroller;

@property (weak, nonatomic) IBOutlet UILabel *lblUSERNAME;

@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnTradeCredit;

// @property (weak, nonatomic) IBOutlet NSString *username;

-(IBAction)removeAccount;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)tradeCredit:(id)sender;

@end
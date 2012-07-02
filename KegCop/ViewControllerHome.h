//
//  ViewControllerHome.h
//  KegCop
//
//  Created by capin on 6/20/12.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "AppDelegate.h"

@interface ViewControllerHome : UIViewController
{
    UIButton *removeAccount;
    UIAlertView *alert;
}
@property (weak, nonatomic) IBOutlet UIScrollView *homeScroller;

@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnTradeCredit;

-(IBAction)removeAccount;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)tradeCredit:(id)sender;

@end

//
//  ViewController.h
//  KegCop
//
//  Created by capin on 6/30/12.
//

#import "ViewControllerWebView.h"

@interface ViewControllerPurchase : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfCredit;

- (IBAction)purchase:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
@end

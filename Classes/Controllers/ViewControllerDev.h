//
//  ViewControllerDev.h
//  KegCop
//
//  Created by capin on 8/13/12.
//

#import <UIKit/UIKit.h>
#import "JailbrokenSerial.h"

@interface ViewControllerDev : UIViewController <JailbrokenSerialDelegate> {
    
    JailbrokenSerial *serial;
    NSMutableString *blink_text;
    NSString *blink_string_text;
    
}

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (weak, nonatomic) IBOutlet UIButton *btnValve;

@property (weak, nonatomic) IBOutlet UIButton *btnBlink;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

- (IBAction)submit:(id)sender;

- (IBAction)openValve:(id)sender;

- (IBAction)blinkFlow_A_LED:(id)sender;

- (IBAction)dimissScene:(id)sender;
@end

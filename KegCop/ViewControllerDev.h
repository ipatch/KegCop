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
    
}

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (weak, nonatomic) IBOutlet UIButton *btnValve;

@property (weak, nonatomic) IBOutlet UIButton *btnBlink;

- (IBAction)submit:(id)sender;

- (IBAction)openValve:(id)sender;

- (IBAction)blinkFlow_A_LED:(id)sender;
@end

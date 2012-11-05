//
//  ViewControllerSerialConsole.h
//  KegCop
//
//  Created by capin on 7/30/12.
//

#import <UIKit/UIKit.h>
// #import "Serial.c"
#import "JailbrokenSerial.h"

#define BUFFER_LEN 1024

@interface ViewControllerSerialConsole : UIViewController <JailbrokenSerialDelegate> {
    

    UInt8 rxBuffer[BUFFER_LEN];
    UInt8 txBuffer[BUFFER_LEN];
    
}
@property (weak, nonatomic) IBOutlet UITextField *textEntry;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITextView *serialView;





- (IBAction)btnPressed:(id)sender;
- (IBAction)sendString:(id)sender;


@end

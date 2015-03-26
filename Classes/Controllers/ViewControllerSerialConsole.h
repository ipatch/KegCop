//
//  ViewControllerSerialConsole.h
//  KegCop
//
//  Created by capin on 7/30/12.
//

#import "JailbrokenSerial.h"

@interface ViewControllerSerialConsole : UIViewController <JailbrokenSerialDelegate> {
    JailbrokenSerial *serial;
    NSMutableString *text;
}
@property (weak, nonatomic) IBOutlet UITextField *textEntry;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITextView *serialView;


- (IBAction)donePressed:(id)sender;
- (IBAction)sendString:(id)sender;
- (IBAction)openSerial:(id)sender;
- (IBAction)closeSerial:(id)sender;


@end

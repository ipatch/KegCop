//
//  ViewControllerDev3.h
//  KegCop
//
//  Created by capin on 7/2/13.
//
//

#import "JailbrokenSerial.h"
#import "KBKegboardCommand.h"
#import "KBKegProcessing.h"

@interface ViewControllerDev3 : UIViewController <JailbrokenSerialDelegate> {
    JailbrokenSerial *jbserial;
    KBKegProcessing *kegProcessing;
    NSMutableString *text;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnJBSerialOpen;
@property (weak, nonatomic) IBOutlet UIButton *btnJBSerialClose;
@property (weak, nonatomic) IBOutlet UIButton *btnKBSerialOpen;
@property (weak, nonatomic) IBOutlet UIButton *btnKBSerialClose;

@property (weak, nonatomic) IBOutlet UIButton *btnOpenValveKBCommand;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenValveRawHex;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenValveKBProcessing;

@property (weak, nonatomic) IBOutlet UIButton *btnOpenValve;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseValve;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenValve2;

@property (weak, nonatomic) IBOutlet UILabel *lblValveState;

- (IBAction)dismissScene:(id)sender;

- (IBAction)jbSerialOpen:(id)sender;

- (IBAction)jbSerialClose:(id)sender;

- (IBAction)kbSerialOpen:(id)sender;

- (IBAction)kbSerialClose:(id)sender;

- (IBAction)openValveKBCommand:(id)sender;

- (IBAction)openValveRawHex:(id)sender;

- (IBAction)openValveKBProcessing:(id)sender;

- (IBAction)openValve:(id)sender;
- (IBAction)closeValve:(id)sender;
- (IBAction)openValve2:(id)sender;
@end
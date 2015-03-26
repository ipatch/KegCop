//
//  ViewControllerDev.h
//  KegCop
//
//  Created by capin on 8/13/12.
//

#import "JailbrokenSerial.h"
#import "KBKegProcessing.h"

@interface ViewControllerDev : UIViewController <JailbrokenSerialDelegate> {
    
    JailbrokenSerial *serial;
    NSMutableString *blink_text;
    NSString *blink_string_text;
    
    // test - per John Boiles email
    KBKegProcessing *kegProcessing;
    
}

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (weak, nonatomic) IBOutlet UIButton *btnValve;
@property (weak, nonatomic) IBOutlet UIButton *btnValve2;

@property (weak, nonatomic) IBOutlet UIButton *btnBlink;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

// toolbar button for dev2 scene
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btndev2;

- (IBAction)submit:(id)sender;

- (IBAction)openValve:(id)sender;

// this method uses kegboard clone sketch
- (IBAction)open_Valve:(id)sender;

- (IBAction)blinkFlow_A_LED:(id)sender;

- (IBAction)dimissScene:(id)sender;

// method to load the dev2 scene file
- (IBAction)showDev2scene:(id)sender;
@end

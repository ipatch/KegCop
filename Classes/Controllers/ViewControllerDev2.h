//
//  ViewControllerDev2.h
//  KegCop
//
//  Created by capin on 6/25/13.
//
//  ViewController for testing Bluetooth connectivity.
//  tutorial for BT4.0LE peripheral,
//  http://mobile.tutsplus.com/tutorials/iphone/ios-7-sdk-core-bluetooth-practical-lesson/
//  http://weblog.invasivecode.com/post/39707371281/core-bluetooth-for-ios-6-core-bluetooth-was
//

#import <UIKit/UIKit.h>
#import "DFBlunoManager.h"

@interface ViewControllerDev2 : UIViewController <DFBlunoDelegate> {

}

// btn required to dismiss scene
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

// CoreBluetooth stuff
@property(strong, nonatomic) DFBlunoManager *blunoManager;
@property(strong, nonatomic) DFBlunoDevice *blunoDev;

// interface elements for CoreBluetooth stuff
@property (weak, nonatomic) IBOutlet UILabel *lbReceiveMsg;
@property (weak, nonatomic) IBOutlet UITextField *txtSendMsg;
@property (weak, nonatomic) IBOutlet UILabel *lbReady;

- (IBAction)actionSend:(id)sender;
// method definition to dimiss scene
- (IBAction)dismissScene:(id)sender;





@end

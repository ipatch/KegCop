//
//  ViewControllerDev2.h
//  KegCop
//
//  Created by capin on 6/25/13.
//
//

#import <Foundation/Foundation.h>
#import "JailbrokenSerial.h"
#import "KBKegboardCommand.h"

@interface ViewControllerDev2 : UIViewController <JailbrokenSerialDelegate> {
    
    JailbrokenSerial *jbserial;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

@property (weak, nonatomic) IBOutlet UIButton *btnOpenValve;

@property (weak, nonatomic) IBOutlet UIButton *btnOpenValveKBCommand;

- (IBAction)dismissScene:(id)sender;

- (IBAction)openValve:(id)sender;

- (IBAction)openValveKBCommand:(id)sender;
@end

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

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <QuartzCore/QuartzCore.h>

#import "SERVICES.h"

@interface ViewControllerDev2 : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UITextViewDelegate> {
    
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

// Core Bluetooth Peripheral stuff
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;



@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;




- (IBAction)dismissScene:(id)sender;

- (IBAction)sendBTData:(id)sender;


@end

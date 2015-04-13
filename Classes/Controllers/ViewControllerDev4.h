//
//  ViewControllerDev4.h
//  KegCop
//
//  Created by capin on 2/5/14.
//
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

#define BLUNO_TRANSFER_SERVICE_UUID         @"dfb0"
#define BLUNO_TRANSFER_CHARACTERISTIC_UUID  @"dfb1"

@interface ViewControllerDev4 : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

// CoreBluetooth necessary objects
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;

- (IBAction) dismissScene:(id)sender;
@end

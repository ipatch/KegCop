//
//  BLEDevice.h
//  KegCop
//
//  Created by capin on 1/31/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEDevice : NSObject

/// pointer to CoreBluetooth peripheral
@property (strong,nonatomic) CBPeripheral *peripheral;
/// pointer to CoreBluetooth manager that found this peripheral
@property (strong,nonatomic) CBCentralManager *centralManager;
/// pointer to dictionary with device setup data
@property (strong,nonatomic) NSMutableDictionary *dicSetupData;
/// current device has some resources
@property (strong,nonatomic) NSMutableArray *aryResources;

@end
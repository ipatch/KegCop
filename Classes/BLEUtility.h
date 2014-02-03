//
//  BLEUtility.h
//  KegCop
//
//  Created by capin on 1/31/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEUtility : NSObject

+(void)readCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID;

+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable;
+(void)writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data;

+(void)writeCharacteristic:(CBPeripheral *)peripheral sCBUUID:(NSString *)sCBUUID cCBUUID:(NSString *)cCBUUID data:(NSData *)data;
+(void)readCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID;
+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID enable:(BOOL)enable;

+(bool)isCharacteristicNotifiable:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID;

@end

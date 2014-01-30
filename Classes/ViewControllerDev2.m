//
//  ViewControllerDev2.m
//  KegCop
//
//  Created by capin on 6/25/13.
//
//

#import "ViewControllerDev2.h"

@implementation ViewControllerDev2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // start up the central manager object, "by specifying the dispatch queue as nil the central manager dispatches central role events using the main queue
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil]; // options:nil is an iOS 7 feature
    
    // http://stackoverflow.com/questions/18970247/cbcentralmanager-changes-for-ios-7
    
    _data = [[NSMutableData alloc] init];
}

- (void)viewDidUnload {
    [self setBtnDone:nil];
    [super viewDidUnload];
}

- (IBAction)sendBTData:(id)sender {
    //[self sendData];
}

- (IBAction)dismissScene:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_centralManager stopScan];
}

// this method is called when creating a CBCentralManager, and is required!
// this method ensures that BLE is supported and available to use on the central device.
// the protocol allows the delegate to monitor the discovery, connectivity, and retrieval of peripheral devices.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // You should test all scenarios
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BLUNO_TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        NSLog(@"Scanning started");
    }
}

// this method is called after the central manager discovers a peripheral.
// "Any peripheral that is discovered is returned as a CBPeripheral object"
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    if (_discoveredPeripheral != peripheral) {
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        _discoveredPeripheral = peripheral;
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [_centralManager connectPeripheral:peripheral options:nil];
        
        // then stop scanning for peripherals
        [_centralManager stopScan];
        NSLog(@"Scanning stopped");
    }
}

// if the connection request is successful, the central manager calls the following method of its delegate object.
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Peripheral Connected");
    [_centralManager stopScan];
    NSLog(@"Scanning stopped");
    peripheral.delegate = self;
    [_data setLength:0];
    // discover the services offered by the peripheral
    [peripheral discoverServices:@[[CBUUID UUIDWithString:BLUNO_TRANSFER_SERVICE_UUID]]];
}

// this method is called once a service of a peripheral is discovered.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:BLUNO_TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
    // Discover other characteristics
}

// this method is called once a characteristic of a service is discovered
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BLUNO_TRANSFER_CHARACTERISTIC_UUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error");
        return;
    }
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        //[_textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        [_centralManager cancelPeripheralConnection:peripheral];
    }
    [_data appendData:characteristic.value];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:BLUNO_TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    _discoveredPeripheral = nil;
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BLUNO_TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

// this method should be called if central fails to connect to peripheral
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect");
    [self cleanup];
}

- (void)cleanup {
    // See if we are subscribed to a characteristic on the peripheral
    if (_discoveredPeripheral.services != nil) {
        for (CBService *service in _discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BLUNO_TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            [_discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
    [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
}



@end

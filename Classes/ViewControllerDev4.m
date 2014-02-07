//
//  ViewControllerDev4.m
//  KegCop
//
//  Created by capin on 2/5/14.
//
//

#import "ViewControllerDev4.h"

@interface ViewControllerDev4 ()

@end

@implementation ViewControllerDev4

@synthesize centralManager = _centralManager;
@synthesize discoveredPeripheral = _discoveredPeripheral;
@synthesize data = _data;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // initialize central manager object
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    _data = [[NSMutableData alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Necessary methods for CoreBluetooth CentralManager

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

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    // stop scanning for peripheral
    [_centralManager stopScan];
    
    if (_discoveredPeripheral != peripheral) {
        _discoveredPeripheral = peripheral;
        NSLog(@"Connecting to peripheral %@", _discoveredPeripheral);
        [_centralManager connectPeripheral:peripheral options:nil];
    }
    
    
    
    
//    if (_discoveredPeripheral != peripheral) {
//        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
//        // _discoveredPeripheral = peripheral;
//        peripheral = _discoveredPeripheral;
//        // And connect
//        NSLog(@"Connecting to peripheral %@", _discoveredPeripheral);
//        [_centralManager connectPeripheral:_discoveredPeripheral options:nil];
//        
//        // then stop scanning for peripherals
//        [_centralManager stopScan];
//        NSLog(@"Scanning stopped");
//    }
}

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

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected");
    [_centralManager stopScan];
    NSLog(@"Scanning stopped");
    [_data setLength:0];
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:BLUNO_TRANSFER_SERVICE_UUID]]];
}

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

- (IBAction)dismissScene:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

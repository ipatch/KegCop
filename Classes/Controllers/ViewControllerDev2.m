//
//  ViewControllerDev2.m
//  KegCop
//
//  Created by capin on 6/25/13.
//
//

#import "ViewControllerDev2.h"

@interface ViewControllerDev2 ()

@end

@implementation ViewControllerDev2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    self.lbReady.text = @"Not Ready!";
#ifdef DEBUG
    NSLog(@"view did load method called");
#endif
    [self.blunoManager scan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionSend:(id)sender
{
    [self.txtSendMsg resignFirstResponder];
    if (self.blunoDev.bReadyToWrite)
    {
        NSString *strTemp = self.txtSendMsg.text;
        NSData *data = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
        [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
#ifdef DEBUG
        NSLog(@"data written = %@",data);
#endif
    }
}

#pragma mark - DFBlunoDelegate

- (void)bleDidUpdateState:(BOOL)bleSupported
{
    if(bleSupported)
    {
        [self.blunoManager scan];
    }
}

- (void)didDiscoverDevice:(DFBlunoDevice *)dev
{
    [self.blunoManager connectToDevice:dev];
#ifdef DEBUG
    NSLog(@"Connected to %@",dev);
#endif
    self.blunoDev = dev;
}

- (void)readyToCommunicate:(DFBlunoDevice *)dev
{
    self.lbReady.text = @"Ready";
}

- (void)didDisconnectDevice:(DFBlunoDevice *)dev
{
    self.lbReady.text = @"Not Ready!";
    [self.blunoManager scan];
}

- (void)didWriteData:(DFBlunoDevice *)dev
{
    
}

- (void)didReceiveData:(NSData *)data Device:(DFBlunoDevice *)dev
{
    self.lbReceiveMsg.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (IBAction)dismissScene:(id)sender {
#ifdef DEBUG
    NSLog(@"dismissScene method called");
#endif
    // figure out way to disconnect from Bluno
    
     // stop scanning for BLE devices
    
    [self.blunoManager stop];
    
    [self.blunoManager disconnectToDevice:self.blunoDev];
    
    [self dismissViewControllerAnimated:NO completion:nil];
#ifdef DEBUG
    NSLog(@"code execution reached here");
#endif
}
@end
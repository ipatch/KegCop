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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    self.lbReady.text = @"Not Ready!";
    NSLog(@"view did load method called");
    [self.blunoManager scan];
}

- (void)viewDidUnload {
    
    // this method is never called for whatever reason :/
    
    NSLog(@"viewDidUnload method called");
    [super viewDidUnload];
    [self setBtnDone:nil]; // dismiss the done btn when the scene is closed
    //[self setblunoManager:nil];
    self.blunoManager.delegate = self;
    self.lbReady.text = @"Not Ready!";
    // release the Bluno objects when the view is dismissed.
    self.blunoManager = nil;
    self.blunoDev = nil;
  
}

- (void)didReceiveMemoryWarning
{
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
        NSLog(@"data written = %@",data);
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
    NSLog(@"Connected to %@",dev);
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
    NSLog(@"dismissScene method called");
    // figure out way to disconnect from Bluno
    
     // stop scanning for BLE devices
    
    [self.blunoManager stop];
    
    [self.blunoManager disconnectToDevice:self.blunoDev];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"code execution reached here");
    
}
@end
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
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setBtnDone:nil]; // dismiss the done btn when the scene is closed
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    self.lbReady.text = @"Not Ready!";
  
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
}








@end

//
//  ViewControllerDev2.m
//  KegCop
//
//  Created by capin on 6/25/13.
//
//

#import "ViewControllerDev2.h"

@implementation ViewControllerDev2

- (void)viewDidUnload {
    [self setBtnDone:nil];
    [super viewDidUnload];
}
- (IBAction)dismissScene:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end

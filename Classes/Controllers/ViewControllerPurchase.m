//
//  ViewController.m
//  KegCop
//
//  Created by capin on 6/30/12.
//

#import "ViewControllerPurchase.h"

@interface ViewControllerPurchase ()

@end

@implementation ViewControllerPurchase

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (YES);
}

- (IBAction)purchase:(id)sender {
    NSLog(@"purchase button pressed");

    ViewControllerWebView *webview = (ViewControllerWebView *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    [self presentViewController:webview animated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [_tfCredit resignFirstResponder];
}
@end
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
@synthesize tfCredit = _tfCredit;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
}

- (void)viewDidUnload
{
    [self setTfCredit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (YES);
}

- (IBAction)purchase:(id)sender {
    
    NSLog(@"purchase button pressed");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    ViewControllerWebView *webview = (ViewControllerWebView *)[storyboard instantiateViewControllerWithIdentifier:@"webView"];
    [self presentViewController:webview animated:YES completion:nil];
    
}

- (IBAction)dismissKeyboard:(id)sender {
    [_tfCredit resignFirstResponder];
}
@end

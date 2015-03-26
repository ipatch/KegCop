//
//  ViewControllerWebView.m
//  KegCop
//
//  Created by capin on 6/30/12.
//

#import "ViewControllerWebView.h"

@interface ViewControllerWebView ()

@end

@implementation ViewControllerWebView {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSString *urlAddress = @"http://www.paypal.com";
    
    // Create a URL object
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    // URL request object
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Load the the request in the webview
    [_webView loadRequest:request];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setBtnDone:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (YES);
}

- (IBAction)dimissWebView:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
}
@end

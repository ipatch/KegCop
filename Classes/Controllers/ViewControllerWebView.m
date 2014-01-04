//
//  ViewControllerWebView.m
//  KegCop
//
//  Created by capin on 6/30/12.
//

#import "ViewControllerWebView.h"

@interface ViewControllerWebView ()

@end

@implementation ViewControllerWebView
@synthesize webView = _webView;
@synthesize btnDone = _btnDone;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    ViewControllerHome *home = (ViewControllerHome *)[storyboard instantiateViewControllerWithIdentifier:@"Home"];
    [self presentViewController:home animated:YES completion:nil];
    
    
}
@end

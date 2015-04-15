//
//  ViewControllerIntro.m
//  KegCop
//
//  Created by capin on 4/14/15.
//
//

#import "ViewControllerIntro.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewControllerIntro ()

@end

@implementation ViewControllerIntro

- (void)viewDidLoad {
    [super viewDidLoad];
    // create a webview that fills the bounds of the screen programmatically
    UIWebView *webView = [[UIWebView alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ))];
    
    NSString *urlAddress = @"http://kegcop.chrisrjones.com/bubbles";
    
    // Create a URL object
    NSURL *kegcopURL = [NSURL URLWithString:urlAddress];
    
    // URL request object
//    NSURLRequest *request = [NSURLRequest requestWithURL:urlAddress];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:kegcopURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
    // add UILabel w/ custom font for KegCop
    UILabel *kegCop = [[UILabel alloc] initWithFrame:(CGRectMake(70, 120, 300, 300))];
    
//    kegCop.textColor = [UIColor yellowColor];
    kegCop.text = @"KegCop";
    kegCop.font = [UIFont fontWithName:@"Helvetica" size:50];
    
    [kegCop setTextColor: [UIColor colorWithRed:(174/255.0)
                                        green:(127/255.0)
                                        blue:(120/255.0)
                                        alpha:(1.0f)]];
    
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signInButton addTarget:self
                               action:@selector(signIn)
                     forControlEvents:UIControlEventTouchUpInside];
    [signInButton setTitle:@"SIGN IN"  forState:UIControlStateNormal ];
    signInButton.frame = CGRectMake(10, 500.0, 130.0, 60.0); // x, y, width, height
    
    [signInButton setBackgroundColor: [UIColor colorWithRed:(77/255.0)
                                          green:(33/255.0)
                                           blue:(28/255.0)
                                          alpha:(1.0f)]];
    
    [signInButton setTitleColor:[UIColor colorWithRed:174/255.0
                                                 green:127/255.0
                                                  blue:120/255.0
                                                 alpha:1.0f] forState:UIControlStateNormal];
    
    // round corners of signInButton
    signInButton.layer.cornerRadius = 5;
    
    // how to change font color UIButton
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerButton addTarget:self
                     action:@selector(registerAccount)
           forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"REGISTER"  forState:UIControlStateNormal ];
    registerButton.frame = CGRectMake(160, 500.0, 140.0, 60.0);
    
    // change background color of register button
    
    [registerButton setBackgroundColor: [UIColor colorWithRed:(55/255.0)
                                                      green:(16/255.0)
                                                       blue:(11/255.0)
                                                      alpha:(1.0f)]];
    
    [registerButton setTitleColor:[UIColor colorWithRed:174/255.0
                                                green:127/255.0
                                                 blue:120/255.0
                                                alpha:1.0f] forState:UIControlStateNormal];

    // round corners of registerButton
    registerButton.layer.cornerRadius = 5;
    

    [self.view addSubview:signInButton];
    [self.view addSubview:registerButton];
    [self.view addSubview:kegCop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signIn {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"Welcome"];
    [self presentViewController:welcomeVC animated:YES completion:nil];
    
}

- (void)registerAccount {
    
}
@end
//
//  ViewControllerIntro.m
//  KegCop
//
//  Created by capin on 4/14/15.
//
//

#import "ViewControllerIntro.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@interface ViewControllerIntro ()

@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) UILabel *kegCop;
@property(nonatomic, retain) UIButton *signInButton;
@property(nonatomic, retain) UIButton *registerButton;

@end

@implementation ViewControllerIntro

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // below is an ASCII art representation of the intro view
    
    /*
     
      ---------------
     |               |
     |               |
     |               |
     |               |
     |    KegCop     |
     |               |
     |               |
     |               |
     |               |
     | SIGNIN   REG  |
      ---------------
     
     */
    
    // Allocate a reachability object
    Reachability *reach = [Reachability reachabilityWithHostname:@"kegcop.chrisrjones.com"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
#ifdef DEBUG
            NSLog(@"reachable!");
#endif
            // create a webview that fills the bounds of the screen programmatically
            _webView = [[UIWebView alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ))];
            
            NSString *urlAddress = @"http://kegcop.chrisrjones.com/bubbles";
            
            // Create a URL object
            NSURL *kegcopURL = [NSURL URLWithString:urlAddress];
            
            // URL request object
            NSURLRequest *request = [NSURLRequest requestWithURL:kegcopURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
            
            [_webView loadRequest:request];
            
            [self.view addSubview:_webView];
            
            [self addUIElements];
            [self addConstraintsToUIElements];
        });
    };
    reach.unreachableBlock = ^(Reachability*reach)
    {
#ifdef DEBUG
        NSLog(@"unreachable!");
#endif
        self.view.backgroundColor = [UIColor colorWithRed:(245/255.0)
                                                    green:(208/255.0)
                                                     blue:(55/255)
                                                    alpha:(1.0f) ];
        [self addUIElements];
        [self addConstraintsToUIElements];
    };
    
    // start the notifier, which will cause the reachability object
    // to retain itself.
    [reach startNotifier];
}

- (void)addUIElements {
    
    _kegCop = [[UILabel alloc] init];
    _kegCop.text = @"KegCop";
    _kegCop.font = [UIFont fontWithName:@"Helvetica" size:50];
    
    [_kegCop setTextColor: [UIColor colorWithRed:(100/255.0)
                                          green:(83/255.0)
                                           blue:(0/255.0)
                                          alpha:(1.0f)]];
    
    // manually specify Auto Layout constraints in code
    [_kegCop setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // add UILabel, KegCop to view
    [self.view addSubview:_kegCop];
    
    _signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_signInButton addTarget:self
                     action:@selector(signIn)
           forControlEvents:UIControlEventTouchUpInside];
    [_signInButton setTitle:@"SIGN IN"  forState:UIControlStateNormal ];
    _signInButton.frame = CGRectMake(10, 500.0, 130.0, 60.0); // x, y, width, height
    
    [_signInButton setBackgroundColor: [UIColor colorWithRed:(221/255.0)
                                                      green:(183/255.0)
                                                       blue:(0/255.0)
                                                      alpha:(1.0f)]];
    
    [_signInButton setTitleColor:[UIColor colorWithRed:255/255.0
                                                green:239/255.0
                                                 blue:160/255.0
                                                alpha:1.0f] forState:UIControlStateNormal];
    
    // turn off AutoLayout for signInButton
    [_signInButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    // round corners of signInButton
    _signInButton.layer.cornerRadius = 5;
    [self.view addSubview:_signInButton];
    
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_registerButton addTarget:self
                       action:@selector(registerAccount)
             forControlEvents:UIControlEventTouchUpInside];
    [_registerButton setTitle:@"REGISTER"  forState:UIControlStateNormal ];
    _registerButton.frame = CGRectMake(160, 500.0, 140.0, 60.0);
    
    // change background color of register button
    [_registerButton setBackgroundColor: [UIColor colorWithRed:(100/255.0)
                                                        green:(83/255.0)
                                                         blue:(0/255.0)
                                                        alpha:(1.0f)]];
    
    [_registerButton setTitleColor:[UIColor colorWithRed:255/255.0
                                                  green:239/255.0
                                                   blue:160/255.0
                                                  alpha:1.0f] forState:UIControlStateNormal];
}

- (void)addConstraintsToUIElements {
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_kegCop
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual toItem:_kegCop.superview
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_kegCop
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual toItem:_kegCop.superview
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0];
    [_kegCop.superview addConstraints:@[centerX, centerY]];
    
    
    // add constraints, bottom / left for signInButton
    NSLayoutConstraint *pullToBottom = [NSLayoutConstraint constraintWithItem:_signInButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_signInButton.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0];
    
    NSLayoutConstraint *pullToRight = [NSLayoutConstraint constraintWithItem:_signInButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_signInButton.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
    
    [_signInButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_signInButton(==130)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_signInButton)]];
    
    [_signInButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_signInButton(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_signInButton)]];
    
    [_signInButton.superview addConstraints:@[pullToBottom, pullToRight]];
    
    
    // set Auto Layout constraints in code
    [_registerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    // round corners of registerButton
    _registerButton.layer.cornerRadius = 5;
    [self.view addSubview:_registerButton];
    // add constraints to button
    NSLayoutConstraint *pullRegToBottom = [NSLayoutConstraint constraintWithItem:_registerButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_registerButton.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0];
    
    NSLayoutConstraint *pullRegToRight = [NSLayoutConstraint constraintWithItem:_registerButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_registerButton.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15.0];
    
    [_registerButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_registerButton(==130)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_registerButton)]];
    
    [_registerButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_registerButton(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_registerButton)]];
    
    [_registerButton.superview addConstraints:@[pullRegToBottom, pullRegToRight]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signIn {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"Welcome"];
    welcomeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:welcomeVC animated:YES completion:nil];
    
}

- (void)registerAccount {
    
    // display a UIAlertView displaying legal disclaimer.
    UIAlertView *alertlegal = [[UIAlertView alloc] initWithTitle:@"Terms of Service" message:@"By clicking agree you abide to the terms of this application.\n\nThis iOS application is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the MIT License for more details.\n\nBy creating an account on this system you are NOT PAYING FOR BEER!  YOU ARE MAKING A DONATION TO THE PERSON WHO IS RESPONSIBLE FOR THE ADMIN / ROOT ACCOUNT ON THE SYSTEM  THE PERSON WHO GOVERNS THE ROOT ACCOUNT ON THE SYSTEM IS NOT RESPONSIBLE FOR YOUR DRINKING OR THE RESULTS FROM THE BEHAVIOR OF YOUR DRINKING.\n\nThat being said, PLEASE DRINK RESPONSIBLY, AND TRY TO HAVE SOME FUN." delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Agree", nil];
    
    [alertlegal show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    if (buttonIndex == 1) {
        
        // display ViewControllerCreate
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone"bundle:nil];
        UIViewController *createVC = [storyboard instantiateViewControllerWithIdentifier:@"Create"];
        createVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:createVC animated:YES completion:nil];
    }
}

# pragma mark - device orientation

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
#endif        
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.bounds;
}
@end
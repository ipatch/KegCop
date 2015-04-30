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
            
            // add UILabel w/ custom font for KegCop
            UILabel *kegCop = [[UILabel alloc] init];
//            UILabel *kegCop = [[UILabel alloc] initWithFrame:(CGRectMake(70, 120, 300, 300))];
            
            //    kegCop.textColor = [UIColor yellowColor];
            kegCop.text = @"KegCop";
            kegCop.font = [UIFont fontWithName:@"Helvetica" size:50];
            
            [kegCop setTextColor: [UIColor colorWithRed:(100/255.0)
                                                  green:(83/255.0)
                                                   blue:(0/255.0)
                                                  alpha:(1.0f)]];
            
            // center the kegCop Label
//            [kegCop setCenter:_webView.center];
//            kegCop.textAlignment = NSTextAlignmentCenter;
//            
            // manually specify Auto Layout constraints in code
            [kegCop setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            // add UILabel, KegCop to view
            [self.view addSubview:kegCop];
            
            
//            NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:kegCop attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:100];
            
NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:kegCop
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual toItem:kegCop.superview
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.0
                                                                           constant:0.0];

NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:kegCop
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                      relatedBy:NSLayoutRelationEqual toItem:kegCop.superview
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                     multiplier:1.0
                                                                                       constant:0.0];
            [kegCop.superview addConstraints:@[centerX, centerY]];
            
            UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [signInButton addTarget:self
                             action:@selector(signIn)
                   forControlEvents:UIControlEventTouchUpInside];
            [signInButton setTitle:@"SIGN IN"  forState:UIControlStateNormal ];
            signInButton.frame = CGRectMake(10, 500.0, 130.0, 60.0); // x, y, width, height
            
            [signInButton setBackgroundColor: [UIColor colorWithRed:(221/255.0)
                                                              green:(183/255.0)
                                                               blue:(0/255.0)
                                                              alpha:(1.0f)]];
            
            [signInButton setTitleColor:[UIColor colorWithRed:255/255.0
                                                        green:239/255.0
                                                         blue:160/255.0
                                                        alpha:1.0f] forState:UIControlStateNormal];
            
            // turn off AutoLayout for signInButton
            [signInButton setTranslatesAutoresizingMaskIntoConstraints:NO];
            // round corners of signInButton
            signInButton.layer.cornerRadius = 5;
            [self.view addSubview:signInButton];
            // add constraints, bottom / left for signInButton
            
            NSLayoutConstraint *pullToBottom = [NSLayoutConstraint constraintWithItem:signInButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:signInButton.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0];
            
            NSLayoutConstraint *pullToRight = [NSLayoutConstraint constraintWithItem:signInButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:signInButton.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
            
            [signInButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[signInButton(==130)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(signInButton)]];
            
            [signInButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[signInButton(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(signInButton)]];
            
            [signInButton.superview addConstraints:@[pullToBottom, pullToRight]];
//          [signInButton addConstraints:@[signInBtnWidth]];
            
            UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [registerButton addTarget:self
                               action:@selector(registerAccount)
                     forControlEvents:UIControlEventTouchUpInside];
            [registerButton setTitle:@"REGISTER"  forState:UIControlStateNormal ];
            registerButton.frame = CGRectMake(160, 500.0, 140.0, 60.0);
            
            // change background color of register button
            
            [registerButton setBackgroundColor: [UIColor colorWithRed:(100/255.0)
                                                                green:(83/255.0)
                                                                 blue:(0/255.0)
                                                                alpha:(1.0f)]];
            
            [registerButton setTitleColor:[UIColor colorWithRed:255/255.0
                                                          green:239/255.0
                                                           blue:160/255.0
                                                          alpha:1.0f] forState:UIControlStateNormal];
            
            
            // turn off AutoLayout for signInButton
            [registerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            // round corners of registerButton
            registerButton.layer.cornerRadius = 5;
            
            

//            [self.view addSubview:registerButton];
        
//            NSDictionary *elementsDict = NSDictionaryOfVariableBindings(signInButton, kegCop, registerButton);
            
//            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[kegCop]-[signInButton]-[registerButton]-|" options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                              metrics:nil
//                                                    views:elementsDict]];
//            
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[kegCop]-|" options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                             metrics:nil
//                                                                               views:elementsDict]];
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
        
        
        // add UILabel w/ custom font for KegCop
        UILabel *kegCop = [[UILabel alloc] initWithFrame:(CGRectMake(70, 120, 300, 300))];
        
        //    kegCop.textColor = [UIColor yellowColor];
        kegCop.text = @"KegCop";
        kegCop.font = [UIFont fontWithName:@"Helvetica" size:50];
        
        [kegCop setTextColor: [UIColor colorWithRed:(100/255.0)
                                              green:(83/255.0)
                                               blue:(0/255.0)
                                              alpha:(1.0f)]];
        
        UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [signInButton addTarget:self
                         action:@selector(signIn)
               forControlEvents:UIControlEventTouchUpInside];
        [signInButton setTitle:@"SIGN IN"  forState:UIControlStateNormal ];
        signInButton.frame = CGRectMake(10, 500.0, 130.0, 60.0); // x, y, width, height
        
        [signInButton setBackgroundColor: [UIColor colorWithRed:(221/255.0)
                                                          green:(183/255.0)
                                                           blue:(0/255.0)
                                                          alpha:(1.0f)]];
        
        [signInButton setTitleColor:[UIColor colorWithRed:255/255.0
                                                    green:239/255.0
                                                     blue:160/255.0
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
        [registerButton setBackgroundColor: [UIColor colorWithRed:(100/255.0)
                                                            green:(83/255.0)
                                                             blue:(0/255.0)
                                                            alpha:(1.0f)]];
        
        [registerButton setTitleColor:[UIColor colorWithRed:255/255.0
                                                      green:239/255.0
                                                       blue:160/255.0
                                                      alpha:1.0f] forState:UIControlStateNormal];
        
        // round corners of registerButton
        registerButton.layer.cornerRadius = 5;
        
        
        [self.view addSubview:signInButton];
        [self.view addSubview:registerButton];
        [self.view addSubview:kegCop];
    };
    
    // start the notifier, which will cause the reachability object
    // to retain itself.
    [reach startNotifier];
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
    UIAlertView *alertlegal = [[UIAlertView alloc] initWithTitle:@"Terms of Service" message:@"By clicking agree you abide to the terms of this application.\n\nThis iOS application is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the MIT License for more details.\n\nBy creating an account on this system you are NOT PAYING FOR BEER!  YOU ARE MAKING A DONATION TO THE PERSON WHO IS RESPONSIBLE FOR THE ADMIN / ROOT ACCOUNT ON THE SYSTEM  THE PERSON WHO GOVERNS THE ROOT ACCOUNT ON THE SYSTEM IS NOT RESPONSIBLE FOR YOUR DRIINKING OR THE RESULTS FROM THE BEHAVIOR OF YOUR DRINKING.\n\nThat being said, PLEASE DRINK RESPONSIBLY, AND TRY TO HAVE SOME FUN." delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Agree", nil];
    
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
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.bounds;
}
@end
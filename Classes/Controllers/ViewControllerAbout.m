//
//  ViewControllerAbout.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerAbout.h"

@interface ViewControllerAbout () {
    
}
// add properties below this line
@property (nonatomic, retain) UINavigationBar *navBar;

@property (nonatomic, retain) UILabel *buildnumber;
@property (nonatomic, retain) UILabel *createdaccounts;

@property (nonatomic, retain) UIButton *demoVideo;
@property (nonatomic, retain) UIButton *issueButton;


@end

@implementation ViewControllerAbout {
    
}
-(void)addUIElements {
    _navBar = [[UINavigationBar alloc] init];
    [_navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),60)];
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"KegCop - About"];
    _navBar.barTintColor = [UIColor colorWithRed:100.0f/255.0f
                                          green:83.0f/255.0f
                                           blue:0.0f/255.0f
                                          alpha:1.0f];
    _navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:255.0f/255.0f
                                                                                   green:239.0f/255.0f
                                                                                    blue:160.0f/255.0f
                                                                                   alpha:1.0f]};
    _navBar.translucent = NO;
    
    // add navbar btn
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAboutScene:)];
    // add doneBtn / item to navBar
    titleItem.rightBarButtonItem = doneBtn;
    
    _navBar.items = @[titleItem];
    
    [self.view addSubview:_navBar];
    
    // add logic to present UIButton that loads / displays a youtube video
    _demoVideo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // set button title
    [_demoVideo setTitle:@"Watch Demo Video" forState:UIControlStateNormal];
    // change color of demoVideo button text to blue
    [_demoVideo setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    // draw / render button to screen
//    _demoVideo.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    // add action to button
    [_demoVideo addTarget:self action:@selector(loadDemoVideo)
        forControlEvents:UIControlEventTouchUpInside];
    [_demoVideo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_demoVideo];
    
    _issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_issueButton setTitle:@"Report Issue" forState:UIControlStateNormal];
    [_issueButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    _issueButton.frame = CGRectMake(80, 300, 160.0, 40.0);
    [_issueButton addTarget:self action:@selector(submitIssue) forControlEvents:UIControlEventTouchUpInside];
    // add button(s) to view
    [_issueButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_issueButton];
    
    // _buildNumber setup
    _buildnumber = [[UILabel alloc] init];
    // set version and build numbers
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    _buildnumber.text = [NSString stringWithFormat:@"Version %@ Build %@", version, build];
    [_buildnumber setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_buildnumber];
    
    // display created user accounts
    _createdaccounts = [[UILabel alloc] init];
    _createdaccounts.text = [NSString stringWithFormat:@"X accounts have been created."];
    [_createdaccounts setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_createdaccounts];
}
-(void)addUIElementConstraints {
    
    // add constraint to _buildNumber
    NSLayoutConstraint *pullBuildNumberToTop = [NSLayoutConstraint constraintWithItem:_buildnumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_buildnumber.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:80.0];
    
    // center _buildNumber horizontaly in view
    NSLayoutConstraint *centerXBuildNumber = [NSLayoutConstraint constraintWithItem:_buildnumber                                                 attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_buildnumber.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    // add constraints
    [_buildnumber.superview addConstraints:@[pullBuildNumberToTop, centerXBuildNumber]];
    
    NSLayoutConstraint *pullCreatedAccountsToTop = [NSLayoutConstraint constraintWithItem:_createdaccounts attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_createdaccounts.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:120.0];
    
    NSLayoutConstraint *centerXCreatedAccounts = [NSLayoutConstraint constraintWithItem:_createdaccounts                                                 attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createdaccounts.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];

    
    [_createdaccounts.superview addConstraints:@[pullCreatedAccountsToTop, centerXCreatedAccounts]];
    
    // center demo btn horizontally
    NSLayoutConstraint *centerXdemoBtn = [NSLayoutConstraint constraintWithItem:_demoVideo                                                 attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_demoVideo.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *pulldemoToTop = [NSLayoutConstraint constraintWithItem:_demoVideo attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_demoVideo.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:160.0];
    
    [_demoVideo.superview addConstraints:@[centerXdemoBtn, pulldemoToTop]];
    
    // center issue btn horizontally
    NSLayoutConstraint *centerXissueBtn = [NSLayoutConstraint constraintWithItem:_issueButton                                                 attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_issueButton.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *pullIssueButtonToTop = [NSLayoutConstraint constraintWithItem:_issueButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_issueButton.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:200.0];
    
    [_issueButton.superview addConstraints:@[centerXissueBtn, pullIssueButtonToTop]];

}

#pragma mark - View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUIElements];
    [self addUIElementConstraints];
    
    _context = [[AccountsDataModel sharedDataModel]mainContext];
#ifdef DEBUG
    NSLog(@"context is %@",_context);
#endif
}

- (void)loadDemoVideo {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=1a6hxUb3zfU"]];
}

- (void)submitIssue {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/ipatch/KegCop/issues"]];
}

- (int)countUsernames {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesSubentities:NO];
    [request setEntity:[NSEntityDescription entityForName:@"Account" inManagedObjectContext:_context]];
    
    NSError *err;
    NSUInteger count = [_context countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        //Handle error
    }
    return count;
}

- (IBAction)dismissAboutScene:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
# pragma mark - device orientation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
@end
//
//  ViewControllerAbout.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerAbout.h"

@interface ViewControllerAbout () {
    
}
@end

@implementation ViewControllerAbout {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create navbar
    UINavigationBar *navBar;
    
    navBar = [[UINavigationBar alloc] init];
    [navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),60)];
    
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"KegCop - About"];
    
    navBar.barTintColor = [UIColor blackColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    navBar.translucent = YES;
    
    // add navbar btn
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAboutScene:)];
    // add doneBtn / item to navBar
    titleItem.rightBarButtonItem = doneBtn;
    
    navBar.items = @[titleItem];
    
    [self.view addSubview:navBar];
    

    _context = [[AccountsDataModel sharedDataModel]mainContext];
    NSLog(@"context is %@",_context);
    
    // set version and build numbers
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version should = %@",version);

    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                         
    _buildnumber.text = [NSString stringWithFormat:@"Version %@ Build %@", version, build];
    
    // display created user accounts
    _createdaccounts.text = [NSString stringWithFormat:@"%d accounts have been created.", [self countUsernames]];
    
    
    // add logic to present UIButton that loads / displays a youtube video
    UIButton *demoVideo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // set button title
    [demoVideo setTitle:@"Watch Demo Video" forState:UIControlStateNormal];
    // change color of demoVideo button text to blue
    [demoVideo setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    // draw / render button to screen
    demoVideo.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
     // add action to button
    [demoVideo addTarget:self action:@selector(loadDemoVideo)
forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [issueButton setTitle:@"Report Issue" forState:UIControlStateNormal];
    [issueButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    issueButton.frame = CGRectMake(80, 300, 160.0, 40.0);
    [issueButton addTarget:self action:@selector(submitIssue) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // add button(s) to view
    [self.view addSubview:demoVideo];
    [self.view addSubview:issueButton];
    
}

- (void)loadDemoVideo {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=1a6hxUb3zfU"]];
}

- (void)submitIssue {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/ipatch/KegCop/issues"]];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {  
    return YES; 
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
@end
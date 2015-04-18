//
//  ViewControllerForgot.m
//  KegCop
//
//  Created by capin on 6/12/12.
//

#import "ViewControllerForgot.h"

@interface ViewControllerForgot ()
@end

@implementation ViewControllerForgot

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // present UINavigationBar
    // navBar
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    [navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),60)];
    
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"Forgot Username / Pin"];
    
    navBar.items = @[titleItem];
    
    navBar.barTintColor = [UIColor colorWithRed:100.0f/255.0f
                                          green:83.0f/255.0f
                                           blue:0.0f/255.0f
                                          alpha:1.0f];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:255.0f/255.0f
                                                                                   green:239.0f/255.0f
                                                                                    blue:160.0f/255.0f
                                                                                   alpha:1.0f]};
    navBar.translucent = NO;
    
    [self.view addSubview:navBar];
    // end navBar

    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissKeyboard:(id)sender {

}

- (IBAction)dismissScene:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

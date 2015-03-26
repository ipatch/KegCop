//
//  ViewControllerRootHomeCenter.m
//  KegCop
//
//  Created by capin on 11/19/14.
//
//

#import "ViewControllerRootHomeCenter.h"


@interface ViewControllerRootHomeCenter ()

@end

@implementation ViewControllerRootHomeCenter {
    
}

#pragma mark - View Did Load/Unload

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // navBar crap
    _navBar = [[UINavigationBar alloc] init];
    [_navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),80)];
    
    _hamMenu = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"hamburger-menu-42x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(btnMovePanelRight:)];
    
    // set hamMenu tag to == 1
    _hamMenu.tag = 1;
    
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"KegCop - Admin"];
    
    navItem.hidesBackButton = YES;
    navItem.leftBarButtonItem = _hamMenu;
    
    [_navBar setBarTintColor:[UIColor blackColor]];
    [_navBar setTranslucent:YES];
    
    _navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    _navBar.items = @[navItem];
    
    [self.view addSubview:_navBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Button Actions

-(IBAction)btnMovePanelRight:(id)sender {
    
    NSLog(@"inside btMovePanelRight method");
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            NSLog(@"the button tag = %ld",(long)button.tag);
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            NSLog(@"the button tag = %ld",(long)button.tag);
            NSLog(@"inside btnMovePanelRight method case 1");
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

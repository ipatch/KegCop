//
//  ViewControllerRootHomeCenter.m
//  KegCop
//
//  Created by capin on 11/19/14.
//
//

#import "ViewControllerRootHomeCenter.h"
#import "ViewControllerCalibrate.h"

@interface ViewControllerRootHomeCenter ()

@end

@implementation ViewControllerRootHomeCenter {
    
}

#pragma mark - View Did Load/Unload

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // navBar crap
    _navBar = [[UINavigationBar alloc] init];
    _navBar.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen]bounds]), 64);

#ifdef DEBUG
    NSLog(@"frame width = %f",self.view.frame.size.width);
#endif
    
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
    
    _viewRootHomeCenter.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [_viewRootHomeCenter addSubview:_navBar];

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
#pragma mark - Remove subviews i.e. Calibration
- (void)removeSubViews{
    for (UIView *subview in [self.view subviews]){
        NSLog(@"subviews = %@",[self.view subviews]);
        if (subview.tag == 3) {
            
            [self removeCalibrateView];
            [subview removeFromSuperview];
            
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - Button Actions

-(IBAction)btnMovePanelRight:(id)sender {

    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
#ifdef DEBUG
            NSLog(@"the button tag = %ld",(long)button.tag);
#endif
            [_delegate movePanelToOriginalPosition];
            
            break;
        }
            
        case 1: {
#ifdef DEBUG
            NSLog(@"the button tag = %ld",(long)button.tag);
            NSLog(@"inside btnMovePanelRight method case 1");
            
            // remove any views / vc's loaded in the current vc
            [self removeSubViews];
#endif
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
# pragma mark - device orientation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
@end
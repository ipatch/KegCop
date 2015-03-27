//
//  ViewControllerWebService.m
//  KegCop
//
//  Created by capin on 3/27/15.
//
//

#import "ViewControllerWebService.h"

@interface ViewControllerWebService () {
    
}

@end

@implementation ViewControllerWebService {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"inside viewDidLoad of webServiceVC");
//    NSLog(@"self.view = %@",self.view);
    
    // create uibutton
    UIButton *createWebServiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [createWebServiceButton addTarget:self
                               action:@selector(establishWebService)
                     forControlEvents:UIControlEventTouchUpInside];
    [createWebServiceButton setTitle:@"Create Web Service"  forState:UIControlStateNormal ];
    createWebServiceButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:createWebServiceButton];
    
    
    // create navbar
    UINavigationBar *navBar;
    
    navBar = [[UINavigationBar alloc] init];
    [navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),60)];
    
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"Create Web Service"];
    
    
    
    navBar.barTintColor = [UIColor blackColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    navBar.translucent = YES;
    
    // add navbar btn
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissWebServiceVC)];
    // add doneBtn / item to navBar
    titleItem.rightBarButtonItem = doneBtn;
    
    navBar.items = @[titleItem];
    
    [self.view addSubview:navBar];
}

- (void)establishWebService {
    NSLog(@"Create Web Service btn pressed");
}

- (void)dismissWebServiceVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
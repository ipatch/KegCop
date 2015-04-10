//
//  ViewControllerWebService.m
//  KegCop
//
//  Created by capin on 3/27/15.
//
//

#import "ViewControllerWebService.h"
#import <RestKit/RestKit.h>

@interface ViewControllerWebService () {
    
}

@end

@implementation ViewControllerWebService {

    UIAlertView *alertview;
    NSString *uniqueName;
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
    [createWebServiceButton setTitle:@"Connect"  forState:UIControlStateNormal ];
    createWebServiceButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:createWebServiceButton];
    
    
    // create navbar
    UINavigationBar *navBar;
    
    navBar = [[UINavigationBar alloc] init];
    [navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),60)];
    
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"Connect to Web Service"];
    
    // figure out new line terminator
    
    
    
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
    
    // create a UIAlertBox with a textfield
    alertview = [[UIAlertView alloc] initWithTitle:@"Enter a unique name" message:@"Your unique name will be the name of your kegerator." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    
    [alertview setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    // display alertview
    // keep this line at the bottom
    [alertview show];
    
    
    
}

- (void)meetAndPotatoes {
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"UUID = %@",idfv);
    
    // establish connection with remote API
    
    AFHTTPRequestOperation *manager = [AFHTTPRequestOperation manager];
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@"alertView dismissed");
    }
    if (buttonIndex == 1) {
        // get "name" inputted in alertview
        uniqueName = [[NSString alloc] initWithString:[alertview textFieldAtIndex:0].text];
        NSLog(@"Your unique name is: %@",uniqueName);
        [self meetAndPotatoes];
    }
}


- (void)dismissWebServiceVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
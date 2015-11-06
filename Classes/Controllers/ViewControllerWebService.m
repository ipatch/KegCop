//
//  ViewControllerWebService.m
//  KegCop
//
//  Created by capin on 3/27/15.
//
//

#import "ViewControllerWebService.h"
#import <RestKit/RestKit.h>


@interface ViewControllerWebService () { }

@end

@implementation ViewControllerWebService {

    UIAlertView *alertview;
    NSString *uniqueName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef DEBUG
    NSLog(@"inside viewDidLoad of webServiceVC");
#endif
    
    // establish delegate in calling method that launches vc
    
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
#ifdef DEBUG
    NSLog(@"Create Web Service btn pressed");
#endif
    
    // create a UIAlertBox with a textfield
    alertview = [[UIAlertView alloc] initWithTitle:@"Enter a unique name" message:@"Your unique name will be the name of your kegerator." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    
    [alertview setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    // display alertview
    // keep this line at the bottom
    [alertview show];
}

- (void)meatAndPotatoes {
//    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//#ifdef DEBUG
//    NSLog(@"UUID = %@",idfv);
//#endif
    
    // establish connection with remote API
#ifdef DEBUG
    NSLog(@"I am your RKClient singleton : %@", [RKObjectManager sharedManager]);
#endif
    
    
    // get deviceToken
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueTokenString"];
#ifdef DEBUG
    NSLog(@"tokenString = %@",tokenString);
#endif
    // get length of tokenString
//    NSUInteger tokenStringLen = [tokenString length];
//#ifdef DEBUG
//    NSLog(@"tokenStringLen = %d",tokenStringLen);
//#endif
    
    // get length of string in standard int
    NSString *tokenLen = [NSString stringWithFormat:@"%d",[tokenString length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"kegcop.chrisrjones.com/api/register"]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:tokenLen forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:tokenString forHTTPHeaderField:@"token"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
#ifdef DEBUG
        NSLog(@"Connection Successful");
#endif
    } else {
#ifdef DEBUG
        NSLog(@"Connection could not be made");
#endif
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
#ifdef DEBUG
        NSLog(@"alertView dismissed");
#endif
    }
    if (buttonIndex == 1) {
        // get "name" inputted in alertview
        uniqueName = [[NSString alloc] initWithString:[alertview textFieldAtIndex:0].text];
#ifdef DEBUG
        NSLog(@"Your unique name is: %@",uniqueName);
#endif
        [self meatAndPotatoes];
    }
}


- (void)dismissWebServiceVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
@end
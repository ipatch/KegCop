//
//  ViewControllerCalibrate.m
//  KegCop
//
//  Created by capin on 4/27/15.
//
//

#import "ViewControllerCalibrate.h"

@interface ViewControllerCalibrate ()

@end

@implementation ViewControllerCalibrate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // navBar
//    UINavigationBar *navBar = [[UINavigationBar alloc] init];
//    [navBar setFrame:CGRectMake(0,0,CGRectGetWidth([[UIScreen mainScreen]bounds]),60)];
//    
//    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"Calibrate"];
//    
//    navBar.items = @[titleItem];
//    
//    navBar.barTintColor = [UIColor colorWithRed:100.0f/255.0f
//                                          green:83.0f/255.0f
//                                           blue:0.0f/255.0f
//                                          alpha:1.0f];
//    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:255.0f/255.0f
//                                                                                   green:239.0f/255.0f
//                                                                                    blue:160.0f/255.0f
//                                                                                   alpha:1.0f]};
//    navBar.translucent = NO;
//    
//    [self.view addSubview:navBar];
    // END navBar
    
    // add navbar btn
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissCalibrateVC)];
//    // add doneBtn / item to navBar
//    titleItem.rightBarButtonItem = doneBtn;
//    
//    navBar.items = @[titleItem];


    
    
    // create slider programmatically
    
    CGRect sliderFrame = CGRectMake(10.0f, 10.0f, 250.0f, 400.0f);
    
    UISlider *sliderCalibrate = [[UISlider alloc] initWithFrame:sliderFrame];
    
    sliderCalibrate.minimumValue = 1.0f;
    
    sliderCalibrate.maximumValue = 100.0f;
    
    sliderCalibrate.value = 50.0f;
    
    // add slider to view
    [self.view addSubview:sliderCalibrate];
}

- (void)dismissCalibrateVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

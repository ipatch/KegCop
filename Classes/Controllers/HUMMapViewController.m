//
//  HUMMapViewController.m
//  KegCop
//
//  Created by capin on 11/5/14.
//
//

#import "HUMMapViewController.h"
#import "HUMAddEventViewController.h"

@interface HUMMapViewController () <MKMapViewDelegate>


@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIButton *addButton;

@end

@implementation HUMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    // create a frame and label for the "add" button
    CGRect buttonFrame = CGRectMake(0,
                                    self.view.bounds.size.height -2*44,
                                    self.view.bounds.size.width,44);
    
    NSString *buttonText = NSLocalizedString(@"Add Event", nil);
    
    // create and add the "add" button as a subview
    self.addButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.addButton.backgroundColor = [UIColor grayColor];
    self.addButton.alpha = 0.8;
    [self.addButton setTitle:buttonText forState:UIControlStateNormal];
    [self.addButton addTarget:self
                       action:@selector(addButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:self.addButton];
    
}

- (void)addButtonPressed
{
    NSLog(@"You pressed the add button!");
    HUMAddEventViewController *addEventViewController = [[HUMAddEventViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addEventViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
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
//
//  ViewControllerCalibrate.m
//  KegCop
//
//  Created by capin on 4/27/15.
//
//

#import "ViewControllerCalibrate.h"

@interface ViewControllerCalibrate ()

@property (nonatomic, retain) UISlider *sliderCalibrate;
@property (nonatomic) CGRect sliderFrame;
@property (nonatomic, retain) UILabel *currentReading;

@end

@implementation ViewControllerCalibrate

- (void)viewDidLoad {
    [super viewDidLoad];
    // view tag is necessary for disposing VC from left panel using ham menu
    self.view.tag = 3;
    
    [self addUIElements];
    [self addConstraintsToUIElements];
    
    // get the current numTicks reading when the VC is loaded
    [self getCurrentNumTicks];
}

-(void)addUIElements {
    // create slider programmatically
    _sliderFrame = CGRectMake(10.0f, 10.0f, 250.0f, 400.0f);
    _sliderCalibrate = [[UISlider alloc] initWithFrame:_sliderFrame];
    _sliderCalibrate.minimumValue = 1.0f;
    _sliderCalibrate.maximumValue = 100.0f;
    _sliderCalibrate.value = 50.0f;
    // add method for listening to movement of UISlider
    [_sliderCalibrate addTarget:self action:@selector(calibrateNumTicks) forControlEvents:UIControlEventValueChanged];
    // manually specify Auto Layout constraints in code
    [_sliderCalibrate setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // add slider to view
    [self.view addSubview:_sliderCalibrate];
    
    // programmatically create a UILabel
    _currentReading = [[UILabel alloc] init];
    _currentReading.text = @"Current fluid oz: ";
    [_currentReading setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:_currentReading];
}

- (void)addConstraintsToUIElements {
    NSLayoutConstraint *centerSliderX = [NSLayoutConstraint constraintWithItem:_sliderCalibrate
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual toItem:_sliderCalibrate.superview
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *centerSliderY = [NSLayoutConstraint constraintWithItem:_sliderCalibrate
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual toItem:_sliderCalibrate.superview
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0];
    [_sliderCalibrate.superview addConstraints:@[centerSliderX, centerSliderY]];
    
    [_sliderCalibrate addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sliderCalibrate(==300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sliderCalibrate)]];
    
    // programmatically add constraints for UILabel, currentReading
    // add constraints, bottom / left for signInButton
    NSLayoutConstraint *pullToTop = [NSLayoutConstraint constraintWithItem:_currentReading attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_currentReading.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:15.0];
    
    NSLayoutConstraint *pullToRight = [NSLayoutConstraint constraintWithItem:_currentReading attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_currentReading.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
    
    [_currentReading.superview addConstraints:@[pullToTop, pullToRight]];
}

# pragma mark - Calibration
- (void)calibrateNumTicks {
    // method to hopefully set the numTicks value on the microcontroller
}

- (void)getCurrentNumTicks {
    // method to read the current numTicks value from the Bluno / microcontroller
    
}
# pragma mark - Remove Calibrate View
- (void)removeCalibrateView {
    NSLog(@"dismissCalibrateVC method called");
//    [self dismissViewControllerAnimated:YES completion:nil];
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
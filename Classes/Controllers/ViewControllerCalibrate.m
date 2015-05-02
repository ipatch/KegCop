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

@end

@implementation ViewControllerCalibrate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tag = 3;
    
    [self addUIElements];
    [self addConstraintsToUIElements];
}

-(void)addUIElements {
    // create slider programmatically
    
    _sliderFrame = CGRectMake(10.0f, 10.0f, 250.0f, 400.0f);
    
    _sliderCalibrate = [[UISlider alloc] initWithFrame:_sliderFrame];
    
    _sliderCalibrate.minimumValue = 1.0f;
    
    _sliderCalibrate.maximumValue = 100.0f;
    
    _sliderCalibrate.value = 50.0f;
    
    // manually specify Auto Layout constraints in code
    [_sliderCalibrate setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // add slider to view
    [self.view addSubview:_sliderCalibrate];
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
    
}

- (void)dismissCalibrateVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark - device orientation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}
@end
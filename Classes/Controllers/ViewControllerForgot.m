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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

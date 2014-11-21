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

@implementation ViewControllerRootHomeCenter

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



#pragma mark -
#pragma mark Button Actions

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

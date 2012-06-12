//
//  ViewControllerAbout.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerAbout.h"

@interface ViewControllerAbout ()

@end

@implementation ViewControllerAbout

@synthesize buildnumber = _buildnumber;



- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version should = %@",version);

    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    
    
                         
    _buildnumber.text = [NSString stringWithFormat:@"Version %@ Build %@", version, build];
    
    
}

- (void)viewDidUnload {

    [self setBuildnumber:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {  
    return YES; 
}


@end

//
//  ViewControllerAbout.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerAbout.h"
#import "AccountsDataModel.h"

@interface ViewControllerAbout ()

@end

@implementation ViewControllerAbout

@synthesize buildnumber = _buildnumber;
@synthesize createdaccounts = _createdaccounts;
@synthesize managedObjectContext = _context;



- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Core Data
    if (_context == nil)
    {
//        _context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@", _context);
    }
    
    // set version and build numbers
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version should = %@",version);

    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                         
    _buildnumber.text = [NSString stringWithFormat:@"Version %@ Build %@", version, build];
    
    // display created user accounts
    _createdaccounts.text = [NSString stringWithFormat:@"%d accounts have been created.", [self countUsernames]];
    
}

- (void)viewDidUnload {

    [self setBuildnumber:nil];
    [self setCreatedaccounts:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {  
    return YES; 
}

- (int)countUsernames {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesSubentities:NO];
    [request setEntity:[NSEntityDescription entityForName:@"Account" inManagedObjectContext:_context]];
    
    NSError *err;
    NSUInteger count = [_context countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        //Handle error
    }
    return count;     
}


- (IBAction)dismissAboutScene:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

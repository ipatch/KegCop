//
//  ViewControllerUsers.m
//  KegCop
//
//  Created by capin on 6/25/13.
//
//

#import "ViewControllerUsers.h"

@interface ViewControllerUsers ()

@end

@implementation ViewControllerUsers

@synthesize uiPickerViewUsers = _uiPickerViewUsers;

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
    
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *dirContents = [fileMgr contentsOfDirectoryAtPath:root error:nil];
//    NSPredicate *userNames = [NSPredicate predicateWithFormat:]
//    
//    // CORE DATA
//    // setup up the fetch request
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    
//    // define our table / entity to use
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
//    [request setEntity:entity];
//    
//    // define how records are sorted
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:NO];
//    
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    
//    [request setSortDescriptors:sortDescriptors];
//    
//    // Fetch the records and handle an error
//    NSError *error;
//    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:& error] mutableCopy];
//    
//    if (!mutableFetchResults) {
//        // handle error.
//        // should advise user to restart
//    }
//    
//    NSMutableString *string = [NSMutableString string];
//    for ( Account *anAccount in mutableFetchResults) {
//        [string appendString:[NSString stringWithFormat:@"%@\n",anAccount.username]];
//    }
[self.uiPickerViewUsers selectRow:1 inComponent:0 animated:NO];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnDone:nil];
    [self setUiPickerViewUsers:nil];
    [self setBtnChangePin:nil];
    [super viewDidUnload];
}
- (IBAction)dismissScene:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)changePin:(id)sender {
}
@end

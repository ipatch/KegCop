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

// Core Data
@synthesize managedObjectContext = _managedObjectContext;

@synthesize uiPickerViewUsers = _uiPickerViewUsers;

@synthesize usernames = _usernames;

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
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    request.resultType = NSDictionaryResultType;
    request.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"username"]];
    request.returnsDistinctResults = YES;

    _usernames = [_managedObjectContext executeFetchRequest:request error:nil];
   
    NSLog (@"names: %@",_usernames);
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // set number of rows
    return _usernames.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // set item per row
    // changed statment below per this SO thread,
    // http://stackoverflow.com/questions/17331293/populate-uipicker-view-with-results-from-core-data-db-using-an-nsarray
    return _usernames[row][@"username"];
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

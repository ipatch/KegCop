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

//-(NSInteger)selectedRowInComponent:(NSInteger)component
//{
//    NSLog(@"%d",[_uiPickerViewUsers selectedRowInComponent:0]);
//}

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
    
    // get currently selected username in pickerview and store it as a NSString variable
    NSInteger row;
    
    row = [_uiPickerViewUsers selectedRowInComponent:0];
    NSString *strSelectedUN = _usernames[row][@"username"];
    NSLog(@"The currently selected row is %@",strSelectedUN);
    
    // create a compound string for title
    NSString *title = [NSString stringWithFormat:@"Change pin for %@",strSelectedUN];
    
    // display a UIAlertBox with a textfield (change tf to just have numbers)
    alertview = [[UIAlertView alloc] initWithTitle:title message:@"Input new pin" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    
    [alertview setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    
    // set the delegate for the UIAlertView textfield
    //[alertview textFieldAtIndex:0].delegate = self;
    [[alertview textFieldAtIndex:0] setPlaceholder:@"New pin"];
    [[alertview textFieldAtIndex:1] setPlaceholder:@"Confirm new pin"];
    [[alertview textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alertview textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alertview textFieldAtIndex:0] setSecureTextEntry:YES];
    
    // keep this line at the bottom
    [alertview show];
    
    
}

- (void)saveNewPin{
    
    // get selected username from uiPickerView
    NSInteger row;
    
    row = [_uiPickerViewUsers selectedRowInComponent:0];
    NSString *strSelectedUN = _usernames[row][@"username"];
    NSLog(@"The selected username is %@",strSelectedUN);
    
    // get text from textfield's in UIAlertView, compare them, then store them in DB.
    NSString *pin = [alertview textFieldAtIndex:0].text;
    NSString *repin = [alertview textFieldAtIndex:1].text;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex ==0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    if (buttonIndex == 1) {
        
        NSLog(@"btn 1 tapped");
        
        [self saveNewPin];
    }
}
@end

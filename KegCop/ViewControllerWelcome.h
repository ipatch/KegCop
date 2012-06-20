//
//  ViewControllerWelcome.h
//  KegCop
//
//  Created by capin on 6/3/12.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Account.h"
#import "CoreDataHelper.h"

@interface ViewControllerWelcome : UIViewController {
    
    
    // toolbar
    IBOutlet UIToolbar *toolBar;
    NSArray *fieldsArray;
    IBOutlet UIBarButtonItem *barButton;

  
    

}

// Notes
//
// nonatomic means setter & getter are not thread safe
// not a problem, because all UI code happens on main thread of
// application.

// "strong" - memory for object will stay around as long as needed.

// All objects are always accessed via the heap. ALWAYS
// that's why a pointer is used.
//
//
//
//
// End Notes

// Welcome screen
@property (weak, nonatomic) IBOutlet UIScrollView *welcomeScroller;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPin;
@property (weak, nonatomic) IBOutlet UILabel *wrongUserPin;
@property (weak, nonatomic) IBOutlet UIButton *welcomeLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *welcomeActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *welcomeAbout;





// end Welcome

// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;



- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;

- (IBAction)processLogin:(id)sender;

- (IBAction) next;
- (IBAction) previous;


@end

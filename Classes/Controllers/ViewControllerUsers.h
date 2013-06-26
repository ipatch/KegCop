//
//  ViewControllerUsers.h
//  KegCop
//
//  Created by capin on 6/25/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewControllerUsers : UIViewController <NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{

NSArray *dictionaries;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSArray *users;

@property (strong, nonatomic) IBOutlet UIPickerView *uiPickerViewUsers;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

@property (weak, nonatomic) IBOutlet UIButton *btnChangePin;

// added for testing purposes
@property (nonatomic, strong) NSArray *usernames;

- (IBAction)dismissScene:(id)sender;

- (IBAction)changePin:(id)sender;

@end

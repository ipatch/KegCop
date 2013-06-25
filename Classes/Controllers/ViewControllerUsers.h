//
//  ViewControllerUsers.h
//  KegCop
//
//  Created by capin on 6/25/13.
//
//

#import <UIKit/UIKit.h>

@interface ViewControllerUsers : UIViewController <NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *users;

@property (strong, nonatomic) IBOutlet UIPickerView *uiPickerViewUsers;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

@property (weak, nonatomic) IBOutlet UIButton *btnChangePin;

- (IBAction)dismissScene:(id)sender;

- (IBAction)changePin:(id)sender;

@end

//
//  ViewControllerAbout.h
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "AppDelegate.h"
#import "AccountsDataModel.h"

@interface ViewControllerAbout : UIViewController 
{

}

@property (weak, nonatomic) IBOutlet UILabel *buildnumber;
@property (weak, nonatomic) IBOutlet UILabel *createdaccounts;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)dismissAboutScene:(id)sender;
@end



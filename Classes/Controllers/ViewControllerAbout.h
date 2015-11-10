//
//  ViewControllerAbout.h
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "AccountsDataModel.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "SSKeychain.h"
#import "CHCSVParser.h"
#import "Account.h"

@interface ViewControllerAbout : UIViewController  <CHCSVParserDelegate>
{
    NSMutableArray * usersArray;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)dismissAboutScene:(id)sender;
@end



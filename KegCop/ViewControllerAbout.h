//
//  ViewControllerAbout.h
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewControllerAbout : UIViewController 
{

}

@property (weak, nonatomic) IBOutlet UILabel *buildnumber;
@property (weak, nonatomic) IBOutlet UILabel *createdaccounts;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end



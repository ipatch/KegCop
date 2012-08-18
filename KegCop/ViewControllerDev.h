//
//  ViewControllerDev.h
//  KegCop
//
//  Created by capin on 8/13/12.
//

#import <UIKit/UIKit.h>


@interface ViewControllerDev : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *lbl;

- (IBAction)submit:(id)sender;

@end

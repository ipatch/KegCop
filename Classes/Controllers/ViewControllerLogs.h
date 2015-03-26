//
//  ViewControllerLogs.h
//  KegCop
//
//  Created by capin on 7/28/12.
//

@interface ViewControllerLogs : UIViewController {
    BOOL firstOpen;
}

@property (weak, nonatomic) IBOutlet UIToolbar *btnDone;
@property (weak, nonatomic) IBOutlet UITextView *logWindow;


- (IBAction)btnPressed:(id)sender;
- (void)setWindowScrollToVisible;

@end

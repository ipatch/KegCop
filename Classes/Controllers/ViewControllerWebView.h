//
//  ViewControllerWebView.h
//  KegCop
//
//  Created by capin on 6/30/12.
//

#import "ViewControllerHome.h"

@interface ViewControllerWebView : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

- (IBAction)dimissWebView:(id)sender;

@end

//
//  ViewControllerRootHomeCenter.h
//
//
//
//
//

#import "ViewControllerRootHomeLeftPanel.h"

@protocol ViewControllerRootHomeCenterDelegate;
@protocol ViewControllerRootHomeCenterDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
@end

IB_DESIGNABLE

@interface ViewControllerRootHomeCenter : UIViewController <ViewControllerRootHomeCenterDelegate> {
}

@property (nonatomic, weak) id<ViewControllerRootHomeCenterDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *viewRootHomeCenter;

@property (nonatomic, strong) IBInspectable UIButton *leftButton;
@property (nonatomic, strong) IBInspectable UINavigationBar *navBar;
@property (nonatomic, strong) IBInspectable UIBarButtonItem *hamMenu;
@end
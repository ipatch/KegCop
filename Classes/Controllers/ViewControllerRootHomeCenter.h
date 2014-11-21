//
//  ViewControllerRootHomeCenter.h
//  KegCop
//
//  Created by capin on 11/19/14.
//
//

#import "ViewControllerRootHomeLeftPanel.h"

@protocol ViewControllerRootHomeCenterDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;


@required
- (void)movePanelToOriginalPosition;

@end

@interface ViewControllerRootHomeCenter : UIViewController <ViewControllerRootHomeLeftPanelDelegate> {
}

@property (nonatomic, assign) id<ViewControllerRootHomeCenterDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *hamMenu;

@end

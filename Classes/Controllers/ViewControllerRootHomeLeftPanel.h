//
//  ViewControllerRootHomeLeftPanel.h
//  KegCop
//
//  Created by capin on 11/19/14.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerRootHome.h"

@class ViewControllerRootHome;
@protocol ViewControllerRootHomeLeftPanelDelegate <NSObject>
- (void) movePanelToOriginalPosition: (ViewControllerRootHome *) sender;

@end

@interface ViewControllerRootHomeLeftPanel : UIViewController                     <MovePanelToOriginalPositionDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id<ViewControllerRootHomeLeftPanelDelegate> delegate;
//@property (nonatomic, assign) id<ViewControllerRootHomeLeftPanelDelegate> delegate;

// need to find a UI element that lists elements in a column.
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *options;

@end



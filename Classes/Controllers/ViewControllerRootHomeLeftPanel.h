//
//  ViewControllerRootHomeLeftPanel.h
//  KegCop
//
//  Created by capin on 11/19/14.
//
//


#import <UIKit/UIKit.h>
#import "ViewControllerRootHome.h"
#import "ViewControllerRootHomeCenter.h"

@protocol ViewControllerRootHomeLeftPanelDelegate;


@interface ViewControllerRootHomeLeftPanel : UIViewController < UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<ViewControllerRootHomeLeftPanelDelegate> delegate;

// need to find a UI element that lists elements in a column.
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *options;

@end
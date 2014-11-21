//
//  ViewControllerRootHomeLeftPanel.h
//  KegCop
//
//  Created by capin on 11/19/14.
//
//

#import <UIKit/UIKit.h>

@protocol ViewControllerRootHomeLeftPanelDelegate <NSObject>

@end

@interface ViewControllerRootHomeLeftPanel : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<ViewControllerRootHomeLeftPanelDelegate> delegate;

// need to find a UI element that lists elements in a column.
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *options;

@end



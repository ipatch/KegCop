//
//  ViewControllerRootHomeLeftPanel.h
//  KegCop
//
//  Created by capin on 11/19/14.
//
//

#import "ViewControllerRootHome.h"
#import "ViewControllerRootHomeCenter.h"
#import "returnToRootHome.h"

@interface ViewControllerRootHomeLeftPanel : UIViewController < UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id<returnToRootHome> myDelegate;

// need to find a UI element that lists elements in a column.
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *usernames;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

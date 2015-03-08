//
//  ViewControllerRootHomeLeftPanel.m
//  KegCop
//
//  Created by capin on 11/19/14.
//
//

#import "ViewControllerRootHomeLeftPanel.h"
#import "ViewControllerRootHome.h"
#import "ViewControllerRootHomeCenter.h"

#define SLIDE_TIMING .25

@interface ViewControllerRootHomeLeftPanel ()

@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;

@property (nonatomic, strong) ViewControllerRootHome *vcrh;

//@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ViewControllerRootHomeLeftPanel;


- (UITableView *)makeTableView {
    CGFloat x = 0;
    CGFloat y = 50;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - 50;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 45;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // tableView cell options
    _options = [[NSMutableArray alloc] initWithObjects:@"test", @"Manage Accounts", @"Logoff", nil];
    
    
    self.tableView = [self makeTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Options"];
    [self.view addSubview:self.tableView];
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Option";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // configure the cell
    cell.textLabel.text = [NSString stringWithFormat:[_options objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_options count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate

- (void)showViewControllerRootHomeCenter {
    
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"LeftPanelViewController" bundle:nil]  forCellReuseIdentifier:@"Manage Accounts"];
    
//    [self setContentViewController:vcrhc animated:YES completion:nil];
//    [self.ViewControllerRootHomeLeftPanel.view removeFromSuperView];
//    self.ViewControllerRootHomeLeftPanel = nil;

    //    static NSString *cellMainNibID = @"LeftPanelViewController";
    
//    _cellMain = [_tableView dequeueReusableCellWithIdentifier:cellMainNibID];
   }

//- (void) movePanelToOriginalPosition: (ViewControllerRootHome *) sender {
//    NSLog(@"Delegates are great!");
//    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        _viewControllerRootHomeCenter.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
//                     completion:^(BOOL finished) {
//                         if (finished) {
//                             [self resetMainView];
//                         }
//                     }];
//}


//-(void)resetMainView {
//    // remove left and right views, and reset variables, if needed
//    if (_viewControllerRootHomeLeftPanel != nil) {
//        [self.viewControllerRootHomeLeftPanel.view removeFromSuperview];
//        self.viewControllerRootHomeLeftPanel = nil;
//        _viewControllerRootHomeCenter.leftButton.tag = 1;
//        _viewControllerRootHomeCenter.hamMenu.tag = 1;
//        self.showingLeftPanel = NO;
//    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    NSString *currentString = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if ([currentString isEqualToString:@"Logoff"]) {
        NSLog(@"Logout button pressed");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([currentString isEqualToString:@"Manage Accounts"]) {
        NSLog(@"Manage Accounts button pressed");
        
        // do any additional checks / loads for managing accounts.
        
        
//        [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        
        
        
        
        
//        [tableView dequeueReusableCellWithIdentifier:@"Manage Accounts"];
        
        
        
        
        
        
        
        //        static NSString *CellIdentifier = @"Cell";
        
        
        
        
//        [_delegate movePanelToOriginalPosition];
        
//        static NSString *centerNib = @"CenterViewController";
        
//        _parentViewController = [tableView dequeueReusableCellWithIdentifier:centerNib];
//        if (_cellMain == nil) {
//            [[NSBundle mainBundle] loadNibNamed:@"CenterViewController" owner:self options:nil];

        
        // the below code was presenting a new view controller not hiding the left pane :(
//        UIViewController *vcrhc = [[UIViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
//        
//        [self presentViewController:vcrhc animated:YES completion:nil];
        
    }
//    return cell;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

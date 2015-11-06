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
#import "KCModalPickerView.h"
#import "KCModalPickerViewForCredit.h"
#import "ViewControllerUsers.h"
#import "Account.h"
#import "ViewControllerWebService.h"
#import "ViewControllerDev2.h"
#import "ViewControllerCalibrate.h"
#import "ViewControllerCreate.h"
#import "ViewControllerDBExportImport.h"

#define SLIDE_TIMING .25

@interface ViewControllerRootHomeLeftPanel ()

@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *userNames;
@property (strong, nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableArray *zeroToFifty;
@property (strong, nonatomic) NSString  *strSelectedUN;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation ViewControllerRootHomeLeftPanel {
    
}
@synthesize myDelegate;

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

    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[AccountsDataModel sharedDataModel]mainContext];
#ifdef DEBUG
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
#endif
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    request.resultType = NSDictionaryResultType;
    request.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"username"]];
    request.returnsDistinctResults = YES;
    
    _userNames = [_managedObjectContext executeFetchRequest:request error:nil];
    
    // tableView cell options
    _options = [[NSMutableArray alloc] initWithObjects:@"Add Credits", @"Change Pin", @"Export Users", @"Logoff", nil];
    
//    @"Calibrate",
    
//    @"Test Bluno Connection"
//    @"Connect to Web Service",
    
    // nums for Add Credits
    _zeroToFifty = [NSMutableArray arrayWithCapacity:50];
    for (int j=0; j < 50; j++) {
        [_zeroToFifty addObject:[NSString stringWithFormat:@"%d",j]];
    }

    
    
    
    self.tableView = [self makeTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Options"];
    [self.view addSubview:self.tableView];
    
    // load array items - TEMP ITEMS TO LOAD IN UIPICKERVIEW
    self.items = [NSArray arrayWithObjects:@"Red",@"Green",@"Blue", nil];
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
    if (self.myDelegate){
        [myDelegate loadVCRH];
    }
}

#pragma mark - table view cell entry selections

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    NSString *currentString = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if ([currentString isEqualToString:@"Calibrate"]) {
        [self showCalibrate];
    }
         
    
    if ([currentString isEqualToString:@"Logoff"]) {
        // this condition is satisfied when a new user creates an account then logs out
        if([self.presentingViewController isKindOfClass:[ViewControllerCreate class]] ) {
            
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion: nil];
        }

        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([currentString isEqualToString:@"Add Credits"]) {
        if (self.parentViewController.isViewLoaded)
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
            [fetchRequest setEntity:entity];
            
            fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"username"]];
            
            NSError *error = nil;
            NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            if (error) {
#ifdef DEBUG
                NSLog(@"Unable to execute fetch request.");
                NSLog(@"%@, %@", error, error.localizedDescription);
#endif
            } else {
#ifdef DEBUG
                NSLog(@"%@", result);
#endif
            }
            
            _names = [NSMutableArray arrayWithCapacity:[result count]];
            for (Account *account in result) {
                NSString *accountName = account.username;
                if (!accountName) {
                    accountName = @"<Unknown Account>";
                }
                [_names addObject:accountName];
            }

            KCModalPickerViewForCredit *pickerView = [[KCModalPickerViewForCredit alloc] initWithValues:_names];
            
            [pickerView presentInView:self.parentViewController.view withBlock:^(BOOL madeChoice) { }];
        
        [myDelegate loadVCRH];

        }
    }
    
    if ([currentString isEqualToString:@"Change Pin"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        UIViewController *changePinVC = [storyboard instantiateViewControllerWithIdentifier:@"users"];
        changePinVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:changePinVC animated:YES completion:nil];
    }
    
    if ([currentString isEqualToString:@"Create Web Service"]) {
        ViewControllerWebService *webServiceVC = [[ViewControllerWebService alloc] initWithNibName:@"ViewControllerWebService" bundle:nil];
        // establish delegate for vc
        webServiceVC.delegate = self;
        [self presentViewController:webServiceVC animated:YES completion:nil];
    }
    
    // add condition to load import / export SQLite / Core Data DB
    if ([currentString isEqualToString:@"Export Users"]) {
        ViewControllerDBExportImport *exportImportVC = [[ViewControllerDBExportImport alloc] initWithNibName:@"ViewControllerDBExportImport" bundle:nil];
        [self presentViewController:exportImportVC animated:YES completion:nil];
    }
    
    if ([currentString isEqualToString:@"Test Bluno Connection"]) {
        AppDelegate *appDelegate = APPDELEGATE;
        UIStoryboard *storyboard = appDelegate.storyboard;
        ViewControllerDev2 *blunoTestVC = [storyboard instantiateViewControllerWithIdentifier:@"dev2"];
        [self presentViewController:blunoTestVC animated:YES completion:nil];
    }
}

-(void)showCalibrate{
    // load the ViewControllerCalibrate class / XIB
//    NSLog(@"inside showCalibrate method");
    
    ViewControllerCalibrate *calibrateVC = [[ViewControllerCalibrate alloc] initWithNibName:@"ViewControllerCalibrate" bundle:nil];
    [((ViewControllerRootHome *)self.parentViewController).viewControllerRootHomeCenter addChildViewController:calibrateVC];
    [calibrateVC.view setFrame:CGRectMake(0.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.height)];
    
    [calibrateVC didMoveToParentViewController:((ViewControllerRootHome *)self.parentViewController).viewControllerRootHomeCenter];
    
    [((ViewControllerRootHome *)self.parentViewController).viewControllerRootHomeCenter.view addSubview:calibrateVC.view];
    
//    [((ViewControllerRootHome *)self.parentViewController) presentViewController:calibrateVC animated:NO completion:nil];
    
    [myDelegate loadVCRH];
}
# pragma mark - device orientation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
@end
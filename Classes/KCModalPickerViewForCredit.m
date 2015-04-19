//
//  KCModalPickerView.m
//  KegCop
//
//  Created by capin on 3/12/15.
//
//

#define KCMODALPICKER_PANEL_HEIGHT 200
#define KCMODALPICKER_TOOLBAR_HEIGHT 40

#import "KCModalPickerViewForCredit.h"
#import "AccountsDataModel.h"
#import "Account.h"

@interface KCModalPickerViewForCredit () {
    UIPickerView *_picker;
    UIToolbar *_toolbar;
    UIView *_panel;
    NSString *_selectedCredit;
}

@property (nonatomic, strong) KCModalPickerViewCallback callbackBlock;

@end

@implementation KCModalPickerViewForCredit

- (id)initWithValues:(NSArray *)values {
    self = [super init];
    if (self) {
        self.values = values;
    }
    
    return self;
}

- (void)setValues:(NSArray *)values {
    _values = values;
    
    if (values) {
        if (_picker) {
            [_picker reloadAllComponents];
        }
    }
}

# pragma mark - selected value methods for component 0

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (_picker) {
        [_picker selectRow:selectedIndex inComponent:0 animated:YES];
    }
}

- (void)setSelectedValue:(NSString *)selectedValue {
    NSInteger index = [self.values indexOfObject:selectedValue];
    [self setSelectedIndex:index];
}

- (NSString *)selectedValue {
    return [self.values objectAtIndex:self.selectedIndex];
}

# pragma mark - selected value methods for component 1

- (void)setSelectedIndex2:(NSUInteger)selectedIndex2 {
    _selectedIndex2 = selectedIndex2;
    if (_picker) {
        [_picker selectRow:selectedIndex2 inComponent:1 animated:YES];
    }
}

- (void)setSelectedValue2:(NSString *)selectedValue2 {
    NSInteger index2 = [self.values indexOfObject:selectedValue2];
    [self setSelectedIndex2:index2];
}

- (NSString *)selectedValue2 {
    return [self.values2 objectAtIndex:self.selectedIndex2];
}

- (void)onCancel:(id)sender {
    self.callbackBlock(NO);
    [self dismissPicker];
}

- (NSManagedObjectContext *)addCoreData {
    // Core Data
//    if (managedObjectContext == nil)
//    {
        NSManagedObjectContext *managedObjectContext = [[AccountsDataModel sharedDataModel]mainContext];
//        NSLog(@"After _managedObjectContext: %@",  managedObjectContext);
//    }
    return managedObjectContext;
}

- (void)addCredits:(id)sender {
    self.callbackBlock(YES);
    
    // add logic for presenting a UIAlertView and adding credits.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:self.addCoreData];
    [request setEntity:entity];
    
    // fetch records and handle error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.addCoreData executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error
    }
    for (Account *anAccount in mutableFetchResults) {
        if ([anAccount.username isEqualToString:self.selectedValue]) {
            NSLog(@"selectedValue = %@",self.selectedValue);
            
            // get value stored in credit tf
            int credit = [_selectedCredit integerValue];
            NSLog(@"selectedValue2 = %@",self.selectedValue2);
            
            // get current credit amount in DB
            int creditcurrent = [anAccount.credit intValue];
            
            // add selection with current credit
            int newcredit = credit + creditcurrent;
            NSLog(@"new credit amount = %i",newcredit);
            
            // save new value to anAccount.credit - convert int to NSNumber
            NSNumber *creditnew = [NSNumber numberWithInt:newcredit];
            anAccount.credit = creditnew;
            NSLog(@"new credit amoutn = %@",creditnew);
            
            // save to DB
            NSError *error = nil;
            if (![self.addCoreData save:&error]) {
                NSLog(@"error %@", error);
            }
        }
    }

//    [self dismissPicker];
}

#pragma mark - method for creating credits for pickerView

- (NSMutableArray *)addZeroTo49ToPicker {
    // nums for Add Credits
    NSMutableArray *zeroToFifty = [NSMutableArray arrayWithCapacity:50];
    for (int j=0; j < 50; j++) {
        [zeroToFifty addObject:[NSString stringWithFormat:@"%d",j]];
    }
    return zeroToFifty;
}

- (void)dismissPicker {
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect newFrame = _panel.frame;
                         newFrame.origin.y += _panel.frame.size.height;
                         _panel.frame = newFrame;
                        // _backdropView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_panel removeFromSuperview];
                         _panel = nil;
                         
                         //[//_backdropView removeFromSuperview];
                         //_backdropView = nil;
                         
                         [self removeFromSuperview];
                     }];
}

- (UIPickerView *)picker {
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KCMODALPICKER_TOOLBAR_HEIGHT, self.bounds.size.width, KCMODALPICKER_PANEL_HEIGHT - KCMODALPICKER_TOOLBAR_HEIGHT)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow:self.selectedIndex inComponent:0 animated:NO];
    
    return picker;
}

- (UIToolbar *)toolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, KCMODALPICKER_TOOLBAR_HEIGHT)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    toolbar.items = [NSArray arrayWithObjects:
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                   target:self
                                                                   action:@selector(onCancel:)],
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                   target:nil
                                                                   action:nil],
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                   target:self
                                                                   action:@selector(addCredits:)],
                     nil];
    
    return toolbar;
}

- (void)presentInView:(UIView *)view withBlock:(KCModalPickerViewCallback)callback {
    self.frame = view.bounds;
    self.callbackBlock = callback;
    
    [_panel removeFromSuperview];
    
    _panel = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - KCMODALPICKER_PANEL_HEIGHT, self.bounds.size.width, KCMODALPICKER_PANEL_HEIGHT)];
    _picker = [self picker];
    _toolbar = [self toolbar];
    
    [_panel addSubview:_picker];
    [_panel addSubview:_toolbar];
    
    [self addSubview:_panel];
    [view addSubview:self];
    
    CGRect oldFrame = _panel.frame;
    CGRect newFrame = _panel.frame;
    newFrame.origin.y += newFrame.size.height;
    _panel.frame = newFrame;
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _panel.frame = oldFrame;
                        // _backdropView.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)presentInWindowWithBlock:(KCModalPickerViewCallback)callback {
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)]) {
        UIWindow *window = [appDelegate window];
        [self presentInView:window withBlock:callback];
    } else {
        [NSException exceptionWithName:@"Can't find a window property on App Delegate.  Please use the presentInView:withBlock: method" reason:@"The app delegate does not contain a window method"
                              userInfo:nil];
    }
}

#pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.values.count;
    }
    else if (component == 1) {
        return self.addZeroTo49ToPicker.count;
    }
}

// edit this method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return [self.values objectAtIndex:row];
    }
    else if (component == 1) {
        return [self.addZeroTo49ToPicker objectAtIndex:row];
        
        // .objectAtIndex:row;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedIndex = row;
    }
    else if (component == 1) {
        _selectedCredit = [self.addZeroTo49ToPicker objectAtIndex:row];
    }
}
@end
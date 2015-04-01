//
//  ViewControllerLogs.m
//  KegCop
//
//  Created by capin on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewControllerLogs.h"

@interface ViewControllerLogs ()

@end

@implementation ViewControllerLogs

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *log = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"ns.log"];
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:log];
        
        [fh seekToEndOfFile];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getData:)
                                                name:@"NSFileHandleReadCompletionNotification"
                                                   object:fh];
        [fh readInBackgroundAndNotify];
        firstOpen = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *log = [[paths objectAtIndex:0] stringByAppendingPathComponent:
                     @"ns.log"];
    if ( firstOpen ) {
        NSString* content = [NSString stringWithContentsOfFile:log encoding:NSUTF8StringEncoding error:NULL]; 
        _logWindow.editable = TRUE;
        _logWindow.text = [_logWindow.text stringByAppendingString: content];
        _logWindow.editable = FALSE;
        firstOpen = NO;
    }
}

#pragma mark - NSLog Redirection Methods

- (void) getData: (NSNotification *)aNotification 
{ 
    NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem]; 
    if ([data length]) {
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _logWindow.editable = TRUE;
    _logWindow.text = [_logWindow.text stringByAppendingString: aString]; _logWindow.editable = FALSE;
    [self setWindowScrollToVisible];
    [[aNotification object] readInBackgroundAndNotify]; } else {
        [self performSelector:@selector(refreshLog:) withObject:aNotification afterDelay:1.0];
    } 
}

- (void) refreshLog: (NSNotification *)aNotification 
{
    [[aNotification object] readInBackgroundAndNotify]; 
}

- (void)setWindowScrollToVisible {
NSRange txtOutputRange;
txtOutputRange.location = [[_logWindow text] length]; txtOutputRange.length = 0;
_logWindow.editable = TRUE;
[_logWindow scrollRangeToVisible:txtOutputRange]; [_logWindow setSelectedRange:txtOutputRange]; _logWindow.editable = FALSE;
}

@end
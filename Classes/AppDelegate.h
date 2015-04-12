//
//  AppDelegate.h
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import <UIKit/UIKit.h>
#import "ViewControllerWebService.h"

@class AppDelegate;

@protocol AppDelegateDelegate
-(NSData *)passDeviceToken;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, ViewControllerWebServiceDelegate> { }

// the below property is important
// http://developer.apple.com/library/ios/#releasenotes/Miscellaneous/RN-AdoptingStoryboards/_index.html

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIStoryboard *storyboard;
@property (nonatomic, retain) NSData *deviceToken;
@property (assign, nonatomic) id<AppDelegateDelegate> delegate;

@end
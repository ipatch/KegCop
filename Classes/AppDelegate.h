//
//  AppDelegate.h
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> { }

// the below property is important
// http://developer.apple.com/library/ios/#releasenotes/Miscellaneous/RN-AdoptingStoryboards/_index.html

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIStoryboard *storyboard;

@end
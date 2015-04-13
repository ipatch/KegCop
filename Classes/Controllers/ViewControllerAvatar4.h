//
//  ViewControllerAvatar4.h
//  KegCop
//
//  Created by capin on 3/21/15.
//
//



@class ViewControllerAvatar4;

@protocol ViewControllerAvatar4Delegate

- (NSDictionary *) giveMeData;

@end

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewControllerAvatar4 : UIViewController {
    
}
@property (assign, nonatomic) id<ViewControllerAvatar4Delegate>delegate;

@end
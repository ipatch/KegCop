//
//  ViewControllerAvatar4.h
//  KegCop
//
//  Created by capin on 3/21/15.
//
//

#import <Foundation/Foundation.h>

@class ViewControllerAvatar4;

@protocol ViewControllerAvatar4Delegate

- (NSDictionary *) giveMeData;

@end

@interface ViewControllerAvatar4 : UIViewController {
    
}
@property (assign, nonatomic) id<ViewControllerAvatar4Delegate>delegate;

@end

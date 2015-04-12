//
//  ViewControllerWebService.h
//  KegCop
//
//  Created by capin on 3/27/15.
//
//

#import "AppDelegate.h"

@class ViewControllerWebService;
@protocol ViewControllerWebServiceDelegate <NSObject>
-(NSData *)obtainDeviceToken;
@end

@interface ViewControllerWebService : UIViewController

@property (assign, nonatomic) id<ViewControllerWebServiceDelegate> delegate;
@end

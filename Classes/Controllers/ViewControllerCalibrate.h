//
//  ViewControllerCalibrate.h
//  KegCop
//
//  Created by capin on 4/27/15.
//
//

#import <UIKit/UIKit.h>
@protocol ViewControllerCalibrateDelegate;
@protocol ViewControllerCalibrateDelegate <NSObject>
- (void) removeCalibrateView;
@end

@interface ViewControllerCalibrate : UIViewController
@property (nonatomic, weak) id<ViewControllerCalibrateDelegate> delegate;
@end

//
//  ViewControllerRootHomeLeftPanel.h
//  KegCop
//
//  Created by capin on 11/19/14.
//
//

#import <UIKit/UIKit.h>

@protocol ViewControllerRootHomeLeftPanelDelegate <NSObject>

@end

@interface ViewControllerRootHomeLeftPanel : UIViewController

@property (nonatomic, assign) id<ViewControllerRootHomeLeftPanelDelegate> delegate;

@end



//
//  Model.h
//  KegCop
//
//  Created by capin on 6/10/12.
//
//  this class is soon to be obsolete.
//

#import <Foundation/Foundation.h>

@interface ModelWelcome : NSObject {
    
    // remove this object or the property below
    NSString *passedText;
}

@property (nonatomic, strong) NSString *passedText;

+ (ModelWelcome *) sharedModelWelcome;

@end

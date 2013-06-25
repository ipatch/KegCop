//
//  Model.h
//  KegCop
//
//  Created by capin on 6/10/12.
//

#import <Foundation/Foundation.h>

@interface ModelWelcome : NSObject {
    
    NSString *passedText;
}

// not sure how to implement the model, but it's here for when it
// will be needed, if needed \o/

@property (nonatomic, strong) NSString* passedText;

+ (ModelWelcome *) sharedModelWelcome;


@end

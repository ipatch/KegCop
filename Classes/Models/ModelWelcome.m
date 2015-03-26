//
//  Model.m
//  KegCop
//
//  Created by capin on 6/10/12.
//

#import "ModelWelcome.h"   

@interface ModelWelcome () {
    
}
@end

@implementation ModelWelcome
@synthesize passedText =_passedText;

static ModelWelcome *sharedModelWelcome = nil;

+ (ModelWelcome *) sharedModelWelcome {
    @synchronized(self){
        if (sharedModelWelcome == nil){
            sharedModelWelcome = [[self alloc] init];
        }
    }
    return sharedModelWelcome;
}
@end
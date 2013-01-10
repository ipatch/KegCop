//
//  main.m
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        
        // creates ns.log file in Documents directory - NOT COMPLETE
        NSArray *paths =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *log = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"ns.log"];
        
        NSFileManager *fileMgr = [NSFileManager defaultManager]; 
        [fileMgr removeItemAtPath:log error:nil];
        
        freopen([log fileSystemRepresentation], "a", stderr);
        
        int retVal = UIApplicationMain(argc, argv, nil, nil);
        return retVal;
        
    }
}

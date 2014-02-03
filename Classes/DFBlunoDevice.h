//
//  DFBlunoDevice.h
//  KegCop
//
//  Created by capin on 1/31/14.
//
//

#import <Foundation/Foundation.h>

@interface DFBlunoDevice : NSObject
{
@public BOOL _bReadyToWrite;
}

@property(strong, nonatomic) NSString *identifier;
@property(strong, nonatomic) NSString *name;
@property(assign, nonatomic, readonly) BOOL bReadyToWrite;

@end

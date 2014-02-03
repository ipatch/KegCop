//
//  DFBlunoDevice.m
//  KegCop
//
//  Created by capin on 1/31/14.
//
//

#import "DFBlunoDevice.h"

@implementation DFBlunoDevice

@synthesize bReadyToWrite = _bReadyToWrite;

-(id)init
{
    self = [super init];
    _bReadyToWrite = NO;
    return self;
}

@end

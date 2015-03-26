//
//  JailbrokenSerial.h
//  HackSerialTest
//
//  Created by Sunjun Kim on 8/9/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <termios.h> /* POSIX terminal control definitions */

@protocol JailbrokenSerialDelegate
- (void) JailbrokenSerialReceived:(char)ch;
@end

@interface JailbrokenSerial : NSObject {
    NSThread *thread;
   __unsafe_unretained id<JailbrokenSerialDelegate> _receiver; // added "__unsafe_unretained" because of SO thread
    int fd;
    struct termios gOriginalTTYAttrs;
    BOOL debug;                         // will print debugging message if YES
    BOOL nonBlock;                      // will act as nonblocking mode. delegate 'receiver' required
    char receivedCh;
}

@property (nonatomic, assign) id<JailbrokenSerialDelegate> receiver;
@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) BOOL nonBlock;

- (id)initWithReceiver:(id<JailbrokenSerialDelegate>) receiver;

- (BOOL)open:(int)baudRate;
- (BOOL)isOpened;
- (void)close;
- (ssize_t)read:(void *)buffer length:(size_t)len;
- (void)write:(const char *)message length:(int)len;
- (void)write:(NSString *)message;

@end
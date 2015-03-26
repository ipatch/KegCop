//
// KBKegboard.h
// KegPad
//
// Created by John Boiles on 7/29/10.
// Copyright 2010 Yelp. All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//

#import "Serial.h"
#import "KBKegboardMessage.h"
#define SERIAL_PORT "/dev/tty.iap"

@class KBKegboard;

@protocol KBKegboardDelegate <NSObject>
- (void)kegboard:(KBKegboard *)kegboard didReceiveHello:(KBKegboardMessageHello *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveBoardConfiguration:(KBKegboardMessageBoardConfiguration *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveMeterStatus:(KBKegboardMessageMeterStatus *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveTemperatureReading:(KBKegboardMessageTemperatureReading *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveOutputStatus:(KBKegboardMessageOutputStatus *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveAuthToken:(KBKegboardMessageAuthToken *)message;
@end

/*!
 Handles communication to and from the Kegboard via a serial connection.
 */
@interface KBKegboard : NSObject {
    
    // commented below line of code for ARC compliance
    // ref = http://stackoverflow.com/questions/8138902/existing-ivar-delegate-for-unsafe-unretained-property-delegate-must-be-un
    
    // id<KBKegboardDelegate> _delegate;
    NSThread *_readLoopThread;
}

@property (weak, nonatomic) id<KBKegboardDelegate> delegate;

- (id)initWithDelegate:(__weak id<KBKegboardDelegate>)delegate;

- (void)start;

- (void)pingKegboard;

- (void)setKegboardOutputId:(NSInteger)outputId enabled:(BOOL)enabled;

@end
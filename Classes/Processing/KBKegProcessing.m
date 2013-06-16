//
// KBKegProcessing.m
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
// TODO
// - clearly define class in what it does
// - fix errors in class file, as of 28MAY13 there is one error :/
// - interpret code coming from Arduino, recieves messages from board


#import "KBKegProcessing.h"


@implementation KBKegProcessing

// figure out why below statement is causing an ARC error

@synthesize delegate=_delegate, flowRate=_flowRate;

- (id)init {
    if ((self = [super init])) {
        _kegboard = [[KBKegboard alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc {
    
    // commented below lines of code to make ARC compliant
    
    /*
    _kegboard.delegate = nil;
    [_kegboard release];
    [super dealloc];
     */
}

- (void)endPour {
    if (_pouring) {
//        KBDebug(@"Ended pour");
        [self.delegate kegProcessing:self didEndPourWithAmount:_lastVolume - _pourStartVolume];
        _pouring = NO;
        _pourTimeout = nil;
    }
}

- (double)pourVolume {
    return _lastVolume - _pourStartVolume;
}

- (void)pingKegboard {
    [_kegboard pingKegboard];
}

- (void)setKegboardOutputId:(NSInteger)outputId enabled:(BOOL)enabled {
    [_kegboard setKegboardOutputId:outputId enabled:enabled];
}

#pragma mark Delegates (KBKegboard)

- (void)kegboard:(KBKegboard *)kegboard didReceiveHello:(KBKegboardMessageHello *)message {
//    KBDebug(@"Hello from Kegboard!");
}

- (void)kegboard:(KBKegboard *)kegboard didReceiveBoardConfiguration:(KBKegboardMessageBoardConfiguration *)message { }

- (void)kegboard:(KBKegboard *)kegboard didReceiveMeterStatus:(KBKegboardMessageMeterStatus *)message {
    // Check last few meter values, if this is significantly different, notify delegate of start / end of pour
    // Since we're receiving flow values at about 1 Hz, watch for significant changes
    double volume = [message meterReading] * KB_VOLUME_PER_TICK;
    
    // Initialize some data on our first data point
    if (!_hasVolume) {
        _lastVolume = volume;
        _pourStartVolume = volume;
        _hasVolume = YES;
        return;
    }
    
    double timestamp = [message timeStamp];
    _flowRate = (volume - _lastVolume) / (timestamp - _lastVolumeTimetamp);
    _lastVolumeTimetamp = timestamp;
    
    // Figure out if we've started to increase flow a lot since the last sample
    if (_flowRate > KB_VOLUME_DIFFERENCE_THRESHOLD) {
        if (!_pouring) {
//            KBDebug(@"Pouring");
            [self.delegate kegProcessingDidStartPour:self];
            _pourStartVolume = _lastVolume;
            _pouring = YES;
            _pourTimeout = [NSTimer scheduledTimerWithTimeInterval:KB_POUR_TIMEOUT target:self selector:@selector(endPour) userInfo:nil repeats:NO];
        } else {
            [_pourTimeout setFireDate:[NSDate dateWithTimeIntervalSinceNow:KB_POUR_TIMEOUT]];
        }
    }
    _lastVolume = volume;
    [self.delegate kegProcessing:self didUpdatePourWithAmount:(volume - _pourStartVolume) flowRate:_flowRate];
}

- (void)kegboard:(KBKegboard *)kegboard didReceiveTemperatureReading:(KBKegboardMessageTemperatureReading *)message {
    [self.delegate kegProcessing:self didChangeTemperature:[message sensorReading]];
}

- (void)kegboard:(KBKegboard *)kegboard didReceiveOutputStatus:(KBKegboardMessageOutputStatus *)message { }

- (void)kegboard:(KBKegboard *)kegboard didReceiveAuthToken:(KBKegboardMessageAuthToken *)message {
    // Only send a message when the card becomes present
    if ([message status]) [self.delegate kegProcessing:self didReceiveRFIDTagId:[message token]];
}

@end
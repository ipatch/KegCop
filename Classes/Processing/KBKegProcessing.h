//
// KBKegProcessing.h
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
//

#import "KBKegboard.h"

#define kLitersToOunces 33.8140227
#define kOuncesToLiter 0.0295735296

#define KB_VOLUME_DIFFERENCE_THRESHOLD (0.7 * kOuncesToLiter)
// Adjust this value based on the flow meter properties
#define KB_VOLUME_PER_TICK 0.0001639344262
#define KB_POUR_TIMEOUT 1.5

@class KBKegProcessing;

@protocol KBKegProcessingDelegate
- (void)kegProcessingDidStartPour:(KBKegProcessing *)kegProcessing;
- (void)kegProcessing:(KBKegProcessing *)kegProcessing didEndPourWithAmount:(double)amount;
- (void)kegProcessing:(KBKegProcessing *)kegProcessing didChangeTemperature:(double)temperature;
- (void)kegProcessing:(KBKegProcessing *)kegProcessing didReceiveRFIDTagId:(NSString *)tagID;
//- (void)kegProcessing:(KBKegProcessing *)kegProcessing didError:(KBError *)error;
- (void)kegProcessing:(KBKegProcessing *)kegProcessing didUpdatePourWithAmount:(double)amount flowRate:(double)flowRate;
@end

/*!
 Class that provides a layer between a direct communication with a Kegboard (KBKegboard) and the application. In this class it's appropriate to process the data coming from a Kegboard in a way that is more usable by the rest of the application.
 */
@interface KBKegProcessing : NSObject <KBKegboardDelegate> {

    // capin - commented below line of code for ARC compliance
    // ref = http://stackoverflow.com/questions/8138902/existing-ivar-delegate-for-unsafe-unretained-property-delegate-must-be-un
    // id<KBKegProcessingDelegate> _delegate;
    
    KBKegboard *_kegboard;
    
    double _flowRate; // in liters / second
    
    double _lastVolume; // in liters
    double _lastVolumeTimetamp;
    
    double _pourStartVolume;
    BOOL _pouring;
    NSTimer *_pourTimeout;
    
    BOOL _hasVolume;
}

@property (weak, nonatomic) id<KBKegProcessingDelegate> delegate;
@property (readonly, nonatomic) double flowRate;
@property (readonly, nonatomic) double pourVolume;

- (void)pingKegboard;

- (void)setKegboardOutputId:(NSInteger)outputId enabled:(BOOL)enabled;

@end

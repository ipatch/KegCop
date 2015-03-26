//
// KBKegboardMessage.m
// KegPad
//
// Created by John Boiles on 9/27/10.
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

#import "KBKegboardMessage.h"
#import "KBKegboardUtils.h"
#import "KBKegboardCommand.h"

char *const KBSP_PREFIX = kKBSP_PREFIX;
char *const KBSP_TRAILER = kKBSP_TRAILER;


@implementation KBKegboardMessage
@synthesize timeStamp=_timeStamp;

+ (NSUInteger)messageId {
    NSAssert(NO, @"Subclasses must implement messageId");
    return 0;
}

- (NSUInteger)messageId {
    return [[self class] messageId];
}

+ (id)messageWithId:(NSUInteger)messageId payload:(char *)payload length:(NSUInteger)length timeStamp:(NSTimeInterval)timeStamp {
    KBKegboardMessage *message = nil;
    // Any time you add a new KBKegboardMessage subclass, you should add it here
    switch (messageId) {
        case KB_MESSAGE_ID_HELLO:
            message = [[KBKegboardMessageHello alloc] initWithPayload:payload length:length];
            break;
        case KB_MESSAGE_ID_BOARD_CONFIGURATION:
            message = [[KBKegboardMessageBoardConfiguration alloc] initWithPayload:payload length:length];
            break;
        case KB_MESSAGE_ID_METER_STATUS:
            message = [[KBKegboardMessageMeterStatus alloc] initWithPayload:payload length:length];
            break;
        case KB_MESSAGE_ID_TEMPERATURE_READING:
            message = [[KBKegboardMessageTemperatureReading alloc] initWithPayload:payload length:length];
            break;
        case KB_MESSAGE_ID_OUTPUT_STATUS:
            message = [[KBKegboardMessageOutputStatus alloc] initWithPayload:payload length:length];
            break;
        case KB_MESSAGE_ID_AUTH_TOKEN:
            message = [[KBKegboardMessageAuthToken alloc] initWithPayload:payload length:length];
            break;
        case KB_MESSAGE_ID_PING:
            message = [[KBKegboardCommandPing alloc] initWithPayload:payload length:length];
            break;
        case KB_MESSAGE_ID_SET_OUTPUT:
            message = [[KBKegboardCommandSetOutput alloc] initWithPayload:payload length:length];
            break;
    }
    message->_timeStamp = timeStamp;
    if (!message) NSLog(@"Got unknown message with ID %x", messageId);
    return message;
}

- (id)initWithPayload:(char *)payload length:(NSUInteger)length {
    if ((self = [super init])) {
        // Some messages may have no payload
        if (length > 0) {
            [self parsePayload:payload length:length];
        }
    }
    return self;
}

- (void)parsePayload:(char *)payload length:(NSUInteger)length {
    NSUInteger index = 0;
    while (index < length) {
        NSUInteger tag = [KBKegboardUtils parseUInt8:&payload[index]];
        index++;
        NSUInteger length = [KBKegboardUtils parseUInt8:&payload[index]];
        index++;
        if (![self parsePayload:&payload[index] forTag:tag length:length]) NSLog(@"Failed to parse tag: %d", tag);
        index += length;
    }
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
    NSAssert(NO, @"Abstract Method");
    return NO;
}

@end

@implementation KBKegboardMessageHello

+ (NSUInteger)messageId {
    return KB_MESSAGE_ID_HELLO;
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
    switch (tag) {
        case 0x01:
            _protocolVersion = [KBKegboardUtils parseUInt16:data];
            break;
        default:
            return NO;
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"KBKegboardMessageHello with protocolVersion %u", _protocolVersion];
}

@end


@implementation KBKegboardMessageBoardConfiguration
@synthesize boardName=_boardName, baudRate=_baudRate, updateInterval=_updateInterval, watchdogTimeout=_watchdogTimeout;

+ (NSUInteger)messageId {
    return KB_MESSAGE_ID_BOARD_CONFIGURATION;
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
    switch (tag) {
        case 0x01:
            _boardName = [KBKegboardUtils parseString:data length:length];
            break;
        case 0x02:
            _baudRate = [KBKegboardUtils parseUInt16:data];
            break;
        case 0x03:
            _updateInterval = [KBKegboardUtils parseUInt16:data];
            break;
        case 0x04:
            _watchdogTimeout= [KBKegboardUtils parseUInt16:data];
            break;
        default:
            return NO;
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"KBKegboardMessageBoardConfiguration with boardName %@ baudRate %u updateInterval %u watchdogTimeout %u", _boardName, _baudRate, _updateInterval, _watchdogTimeout];
}

@end


@implementation KBKegboardMessageMeterStatus
@synthesize meterName=_meterName, meterReading=_meterReading;

+ (NSUInteger)messageId {
    return KB_MESSAGE_ID_METER_STATUS;
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
    switch (tag) {
        case 0x01:
            _meterName = [KBKegboardUtils parseString:data length:length];
            break;
        case 0x02:
            _meterReading = [KBKegboardUtils parseUInt32:data];
            break;
        default:
            return NO;
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"KBKegboardMessageMeterStatus with meterName %@ _meterReading %u", _meterName, _meterReading];
}

@end

@implementation KBKegboardMessageTemperatureReading
@synthesize sensorName=_sensorName, sensorReading=_sensorReading;

+ (NSUInteger)messageId {
    return KB_MESSAGE_ID_TEMPERATURE_READING;
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
    switch (tag) {
        case 0x01:
            _sensorName = [KBKegboardUtils parseString:data length:length];
            break;
        case 0x02:
            _sensorReading = [KBKegboardUtils parseTemp:data];
            break;
        default:
            return NO;
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"KBKegboardMessageTemperatureReading with _sensorName %@ _sensorReading %f", _sensorName, _sensorReading];
}

@end

@implementation KBKegboardMessageOutputStatus
@synthesize outputName=_outputName, outputReading=_outputReading;

+ (NSUInteger)messageId {
    return KB_MESSAGE_ID_OUTPUT_STATUS;
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
    switch (tag) {
        case 0x01:
            _outputName = [KBKegboardUtils parseString:data length:length];
            break;
        case 0x02:
            _outputReading = [KBKegboardUtils parseBool:data];
            break;
        default:
            return NO;
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"KBKegboardMessageOutputStatus with _outputName %@ _outputReading %d", _outputName, _outputReading];
}

@end

@implementation KBKegboardMessageAuthToken
@synthesize deviceName=_deviceName, token=_token, status=_status;

+ (NSUInteger)messageId {
    return KB_MESSAGE_ID_AUTH_TOKEN;
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
    switch (tag) {
        case 0x01:
            _deviceName = [KBKegboardUtils parseString:data length:length];
            break;
        case 0x02:
            _token = [KBKegboardUtils parseString:data length:length];
            break;
        case 0x03:
            _status = [KBKegboardUtils parseBool:data];
            break;
        default:
            return NO;
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"KBKegboardMessageAuthToken with _deviceName %@ _token %@ _stats %d", _deviceName, _token, _status];
}

@end
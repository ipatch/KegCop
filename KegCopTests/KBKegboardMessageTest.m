//
//  KBKegboardMessageTest.m
//  KegCop
//
//  Created by John Boiles on 6/16/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "KBKegboardMessage.h"

@interface KBKegboardMessageTest : SenTestCase
@end

@implementation KBKegboardMessageTest

- (void)testParsePayload {
    // The following byte string was taken straight out of the KegBot docs
    // https://kegbot.org/docs/kegboard/serial-protocol/
    // Header prefix
    //\x4b\x42\x53\x50\x20\x76\x31\x3a
    // Message ID
    //\x10\x00
    // Payload length
    //\x0e\x00
    // Payload
    //\x01\x06\x66\x6c\x6f\x77\x31\x00\x02\x04\x04\x00\x00\x00
    // CRC
    //\x55\x0a
    // Trailer
    //\x0d\x0a
    char payloadBytes[] = {0x01, 0x06, 0x66, 0x6c, 0x6f, 0x77, 0x31, 0x00, 0x02, 0x04, 0x04, 0x00, 0x00, 0x00};
    KBKegboardMessageMeterStatus *meterStatus = [KBKegboardMessage messageWithId:0x10 payload:payloadBytes length:0xE timeStamp:CACurrentMediaTime()];
    STAssertEqualObjects(meterStatus.meterName, @"flow1", @"Meter name wasn't as expected");
    STAssertEquals(meterStatus.meterReading, (NSUInteger)4, @"Meter reading wasn't as expected");
}

@end

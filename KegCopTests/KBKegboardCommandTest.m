//
//  KBKegboardCommandTest.m
//  KegCop
//
//  Created by John Boiles on 6/14/13.
//

#import <SenTestingKit/SenTestingKit.h>
#import "KBKegboardCommand.h"

@interface KBKegboardCommandTest : SenTestCase
@end

@implementation KBKegboardCommandTest

- (void)testBytes {
    KBKegboardCommandSetOutput *command = [KBKegboardCommandSetOutput kegboardCommandSetOutputWithOutputId:4 outputMode:KBKegboardOutputTypeEnabled];
    char *bytes = [command bytes];
    // This byte array was gotten by copying what KBKegboardCommandSetOutput generated. It may not be correct. Feel free to remove this comment after KBKegboardCommandSetOutput gets tested against hardware and is known to work.
    char expectedBytes[] = {
        // Header prefix ("KBSP v1:")
        0x4b, 0x42, 0x53, 0x50, 0x20, 0x76, 0x31, 0x3a,
        // Message ID (0x0084)
        0x84, 0x00,
        // Payload Length (0x0006)
        0x06, 0x0,
        // Payload
        0x1, 0x1, 0x4, 0x2, 0x1, 0x1,
        // CRC
        0xa4, 0x6f,
        // Trailer ("/r/n")
        0xd, 0xa};
    NSUInteger expectedLength = sizeof(expectedBytes);
    STAssertEquals(command.length, expectedLength, @"Length of command (%d) is not equal to expected length (%d)", command.length, expectedLength);
    for (NSInteger i = 0; i < command.length; i++) {
        NSLog(@"%c (%X)", bytes[i], (unsigned char)bytes[i]);
        STAssertEquals((char)bytes[i], (char)expectedBytes[i], @"Byte at index %d was %c (0x%X). It should be %c (0x%X)", i, bytes[i], bytes[i], expectedBytes[i], expectedBytes[i] & 0xFF);
    }
}

- (void)testPayloadCreateAndParse {
    KBKegboardCommandSetOutput *command = [KBKegboardCommandSetOutput kegboardCommandSetOutputWithOutputId:20 outputMode:KBKegboardOutputTypeEnabled];
    char *bytes = [command bytes];
    // First 12 bytes are the header, don't worry about those
    bytes = &bytes[12];
    // Subtract the header, the crc, and the /r/n from the length, so we can get the length of the payload
    NSUInteger payloadLength = [command length] - 12 - 4;
    KBKegboardCommandSetOutput *parsedCommand = [KBKegboardMessage messageWithId:[command messageId] payload:bytes length:payloadLength timeStamp:CACurrentMediaTime()];
    STAssertEquals(parsedCommand.outputId, (NSUInteger)20, @"Created and parsed Output IDs must be equal");
    STAssertEquals(parsedCommand.outputMode, KBKegboardOutputTypeEnabled, @"Created and parsed Output Modes must be equal");
}

@end

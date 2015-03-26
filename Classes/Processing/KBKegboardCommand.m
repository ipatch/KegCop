//
// KBKegboardCommand.m
// KegPad
//
// Created by John Boiles on 6/13/13.
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

#import "KBKegboardCommand.h"
#import "KBKegboardUtils.h"

@interface KBKegboardCommand ()
@property (assign, nonatomic) char *bytes;
@property (assign, nonatomic) NSUInteger length;
@end

@implementation KBKegboardCommand

+ (NSUInteger)messageId {
    NSAssert(NO, @"Subclasses must implement messageId");
    return 0;
}

- (NSUInteger)payloadLength {
    NSAssert(NO, @"Subclasses must implement payloadLength");
    return 0;
}

- (void)writePayload:(char *)data {
    NSAssert(NO, @"Subclasses must implement writePayload:");
    return;
}

- (void)dealloc {
    free(_bytes);
}

- (char *)newCommandData {
    NSUInteger payloadLength = [self payloadLength];
    char *data = malloc(self.length);
    NSInteger index = 0;
    strcpy(data, kKBSP_PREFIX);
    index += kKBSP_HEADER_PREFIX_SIZE;
    
    // Message ID
    [KBKegboardUtils writeUInt16:[[self class] messageId] data:&data[index]];
    index += kKBSP_HEADER_MESSAGE_ID_SIZE;

    // Payload Length
    [KBKegboardUtils writeUInt16:payloadLength data:&data[index]];
    index += kKBSP_HEADER_PAYLOAD_LENGTH_SIZE;

    // Write the payload
    if (payloadLength > 0) {
        [self writePayload:&data[index]];
        index += payloadLength;
    }

    [KBKegboardUtils writeCRCFromData:data length:index];
    index += kKBSP_FOOTER_CRC_SIZE;
    
    // Trailer
    strcpy(&data[index], kKBSP_TRAILER);

    return data;
}

- (NSUInteger)length {
    return kKBSP_HEADER_PREFIX_SIZE + kKBSP_HEADER_MESSAGE_ID_SIZE + kKBSP_HEADER_PAYLOAD_LENGTH_SIZE + [self payloadLength] + kKBSP_FOOTER_CRC_SIZE + kKBSP_FOOTER_TRAILER_SIZE;
}

- (char *)bytes {
    if (!_bytes) {
        _bytes = [self newCommandData];
    }
    return _bytes;
}

@end


@implementation KBKegboardCommandPing

+ (NSUInteger)messageId {
    return KB_MESSAGE_ID_PING;
}

+ (KBKegboardCommandPing *)kegboardCommandPing {
    return [[self alloc] init];
}

- (NSUInteger)payloadLength {
    // Ping command has no payload
    return 0;
}

@end


@interface KBKegboardCommandSetOutput ()
@property (assign, nonatomic) NSUInteger outputId;
@property (assign, nonatomic) KBKegboardOutputType outputMode;
@end

@implementation KBKegboardCommandSetOutput

+ (NSUInteger)messageId {
    return KB_MESSAGE_ID_SET_OUTPUT;
}

+ (KBKegboardCommandSetOutput *)kegboardCommandSetOutputWithOutputId:(NSUInteger)outputId outputMode:(KBKegboardOutputType)outputMode {
    KBKegboardCommandSetOutput *kegboardCommandSetOutput = [[self alloc] init];
    kegboardCommandSetOutput.outputId = outputId;
    kegboardCommandSetOutput.outputMode = outputMode;
    return kegboardCommandSetOutput;
}

- (NSUInteger)payloadLength {
    // TODO(johnb): It'd be nice to make a more elegant way to store tag/length/values in an array. However, since this is the only command with a payload, I think the simple solution makes sense.
    return kKBSP_PAYLOAD_TAG_SIZE + kKBSP_PAYLOAD_LENGTH_SIZE + 1 + kKBSP_PAYLOAD_TAG_SIZE + kKBSP_PAYLOAD_LENGTH_SIZE + 1;
}

- (void)writePayload:(char *)data {
    NSUInteger index = 0;
    // Tag (output_id)
    [KBKegboardUtils writeUInt8:0x01 data:&data[index]];
    index += 1;
    // Length
    [KBKegboardUtils writeUInt8:1 data:&data[index]];
    index += 1;
    // Value
    [KBKegboardUtils writeUInt8:self.outputId data:&data[index]];
    index += 1;

    // Tag (output_mode)
    [KBKegboardUtils writeUInt8:0x02 data:&data[index]];
    index += 1;
    // Length
    [KBKegboardUtils writeUInt8:1 data:&data[index]];
    index += 1;
    // Value
    [KBKegboardUtils writeUInt8:self.outputMode data:&data[index]];
}

// Including parse logic allows us to test our command creation code against our command parsing code. This probably wont get used in normal operation.
- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
    switch (tag) {
        case 0x01:
            self.outputId = [KBKegboardUtils parseUInt8:data];
            break;
        case 0x02:
            self.outputMode = [KBKegboardUtils parseUInt8:data];
            break;
        default:
            return NO;
    }
    return YES;
}

@end
//
// KBKegboardUtils.m
// KegCop
//
// Created by John Boiles on 6/16/13.
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

#import "KBKegboardUtils.h"
#import "crc16ccitt.h"

@implementation KBKegboardUtils

+ (NSString *)parseString:(char *)stringData length:(NSUInteger)length {
    // NOTE: Kegboard docs say strings are null terminated, but in the latest version (as of 7/29/2010), they are not.
    // To be safe, check for null termination
    if (!stringData[length - 1]) length -= 1;
    return [[NSString alloc] initWithBytes:stringData length:length encoding:NSASCIIStringEncoding];
}

+ (NSUInteger)parseUInt32:(char *)data length:(NSUInteger)length {
    NSUInteger output = 0;
    for (NSInteger i = 0; i < length; i++) {
        output += (unsigned char)data[i] << (i * 8);
    }
    return output;
}

+ (NSUInteger)parseUInt8:(char *)data {
    return [self parseUInt32:data length:1];
}

+ (NSUInteger)parseUInt16:(char *)data {
    return [self parseUInt32:data length:2];
}

+ (NSUInteger)parseUInt32:(char *)data {
    return [self parseUInt32:data length:4];
}

+ (NSInteger)parseInt32:(char *)data {
    return (NSInteger)[self parseUInt32:data];
}

+ (double)parseTemp:(char *)data {
    NSInteger tempInteger = [self parseInt32:data];
    return ((double)tempInteger / 1000000);
}

+ (BOOL)parseBool:(char *)data {
    if (data[0] & 0xFF) return YES;
    else return NO;
}

+ (void)writeUInt:(NSUInteger)value data:(char *)data length:(NSUInteger)length {
    for (NSInteger i = 0; i < length; i++) {
        // The least significant bits go first
        data[i] = value >> (i * 8) & 0xFF;
    }
}

+ (void)writeUInt8:(NSUInteger)value data:(char *)data {
    [self writeUInt:value data:data length:1];
}

+ (void)writeUInt16:(NSUInteger)value data:(char *)data {
    [self writeUInt:value data:data length:2];
}

+ (void)writeUInt32:(NSUInteger)value data:(char *)data {
    [self writeUInt:value data:data length:4];
}

+ (void)writeInt32:(NSInteger)value data:(char *)data {
    [self writeUInt32:(NSUInteger)value data:data];
}

+ (void)writeBool:(BOOL)value data:(char *)data {
    *data = value ? 1 : 0;
}

+ (void)writeCRCFromData:(char *)data length:(NSUInteger)length {
    crc_t calculatedCRC = crc_init();
    calculatedCRC = crc_update(calculatedCRC, (unsigned char *)data, length);
    [self writeUInt16:calculatedCRC data:&data[length]];
}

@end
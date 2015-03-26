//
// KBKegboardUtils.h
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

/*!
 Utility classes for KBKegboard serial communication.
 NOTE: This could just as well be made into c-style functions instead of class methods. It's just a matter of syntax preference.
 */
@interface KBKegboardUtils : NSObject

+ (NSString *)parseString:(char *)stringData length:(NSUInteger)length;
+ (NSUInteger)parseUInt32:(char *)data length:(NSUInteger)length;
+ (NSUInteger)parseUInt8:(char *)data;
+ (NSUInteger)parseUInt16:(char *)data;
+ (NSUInteger)parseUInt32:(char *)data;
+ (NSInteger)parseInt32:(char *)data;
+ (double)parseTemp:(char *)data;
+ (BOOL)parseBool:(char *)data;
+ (void)writeUInt:(NSUInteger)value data:(char *)data length:(NSUInteger)length;
+ (void)writeUInt8:(NSUInteger)value data:(char *)data;
+ (void)writeUInt16:(NSUInteger)value data:(char *)data;
+ (void)writeUInt32:(NSUInteger)value data:(char *)data;
+ (void)writeInt32:(NSInteger)value data:(char *)data;
+ (void)writeBool:(BOOL)value data:(char *)data;
+ (void)writeCRCFromData:(char *)data length:(NSUInteger)length;

@end
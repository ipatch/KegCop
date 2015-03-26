//
// KBKegboardCommand.h
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

#import "KBKegboardMessage.h"

typedef enum {
    KBKegboardOutputTypeDisabled = 0,
    KBKegboardOutputTypeEnabled = 1,
} KBKegboardOutputType;

/*!
 Abstract base class for objects representing a message that will be passed to a Kegboard using the Kegboard Serial Protocol (KBSP).
 */
@interface KBKegboardCommand : KBKegboardMessage {}
@property (readonly, assign, nonatomic) char *bytes;
@property (readonly, assign, nonatomic) NSUInteger length;

// Subclasses must override this method
+ (NSUInteger)messageId;

// Subclasses must override this method
- (NSUInteger)payloadLength;

// Subclasses must override this method
- (void)writePayload:(char *)data;

@end

@interface KBKegboardCommandPing : KBKegboardCommand {}

+ (KBKegboardCommandPing *)kegboardCommandPing;

@end

@interface KBKegboardCommandSetOutput : KBKegboardCommand {}
@property (readonly, assign, nonatomic) NSUInteger outputId;
@property (readonly, assign, nonatomic) KBKegboardOutputType outputMode;

+ (KBKegboardCommandSetOutput *)kegboardCommandSetOutputWithOutputId:(NSUInteger)outputId outputMode:(KBKegboardOutputType)outputMode;

@end
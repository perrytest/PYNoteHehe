//
//  NSString+Encode.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/2.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "NSString+Encode.h"
#import "AESCrypt.h"



@implementation NSString (Encode)

- (NSString *)encodeString {
    NSString *oldString = [self copy];
    NSString *encodeString = [AESCrypt encrypt:oldString password:[PYCoreDataController sharedInstance].dataKeyString];
    return encodeString;
}

- (NSString *)decodeString {
    NSString *oldString = [self copy];
    NSString *encodeString = [AESCrypt decrypt:oldString password:[PYCoreDataController sharedInstance].dataKeyString];
    return encodeString;
}

@end

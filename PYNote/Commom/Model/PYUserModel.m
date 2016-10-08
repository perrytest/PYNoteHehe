//
//  PYUserModel.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYUserModel.h"


@implementation PYUserModel

- (void)convertInfoToUser:(User **)user {
    NSArray *properties = [self filterDemandPropertys];
    for (NSString *key in properties) {
        id value = [self valueForKey:key];
        [*user setValue:value forKey:key];
//        if ([value isKindOfClass:[NSString class]]) {
//            NSString *willEncodeValue = [value copy];
//            NSString *encodeValue = [willEncodeValue encodeString];
//            [*user setValue:encodeValue forKey:key];
//        } else if ([value isKindOfClass:[NSData class]]) {
////            NSString *willEncodeValue = [value copy];
////            NSString *encodeValue = [willEncodeValue encodeString];
//            [*user setValue:value forKey:key];
//        } else {
//            [*user setValue:value forKey:key];
//        }
    }
}


+ (instancetype)convertFromUser:(User *)user {
    PYUserModel *userModel = [[PYUserModel alloc] init];
    NSArray *properties = [userModel filterDemandPropertys];
    for (NSString *key in properties) {
        id value = [user valueForKey:key];
        [userModel setValue:value forKey:key];
//        if ([value isKindOfClass:[NSString class]]) {
//            NSString *willDecodeValue = [value copy];
//            NSString *decodeValue = [willDecodeValue decodeString];
//            [userModel setValue:decodeValue forKey:key];
//        } else if ([value isKindOfClass:[NSData class]]) {
//            [userModel setValue:value forKey:key];
//        } else {
//            [userModel setValue:value forKey:key];
//        }
    }
    return userModel;
}

- (BOOL)isUserValid {
    if (self.name && self.name.length>0 && self.pwd_s && self.pwd_s.length>0) {
        return YES;
    }
    return NO;
}

- (BOOL)isUserRegistValid {
    if ([self isUserValid]) {
        BOOL isExist = NO;
        if (self.name && self.name.length>0) {
            isExist = [[PYCoreDataController sharedInstance] isExistUser:self.name];
            if (isExist) return NO;
        }
        if (self.cardId && self.cardId.length>0) {
            isExist = [[PYCoreDataController sharedInstance] isExistUser:self.cardId];
            if (isExist) return NO;
        }
        if (self.phone && self.phone.length>0) {
            isExist = [[PYCoreDataController sharedInstance] isExistUser:self.phone];
            if (isExist) return NO;
        }
        if (self.email && self.email.length>0) {
            isExist = [[PYCoreDataController sharedInstance] isExistUser:self.email];
            if (isExist) return NO;
        }
        return YES;
    }
    return NO;
}


@end

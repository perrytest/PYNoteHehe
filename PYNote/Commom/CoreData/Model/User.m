//
//  User.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/23.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "User.h"
#import "Account.h"
#import "Question.h"
#import "Base64.h"

@implementation User

- (NSTimeInterval)lockTimeInterval {
    NSTimeInterval validTimeInterval = [self.lockTime doubleValue]!=0?[self.lockTime doubleValue]:60*15;
    return validTimeInterval;
}

- (NSTimeInterval)darkLockTimeInterval {
    NSTimeInterval validTimeInterval = [self.lockTime doubleValue]!=0?[self.lockTime doubleValue]:60*60*24*3;
    return validTimeInterval;
}

- (NSInteger)limitTimes {
    NSInteger times = [self.maxTry integerValue]!=0?[self.maxTry integerValue]:5;
    return times;
}


#pragma mark - Public

- (void)refreshAuthToken {
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *tokenString = [NSString stringWithFormat:@"%@@%@", self.userId, timeString];
    NSString *newToken = [tokenString base64EncodedString];
    self.token = newToken;
    self.lastAt = [NSDate date];
    self.wrongTimes = @(0);
}

- (void)deleteAuthToken {
    self.token = nil;
}

- (BOOL)isTokenValid {
    if (self.token && self.token.length>0) {
        NSString *tokenString = [self.token base64DecodedString];
        NSArray *items = [tokenString componentsSeparatedByString:@"@"];
        NSString *timeString = items[1];
        NSDate *tokenDate = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:tokenDate];
        if (timeInterval>0 && timeInterval < [self lockTimeInterval]) {
            return YES;
        }
    }
    return NO;
}

//token失效，需要密码登录
- (BOOL)isTokenLock {
    if (self.token && self.token.length>0) {
        NSString *tokenString = [self.token base64DecodedString];
        NSArray *items = [tokenString componentsSeparatedByString:@"@"];
        NSString *timeString = items[1];
        NSDate *tokenDate = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:tokenDate];
        if (timeInterval>0 && timeInterval < [self darkLockTimeInterval]) {
            return NO;
        }
        self.token = nil;
    }
    return YES;
}

- (UserAuthType)authType {
    UserAuthType lockType = (UserAuthType)[self.lockType integerValue];
    if (self.token && self.token.length>0 && (![self isTokenLock])) {
        switch (lockType) {
            case UserAuthType_CheckID:
                return UserAuthType_CheckID;
                break;
            case UserAuthType_Login:
                return UserAuthType_Login;
                break;
            case UserAuthType_Gesture:
                return UserAuthType_Gesture;
                break;
            case UserAuthType_Easy:
                return UserAuthType_Easy;
                break;
            case UserAuthType_None:
                if (self.pwd_e && self.pwd_e.length>0) {
                    return UserAuthType_Easy;
                } else if (self.pwd_g && self.pwd_g.length>0) {
                    return UserAuthType_Gesture;
                } else {
                    return UserAuthType_Login;
                }
                break;
            default:
                return UserAuthType_Login;
                break;
        }
    } else {
        if (lockType == UserAuthType_CheckID) {
            return lockType;
        } else {
            return UserAuthType_Login;
        }
    }
}

- (void)addLoginTryWrongTimes {
    NSInteger times = [self.wrongTimes integerValue]+1;
    if (times>[self limitTimes]) {
        UserAuthType authType = [self authType];
        if (authType == UserAuthType_Login) {
            self.lockType = @(UserAuthType_CheckID);
        } else {
            self.lockType = @(UserAuthType_Login);
        }
        self.wrongTimes = @(0);
    } else {
        self.wrongTimes = @(times);
    }
    
}

- (BOOL)checkLoginPassword:(NSString *)pwd {
    if ([self.pwd_s isEqualToString:pwd]) {
        return YES;
    } else {
        [self addLoginTryWrongTimes];
        return NO;
    }
}

- (NSString *)avatarPath {
    if (self.avator && self.avator.length>0) {
        NSString *avatarFilePath = [[PYTools getResourceDirectoryPathForUser:self.userId] stringByAppendingPathComponent:self.avator];
        if ([[NSFileManager defaultManager] fileExistsAtPath:avatarFilePath]) {
            return avatarFilePath;
        } else {
            self.avator = nil;
            [[PYCoreDataController sharedInstance] saveContext];
            return nil;
        }
    }
    return nil;
}

@end

//
//  Account.m
//  PYNote
//
//  Created by kingnet on 16/5/13.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "Account.h"
#import "RelateApp.h"
#import "RelateData.h"
#import "User.h"

@implementation Account

- (AccountType)accountType
{
    [self willAccessValueForKey:@"accountType"];
    NSNumber *tempValue = [self type];
    [self didAccessValueForKey:@"accountType"];
    return (tempValue != nil) ? [tempValue intValue] : AccountType_Other;
}

- (void)setAccountType:(AccountType)accountType {
    NSNumber *temp = @(accountType);
    [self willChangeValueForKey:@"accountType"];
    [self setType:temp];
    [self didChangeValueForKey:@"accountType"];
}

@end

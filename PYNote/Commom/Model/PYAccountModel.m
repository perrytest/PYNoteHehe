//
//  PYAccountModel.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYAccountModel.h"
#import "Account.h"
#import <objc/runtime.h>

@implementation PYAccountModel


- (void)convertInfoToAccout:(Account * _Nonnull * _Nonnull)accoutData {
    NSArray *properties = [self filterDemandPropertys];
    for (NSString *key in properties) {
        id value = [self valueForKey:key];
        [*accoutData setValue:value forKey:key];
    }
}


- (AccountType)accountType
{
    NSNumber *tempValue = [self type];
    return (tempValue != nil) ? [tempValue intValue] : AccountType_Other;
}

- (void)setAccountType:(AccountType)accountType {
    NSNumber *temp = @(accountType);
    [self willChangeValueForKey:@"accountType"];
    [self setType:temp];
    [self didChangeValueForKey:@"accountType"];
}


@end
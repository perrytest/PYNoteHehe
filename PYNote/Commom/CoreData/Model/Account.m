//
//  Account.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/23.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "Account.h"
#import "Question.h"
#import "RelateApp.h"
#import "RelateData.h"
#import "User.h"

@implementation Account

// Insert code here to add functionality to your managed object subclass

- (NSString *)accountTitle {
    if (self.keyword && self.keyword.length>0) {
        return [NSString stringWithFormat:@"%@", self.keyword];
    } else {
        return [NSString stringWithFormat:@"%@", self.account];
    }
}

- (AccountType)accountType {
    NSNumber *tempValue = [self type];
    return (tempValue != nil) ? [tempValue intValue] : AccountType_Unknown;
}

@end

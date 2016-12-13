//
//  Account.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/23.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question, RelateApp, RelateData, User;


typedef enum {
    AccountType_Unknown = 0,
    AccountType_BankCard = 1,  //银行卡
    AccountType_Email = 2,     //邮箱
} AccountType;

NS_ASSUME_NONNULL_BEGIN

@interface Account : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (NSString *)accountTitle;

- (AccountType)accountType;

@end

NS_ASSUME_NONNULL_END

#import "Account+CoreDataProperties.h"

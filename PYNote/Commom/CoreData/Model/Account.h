//
//  Account.h
//  PYNote
//
//  Created by kingnet on 16/5/13.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RelateApp, RelateData, User;

typedef enum {
    AccountType_BankCard = 0,  //银行卡
    AccountType_Email = 1,     //邮箱
    AccountType_App = 2,       //app帐号
    AccountType_Other = 3,     //其它
} AccountType;

NS_ASSUME_NONNULL_BEGIN

@interface Account : NSManagedObject

@property (nonatomic, assign) AccountType accountType;

@end

NS_ASSUME_NONNULL_END

#import "Account+CoreDataProperties.h"

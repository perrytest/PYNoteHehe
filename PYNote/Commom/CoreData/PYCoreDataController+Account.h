//
//  PYCoreDataController+Account.h
//  PYNote
//
//  Created by kingnet on 16/12/6.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYCoreDataController.h"
#import "Account.h"

@interface PYCoreDataController (Account)

/*
 * 查询Account
 * account 查询key值 account | keyword | name | nick
 */
- (NSArray *)searchAccount:(NSString *)account;

/*
 * 删除Account
 * account Account账号dataModel
 */
- (BOOL)deleteAccountData:(Account *)account;

@end

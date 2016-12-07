//
//  PYCoreDataController+User.h
//  PYNote
//
//  Created by kingnet on 16/5/16.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYCoreDataController.h"
#import "User.h"

@interface PYCoreDataController (User)

//查询用户

/*
 * 查询用户
 * userName 查询key值 name | cardId | phone | email
 */
- (User *)searchUser:(NSString *)userName;

- (BOOL)isExistUser:(NSString *)userName;

/*
 * 查询用户
 * userID 查询userID
 */
- (User *)userWithUserID:(NSString *)userID;

/*
 * 删除用户
 * user User用户dataModel
 */
- (BOOL)deleteUserData:(User *)user;

@end

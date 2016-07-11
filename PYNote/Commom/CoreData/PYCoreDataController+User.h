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
- (User *)searchUser:(NSString *)userName;

- (User *)userWithUserID:(NSString *)userID;

@end

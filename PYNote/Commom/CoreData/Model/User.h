//
//  User.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/23.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "PYUserModel.h"

typedef enum {
    UserAuthType_None = 0,        //授权有效
    UserAuthType_Gesture = 1,     //手势解锁授权
    UserAuthType_Easy = 2,        //简单密码授权
    UserAuthType_Login = 3,       //重新登录授权
    UserAuthType_CheckID = 4,     //重新验证身份
} UserAuthType;

@class Account, Question;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

//刷新授权token
- (void)refreshAuthToken;
- (void)deleteAuthToken;

//判断授权token是否有效
- (BOOL)isTokenValid;
//判断授权方式
- (UserAuthType)authType;

- (void)addLoginTryWrongTimes;

- (BOOL)checkLoginPassword:(NSString *)pwd;




@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"

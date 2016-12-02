//
//  PYUserModel.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYBaseModel.h"
#import "PYAccountModel.h"
#import "PYQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYUserModel : PYBaseModel

@property (nullable, nonatomic, copy) NSString *address; //地址
@property (nullable, nonatomic, copy) NSString *avator;
@property (nullable, nonatomic, copy) NSString *cardId; // 身份证件
@property (nullable, nonatomic, copy) NSDate *creatAt;
@property (nullable, nonatomic, copy) NSString *email; //email
@property (nullable, nonatomic, copy) NSDate *lastAt;
@property (nullable, nonatomic, copy) NSNumber *limit;
@property (nullable, nonatomic, copy) NSNumber *locDarkTime;
@property (nullable, nonatomic, copy) NSNumber *lockTime;
@property (nullable, nonatomic, copy) NSNumber *lockType;
@property (nullable, nonatomic, copy) NSString *motto; // 座右铭
@property (nullable, nonatomic, copy) NSString *name; // 姓名
@property (nullable, nonatomic, copy) NSString *nameNick; // 昵称
@property (nullable, nonatomic, copy) NSString *notice; // 备注
@property (nullable, nonatomic, copy) NSString *phone; // 手机号
@property (nullable, nonatomic, copy) NSString *pwd_e;
@property (nullable, nonatomic, copy) NSString *pwd_g;
@property (nullable, nonatomic, copy) NSString *pwd_notice; // 密码备注
@property (nullable, nonatomic, copy) NSString *pwd_s; // 密码
@property (nullable, nonatomic, copy) NSString *qq; // QQ
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSString *userId;


- (void)convertInfoToUser:(User * _Nonnull * _Nonnull)user;

+ (instancetype)convertFromUser:(User * _Nonnull)user;


- (BOOL)isUserValid;

- (BOOL)isUserRegistValid;

@end

NS_ASSUME_NONNULL_END

//
//  PYAccountModel.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYBaseModel.h"
#import "PYRelateDataModel.h"
#import "PYRelateAppModel.h"
#import "PYQuestionModel.h"

typedef enum {
    AccountType_Unknown = 0,
    AccountType_BankCard = 1,  //银行卡
    AccountType_Email = 2,     //邮箱
} AccountType;


@interface PYAccountModel : PYBaseModel


@property (nullable, nonatomic, copy) NSString *accountId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nick;
@property (nullable, nonatomic, copy) NSDate *creatAt;
@property (nullable, nonatomic, copy) NSDate *updateAt;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *keyword;
@property (nullable, nonatomic, copy) NSString *account;
@property (nullable, nonatomic, copy) NSString *pwd;
@property (nullable, nonatomic, copy) NSString *pwd_notice;
@property (nullable, nonatomic, copy) NSString *pwd_g;

@property (nullable, nonatomic, copy) NSNumber *type;
@property (nonatomic, assign) AccountType accountType;

//@property (nonatomic, weak) PYUserModel *user;
//@property (nullable, nonatomic, retain) NSSet<PYRelateDataModel *> *accRelate;
//@property (nullable, nonatomic, retain) NSSet<PYRelateAppModel *> *appList;
//@property (nullable, nonatomic, retain) NSSet<PYQuestionModel *> *safety;



//- (void)addAccRelateObject:(RelateData *)value;
//- (void)removeAccRelateObject:(RelateData *)value;
//- (void)addAccRelate:(NSSet<RelateData *> *)values;
//- (void)removeAccRelate:(NSSet<RelateData *> *)values;
//
//- (void)addAppListObject:(RelateApp *)value;
//- (void)removeAppListObject:(RelateApp *)value;
//- (void)addAppList:(NSSet<RelateApp *> *)values;
//- (void)removeAppList:(NSSet<RelateApp *> *)values;
//
//- (void)addSafetyObject:(Question *)value;
//- (void)removeSafetyObject:(Question *)value;
//- (void)addSafety:(NSSet<Question *> *)values;
//- (void)removeSafety:(NSSet<Question *> *)values;

- (void)convertInfoToAccout:(Account * _Nonnull * _Nonnull)accoutData;

@end

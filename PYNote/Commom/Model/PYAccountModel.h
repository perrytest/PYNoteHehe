//
//  PYAccountModel.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYBaseModel.h"
#import "PYRelateDataModel.h"
#import "PYAppProxy.h"
#import "PYQuestionModel.h"
#import "Account.h"


NS_ASSUME_NONNULL_BEGIN

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
@property (nullable, nonatomic, copy) NSString *url;

@property (nullable, nonatomic, copy) NSNumber *type;
@property (nonatomic, assign) AccountType accountType;

//@property (nonatomic, weak) PYUserModel *user;
@property (nullable, nonatomic, retain) NSSet<PYRelateDataModel *> *accRelate;
@property (nullable, nonatomic, retain) NSSet<PYAppProxy *> *appList;
@property (nullable, nonatomic, retain) NSSet<PYQuestionModel *> *safety;



//- (void)addAccRelateObject:(PYRelateDataModel *)value;
//- (void)removeAccRelateObject:(PYRelateDataModel *)value;
//- (void)addAccRelate:(NSSet<PYRelateDataModel *> *)values;
//- (void)removeAccRelate:(NSSet<PYRelateDataModel *> *)values;

//- (void)addAppListObject:(PYAppProxy *)value;
//- (void)removeAppListObject:(PYAppProxy *)value;
//- (void)addAppList:(NSSet<PYAppProxy *> *)values;
//- (void)removeAppList:(NSSet<PYAppProxy *> *)values;

//- (void)addSafetyObject:(PYQuestionModel *)value;
//- (void)removeSafetyObject:(PYQuestionModel *)value;
//- (void)addSafety:(NSSet<PYQuestionModel *> *)values;
//- (void)removeSafety:(NSSet<PYQuestionModel *> *)values;

- (void)convertInfoToAccout:(Account * _Nonnull * _Nonnull)accoutData;

@end

NS_ASSUME_NONNULL_END

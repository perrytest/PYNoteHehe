//
//  Account+CoreDataProperties.h
//  PYNote
//
//  Created by kingnet on 16/5/13.
//  Copyright © 2016年 perry. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface Account (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *accountId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *nick;
@property (nullable, nonatomic, retain) NSDate *creatAt;
@property (nullable, nonatomic, retain) NSDate *updateAt;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *keyword;
@property (nullable, nonatomic, retain) NSString *account;
@property (nullable, nonatomic, retain) NSString *pwd;
@property (nullable, nonatomic, retain) NSString *pwd_notice;
@property (nullable, nonatomic, retain) NSString *pwd_g;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) User *user;
@property (nullable, nonatomic, retain) NSSet<RelateData *> *accRelate;
@property (nullable, nonatomic, retain) NSSet<RelateApp *> *appList;
@property (nullable, nonatomic, retain) NSSet<Question *> *safety;

@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addAccRelateObject:(RelateData *)value;
- (void)removeAccRelateObject:(RelateData *)value;
- (void)addAccRelate:(NSSet<RelateData *> *)values;
- (void)removeAccRelate:(NSSet<RelateData *> *)values;

- (void)addAppListObject:(RelateApp *)value;
- (void)removeAppListObject:(RelateApp *)value;
- (void)addAppList:(NSSet<RelateApp *> *)values;
- (void)removeAppList:(NSSet<RelateApp *> *)values;

- (void)addSafetyObject:(Question *)value;
- (void)removeSafetyObject:(Question *)value;
- (void)addSafety:(NSSet<Question *> *)values;
- (void)removeSafety:(NSSet<Question *> *)values;

@end

NS_ASSUME_NONNULL_END

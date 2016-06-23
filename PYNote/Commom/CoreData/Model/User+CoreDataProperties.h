//
//  User+CoreDataProperties.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/23.
//  Copyright © 2016年 perry. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *avator;
@property (nullable, nonatomic, retain) NSString *cardId;
@property (nullable, nonatomic, retain) NSDate *creatAt;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSDate *lastAt;
@property (nullable, nonatomic, retain) NSNumber *limit;
@property (nullable, nonatomic, retain) NSNumber *locDarkTime;
@property (nullable, nonatomic, retain) NSNumber *lockTime;
@property (nullable, nonatomic, retain) NSNumber *lockType;
@property (nullable, nonatomic, retain) NSString *motto;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *nameNick;
@property (nullable, nonatomic, retain) NSString *notice;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *pwd_e;
@property (nullable, nonatomic, retain) NSString *pwd_g;
@property (nullable, nonatomic, retain) NSString *pwd_notice;
@property (nullable, nonatomic, retain) NSString *pwd_s;
@property (nullable, nonatomic, retain) NSString *qq;
@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSSet<Account *> *accounts;
@property (nullable, nonatomic, retain) NSSet<Question *> *safety;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet<Account *> *)values;
- (void)removeAccounts:(NSSet<Account *> *)values;

- (void)addSafetyObject:(Question *)value;
- (void)removeSafetyObject:(Question *)value;
- (void)addSafety:(NSSet<Question *> *)values;
- (void)removeSafety:(NSSet<Question *> *)values;

@end

NS_ASSUME_NONNULL_END

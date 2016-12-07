//
//  PYCoreDataController+Account.m
//  PYNote
//
//  Created by kingnet on 16/12/6.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYCoreDataController+Account.h"
#import "RelateData.h"
#import "RelateApp.h"
#import "Question.h"
#import "PYCoreDataController+Other.h"

static NSString *AccountTableName = @"Account";

@implementation PYCoreDataController (Account)

#pragma mark - Search

- (NSArray *)searchAccount:(NSString *)account {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:AccountTableName inManagedObjectContext:context];
    NSPredicate *accountPredicate = [NSPredicate predicateWithFormat:@"account=%@ || keyword=%@ || name=%@ || nick=%@", account, account, account, account];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setFetchLimit:1];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:accountPredicate];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count >= 1) {
        return fetchedObjects;
    }
    return nil;
}

#pragma mark - Delete

- (BOOL)deleteAccountData:(Account *)account {
    //删除相关数据
    NSArray *relateDataList = [account.accRelate allObjects];
    for (RelateData *relateData in relateDataList) {
        [self deleteRelateDataData:relateData];
    }
    //删除关联app
    NSArray *relateAppList = [account.appList allObjects];
    for (RelateApp *relateApp in relateAppList) {
        [self deleteRelateAppData:relateApp];
    }
    //删除密保问题
    NSArray *safetyList = [account.safety allObjects];
    for (Question *safety in safetyList) {
        [self deleteQuestionData:safety];
    }
    //删除帐号
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:account];
    return YES;
}

@end

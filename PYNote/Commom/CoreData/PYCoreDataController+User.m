//
//  PYCoreDataController+User.m
//  PYNote
//
//  Created by kingnet on 16/5/16.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYCoreDataController+User.h"
#import "Account.h"
#import "PYCoreDataController+Account.h"
#import "Question.h"
#import "PYCoreDataController+Other.h"

static NSString *UserTableName = @"User";

@implementation PYCoreDataController (User)

#pragma mark - Search

- (NSArray <User *> *)allUserList {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:UserTableName];
    [request setSortDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ]];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSArray *users = [context executeFetchRequest:request error:nil];
    return users;
}

- (User *)searchUser:(NSString *)userName {
    if (userName && userName.length>0) {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:UserTableName inManagedObjectContext:context];
        NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"name=%@ || cardId=%@ || phone=%@ || email=%@", userName, userName, userName, userName];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setFetchLimit:1];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:userPredicate];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        if (fetchedObjects.count == 1) {
            return fetchedObjects[0];
        }
    }
    return nil;
}

- (BOOL)isExistUser:(NSString *)userName {
    if (userName && userName.length>0) {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:UserTableName inManagedObjectContext:context];
        NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"name=%@ || cardId=%@ || phone=%@ || email=%@", userName, userName, userName, userName];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setFetchLimit:1];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:userPredicate];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        if (fetchedObjects.count >= 1) {
            return YES;
        }
    }
    return NO;
}

- (User *)userWithUserID:(NSString *)userID {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:UserTableName inManagedObjectContext:context];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"userId==%@", userID];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchLimit:1];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:userPredicate];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 1) {
        return fetchedObjects[0];
    }
    return nil;
}

#pragma mark - Delete

- (BOOL)deleteUserData:(User *)user {
    //删除该用户保存的account信息
    NSArray *accoutList = [user.accounts allObjects];
    for (Account *account in accoutList) {
        [self deleteAccountData:account];
    }
    //删除该用户的密保问题
    NSArray *safetyList = [user.safety allObjects];
    for (Question *safety in safetyList) {
        [self deleteQuestionData:safety];
    }
    //删除用户
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:user];
    [self saveContext];
    return YES;
}

@end

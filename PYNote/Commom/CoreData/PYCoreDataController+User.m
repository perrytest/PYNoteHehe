//
//  PYCoreDataController+User.m
//  PYNote
//
//  Created by kingnet on 16/5/16.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYCoreDataController+User.h"

static NSString *UserTableName = @"User";

@implementation PYCoreDataController (User)

- (User *)searchUser:(NSString *)userName {
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
    return nil;
}

- (BOOL)isExistUser:(NSString *)userName {
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

@end

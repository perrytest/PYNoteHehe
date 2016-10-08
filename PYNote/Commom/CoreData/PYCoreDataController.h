//
//  PYCoreDataController.h
//  PYMemorandum
//
//  Created by perry on 14-8-13.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PYCoreDataController : NSObject

@property (nonatomic, copy) NSString *dataKeyString;

+ (PYCoreDataController *)sharedInstance;

- (NSURL *)sourceStoreURL;

- (void)saveContext;

@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

//
//  PYCoreDataController.m
//  PYMemorandum
//
//  Created by perry on 14-8-13.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import "PYCoreDataController.h"

static PYCoreDataController *sharedInstance = nil;

@implementation PYCoreDataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (PYCoreDataController *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}


#pragma mark - Public


- (void)saveContext {
    if (self.managedObjectContext != nil) {
        if (app.activeUser) {
            [app.activeUser refreshAuthToken];
        }
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Accessor

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    _managedObjectContext.persistentStoreCoordinator = coordinator;
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSString *momPath = [[NSBundle mainBundle] pathForResource:@"PYNote"
                                                        ofType:@"momd"];
    
    NSURL *url = [NSURL fileURLWithPath:momPath];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:[self sourceStoreURL]
                                                         options:options
                                                           error:&error]) {
        
        NSLog(@"error: %@", error);
        
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"数据失效", @"")
                                    message:error.localizedDescription
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"退出", @"")
                          otherButtonTitles:NSLocalizedString(@"删除数据", @""), nil] show];
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)sourceStoreURL
{
    return [[PYTools URLForDocumentsDirectory] URLByAppendingPathComponent:@"PYNote.sqlite"];
}


- (NSDictionary *)sourceMetadata:(NSError **)error
{
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                      URL:[self sourceStoreURL]
                                                                    error:error];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self sourceStoreURL].path error:nil];
    } else {
        abort();
    }
}


@end

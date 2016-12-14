//
//  PYCoreDataController.m
//  PYMemorandum
//
//  Created by perry on 14-8-13.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import "PYCoreDataController.h"
#import "EncryptedStore.h"


#define XOR_KEY 0xB2

static NSString *encodeKey = @"PYNoteTestKey";

NSData *PYEncodeString() {
    unsigned char str5[] = {
        (XOR_KEY ^ 'P'),
        (XOR_KEY ^ 'X'),
        (XOR_KEY ^ 'O'),
        (XOR_KEY ^ 'n'),
        (XOR_KEY ^ 'u'),
        (XOR_KEY ^ 'd'),
        (XOR_KEY ^ 'U'),
        (XOR_KEY ^ 'd'),
        (XOR_KEY ^ 'r'),
        (XOR_KEY ^ 'u'),
        (XOR_KEY ^ 'J'),
        (XOR_KEY ^ 'd'),
        (XOR_KEY ^ 'x'),
        (XOR_KEY ^ '\0')};
    unsigned char *p = str5;
    while( ((*p) ^=  XOR_KEY) != '\0'){
        p++;
    }
    NSString *string = [NSString stringWithFormat:@"%s", str5];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

NSString *keyDataEncode(NSData * data) {
    char *dataP = (char *)[data bytes];
    for (int i = 0; i < data.length; i++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        *dataP = *(++dataP) ^ 1;
#pragma clang diagnostic pop
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


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
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataKeyString = keyDataEncode(PYEncodeString());
    }
    return self;
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
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = coordinator;
    _managedObjectContext.mergePolicy = NSErrorMergePolicy;
    
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
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              EncryptedStorePassphraseKey: self.dataKeyString,
                              EncryptedStoreDatabaseLocation: [self sourceStoreURL],
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:EncryptedStoreType//NSSQLiteStoreType//
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
    
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[self sourceStorePath] error:&error]) {
        NSAssert(error != nil, @"%@ in data protect the database", [error description]);
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)sourceStoreURL
{
    return [[PYTools URLForDocumentsDirectory] URLByAppendingPathComponent:@"PYNote.sqlite"];
}

- (NSString *)sourceStorePath {
    return [[PYTools getDocumentDirectoryPath] stringByAppendingPathComponent:@"PYNote.sqlite"];
}

- (NSDictionary *)sourceMetadata:(NSError **)error
{
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:EncryptedStoreType
                                                                      URL:[self sourceStoreURL]
                                                                    error:error];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self sourceStoreURL].path error:nil];
    }
    abort();
}


@end

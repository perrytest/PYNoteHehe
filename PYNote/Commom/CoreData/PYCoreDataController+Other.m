//
//  PYCoreDataController+Other.m
//  PYNote
//
//  Created by kingnet on 16/12/6.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYCoreDataController+Other.h"

@implementation PYCoreDataController (Other)


#pragma mark - Delete

- (BOOL)deleteRelateAppData:(RelateApp *)relateApp {
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:relateApp];
    return YES;
}

- (BOOL)deleteRelateDataData:(RelateData *)relateData {
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:relateData];
    return YES;
}

- (BOOL)deleteQuestionData:(Question *)questionData {
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:questionData];
    return YES;
}

@end

//
//  RelateApp+CoreDataProperties.h
//  PYNote
//
//  Created by kingnet on 16/5/13.
//  Copyright © 2016年 perry. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RelateApp.h"

NS_ASSUME_NONNULL_BEGIN

@interface RelateApp (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bundleId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *version;

@end

NS_ASSUME_NONNULL_END

//
//  RelateData+CoreDataProperties.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/23.
//  Copyright © 2016年 perry. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RelateData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RelateData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *content;
@property (nullable, nonatomic, retain) NSString *file;
@property (nullable, nonatomic, retain) NSString *ps;
@property (nullable, nonatomic, retain) NSString *reId;

@end

NS_ASSUME_NONNULL_END

//
//  Question+CoreDataProperties.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/23.
//  Copyright © 2016年 perry. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface Question (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *answer;
@property (nullable, nonatomic, retain) NSString *answerNotice;
@property (nullable, nonatomic, retain) NSString *question;

@end

NS_ASSUME_NONNULL_END

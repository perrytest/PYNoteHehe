//
//  PYQuestionModel.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYQuestionModel.h"
#import "Question.h"

@implementation PYQuestionModel

- (void)convertInfoToQuestion:(Question * _Nonnull * _Nonnull)questionData {
    NSArray *properties = [self filterDemandPropertys];
    for (NSString *key in properties) {
        id value = [self valueForKey:key];
        [*questionData setValue:value forKey:key];
    }
}

@end

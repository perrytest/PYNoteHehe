//
//  PYQuestionModel.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYBaseModel.h"
@class Question;

NS_ASSUME_NONNULL_BEGIN

@interface PYQuestionModel : PYBaseModel

@property (nullable, nonatomic, retain) NSString *answer;
@property (nullable, nonatomic, retain) NSString *answerNotice;
@property (nullable, nonatomic, retain) NSString *question;

- (void)convertInfoToQuestion:(Question * _Nonnull * _Nonnull)questionData;

@end

NS_ASSUME_NONNULL_END

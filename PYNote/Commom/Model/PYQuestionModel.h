//
//  PYQuestionModel.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYBaseModel.h"

@interface PYQuestionModel : PYBaseModel

@property (nullable, nonatomic, retain) NSString *answer;
@property (nullable, nonatomic, retain) NSString *answerNotice;
@property (nullable, nonatomic, retain) NSString *question;

@end

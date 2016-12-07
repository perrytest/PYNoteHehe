//
//  PYCoreDataController+Other.h
//  PYNote
//
//  Created by kingnet on 16/12/6.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYCoreDataController.h"
#import "RelateApp.h"
#import "RelateData.h"
#import "Question.h"

@interface PYCoreDataController (Other)

/*
 * 删除RelateApp
 * relateApp RelateApp
 */
- (BOOL)deleteRelateAppData:(RelateApp *)relateApp;

/*
 * 删除RelateData
 * relateData RelateData
 */
- (BOOL)deleteRelateDataData:(RelateData *)relateData;

/*
 * 删除密保问题
 * questionData Question
 */
- (BOOL)deleteQuestionData:(Question *)questionData;



@end

//
//  PYRelateDataModel.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYBaseModel.h"

@interface PYRelateDataModel : PYBaseModel

@property (nullable, nonatomic, retain) NSData *content;
@property (nullable, nonatomic, retain) NSString *file;
@property (nullable, nonatomic, retain) NSString *ps;
@property (nullable, nonatomic, retain) NSString *reId;

@end

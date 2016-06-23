//
//  PYRelateAppModel.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYBaseModel.h"

@interface PYRelateAppModel : PYBaseModel

@property (nullable, nonatomic, retain) NSString *bundleId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *version;

@end

//
//  PYRelateDataModel.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYRelateDataModel.h"
#import "RelateData.h"

@implementation PYRelateDataModel

- (void)convertInfoToData:(RelateData * _Nonnull * _Nonnull)data {
    NSArray *properties = [self filterDemandPropertys];
    for (NSString *key in properties) {
        id value = [self valueForKey:key];
        [*data setValue:value forKey:key];
    }
}

@end

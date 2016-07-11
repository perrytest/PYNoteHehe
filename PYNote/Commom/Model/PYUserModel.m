//
//  PYUserModel.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYUserModel.h"


@implementation PYUserModel

- (void)convertInfoToUser:(User **)user {
    NSArray *properties = [self filterDemandPropertys];
    for (NSString *key in properties) {
        id value = [self valueForKey:key];
        [*user setValue:value forKey:key];
    }
}

@end

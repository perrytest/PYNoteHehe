//
//  PYBaseModel.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYBaseModel.h"
#import <objc/runtime.h>

@implementation PYBaseModel

- (NSArray *)filterDemandPropertys {
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        if ([self isDemandProperty:property]) {
            const char *char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            [props addObject:propertyName];
        }
    }
    free(properties);
    return props;
}

- (BOOL)isDemandProperty:(objc_property_t)property {
    const char *char_f = property_getName(property);
    const char *char_a = property_getAttributes(property);
    NSString *attributes = [NSString stringWithUTF8String:char_a];
    printf("\nIgnore====%s:%s", char_f, char_a);
    if ([attributes rangeOfString:@"<Ignore>"].location != NSNotFound || [attributes rangeOfString:@"assign"].location != NSNotFound) {
        
        return NO;
    }
    return YES;
}

@end

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
    unsigned int count = 0;
    objc_property_attribute_t *attribute = property_copyAttributeList(property, &count);
    const char *char_v = attribute->value;
    NSString *attributes = [NSString stringWithUTF8String:char_a];
    NSString *attributesType = [NSString stringWithUTF8String:char_v];
    printf("\nIgnore====%s:%s %s", char_f, char_a, char_v);
    if ([attributes rangeOfString:@"<Ignore>"].location != NSNotFound || [attributesType isEqualToString:@"i"]) {
        return NO;
    }
    return YES;
}

@end

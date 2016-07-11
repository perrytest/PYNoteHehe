//
//  PYAccountModel.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYAccountModel.h"
#import "Account.h"
#import <objc/runtime.h>

@implementation PYAccountModel


- (void)convertInfoToAccout:(Account * _Nonnull * _Nonnull)accoutData {
    NSArray *properties = [self filterDemandPropertys];
    for (NSString *key in properties) {
        id value = [self valueForKey:key];
        [*accoutData setValue:value forKey:key];
    }
}


- (AccountType)accountType
{
    NSNumber *tempValue = [self type];
    return (tempValue != nil) ? [tempValue intValue] : AccountType_Other;
}

- (void)setAccountType:(AccountType)accountType {
    NSNumber *temp = @(accountType);
    [self willChangeValueForKey:@"accountType"];
    [self setType:temp];
    [self didChangeValueForKey:@"accountType"];
}

#pragma mark - Super

- (BOOL)isDemandProperty:(objc_property_t)property {
    const char *char_f = property_getName(property);
    const char *char_a = property_getAttributes(property);
    unsigned int count = 0;
    objc_property_attribute_t *attribute = property_copyAttributeList(property, &count);
    const char *char_v = attribute->value;
    NSString *attributes = [NSString stringWithUTF8String:char_a];
    NSString *attributesType = [NSString stringWithUTF8String:char_v];
    if ([attributes rangeOfString:@"<Ignore>"].location != NSNotFound || [attributesType isEqualToString:@"i"]) {
        printf("\nIgnore====%s:%s %s", char_f, char_a, char_v);
        return NO;
    }
    return YES;
}

@end
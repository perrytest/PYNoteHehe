//
//  PYAppProxy.m
//  PYNote
//
//  Created by kingnet on 16/8/17.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYAppProxy.h"
#include <objc/runtime.h>
#include <objc/message.h>
#import "PYAppManager.h"

@implementation PYAppProxy

+ (instancetype)autoParseProxy:(id)applicationProxy {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    PYAppProxy *app = [[self alloc] init];
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
//        const char *char_a = property_getAttributes(property);
//        unsigned int count = 0;
//        objc_property_attribute_t *attribute = property_copyAttributeList(property, &count);
//        const char *char_v = attribute->value;
//        free(attribute);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
//        printf("\nLSApplicationProxy:%s# %s", char_v, char_f);
//        NSString *propertyType = [NSString stringWithUTF8String:char_v];
        
        id value = [applicationProxy valueForKey:propertyName];
        [app setValue:value forKey:propertyName];
//        TTDEBUGLOG(@"LSApplicationProxy:%@: %@", propertyName, [app valueForKey:propertyName]);
    }
    free(properties);
    
    SEL function_ = NSSelectorFromString(@"localizedName");
    id localizedName = objc_msgSend(applicationProxy, function_);
    app.localizedName = [NSString stringWithFormat:@"%@", localizedName];
    SEL function_test = NSSelectorFromString(@"signerIdentity");
    id signId = objc_msgSend(applicationProxy, function_test);
    app.signerIdentity = [NSString stringWithFormat:@"%@", signId];
    return app;
}

- (UIImage *)appIconWithFormat:(int)format {
    SEL function = NSSelectorFromString(@"iconWithBundleId:format:");
    if ([PYAppManager instancesRespondToSelector:function]) {
        IMP imp = [[PYAppManager shareAppManager] methodForSelector:function];
        UIImage* (*func)(id, SEL, NSString *, int) = (void *)imp;
        UIImage *icon = func([PYAppManager shareAppManager], function, self.applicationIdentifier, format);
        return icon;
    }
    return nil;
}

- (NSString *)description {
    NSMutableString* text = [NSMutableString stringWithFormat:@"<%@> \r", [self class]];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:char_f];
        NSString *value = [self valueForKey:name];
        [text appendFormat:@"   [%@]: %@\r", name, value];
    }
    free(properties);
    [text appendFormat:@"    </%@>", [self class]];
    return text;
}

@end

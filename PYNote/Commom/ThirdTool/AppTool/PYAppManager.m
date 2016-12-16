//
//  PYAppManager.m
//  PYNote
//
//  Created by kingnet on 16/7/15.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYAppManager.h"
#import "PYAppInstallation.h"
#include <objc/runtime.h>
#include <objc/message.h>


@interface UIImage (UIApplicationIconPrivate)

+ (UIImage*)_applicationIconImageForBundleIdentifier:(NSString*)bundleIdentifier format:(int)format scale:(CGFloat)scale;

@end

@interface PYAppManager ()



@end

@implementation PYAppManager

- (instancetype)init {
    self = [super init];
    if (self) {
//        NSArray *array = AppList(kUser);
//        self.installedArray = [NSArray arrayWithArray:array];
    }
    return self;
}

+ (instancetype)shareAppManager {
    static PYAppManager *shareAppManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareAppManager == nil) {
            shareAppManager = [[PYAppManager alloc] init];
        }
    });
    
    return shareAppManager;
}

- (NSArray *)installedArray {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self browseInstalledAppList];
    });
    while (!(_installedArray && _installedArray.count>0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _installedArray;
}

#pragma mark - Public

- (void)browseInstalledAppList {
    NSArray *array = AppList(kUser);
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (_installedArray) {
            self.installedArray = [NSArray arrayWithArray:array];
        }
    });
}

- (UIImage *)iconWithBundleId:(NSString *)bundleID format:(int)format {
    return [self iconWithBundleId:bundleID format:format scale:2.0];
}

- (UIImage *)iconWithBundleId:(NSString *)bundleID format:(int)format scale:(float)scale {
//    UIImage *icon = [UIImage applicationIconImageForBundleIdentifier:bundleID format:format scale:scale];
    
    SEL function = NSSelectorFromString(@"_applicationIconImageForBundleIdentifier:format:scale:");
    if ([UIImage respondsToSelector:function]) {
        id icon = [UIImage _applicationIconImageForBundleIdentifier:bundleID format:format scale:scale];
        if (icon && [icon isKindOfClass:[UIImage class]]) {
            return icon;
        }
    }
    return nil;
}

- (BOOL)uninstallAppWithBundleId:(NSString *)bundleID {
    IPAResult result = UninstallApp(bundleID);
    if (result == IPAResultOK) {
        return YES;
    }
    return NO;
}

- (BOOL)openAppWithBundleId:(NSString *)bundleID {
    IPAResult result = OpenApplication(bundleID);
    if (result == IPAResultOK) {
        return YES;
    }
    return NO;
}

- (PYAppProxy *)appProxyWithBundleId:(NSString *)bundleID {
    __block PYAppProxy *appProxy = nil;
    [self.installedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PYAppProxy *app = (PYAppProxy *)obj;
        if ([app.applicationIdentifier isEqualToString:bundleID]) {
            appProxy = app;
            *stop = YES;
        }
    }];
    return appProxy;
}

@end



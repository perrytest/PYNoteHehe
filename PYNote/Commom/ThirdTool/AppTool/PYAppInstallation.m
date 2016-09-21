//
//  PYAppInstallation.m
//  PYNote
//
//  Created by kingnet on 16/7/15.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYAppInstallation.h"
#import <dlfcn.h>
#include <objc/runtime.h>
#include <objc/message.h>
#import "PYAppProxy.h"


typedef void (* _vIMP)(id, SEL, ...);
typedef id (* _IMP)(id, SEL, ...);

#define kApplicationType   @"ApplicationType"

typedef int (*MobileInstallationBrowse)(NSDictionary *options, int (*mibcallback)(NSDictionary *dict, id usercon), id usercon);

typedef int (*MobileInstallationUninstall)(NSString *appCode, NSDictionary *dict, void *na, NSString *strna);

typedef int (*MobileInstallationInstall)(NSString *path, NSDictionary *dict, void *na, NSString *path2_equal_path_maybe_no_use);


IPAResult InstallIpa(NSString *path){
    
    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib)
    {
        IPAResult ret = IPAResultFail;
        MobileInstallationInstall pMobileInstallationInstall = (MobileInstallationInstall)dlsym(lib, "MobileInstallationInstall");
        if (pMobileInstallationInstall){
            NSString *name = [@"Install_" stringByAppendingString:@"app.ipa"];
            NSString *temp = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
            if(![[NSFileManager defaultManager] fileExistsAtPath:temp])
            {
                if(![[NSFileManager defaultManager] copyItemAtPath:path toPath:temp error:nil])
                    return IPAResultFileNotFound;
            }
            
            ret = (IPAResult)pMobileInstallationInstall(temp, [NSDictionary dictionaryWithObject:kUser forKey:kApplicationType], 0, path);
            [[NSFileManager defaultManager] removeItemAtPath:temp error:nil];
        }
        dlclose(lib);
        return ret;
    }
    return IPAResultNoFunction;
}


IPAResult UninstallApp(NSString *bundleIdentifier){
    
    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib)
    {
        IPAResult ret = IPAResultFail;
        MobileInstallationUninstall pMobileInstallationUninstall = (MobileInstallationUninstall)dlsym(lib, "MobileInstallationUninstall");
        if (pMobileInstallationUninstall)
        {
            ret = (IPAResult)pMobileInstallationUninstall(bundleIdentifier, [NSDictionary dictionaryWithObject:kUser forKey:kApplicationType], 0, 0);
        }
        dlclose(lib);
        return ret;
    }
    return IPAResultNoFunction;
    
    
//    IPAResult result = IPAResultNoFunction;
//    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
//    if (lib) {
//        Class MIInstallerClient = objc_getClass([@"MIInstallerClient" UTF8String]);
//        SEL selector = NSSelectorFromString(@"installerWithProgressBlock:");
//        IMP imp = [MIInstallerClient methodForSelector:selector];
//        id (*func)(id, SEL, id) = (void *)imp;
//        id installerClient = func(MIInstallerClient, selector, nil);
//        
//        if (installerClient) {
//            
//            SEL uninstallSEL = NSSelectorFromString(@"uninstallIdentifiers:withOptions:completion:");
//            
//            IMP imp = [installerClient methodForSelector:uninstallSEL];
//            void (*func)(id, SEL, id, id, id) = (void *)imp;
//            func(installerClient, uninstallSEL, @[bundleIdentifier], [NSDictionary dictionaryWithObject:kUser forKey:kApplicationType], nil);
//        }
//        dlclose(lib);
//    }
//    return result;
    
}


NSArray *AppList(NSString *applicationType){
    
    NSMutableArray *apps = [NSMutableArray array];
    void *lib = dlopen("/System/Library/Frameworks/MobileCoreServices.framework/MobileCoreServices", RTLD_LAZY);
    if (lib) {
        Class LSApplicationWorkspace = objc_getClass([@"LSApplicationWorkspace" UTF8String]);
        SEL selector = NSSelectorFromString(@"defaultWorkspace");
        id workspace = objc_msgSend(LSApplicationWorkspace, selector);
        if (workspace) {
           
            SEL appListSEL = NSSelectorFromString(@"allInstalledApplications");
            id array = objc_msgSend(workspace, appListSEL);
//            TTDEBUGLOG(@"installed array : %@", array);
            if (array && [array isKindOfClass:[NSArray class]]) {
                
//                Class LSApplicationProxy = objc_getClass([@"LSApplicationProxy" UTF8String]);
                
                for (id applicationProxy in array) {
                    PYAppProxy *appProxy = [PYAppProxy autoParseProxy:applicationProxy];
                    if (appProxy && [appProxy.applicationType isEqualToString:applicationType]) {
                        [apps addObject:appProxy];
                    }
                }
            }
        }
        
    }
    if (lib) dlclose(lib);
    if(!apps)
        return nil;
    return apps;
}

IPAResult OpenApplication(NSString *bundleIdentifier) {
    IPAResult result = IPAResultNoFunction;
    void *lib = dlopen("/System/Library/Frameworks/MobileCoreServices.framework/MobileCoreServices", RTLD_LAZY);
    if (lib) {
        Class LSApplicationWorkspace = objc_getClass([@"LSApplicationWorkspace" UTF8String]);
        SEL selector = NSSelectorFromString(@"defaultWorkspace");
        id workspace = objc_msgSend(LSApplicationWorkspace, selector);
        if (workspace) {
            
            SEL openAppSEL = NSSelectorFromString(@"openApplicationWithBundleID:");
            
            IMP imp = [workspace methodForSelector:openAppSEL];
            BOOL (*func)(id, SEL, NSString *) = (void *)imp;
            BOOL flag = func(workspace, openAppSEL, bundleIdentifier);
            if (flag) {
                result = IPAResultOK;
            } else {
                result = IPAResultFail;
            }
        }
        dlclose(lib);
    }
    return result;
}

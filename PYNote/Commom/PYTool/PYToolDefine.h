//
//  PYToolDefine.h
//  PYNote
//
//  Created by kingnet on 16/5/16.
//  Copyright © 2016年 perry. All rights reserved.
//

#ifndef PYToolDefine_h
#define PYToolDefine_h


#ifdef DEBUG
#define TTDEBUGLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define TTDEBUGLOG(...)
#define printf(fmt, ...)
#endif

#define PYProjectDisplayName NSLocalizedString(@"Note", nil)
#define PYProjectVersionNumber          \
[[[NSBundle mainBundle] infoDictionary] \
objectForKey:@"CFBundleShortVersionString"]
#define PYProjectBundleID [[NSBundle mainBundle] bundleIdentifier]


// check system version, make adapter for ios6 and 7
#define PY_IS_IOS10_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)

#define PY_IS_IOS9_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

#define PY_IS_IOS8_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#define PY_IS_IOS7_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)

#define PY_IS_IOS6_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)


//NSUserDefaults相关
#define UserDefaultsObjectForKey(key)             [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define UserDefaultsSetValueForKey(value,key)     [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define UserDefaultsRemoveObjectForKey(key)       [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
#define UserDefaultSynchronize                    [[NSUserDefaults standardUserDefaults] synchronize]




#define NSStringFromInteger(i) [NSString stringWithFormat:@"%ld", (long)(i)]




////////////////////////////////////////////////////////////////////////////////////////////////
// system version compare

// iOS Version Checking
#define PY_SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
//大于
#define PY_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
//大于等于
#define PY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//小于
#define PY_SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//小于等于
#define PY_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Version Checking
#define PY_VERSION_EQUAL_TO(v1, v2) ([v1 compare:v2 options:NSNumericSearch] == NSOrderedSame)
//大于
#define PY_VERSION_GREATER_THAN(v1, v2) ([v1 compare:v2 options:NSNumericSearch] == NSOrderedDescending)
//大于等于
#define PY_VERSION_GREATER_THAN_OR_EQUAL_TO(v1, v2) ([v1 compare:v2 options:NSNumericSearch] != NSOrderedAscending)

//小于
#define PY_VERSION_LESS_THAN(v1, v2) ([v1 compare:v2 options:NSNumericSearch] == NSOrderedAscending)
//小于等于
#define PY_VERSION_LESS_THAN_OR_EQUAL_TO(v1, v2) ([v1 compare:v2 options:NSNumericSearch] != NSOrderedDescending)

///////////////////////////////////////////////////////////////////////////////////////////////////



#endif /* PYToolDefine_h */

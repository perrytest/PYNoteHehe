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


//NSUserDefaults相关
#define UserDefaultsObjectForKey(key)             [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define UserDefaultsSetValueForKey(value,key)     [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define UserDefaultsRemoveObjectForKey(key)       [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
#define UserDefaultSynchronize                    [[NSUserDefaults standardUserDefaults] synchronize]


#define RGBA(r, g, b, a)      [UIColor colorWithRed:r grern:g blue:b alpha:a]
#define HexColor(hexValue) [UIColor hexColor:(hexValue)]

#define NSStringFromInteger(i) [NSString stringWithFormat:@"%ld", (long)(i)]

#define PYScreenHeight [[UIScreen mainScreen] bounds].size.height
#define PYScreenWidth [[UIScreen mainScreen] bounds].size.width
#define PYMainScale [UIScreen mainScreen].scale


#endif /* PYToolDefine_h */

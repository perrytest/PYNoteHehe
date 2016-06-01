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
#endif


//NSUserDefaults相关
#define UserDefaultsObjectForKey(key)             [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define UserDefaultsSetValueForKey(value,key)     [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define UserDefaultSynchronize                    [[NSUserDefaults standardUserDefaults] synchronize]


#define RGBA(r, g, b, a)      [UIColor colorWithRed:r grern:g blue:b alpha:a]

#define NSStringFromInteger(i) [NSString stringWithFormat:@"%ld", (long)(i)]


#endif /* PYToolDefine_h */

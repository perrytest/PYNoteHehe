//
//  PYAppManager.h
//  PYNote
//
//  Created by kingnet on 16/7/15.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYAppManager : NSObject

@property (strong, nonatomic) NSArray *installedArray;

+ (instancetype)shareAppManager;

- (void)browseInstalledAppList;

/**
 *  获取 app icon
 *
 *  @param bundleID app bundle ID
 *  @param format
 0 - 29x29
 1 - 40x40
 2 - 62x62
 3 - 37x48
 4 - 37x48
 5 - 92x71
 6 - 62x48
 7 - 20x20
 8 - 37x48
 9 - 37x48
 10 - 124x124
 11 - 58x58
 12 - 62x62
 *
 *  @return UIImage
 */
- (UIImage *)iconWithBundleId:(NSString *)bundleID format:(int)format;
- (UIImage *)iconWithBundleId:(NSString *)bundleID format:(int)format scale:(float)scale;

// 无效
//- (BOOL)uninstallAppWithBundleId:(NSString *)bundleID;

- (BOOL)openAppWithBundleId:(NSString *)bundleID;

- (PYAppProxy *)appProxyWithBundleId:(NSString *)bundleID;


@end

//
//  PYAppInstallation.h
//  PYNote
//
//  Created by kingnet on 16/7/15.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUser              @"User"
#define kSystem            @"System"



typedef enum {
    IPAResultOK = 0,                            //Successful
    IPAResultFail = -1,                         //failed
    IPAResultNoFunction = -2,                   //api not found
    IPAResultFileNotFound = -3                  //ipa file not found
} IPAResult;


/**
 *  install ipa file
 *
 *  @param path ipa file path
 *
 *  @return ipa Status
 */
extern IPAResult InstallIpa(NSString *path);

/**
 *  uninstall app
 *
 *  @param bundle Identifier
 *
 *  @return ipa Status
 */
extern IPAResult UninstallApp(NSString *bundleIdentifier);

/**
 *  installed App
 *
 *  @param applicationType installed App
 *
 *  @return appList
 */
extern NSArray *AppList(NSString *applicationType);

/**
 *  open App
 *
 *  @param bundleIdentifier Identifier
 *
 *  @return open result
 */
IPAResult OpenApplication(NSString *bundleIdentifier);


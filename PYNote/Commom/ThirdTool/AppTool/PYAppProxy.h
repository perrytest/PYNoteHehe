//
//  PYAppProxy.h
//  PYNote
//
//  Created by kingnet on 16/8/17.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYAppProxy : NSObject

@property (nonatomic, copy) NSString *applicationIdentifier;
@property (nonatomic, copy) NSString *companionApplicationIdentifier;
@property (nonatomic, copy) NSDate *registeredDate;
@property (nonatomic, copy) NSNumber *itemID;
@property (nonatomic, copy) NSString *roleIdentifier;
@property (nonatomic, copy) NSString *vendorName;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *storeCohortMetadata;
@property (nonatomic, copy) NSString *minimumSystemVersion;
@property (nonatomic, copy) NSString *sdkVersion;
@property (nonatomic, copy) NSString *shortVersionString;
@property (nonatomic, copy) NSString *preferredArchitecture;
@property (nonatomic, copy) NSString *applicationType;
@property (nonatomic, copy) NSArray *directionsModes;
@property (nonatomic, copy) NSArray *UIBackgroundModes;
@property (nonatomic, copy) NSArray *audioComponents;
@property (nonatomic, copy) NSDictionary *groupContainers;
@property (nonatomic, copy) NSUUID *deviceIdentifierForVendor;
@property (nonatomic, copy) NSProgress *installProgress;
@property (nonatomic, copy) NSNumber *staticDiskUsage;
@property (nonatomic, copy) NSNumber *dynamicDiskUsage;
@property (nonatomic, copy) NSNumber *ODRDiskUsage;
@property (nonatomic, copy) NSArray *VPNPlugins;
@property (nonatomic, copy) NSArray *plugInKitPlugins;
@property (nonatomic, copy) NSArray *appTags;
@property (nonatomic, copy) NSString *applicationDSID;
@property (nonatomic, copy) NSNumber *purchaserDSID;
@property (nonatomic, copy) NSNumber *downloaderDSID;
@property (nonatomic, copy) NSNumber *familyID;
@property (nonatomic, assign) unsigned long long installType;
@property (nonatomic, assign) unsigned long long originalInstallType;
@property (nonatomic, copy) NSArray *requiredDeviceCapabilities;
@property (nonatomic, copy) NSArray *deviceFamily;
@property (nonatomic, copy) NSArray *groupIdentifiers;
@property (nonatomic, copy) NSArray *externalAccessoryProtocols;
@property (nonatomic, copy) NSString *teamID;
@property (nonatomic, copy) NSNumber *storeFront;
@property (nonatomic, copy) NSNumber *externalVersionIdentifier;
@property (nonatomic, copy) NSNumber *betaExternalVersionIdentifier;
@property (nonatomic, copy) NSString *sourceAppIdentifier;
@property (nonatomic, copy) NSString *applicationVariant;
@property (nonatomic, assign) BOOL isInstalled;
@property (nonatomic, assign) BOOL isPlaceholder;
@property (nonatomic, assign) BOOL isAppUpdate;
@property (nonatomic, assign) BOOL isNewsstandApp;
@property (nonatomic, assign) BOOL isRestricted;
@property (nonatomic, assign) BOOL whitelisted;
@property (nonatomic, assign) BOOL isBetaApp;
@property (nonatomic, assign) BOOL profileValidated;
@property (nonatomic, assign) BOOL isAdHocCodeSigned;
@property (nonatomic, assign) BOOL supportsAudiobooks;
@property (nonatomic, assign) BOOL isContainerized;
@property (nonatomic, assign) BOOL hasSettingsBundle;
@property (nonatomic, assign) BOOL supportsExternallyPlayableContent;
@property (nonatomic, assign) BOOL supportsOpenInPlace;
@property (nonatomic, assign) BOOL fileSharingEnabled;
@property (nonatomic, assign) BOOL iconIsPrerendered;
@property (nonatomic, assign) BOOL isPurchasedReDownload;
@property (nonatomic, assign) BOOL isWatchKitApp;
@property (nonatomic, assign) BOOL hasMIDBasedSINF;
@property (nonatomic, assign) BOOL missingRequiredSINF;

@property (nonatomic, copy) NSString *signerIdentity;

@property (nonatomic, copy) NSString *localizedName;

+ (instancetype)autoParseProxy:(id)applicationProxy;


/*
 @param format
 0 - 29x29
 1 - 40x40
 2 - 62x62
 3 - 42x42
 4 - 37x48
 5 - 37x48
 6 - 82x82
 7 - 62x62
 8 - 20x20
 9 - 37x48
 10 - 37x48
 11 - 122x122
 12 - 58x58
 */
- (UIImage *)appIconWithFormat:(int)format;

@end

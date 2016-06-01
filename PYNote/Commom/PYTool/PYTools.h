//
//  PYTools.h
//  FirstTest
//
//  Created by perry on 14-6-24.
//  Copyright (c) 2014年 juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYTools : NSObject

+ (NSString*)getDocumentDirectoryPath;

+ (NSURL *)URLForDocumentsDirectory;

//获取唯一ID
+ (NSString *)getUniqueId;

@end

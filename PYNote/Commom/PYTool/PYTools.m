//
//  PYTools.m
//  FirstTest
//
//  Created by perry on 14-6-24.
//  Copyright (c) 2014年 juvid. All rights reserved.
//

#import "PYTools.h"

@implementation PYTools

+ (NSString*)getDocumentDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;
}

+ (NSURL *)URLForDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString*)getResourceRootDirectoryPath {
    NSString *dirPath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:@"User"];
    return dirPath;
}

+ (NSURL *)URLForResourceRootDirectory {
    NSURL *resurceDir = [[self URLForDocumentsDirectory] URLByAppendingPathComponent:@"User" isDirectory:YES];
    return resurceDir;
}

+ (NSString*)getResourceDirectoryPathForUser:(NSString *)userId {
    NSString *dirPath = [[self getResourceRootDirectoryPath] stringByAppendingPathComponent:userId];
    return dirPath;
}

+ (NSURL *)URLForResourceDirectoryForUser:(NSString *)userId {
    NSURL *resurceDir = [[self URLForResourceRootDirectory] URLByAppendingPathComponent:userId isDirectory:YES];
    return resurceDir;
}

+ (void)makeResourceDirectoryForUser:(NSString *)userId {
    NSString *dirPath = [self getResourceDirectoryPathForUser:userId];
    BOOL isDir = YES;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] && isDir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

+ (NSString *)getUniqueId {
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    
    CFRelease(uuidRef);
    
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}



@end

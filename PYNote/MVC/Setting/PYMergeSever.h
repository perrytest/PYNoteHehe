//
//  PYMergeSever.h
//  PYNote
//
//  Created by kingnet on 16/12/14.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYMergeSever : NSObject

+ (PYMergeSever *)sharedInstance;

- (void)start;

- (void)stop;

- (NSString *)serverName;

@end

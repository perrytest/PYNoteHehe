//
//  PYMergeClient.h
//  PYNote
//
//  Created by kingnet on 16/12/14.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface PYMergeClient : NSObject

@property (nonatomic, assign) BOOL connected;

+ (PYMergeClient *)sharedInstance;

- (void)searchServerAndConnect;

- (void)stop;

- (void)sendText:(NSString *)text;

@end

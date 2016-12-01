//
//  PYAppProxy+Convert.h
//  PYNote
//
//  Created by kingnet on 16/12/1.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYAppProxy.h"
@class RelateApp;

@interface PYAppProxy (Convert)

- (void)convertInfoToRelateApp:(RelateApp * _Nonnull * _Nonnull)app;

@end

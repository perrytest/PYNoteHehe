//
//  PYAppProxy+Convert.m
//  PYNote
//
//  Created by kingnet on 16/12/1.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYAppProxy+Convert.h"
#import "RelateApp.h"

@implementation PYAppProxy (Convert)

- (void)convertInfoToRelateApp:(RelateApp * _Nonnull * _Nonnull)app {
    (*app).bundleId = self.applicationIdentifier;
    (*app).title = self.localizedName;
    (*app).version = self.shortVersionString;
}

@end

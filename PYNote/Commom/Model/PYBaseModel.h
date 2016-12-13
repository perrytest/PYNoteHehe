//
//  PYBaseModel.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Ignore
@end

@interface PYBaseModel : NSObject

/*
 * 筛选基本对象属性,NString、NSNumber、NSDate、NSData
 */
- (NSArray *)filterDemandPropertys;

@end

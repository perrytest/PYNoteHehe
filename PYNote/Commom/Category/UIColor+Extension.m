//
//  UIColor+Extension.m
//  PYNote
//
//  Created by kingnet on 16/10/8.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)hexColor:(long)hexValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF)) / 255.0
                           alpha:1.0];
}

@end

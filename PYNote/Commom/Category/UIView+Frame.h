//
//  UIView+Frame.h
//  PYNote
//
//  Created by kingnet on 16/10/8.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

- (CGFloat)originX;
- (void)setOriginX:(CGFloat)originX;
- (CGFloat)originY;
- (void)setOriginY:(CGFloat)originY;


@end

@interface UIView (Extension)

- (void)cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor*)color;
- (void)removeAllSubviews;

@end

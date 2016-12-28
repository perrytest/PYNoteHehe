//
//  PYTextfieldCell.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYTextfieldCell.h"

@implementation PYTextfieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (![self.contentView.subviews count]) {
//        NSBundle *mainBundle = [NSBundle mainBundle];
//        NSArray *loadedViews = [mainBundle loadNibNamed:@"PYTextfieldCell" owner:self options:nil];
//        self = [loadedViews firstObject];
//    }
//    return self;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end

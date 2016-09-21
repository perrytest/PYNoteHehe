//
//  PYDoubleTextfieldCell.m
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYDoubleTextfieldCell.h"

@implementation PYDoubleTextfieldCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.leftInputTF) {
        [textField resignFirstResponder];
        [self.rightInputTF becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField == self.leftInputTF) {
//        [self.rightInputTF becomeFirstResponder];
//    }
}


@end

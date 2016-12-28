//
//  PYTextfieldCell.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NormalSingleTFCellID @"kCellTextFieldIdentifier"

@interface PYTextfieldCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UITextField *inputTF;

@end

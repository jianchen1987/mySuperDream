//
//  PayOrderTableCell.h
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAInfoTableViewCell.h"
#import "PayOrderTableCellModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PayOrderTableCell : SATableViewCell
@property (nonatomic, strong) PayOrderTableCellModel *model;
@property (nonatomic, strong) SALabel *nameLB;
@property (nonatomic, strong) SALabel *valueLB;
//@property (nonatomic, strong) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END

//
//  OrderListTBCell.h
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOrderListModel.h"
#import "PNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNOrderListCell : PNTableViewCell
@property (nonatomic, strong) PNOrderListModel *model;
@property (nonatomic, copy) void (^cellBlock)(PNOrderListModel *model);
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) SALabel *nameLB;
@property (nonatomic, strong) SALabel *timeLB;
@property (nonatomic, strong) SALabel *amountLB;
@property (nonatomic, strong) SALabel *stateLB;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL isLastCell;
@end

NS_ASSUME_NONNULL_END

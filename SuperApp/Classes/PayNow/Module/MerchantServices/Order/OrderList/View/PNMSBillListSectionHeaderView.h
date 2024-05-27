//
//  PNMSBillListSectionHeaderView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"

@class PNMSBillListGroupModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSBillListSectionHeaderView : SATableHeaderFooterView
@property (nonatomic, strong) PNMSBillListGroupModel *model;
@end

NS_ASSUME_NONNULL_END

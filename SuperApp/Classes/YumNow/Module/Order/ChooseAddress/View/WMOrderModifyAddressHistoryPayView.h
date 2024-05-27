//
//  WMOrderModifyAddressHistoryPayView.h
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMModifyAddressListModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderModifyAddressHistoryPayView : SAView
/// payLB
@property (nonatomic, strong) YYLabel *payLB;
/// cancel
@property (nonatomic, strong) HDUIButton *cancelBTN;
/// pay
@property (nonatomic, strong) HDUIButton *payBTN;
/// model
@property (nonatomic, strong) WMModifyAddressListModel *model;
@end

NS_ASSUME_NONNULL_END

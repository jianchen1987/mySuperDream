//
//  PNMSWithdranBankInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSWithdranBankInfoModel : PNModel
/// 银行 participantCode
@property (nonatomic, copy) NSString *participantCode;
/// 银行名字
@property (nonatomic, copy) NSString *bankName;
/// 银行户名
@property (nonatomic, copy) NSString *accountName;
/// 银行账号
@property (nonatomic, copy) NSString *accountNumber;
/// 币种
@property (nonatomic, strong) PNCurrencyType currency;
/// 银行图片
@property (nonatomic, copy) NSString *bankImage;
/// 是否可以删除
@property (nonatomic, assign) BOOL deleteAble;
/// 背景颜色
@property (nonatomic, copy) NSString *bgColor;
@end

NS_ASSUME_NONNULL_END

//
//  TransAmountVC.h
//  SuperApp
//
//  Created by Quin on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDPayeeInfoModel.h"
#import "PNEnum.h"
#import "PNViewController.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface PNTransAmountViewController : PNViewController
@property (nonatomic, assign) PNTradeSubTradeType pageType;
@property (nonatomic, strong) HDPayeeInfoModel *payeeInfo; ///< 收款方信息

@property (nonatomic, copy) NSString *payeeBankCode;
@property (nonatomic, copy) NSString *payeeAccountNo;
@property (nonatomic, copy) NSString *payeeAccountName;
@property (nonatomic, copy) NSString *payeeBankName;
@property (nonatomic, copy) NSString *logo;
@property (copy, nonatomic) NSString *payeeStoreName;
@property (copy, nonatomic) NSString *payeeStoreLocation;
@property (copy, nonatomic) NSString *billNumber;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) PNCurrencyType cy; //币种

/// qrCode
@property (nonatomic, copy) NSString *qrData;

/// 扫码到bakong 子业务类型
@property (nonatomic, copy) NSString *subBizType; ///【扫用户收款码】子交易类型，目前只有 用户收款下单的时候需要传【2022.6.15】

@end

NS_ASSUME_NONNULL_END

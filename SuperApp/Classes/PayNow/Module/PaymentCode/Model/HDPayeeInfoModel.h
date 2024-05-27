//
//  HDPayeeInfoModel.h
//  ViPay
//
//  Created by seeu on 2019/7/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAnalysisQRCodeRspModel.h"
#import "HDBaseCodingObject.h"
#import "HDContactsModel.h"
#import "PNSceneQrCodeInfoModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDPayeeInfoModel : HDBaseCodingObject

@property (nonatomic, copy) NSString *firstName;                 ///< 姓
@property (nonatomic, copy) NSString *lastName;                  ///< 名
@property (nonatomic, copy) NSString *nickName;                  ///< 昵称 | 菜单名称
@property (nonatomic, copy) NSString *headUrl;                   ///< 头像链接
@property (nonatomic, copy) NSString *payeeLoginName;            ///< 收款方账号
@property (nonatomic, strong) SAMoneyModel *__nullable orderAmt; ///< 订单金额
@property (nonatomic, strong) NSURL *routePath;                  ///< 路由
// bakong
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *frozen;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *kycStatus;
//银行
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *accountCurrency;
@property (nonatomic, copy) NSString *accountType;
@property (nonatomic, copy) NSString *participantCode;

// bakong扫码
@property (nonatomic, copy) NSString *payloadFormatIndicator;
@property (nonatomic, copy) NSString *pointOfInitiationMethod;
@property (nonatomic, copy) NSString *merchantType;
@property (nonatomic, copy) NSString *bakongAccountID;
@property (nonatomic, copy) NSString *merchantAccountId;
@property (nonatomic, copy) NSString *acquiringBank;
@property (nonatomic, copy) NSString *merchantCategoryCode;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *merchantCity;
@property (nonatomic, copy) NSString *transactionCurrency;
@property (nonatomic, copy) NSString *transactionAmount;
@property (nonatomic, copy) NSString *billNumber;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *storeLabel;
@property (nonatomic, copy) NSString *terminalLabel;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *crc;

@property (nonatomic, assign) BOOL isCoolCashAccount;

//出金二维码
@property (nonatomic, strong) NSString *feeAmt;
@property (nonatomic, strong) NSString *payAmt;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *bizType;
@property (nonatomic, copy) NSString *merName;
@property (nonatomic, copy) NSString *logoUrl;

@property (nonatomic, strong) PNSceneQrCodeInfoModel *sceneQrCodeInfoDTO;

// 账户是否已实名 ->true|false）
@property (nonatomic, assign) BOOL certified;

/// 最近联系人
- (instancetype)initWithContactModel:(HDContactsModel *)contact;
/// 扫码转账
- (instancetype)initWithAnalysisQRCodeModel:(HDAnalysisQRCodeRspModel *)analysisModel;
/// 转账菜单
+ (instancetype)modelWithTitle:(NSString *)title icon:(NSString *)icon routePath:(NSURL *)routePath;

@end

NS_ASSUME_NONNULL_END

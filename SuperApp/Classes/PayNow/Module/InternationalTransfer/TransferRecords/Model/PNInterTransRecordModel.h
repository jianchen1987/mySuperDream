//
//  PNInterTransRecordModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransRecordModel : PNModel
/// 记录id
@property (nonatomic, copy) NSString *recordId;
/// 收款人id
@property (nonatomic, copy) NSString *beneficiaryId;
/// 证件类型;13护照，12身份证
@property (nonatomic, assign) PNPapersType idType;
/// 证件类型码值;PASSPORT护照，NATIONAL_ID身份证
@property (nonatomic, copy) NSString *idTypeCode;
/// 证件编号
@property (nonatomic, copy) NSString *idCode;
/// 证件生效时间
@property (nonatomic, copy) NSString *idDeliveryDate;
/// 证件失效时间
@property (nonatomic, copy) NSString *idExpirationDate;
/// 证件国籍
@property (nonatomic, copy) NSString *idCountry;
/// 证件国籍码值;国籍信息ID
@property (nonatomic, copy) NSString *idCountryId;
/// 电话号码(移动国际用户识别码)
@property (nonatomic, copy) NSString *msisdn;
/// 名字
@property (nonatomic, copy) NSString *firstName;
/// 中间名字
@property (nonatomic, copy) NSString *middleName;
/// 姓氏
@property (nonatomic, copy) NSString *lastName;
/// 全名
@property (nonatomic, copy) NSString *fullName;
/// 性别;10未知，14男性，15女性
@property (nonatomic, assign) PNSexType genderType;
/// 出生日期  时间戳
@property (nonatomic, copy) NSString *birthDate;
/// 出生日期格式化显示
@property (nonatomic, copy) NSString *showBirthDateStr;
/// 出生国籍
@property (nonatomic, copy) NSString *birthCountry;
/// 出生国籍码值;国籍信息ID
@property (nonatomic, copy) NSString *birthCountryId;
/// 身份国籍
@property (nonatomic, copy) NSString *nationality;
/// 身份国籍码值;国籍信息ID
@property (nonatomic, copy) NSString *nationalityCodeId;
/// 省
@property (nonatomic, copy) NSString *province;
/// 城市
@property (nonatomic, copy) NSString *city;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 邮箱
@property (nonatomic, copy) NSString *email;
/// 关系
@property (nonatomic, copy) NSString *relationType;
/// 关系code
@property (nonatomic, copy) NSString *relationCode;
/// 其它关系
@property (nonatomic, copy) NSString *otherRelation;
/// 交易列表 金额 + -
@property (nonatomic, copy) NSString *sign;

/// 创建时间
@property (nonatomic, copy) NSString *createTime;
/// 更新时间
@property (nonatomic, copy) NSString *updateTime;
/// 付款人用户ID 存My Account（我的账号）
@property (nonatomic, copy) NSString *senderId;
/// 订单id
@property (nonatomic, copy) NSString *orderNo;
/// 支付单id
@property (nonatomic, copy) NSString *tradeNo;
/// THUNES报价单id
@property (nonatomic, copy) NSString *thunesQuotationId;
/// THUNES交易单id
@property (nonatomic, copy) NSString *thunesTransactionId;
/// 收款金额=转账金额*转账汇率
@property (nonatomic, strong) SAMoneyModel *receiverAmount;

/// 转账支付金额=转账金额+手续费-营销减免（实际支付金额）
@property (nonatomic, strong) SAMoneyModel *totalPayoutAmount;
/// 转账金额
@property (nonatomic, strong) SAMoneyModel *payoutAmount;
/// 营销减免
@property (nonatomic, strong) SAMoneyModel *promotion;
/// 手续费(服务费）
@property (nonatomic, strong) SAMoneyModel *serviceCharge;
@property (nonatomic, copy) NSString *exchangeRate;
/// 实际支付手续费: 手续费-营销减免
@property (nonatomic, strong) SAMoneyModel *actualServiceCharge;
/// 转账汇率
@property (nonatomic, copy) NSString *fxRate;

/// 资金来源信息ID
@property (nonatomic, copy) NSString *sourceFundId;
/// 其他资金来源注明
@property (nonatomic, copy) NSString *otherSourceFund;
/// 汇款目的信息ID
@property (nonatomic, copy) NSString *purposeRemittanceId;
/// 其他汇款目的注明
@property (nonatomic, copy) NSString *otherPurposeRemittance;
/// 转账目的
@property (nonatomic, copy) NSString *purposeRemittanceType;
/// 资金来源
@property (nonatomic, copy) NSString *sourceFundType;
/// 拒绝或取消原因
@property (nonatomic, copy) NSString *reason;
/// 订单状态;10初始,11支付完成,12创建,13确认,14提交,15待收款人提款,20已完成,21拒绝,22取消,23失败,24撤销
@property (nonatomic, assign) PNInterTransferOrderStatus status;
/// 转账撤销状态 默认是未撤销 10未撤销 11撤销待审核 12撤销审核通过 13撤销审核拒绝
@property (nonatomic, assign) NSInteger transferRevokeStatus;

/// 付款人转出国家
@property (nonatomic, copy) NSString *senderPayoutCountry;
/// 付款人出生国家
@property (nonatomic, copy) NSString *senderPayoutCountryOfBirth;
/// 付款人地址
@property (nonatomic, copy) NSString *senderAddress;
/// 付款人姓名
@property (nonatomic, copy) NSString *senderName;
/// 付款人手机号
@property (nonatomic, copy) NSString *senderIphone;

/// 收款人是否可用
@property (nonatomic, assign) BOOL beneficiaryIsUsable;
/// 收款人不可用提示文案
@property (nonatomic, copy) NSString *beneficiaryIsUsableMsg;
/// 邀请码
@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, assign) PNInterTransferThunesChannel channel;
@property (nonatomic, copy) NSString *logoPath;
@property (nonatomic, copy) NSString *receiveChannel;
@end

NS_ASSUME_NONNULL_END

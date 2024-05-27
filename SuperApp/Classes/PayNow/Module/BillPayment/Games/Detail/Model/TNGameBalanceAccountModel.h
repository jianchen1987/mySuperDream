//
// Created by ESJsonFormatForMac on 22/12/23.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
#import <Foundation/Foundation.h>


@interface TNGameSupplierModel : TNModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) BOOL allowPartialPayment;

@property (nonatomic, assign) BOOL allowExceedPayment;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *shortName;

@end


@interface TNGameCustomerModel : TNModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *nameEn;

@property (nonatomic, copy) NSString *name;

@end


@interface TNGameBalancesModel : TNModel

@property (nonatomic, copy) NSString *lastPayDate;

@property (nonatomic, copy) NSString *billState;

@property (nonatomic, copy) NSString *currency;

@property (nonatomic, copy) NSString *otherCurrencyAmounts;

@property (nonatomic, copy) NSString *paymentCategory;

@property (nonatomic, strong) SAMoneyModel *billAmount;

@property (nonatomic, copy) NSString *marketingBreaks;

@property (nonatomic, assign) NSInteger supplierFeePercentage;

@property (nonatomic, copy) NSString *actualPaymentCurrency;
///费用类型（D=客户全部承担，C=商家全部承担，P=客户和商家按比例共同承担
@property (nonatomic, copy) NSString *chargeType;

@property (nonatomic, copy) NSString *payFinished;

@property (nonatomic, copy) NSString *billNo;

@property (nonatomic, copy) NSString *customerPhone;

@property (nonatomic, copy) NSString *paymentToken;

@property (nonatomic, copy) NSString *feeType;

@property (nonatomic, strong) SAMoneyModel *totalAmount;

@property (nonatomic, copy) NSString *posAgentName;

@property (nonatomic, strong) SAMoneyModel *feeAmount;

@property (nonatomic, assign) NSInteger customerFeePercentage;

@property (nonatomic, copy) NSString *lastBillDate;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *paymentCategoryName;

@property (nonatomic, copy) NSString *posAgentOperator;

@property (nonatomic, strong) SAMoneyModel *minAmount;

@property (nonatomic, copy) NSString *commissionAmount;

@property (nonatomic, copy) NSString *orderTime;

@property (nonatomic, copy) NSString *posOperatorNo;

@property (nonatomic, strong) SAMoneyModel *balance;

@property (nonatomic, copy) NSString *notes;

@property (nonatomic, copy) NSString *lastDueDate;

@property (nonatomic, strong) SAMoneyModel *maxAmount;

@property (nonatomic, copy) NSString *posMerchantNo;

@property (nonatomic, copy) NSString *billCode;

@end


@interface TNGameBalanceAccountModel : TNModel

@property (nonatomic, strong) TNGameSupplierModel *supplier;

@property (nonatomic, strong) NSArray<TNGameBalancesModel *> *balances;

@property (nonatomic, strong) TNGameCustomerModel *customer;

@end

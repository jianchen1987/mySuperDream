//
//  PNGuarateenDetailModel.h
//  SuperApp
//
//  Created by xixi on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenAttachmentModel.h"
#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenNextActionModel : PNModel
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) PNEnumModel *action;
@end


@interface PNGuarateenFlowModel : PNModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *message_us;
@property (nonatomic, copy) NSString *message_kh;
@end


@interface PNGuarateenDetailModel : PNModel
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *userNo;
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *traderNo;
@property (nonatomic, copy) NSString *traderMobile;
@property (nonatomic, copy) NSString *traderName;
@property (nonatomic, strong) NSNumber *amt;
@property (nonatomic, copy) NSString *amtStr; // 带金额显示
@property (nonatomic, copy) NSString *cy;
@property (nonatomic, strong) NSNumber *feeAmt;
@property (nonatomic, copy) NSString *feeAmtStr; /// 带金额显示
@property (nonatomic, strong) NSNumber *paidAmt;
@property (nonatomic, strong) PNEnumModel *originator;
@property (nonatomic, strong) PNEnumModel *status;
@property (nonatomic, assign) BOOL paid;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *completeTime;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) PNGuarateenAttachmentModel *attachment;
@property (nonatomic, copy) NSString *operationDesc;
@property (nonatomic, copy) NSString *refundTime;
@property (nonatomic, strong) NSArray<PNGuarateenFlowModel *> *flow;
//@property (nonatomic, assign) NSArray<NSArray<PNGuarateenFlowModel *> *> *flowSplit;
@property (nonatomic, strong) NSArray *flowSplit;

@property (nonatomic, assign) NSInteger flowStep;
@property (nonatomic, strong) NSArray<PNGuarateenNextActionModel *> *nextActions;

@property (nonatomic, assign) NSInteger expiredDays;
@end

NS_ASSUME_NONNULL_END

//
//  PNGuarateenBuildModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenAttachmentModel.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenBuildModel : PNModel
/// 发起方手机号
@property (nonatomic, copy) NSString *userMobile;
/// 发起方名字
@property (nonatomic, copy) NSString *userName;
/// 交易方手机号
@property (nonatomic, copy) NSString *traderMobile;
/// 交易对方名字
@property (nonatomic, copy) NSString *traderName;
/// 金额
@property (nonatomic, copy) NSString *amt;
/// 币种
@property (nonatomic, copy) NSString *cy;
/// 交易内容
@property (nonatomic, copy) NSString *body;
/// 附件信息
@property (nonatomic, strong) PNGuarateenAttachmentModel *attachment;
/// BUYER(10, "买方", "", ""),     SELLER(11, "卖方", "", ""),
@property (nonatomic, assign) NSInteger originator;

@property (nonatomic, copy) NSString *action;
@end

NS_ASSUME_NONNULL_END

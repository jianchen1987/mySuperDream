//
//  TNTransferRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
///转账凭证状态
typedef NS_ENUM(NSUInteger, TNTransferAuditStatus) {
    ///待提交
    TNTransferAuditStatusNotSubmit = 10,
    ///审核中 待补交 13 前端显示和审核中一致   合并到审核中一起处理
    TNTransferAuditStatusChecking = 11,
    ///已通过
    TNTransferAuditStatusPassed = 12,
    ///待补交
    TNTransferAuditStatusSupplementInfo = 13,
    ///重新提交 后端没有返回  前端根据 10 待提交状态  是否有凭证值来判断
    TNTransferAuditStatusAgainSubmit = -1,
};
@class SAMoneyModel;
///转账凭证数据源
@interface TNTransferCredentialModel : TNModel
/// 联系方式
@property (nonatomic, copy) NSString *mobile;
/// 凭证图片
@property (strong, nonatomic) NSArray *credentialImages;
/// 转账凭证状态
@property (nonatomic, assign) TNTransferAuditStatus auditStatus;

@end
///具体的支付方式 数据模型
@interface TNTransferItemModel : TNModel
/// 小标题名称
@property (nonatomic, copy) NSString *name;
/// 值
@property (nonatomic, copy) NSString *value;
/// 是否是客服页面
@property (nonatomic, assign) BOOL isCustomerService;
@end
///支付方式模型
@interface TNTransferPayTypeModel : TNModel
/// 支付方式名称
@property (nonatomic, copy) NSString *name;
/// 付款方式的展示数据
@property (strong, nonatomic) NSArray<TNTransferItemModel *> *dataDictList;
@end


@interface TNTransferRspModel : TNModel
/// 订单金额
@property (strong, nonatomic) SAMoneyModel *money;
/// 说明
@property (nonatomic, copy) NSString *explain;
/// 付款方式
@property (strong, nonatomic) NSArray<TNTransferPayTypeModel *> *payType;
/// 付款凭证数据
@property (strong, nonatomic) TNTransferCredentialModel *credential;

@end

NS_ASSUME_NONNULL_END

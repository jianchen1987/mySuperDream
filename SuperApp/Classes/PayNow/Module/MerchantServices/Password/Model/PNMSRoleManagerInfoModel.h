//
//  PNMSRoleManagerInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSRoleManagerInfoModel : PNModel
/// 角色
@property (nonatomic, assign) PNMSRoleType currentRole;
/// 当前操作员编号
@property (nonatomic, copy) NSString *currentOperatorNo;
/// 超管操作员编号
@property (nonatomic, copy) NSString *managerOperatorNo;
/// 超管姓氏
@property (nonatomic, copy) NSString *managerSurname;
/// 超管名字
@property (nonatomic, copy) NSString *managerName;
@end

NS_ASSUME_NONNULL_END

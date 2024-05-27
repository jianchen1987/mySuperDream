//
//  TNTransferSubmitModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNTransferSubmitModel : TNModel
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;
/// 电话
@property (nonatomic, copy) NSString *mobile;
/// 凭证图片
@property (strong, nonatomic) NSArray *credentialImages;
/// 用户名
@property (nonatomic, copy) NSString *userName;
@end

NS_ASSUME_NONNULL_END

//
//  PNMSVoucherInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSVoucherInfoModel : PNModel
/// 凭证记录唯一标识
@property (nonatomic, copy) NSString *voucherId;
/// 上传时间
@property (nonatomic, strong) NSNumber *createDate;
/// 门店名称
@property (nonatomic, copy) NSString *storeName;
/// 上传的凭证图片地址
@property (nonatomic, strong) NSArray *imgUrl;
/// 名字
@property (nonatomic, copy) NSString *name;
/// 姓氏
@property (nonatomic, copy) NSString *surname;
/// 备注
@property (nonatomic, copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END

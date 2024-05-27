//
//  TNOrderDetailsStoreInfoModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsStoreInfoModel : TNCodingModel
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 门店名
@property (nonatomic, copy) NSString *name;
/// 门店类型
@property (nonatomic, copy) TNStoreType type;
/// 商家客服热线
@property (nonatomic, copy) NSString *hotline;
/// 店铺标签文案
@property (nonatomic, copy) NSString *storeLabelTxt;
@end

NS_ASSUME_NONNULL_END

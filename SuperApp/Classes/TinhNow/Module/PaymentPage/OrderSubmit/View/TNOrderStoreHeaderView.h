//
//  TNOrderStoreHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
#import "TNEnum.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderStoreHeaderModel : NSObject
/// 店铺名称
@property (nonatomic, copy) NSString *storeName;
/// 店铺id
@property (nonatomic, copy) NSString *storeId;
/// 店铺类型
@property (nonatomic, copy) TNStoreType storeType;

/// 是否显示右箭头 跳往店铺详情
@property (nonatomic, assign) BOOL isNeedShowStoreRightIV;
@end


@interface TNOrderStoreHeaderView : SATableHeaderFooterView
/// 数据源
@property (strong, nonatomic) TNOrderStoreHeaderModel *model;
/// 去店铺埋点回调
@property (nonatomic, copy) void (^goStoreTrackEventCallBack)(void);
@end

NS_ASSUME_NONNULL_END

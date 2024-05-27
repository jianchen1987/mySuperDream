//
//  TNBargainProductDetailViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductDetailsRspModel.h"
#import "TNProductNavTitleModel.h"
#import "TNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainProductDetailViewModel : TNViewModel
/// dataSource
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 根据activityId查询砍价商品详情
@property (nonatomic, copy) NSString *activityId;
/// 砍价来的页面  直接显示sku销售价
@property (nonatomic, copy) NSString *bargainPrice;
/// 砍价任务id 用于砍价活动进入详情  分享用
@property (nonatomic, copy) NSString *taskId;
/// 记录原始入参记录
@property (nonatomic, strong) NSDictionary *originParameters;
/// 商品详情
@property (nonatomic, strong) TNProductDetailsRspModel *productDetailsModel;
/// 商品详情显示的标题数组
@property (strong, nonatomic) NSMutableArray<TNProductNavTitleModel *> *titleArr;
/// 刷新标识
@property (nonatomic, assign) BOOL refreshFlag;
/// 获取商品详情数据失败
@property (nonatomic, copy) void (^failGetProductDetaulDataCallBack)(SARspModel *rspModel);

/// 获取砍价商品详情
- (void)queryBargainProductDetailsData;
@end

NS_ASSUME_NONNULL_END

//
//  TNProductDetailsStoreCell.h
//  SuperApp
//  卡片式店铺cell
//  Created by xixi on 2021/1/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNProductStoreModel.h"


@interface TNProductDetailsStoreCellModel : TNModel

@property (nonatomic, strong) TNProductStoreModel *storeModel;
/// 详情显示样式
@property (nonatomic, assign) TNProductDetailViewType detailViewStyle;
/// 供销码  卖家专有
@property (nonatomic, copy) NSString *sp;
/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;
/// 店长推荐
@property (strong, nonatomic) NSArray *goodsArray;
/// 是否显示展开按钮
@property (nonatomic, assign) CGFloat isNeedShowEvaluateDownBtn;
/// 展开店铺评价
@property (nonatomic, assign) BOOL extandStoreEvaluation;
/// 商品id
@property (nonatomic, copy) NSString *productId;
@end


@interface TNProductDetailsStoreCell : SATableViewCell

@property (nonatomic, strong) TNProductDetailsStoreCellModel *model;
/// 客服的回调
@property (nonatomic, copy) void (^customerServiceButtonClickedHander)(NSString *storeNo);
/// 电话的回调
@property (nonatomic, copy) void (^phoneButtonClickedHander)(void);
/// SMS的回调
@property (nonatomic, copy) void (^smsButtonClickedHander)(void);
///
@property (nonatomic, copy) void (^reloadStoreCellCallBack)(void);

@end

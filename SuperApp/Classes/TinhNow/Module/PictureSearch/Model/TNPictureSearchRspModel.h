//
//  TNPictureSearchRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/1/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNPagingRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNPictureSearchModel : TNModel
/// 商品编号  商品详情 如果没有商品id可以通过sn查询到详情
@property (nonatomic, copy) NSString *sn;
/// 商品名称
@property (nonatomic, copy) NSString *title;
/// 商品图片
@property (nonatomic, copy) NSString *thumbnail;
/// 多少人想买
@property (nonatomic, copy) NSString *wantBuy;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 店铺名称
@property (nonatomic, copy) NSString *storeName;
/// 商品所属渠道
@property (nonatomic, copy) NSString *channel;
/// 标题富文本 有海外购的显示海外购
@property (strong, nonatomic) NSAttributedString *nameAttr;
/// cell宽度
@property (nonatomic, assign) CGFloat preferredWidth;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
- (void)configCellHeight;
@end


@interface TNPictureSearchRspModel : TNPagingRspModel
/// 商品列表
@property (nonatomic, strong) NSArray<TNPictureSearchModel *> *items;
@end

NS_ASSUME_NONNULL_END

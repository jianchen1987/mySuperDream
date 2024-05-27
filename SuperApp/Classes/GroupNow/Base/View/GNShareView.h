//
//  GNShareView.h
//  SuperApp
//
//  Created by wmz on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNMultiLanguageManager.h"
#import "GNProductModel.h"
#import "GNStoreDetailModel.h"
#import "GNTheme.h"
#import "SACommonConst.h"
#import "SASocialShareBaseGenerateImageView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNShareView : SASocialShareBaseGenerateImageView
///商品model
@property (nonatomic, strong) GNProductModel *productModel;
///门店model
@property (nonatomic, strong) GNStoreDetailModel *storeModel;
/// codeURL
@property (nonatomic, copy) NSString *codeURL;
///添加商品分享视图
- (void)addSharePorductView;
///添加门店分享视图
- (void)addShareStoreView;
///添加底部
- (void)addBottomView:(GNShareViewType)type;
@end

NS_ASSUME_NONNULL_END

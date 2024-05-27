//
//  TNSpecialProductTagView.h
//  SuperApp
//
//  Created by 张杰 on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNGoodsTagModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSpecialProductTagView : TNView
//容器宽度
@property (nonatomic, assign) CGFloat contentWidth;
///
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *itemArray;
/// 点击回调
@property (nonatomic, copy) void (^tagClickCallBack)(TNGoodsTagModel *model);
/// 标签下拉回调点击
@property (nonatomic, copy) void (^dropSpecialProductTagClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END

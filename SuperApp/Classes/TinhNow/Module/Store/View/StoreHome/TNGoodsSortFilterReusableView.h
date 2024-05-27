//
//  TNGoodsSortFilterReusableView.h
//  SuperApp
//
//  Created by seeu on 2020/7/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchSortFilterBar.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class TNSearchBaseViewModel;
@class TNGoodsTagModel;


@interface TNGoodsSortFilterReusableView : UICollectionReusableView
/// viewmodel
@property (nonatomic, strong) TNSearchBaseViewModel *viewModel;
/// 筛选栏
@property (nonatomic, strong) TNSearchSortFilterBar *sortFilterBar;
/// 分类搜索  展示分类名称
@property (nonatomic, assign) NSString *desText;
/// 专题展示切换商品布局样式按钮
@property (nonatomic, assign) BOOL showChangeProductDisplayStyleBtn;
/// 专题标签栏目
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *tagArr;
//  标签容器宽度
@property (nonatomic, assign) CGFloat contentWidth;
/// 更改商品展示回调
@property (nonatomic, copy) void (^changeProductDisplayStyleCallBack)(void);
/// 标签点击回调
@property (nonatomic, copy) void (^tagClickCallBack)(TNGoodsTagModel *model);
/// 标签下拉回调点击
@property (nonatomic, copy) void (^dropSpecialProductTagClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END

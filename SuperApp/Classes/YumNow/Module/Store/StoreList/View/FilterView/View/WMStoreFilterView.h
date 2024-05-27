//
//  WMStoreFilterView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMStoreFilterModel.h"
#import "WMStoreFilterNavModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMStoreFilterView;
@class WMCategoryItem;

@protocol WMStoreFilterViewDelegate <NSObject>

@optional
- (void)storeFilterViewDidSelectedOption:(WMStoreFilterView *)filterView;

@end


@interface WMStoreFilterView : SAView

/// 根据特定品类初始化
/// @param businessScope 品类 id
- (instancetype)initWithBusinessScope:(NSString *)businessScope;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, weak) id<WMStoreFilterViewDelegate> delegate;      ///< 代理
@property (nonatomic, strong, readonly) WMStoreFilterModel *filterModel; ///< 当前筛选的模型
/** 更新标题 */
- (void)updateTitle:(NSString *)title forType:(WMStoreFilterNavType)type;
/// 模拟点击当前选中的按钮
- (void)simulateClickCurrentTabForType:(WMStoreFilterNavType)type;
/// 清空当前选中的按钮
- (void)clearCurrentSelectedButton;

/// 品类数据如果为空，告诉 C 发起请求
@property (nonatomic, copy) void (^requestCategoryListBlock)(void);
/// 成功获取到品类数据后，告知外部刷新门店数据（外部传了品类 id 才会 触发，否则无必要）
@property (nonatomic, copy) void (^refreshStoreListBlock)(void);
/// 成功获取品类数据
- (void)successGetCategoryList;
@end

NS_ASSUME_NONNULL_END

//
//  SACMSWaterfallCategoryCollectionReusableView.h
//  SuperApp
//
//  Created by seeu on 2022/2/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SACMSWaterfallCategoryCollectionReusableViewModel;
@class SACMSCategoryTitleModel;


@interface SACMSWaterfallCategoryCollectionReusableView : UICollectionReusableView

///< 模型
@property (nonatomic, strong) SACMSWaterfallCategoryCollectionReusableViewModel *model;
/// 选择回调
@property (nonatomic, copy) void (^clickedOnCategory)(SACMSCategoryTitleModel *model, SACMSWaterfallCategoryCollectionReusableView *cell);

@end


@interface SACMSWaterfallCategoryCollectionReusableViewModel : NSObject
///< 高亮颜色
@property (nonatomic, copy) NSString *tintColor;
///< 标题字体
@property (nonatomic, assign) NSUInteger fontSize;
///< 标题
@property (nonatomic, strong) NSArray<SACMSCategoryTitleModel *> *titles;

@end

NS_ASSUME_NONNULL_END

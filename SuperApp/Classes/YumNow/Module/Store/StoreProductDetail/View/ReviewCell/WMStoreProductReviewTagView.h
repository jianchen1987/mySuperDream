//
//  WMStoreProductReviewTagView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreProductReviewTagModel : WMModel

/// 标题
@property (nonatomic, copy) NSString *title;
/// 标签id
@property (nonatomic, copy) NSString *tagId;

@end

/// 评论 cell 上标签信息
@interface WMStoreProductReviewTagView : SAView

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 图标
@property (nonatomic, copy) NSString *iconName;
/// 标签文字大小(默认是standard3)
@property (nonatomic, strong) UIFont *font;
/// 标签数组
@property (nonatomic, copy) NSArray<WMStoreProductReviewTagModel *> *tags;
/// 点击了标签
@property (nonatomic, copy) void (^clickedTagButtonBlock)(HDUIGhostButton *buton, WMStoreProductReviewTagModel *tag);
@end

NS_ASSUME_NONNULL_END

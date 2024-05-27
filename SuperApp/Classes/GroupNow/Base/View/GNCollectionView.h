//
//  GNCollectionView.h
//  SuperApp
//
//  Created by wmz on 2021/6/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "SACollectionView.h"
#import "SACollectionViewCell.h"
typedef void (^GNCustomPlaceHolder)(UIViewPlaceholderViewModel *_Nonnull placeholderViewModel, BOOL showError);

NS_ASSUME_NONNULL_BEGIN


@interface GNCollectionView : SACollectionView
///触发多手势响应 默认NO
@property (nonatomic, assign) BOOL shouldRecognizeSimultaneousl;
///需要手动刷新
@property (nonatomic, assign) BOOL needRefreshBtn;
/// 刷新按钮回调
@property (nonatomic, copy) GNCustomPlaceHolder customPlaceHolder;
///占位
@property (nonatomic, strong) UIViewPlaceholderViewModel *gnPlaceholderViewModel;
- (void)updateUI;

- (void)gnFailGetNewData;

- (void)gnFailLoadMoreData;
///根据业务的刷新
- (void)reloadNewData:(BOOL)isNoMore;
///根据业务的刷新
- (void)reloadMoreData:(BOOL)isNoMore;
@end

NS_ASSUME_NONNULL_END

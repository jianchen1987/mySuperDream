//
//  WMNearbyFilterBarView.h
//  SuperApp
//
//  Created by Chaos on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMNearbyFilterModel;

NS_ASSUME_NONNULL_BEGIN

@interface WMNearbyFilterBarViewFilterParamsModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *value;
/// 选择状态
@property (nonatomic) BOOL isSelected;
/// 文本宽度
@property (nonatomic) NSInteger width;

@end

@interface WMNearbyFilterBarViewFilterModel : NSObject

@property (nonatomic, assign) BOOL moreChoices;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) NSArray *params;

@end

@interface WMNearbyFilterBarContentView : SAView<HDCustomViewActionViewProtocol,UICollectionViewDelegate, UICollectionViewDataSource>
/// 重置按钮
@property (nonatomic, strong) UIButton *resetBTN;
/// 确定按钮
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<WMNearbyFilterBarViewFilterModel *> *filterDataSource;

/// 点击确认按钮回调
@property (nonatomic, copy) void (^submitBlock)(NSArray <NSString *>*marketingTypes ,NSArray <NSString *>*storeFeature);

@end

@interface WMNearbyFilterBarView : SAView
- (instancetype)initWithFrame:(CGRect)frame filterModel:(WMNearbyFilterModel *)filterModel startOffsetY:(CGFloat)offset;
/// 起始坐标Y
@property (nonatomic, assign) CGFloat startOffsetY;
/// viewWillAppear
@property (nonatomic, copy) void (^viewWillAppear)(UIView *view);
/// viewWillDisappear
@property (nonatomic, copy) void (^viewWillDisappear)(UIView *view);

- (void)hideAllSlideDownView;
///重置
- (void)resetAll;
@end

NS_ASSUME_NONNULL_END

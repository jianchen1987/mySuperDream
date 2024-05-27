//
//  PNFilterView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PNFilterViewDelegate <NSObject>

@optional
/// 交易类型数据源
- (NSMutableArray *)tradeTypeDataSource;

@end

/// 点击确定回调
typedef void (^ConfirmBlock)(NSString *startDate, NSString *endDate, PNTransType transType, NSString *currency);


@interface PNFilterView : PNView

@property (nonatomic, weak) id<PNFilterViewDelegate> delegate;

@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, assign) PNTransType transType;
@property (nonatomic, strong) NSString *currency;

@property (nonatomic, copy) ConfirmBlock confirmBlock;

- (void)showInSuperView:(UIView *)superview;

@end

NS_ASSUME_NONNULL_END

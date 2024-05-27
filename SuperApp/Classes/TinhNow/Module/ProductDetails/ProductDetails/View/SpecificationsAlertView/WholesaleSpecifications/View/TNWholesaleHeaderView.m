//
//  TNWholesaleHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNWholesaleHeaderView.h"


@interface TNWholesaleHeaderItemView : TNView
/// 价格
@property (strong, nonatomic) UILabel *priceLabel;
/// 起批数量
@property (strong, nonatomic) UILabel *batchNumberLabel;
///
@property (strong, nonatomic) TNWholesalePriceAndBatchNumberModel *model;
@end


@implementation TNWholesaleHeaderItemView

- (void)hd_setupViews {
    [self addSubview:self.priceLabel];
    [self addSubview:self.batchNumberLabel];
}
- (void)setModel:(TNWholesalePriceAndBatchNumberModel *)model {
    _model = model;
    self.priceLabel.text = model.showPrice;
    self.batchNumberLabel.text = model.batchNumber;
    if (model.isRangePrice) {
        self.priceLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
    } else {
        self.priceLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(kRealWidth(6));
    }];
    [self.batchNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(6));
    }];
    [super updateConstraints];
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _priceLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}
/** @lazy batchNumberLabel */
- (UILabel *)batchNumberLabel {
    if (!_batchNumberLabel) {
        _batchNumberLabel = [[UILabel alloc] init];
        _batchNumberLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _batchNumberLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _batchNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _batchNumberLabel;
}
@end


@implementation TNWholesaleHeaderView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollView.bounces = NO;
}
- (void)setList:(NSArray<TNWholesalePriceAndBatchNumberModel *> *)list {
    _list = list;
    [self.scrollViewContainer hd_removeAllSubviews];
    CGFloat width = list.count <= 3 ? kScreenWidth / list.count : kScreenWidth / 3;
    UIView *lastView = nil;
    for (int i = 0; i < list.count; i++) {
        TNWholesalePriceAndBatchNumberModel *model = list[i];
        TNWholesaleHeaderItemView *itemView = [[TNWholesaleHeaderItemView alloc] init];
        itemView.model = model;
        [self.scrollViewContainer addSubview:itemView];

        [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.scrollViewContainer);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            } else {
                make.left.equalTo(self.scrollViewContainer);
            }
            make.width.mas_equalTo(width);
            if (i == list.count - 1) {
                make.right.equalTo(self.scrollViewContainer);
            }
        }];
        lastView = itemView;
    }
    [self setNeedsUpdateConstraints];
}

- (void)bingoBatchNumberModel:(TNWholesalePriceAndBatchNumberModel *)model {
    __block NSInteger bingoIndex;
    [self.list enumerateObjectsUsingBlock:^(TNWholesalePriceAndBatchNumberModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj != model) {
            obj.isRangePrice = NO;
        } else {
            obj.isRangePrice = YES;
            bingoIndex = idx;
        }
        TNWholesaleHeaderItemView *itemView = self.scrollViewContainer.subviews[idx];
        itemView.model = obj;
    }];

    if (self.scrollView.contentOffset.x > kScreenWidth || bingoIndex > 2) {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth / 3 * bingoIndex, 0) animated:YES];
    }
}
- (void)reset {
    [self.list enumerateObjectsUsingBlock:^(TNWholesalePriceAndBatchNumberModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.isRangePrice = NO;
        TNWholesaleHeaderItemView *itemView = self.scrollViewContainer.subviews[idx];
        itemView.model = obj;
    }];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    [super updateConstraints];
}
@end

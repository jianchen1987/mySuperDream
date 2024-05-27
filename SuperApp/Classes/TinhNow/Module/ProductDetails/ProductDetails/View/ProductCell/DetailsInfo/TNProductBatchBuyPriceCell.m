//
//  TNProductBatchBuyPriceCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBatchBuyPriceCell.h"
#import "TNProductBatchLadderPriceView.h"
#import "TNProductBatchNormalPriceView.h"
#import "TNProductBatchPriceInfoModel.h"


@interface TNProductBatchBuyPriceCell ()
///
@property (strong, nonatomic) TNProductBatchNormalPriceView *normalView;
@property (strong, nonatomic) TNProductBatchLadderPriceView *priceView;
@end


@implementation TNProductBatchBuyPriceCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.normalView];
    [self.contentView addSubview:self.priceView];
}
- (void)setModel:(TNProductBatchBuyPriceCellModel *)model {
    _model = model;
    if (model.infoModel.quoteType == TNProductQuoteTypeNoSpecByNumber || model.infoModel.quoteType == TNProductQuoteTypeHasSpecByNumber) {
        //有阶梯价
        self.priceView.hidden = NO;
        self.normalView.hidden = YES;
        self.priceView.infoModel = model.infoModel;
    } else {
        //没有阶梯价
        self.priceView.hidden = YES;
        self.normalView.hidden = NO;
        self.normalView.model = model.infoModel;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    if (!self.normalView.isHidden) {
        [self.normalView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    if (!self.priceView.isHidden) {
        [self.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    [super updateConstraints];
}
/** @lazy priceView */
- (TNProductBatchLadderPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[TNProductBatchLadderPriceView alloc] init];
    }
    return _priceView;
}
/** @lazy normalView */
- (TNProductBatchNormalPriceView *)normalView {
    if (!_normalView) {
        _normalView = [[TNProductBatchNormalPriceView alloc] init];
    }
    return _normalView;
}
@end


@implementation TNProductBatchBuyPriceCellModel

@end

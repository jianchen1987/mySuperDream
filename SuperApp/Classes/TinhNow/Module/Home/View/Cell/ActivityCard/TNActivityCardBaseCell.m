//
//  TNActivityCardBaseCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardBaseCell.h"


@interface TNActivityCardBaseCell ()
/// 文本
@property (strong, nonatomic) UILabel *titleLabel;
@end


@implementation TNActivityCardBaseCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.headerView];
    [self.headerView addSubview:self.titleLabel];
    self.backgroundColor = [UIColor clearColor];
}
- (void)setCardModel:(TNActivityCardModel *)cardModel {
    _cardModel = cardModel;
    if (cardModel.scene == TNActivityCardSceneTopic || HDIsStringEmpty(cardModel.advertiseName)) {
        self.titleLabel.hidden = YES;
    } else {
        self.titleLabel.hidden = NO;
        self.titleLabel.text = cardModel.advertiseName;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(self.cardModel.isSpecialStyleVertical ? kRealWidth(5) : kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(self.cardModel.isSpecialStyleVertical ? -kRealWidth(5) : -kRealWidth(10));
    }];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.baseView);
        make.height.mas_equalTo(self.cardModel.headerHeight);
        if (self.cardModel.titlePosition == TNActivityCardTitlePositionTop) {
            make.top.equalTo(self.baseView);
        } else {
            make.bottom.equalTo(self.baseView);
        }
    }];
    if (!self.titleLabel.isHidden) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headerView.mas_centerY);
            make.left.equalTo(self.headerView.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.headerView.mas_right).offset(-kRealWidth(10));
        }];
    }
    [super updateConstraints];
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}
- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        _baseView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            if (self.cardModel.scene != TNActivityCardSceneTopic && self.cardModel.cardStyle != TNActivityCardStyleText) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:8];
            }
        };
    }
    return _baseView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _titleLabel;
}
@end

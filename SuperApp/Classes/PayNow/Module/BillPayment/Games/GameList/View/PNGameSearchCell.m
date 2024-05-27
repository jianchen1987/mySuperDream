//
//  PNGameSearchCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameSearchCell.h"
#import "PNGameRspModel.h"


@interface PNGameSearchCell ()
///
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) UIView *lineView;
@end


@implementation PNGameSearchCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = HexColor(0xF3F4FA);
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lineView];
}
- (void)setModel:(PNGameCategoryModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
}
- (void)updateConstraints {
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    [super updateConstraints];
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [HDAppTheme.PayNowFont fontBold:14];
        _nameLabel.textColor = HexColor(0x333333);
    }
    return _nameLabel;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(0xE9EAEF);
    }
    return _lineView;
}
@end

//
//  PNMSStoreListCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreListCell.h"
#import "PNMSStoreInfoModel.h"


@interface PNMSStoreListCell ()
@property (nonatomic, strong) SALabel *nameLabel;
@property (nonatomic, strong) SALabel *numberLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNMSStoreListCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-kRealWidth(8));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(16));
    }];

    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(4));
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(self.nameLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(16));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.height.equalTo(@(PixelOne));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(1));
    }];

    [super updateConstraints];
}

- (void)setModel:(PNMSStoreInfoModel *)model {
    _model = model;

    self.nameLabel.text = self.model.storeName;
    self.numberLabel.text = [NSString stringWithFormat:@"%@: %zd%@", PNLocalizedString(@"pn_Number_of_staff", @"门店人数："), self.model.operatorCount, PNLocalizedString(@"pn_num_people", @"人")];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALabel *)numberLabel {
    if (!_numberLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        _numberLabel = label;
    }
    return _numberLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_icon_black_arrow"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line;
}
@end

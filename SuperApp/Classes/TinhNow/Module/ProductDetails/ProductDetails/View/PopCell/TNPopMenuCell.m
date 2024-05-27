//
//  TNPopMenuCell.m
//  SuperApp
//
//  Created by xixi on 2021/1/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPopMenuCell.h"
#import "HDAppTheme+TinhNow.h"


@implementation TNPopMenuCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10.f);
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.centerY.mas_equalTo(self);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20.f);
    }];
    [super updateConstraints];
}

- (void)setModel:(TNPopMenuCellModel *)model {
    _model = model;

    self.iconImgView.image = [UIImage imageNamed:model.icon];
    self.titleLabel.text = model.title;

    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.font = HDAppTheme.TinhNowFont.standard14;
    }
    return _titleLabel;
}
@end


@implementation TNPopMenuCellModel

@end

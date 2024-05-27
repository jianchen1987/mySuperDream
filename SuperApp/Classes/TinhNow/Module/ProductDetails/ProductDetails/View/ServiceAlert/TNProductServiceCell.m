//
//  TNProductServiceCell.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductServiceCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNProductServiceCell ()
@property (nonatomic, strong) UIImageView *icon;      ///< 左边图片
@property (nonatomic, strong) UIStackView *stackView; ///< 容器
@property (nonatomic, strong) UILabel *nameLabel;     ///<名称
@property (nonatomic, strong) UILabel *contentLabel;  ///<文本
@end


@implementation TNProductServiceCell

- (void)setModel:(TNProductServiceModel *)model {
    _model = model;
    _nameLabel.text = model.name;
    if (HDIsStringNotEmpty(model.content)) {
        _contentLabel.text = model.content;
        [_contentLabel setHidden:false];
    } else {
        [_contentLabel setHidden:true];
    }
}

- (void)hd_setupViews {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.nameLabel];
    [self.stackView addArrangedSubview:self.contentLabel];
}
- (void)updateConstraints {
    [self.icon sizeToFit];
    [self.nameLabel sizeToFit];
    [self.contentLabel sizeToFit];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2);
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.size.mas_equalTo(self.icon.image.size);
    }];
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];

    [super updateConstraints];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"tinhnow_service"];
    }
    return _icon;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 10;
    }
    return _stackView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
    }
    return _nameLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _contentLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _contentLabel;
}
@end

//
//  SAImageTitleTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAImageTitleTableViewCell.h"


@implementation SAImageTitleTableViewCellModel

@end


@interface SAImageTitleTableViewCell ()
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation SAImageTitleTableViewCell

- (void)hd_setupViews {
    self.textLabel.font = HDAppTheme.font.standard2Bold;
    self.textLabel.textColor = HDAppTheme.color.G1;

    // 横线
    [self.contentView addSubview:self.bottomLine];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.imageView.image.size);
        make.left.equalTo(self.contentView).offset(kRealWidth(20));
        make.centerY.equalTo(self.contentView);
    }];

    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(kRealWidth(10));
        make.top.equalTo(self.contentView).offset(kRealWidth(20));
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(PixelOne);
        make.left.equalTo(self.textLabel);
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SAImageTitleTableViewCellModel *)model {
    _model = model;

    self.imageView.image = model.image;
    self.textLabel.text = model.title;
}

#pragma mark - lazy load
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end

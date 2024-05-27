//
//  TNCategoryFirstLevelTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryFirstLevelTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNFirstLevelCategoryModel.h"


@interface TNCategoryFirstLevelTableViewCell ()
/// name
@property (nonatomic, strong) UILabel *nameLabel;
/// icon
@property (nonatomic, strong) UIImageView *icon;

@end


@implementation TNCategoryFirstLevelTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.icon];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.icon.mas_bottom).offset(7);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo([self imageSize]);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(TNFirstLevelCategoryModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    [self setBgColorBy:model.isSelected];
}
- (void)setBgColorBy:(BOOL)isSelected {
    if (isSelected) {
        self.nameLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [HDWebImageManager setImageWithURL:self.model.selectedimgUrl placeholderImage:[HDHelper placeholderImageWithSize:[self imageSize]] imageView:self.icon];
    } else {
        self.nameLabel.textColor = [UIColor hd_colorWithHexString:@"#333443"];
        self.contentView.backgroundColor = HDAppTheme.TinhNowColor.G6;
        [HDWebImageManager setImageWithURL:self.model.uncheckimgUrl placeholderImage:[HDHelper placeholderImageWithSize:[self imageSize]] imageView:self.icon];
    }
}

#pragma mark - lazy load
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HDAppTheme.font.standard4;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}
- (CGSize)imageSize {
    return CGSizeMake(kRealWidth(24), kRealWidth(24));
}
@end

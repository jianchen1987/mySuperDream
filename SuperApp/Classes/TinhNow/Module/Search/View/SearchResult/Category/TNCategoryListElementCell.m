//
//  TNCategoryListElementCell.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryListElementCell.h"


@interface TNCategoryListElementCell ()
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// icon
@property (nonatomic, strong) UIImageView *icon;
/// 图片
@property (nonatomic, copy) NSString *logo;
@end


@implementation TNCategoryListElementCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.icon];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [self addGestureRecognizer:tap];
}
- (void)itemClick:(UIGestureRecognizer *)tap {
    if (self.itemClickCallBack) {
        self.itemClickCallBack(self.model);
    }
}
- (void)setNotShowSelectedStyle:(BOOL)notShowSelectedStyle {
    _notShowSelectedStyle = notShowSelectedStyle;
}
- (void)setModel:(TNCategoryModel *)model {
    _model = model; //商品分类字段和商铺分类字段有些不一致  这边赶时间  复用
    if (HDIsStringNotEmpty(model.menuName.desc)) {
        self.titleLabel.text = model.menuName.desc;
    } else {
        self.titleLabel.text = model.name;
    }
    //设置图片  有可能是本地图片
    self.logo = HDIsStringNotEmpty(model.icon) ? model.icon : model.logo;

    if (!self.notShowSelectedStyle) {
        [self setClickColor:model.isSelected];
    } else {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.G2;
        self.icon.layer.borderColor = UIColor.clearColor.CGColor;
        [HDWebImageManager setImageWithURL:self.logo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(self.model.imageWidth, self.model.imageWidth)] imageView:self.icon];
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(self.model.imageWidth, self.model.imageWidth));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setClickColor:(BOOL)isClick {
    self.icon.image = nil;
    if (isClick == true) {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.C1;
        if (_model.selectLogoImage != nil) {
            [self.icon sd_cancelCurrentImageLoad]; //解决网络图片异步覆盖问题
            self.icon.image = _model.selectLogoImage;
            self.icon.layer.borderColor = UIColor.clearColor.CGColor;
        } else {
            self.icon.layer.borderColor = HDAppTheme.TinhNowColor.C1.CGColor;
            [HDWebImageManager setImageWithURL:self.logo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(self.model.imageWidth, self.model.imageWidth)] imageView:self.icon];
        }
    } else {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.G2;
        self.icon.layer.borderColor = UIColor.clearColor.CGColor;
        if (_model.unSelectLogoImage != nil) {
            [self.icon sd_cancelCurrentImageLoad];
            self.icon.image = _model.unSelectLogoImage;
        } else {
            [HDWebImageManager setImageWithURL:self.logo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(self.model.imageWidth, self.model.imageWidth)] imageView:self.icon];
        }
    }
}
#pragma mark - lazy load
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard4;
        _titleLabel.textColor = HDAppTheme.color.G2;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.masksToBounds = true;
        _icon.layer.cornerRadius = 4;
        _icon.layer.borderWidth = 1;
    }
    return _icon;
}
@end

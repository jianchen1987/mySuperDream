//
//  TNFavoritesCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNFavoritesCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "TNGoodFavoritesModel.h"
#import "TNStoreFavoritesModel.h"


@interface TNFavoritesCell ()
/// 图片
@property (strong, nonatomic) UIImageView *icon;
/// 名字
@property (strong, nonatomic) HDLabel *nameLabel;
/// 价格
@property (strong, nonatomic) HDLabel *priceLabel;
/// 删除按钮
@property (strong, nonatomic) SAOperationButton *deleteBtn;
/// 荣誉标识
@property (strong, nonatomic) UIImageView *honorLogoImageView;
@end


@implementation TNFavoritesCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.honorLogoImageView];
}

- (void)setGoodModel:(TNGoodFavoritesModel *)goodModel {
    _goodModel = goodModel;
    [HDWebImageManager setImageWithURL:goodModel.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(80), kRealWidth(80))] imageView:self.icon];
    self.nameLabel.text = goodModel.name;
    self.priceLabel.text = goodModel.price.thousandSeparatorAmount;
    [self setNeedsUpdateConstraints];
}
- (void)setStoreModel:(TNStoreFavoritesModel *)storeModel {
    _storeModel = storeModel;
    if (storeModel.isMicroShop) {
        if (HDIsStringNotEmpty(storeModel.supplierFavoriteRespDto.supplierImage)) {
            [HDWebImageManager setImageWithURL:storeModel.supplierFavoriteRespDto.supplierImage placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(80), kRealWidth(80))]
                                     imageView:self.icon];
        } else {
            self.icon.image = [UIImage imageNamed:@"tn_microshop_defalut"];
        }

        self.nameLabel.text = storeModel.supplierFavoriteRespDto.nickName;
        self.priceLabel.hidden = YES;
        self.honorLogoImageView.hidden = !storeModel.supplierFavoriteRespDto.isHonor;
    } else {
        [HDWebImageManager setImageWithURL:storeModel.logo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(80), kRealWidth(80))] imageView:self.icon];
        self.nameLabel.text = storeModel.name;
        self.priceLabel.hidden = YES;
        self.honorLogoImageView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_top);
        make.left.equalTo(self.icon.mas_right).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    if (!self.honorLogoImageView.isHidden) {
        [self.honorLogoImageView sizeToFit];
        [self.honorLogoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(10));
        }];
    }
    if (!self.priceLabel.isHidden) {
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.icon.mas_bottom);
            make.left.equalTo(self.icon.mas_right).offset(kRealWidth(8));
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    [self.deleteBtn sizeToFit];
    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.icon.mas_bottom).offset(kRealWidth(10));
    }];
    [super updateConstraints];
}
/** @lazy icon */
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _icon;
}
/** @lazy nameLabel */
- (HDLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[HDLabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.numberOfLines = 2;
        _nameLabel.hd_lineSpace = 3;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _nameLabel;
}
/** @lazy priceLabel */
- (HDLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[HDLabel alloc] init];
        _priceLabel.textColor = HexColor(0xFF4444);
        _priceLabel.font = HDAppTheme.TinhNowFont.standard20;
    }
    return _priceLabel;
}
/** @lazy deleteBtn */
- (SAOperationButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _deleteBtn.borderColor = HDAppTheme.TinhNowColor.G3;
        _deleteBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
        [_deleteBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_deleteBtn setTitle:TNLocalizedString(@"tn_delete", @"删除") forState:UIControlStateNormal];
        [_deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
        @HDWeakify(self);
        [_deleteBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.goodDeleteCallBack) {
                self.goodDeleteCallBack(self.goodModel);
            }
            if (self.storeDeleteCallBack) {
                self.storeDeleteCallBack(self.storeModel);
            }
        }];
    }
    return _deleteBtn;
}
/** @lazy honorLogoImageView */
- (UIImageView *)honorLogoImageView {
    if (!_honorLogoImageView) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", @"tn_highquality_store", [TNMultiLanguageManager currentLanguage]];
        _honorLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        _honorLogoImageView.hidden = YES;
    }
    return _honorLogoImageView;
}
@end

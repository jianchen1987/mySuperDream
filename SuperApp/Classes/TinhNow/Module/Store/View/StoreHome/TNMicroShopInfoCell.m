//
//  TNMicroShopInfoCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopInfoCell.h"
#import "TNStoreDTO.h"


@interface TNMicroShopInfoCell ()
/// 店铺图片
@property (strong, nonatomic) UIImageView *shopImageView;
/// 店铺名称
@property (strong, nonatomic) UILabel *shopNameLabel;
/// 店铺号
@property (strong, nonatomic) UILabel *shopNoLabel;
/// 收藏按钮
@property (nonatomic, strong) HDUIButton *favoriteButton;
/// 荣誉标识
@property (strong, nonatomic) UIImageView *honorLogoImageView;
/// storeDTO
@property (nonatomic, strong) TNStoreDTO *storeDTO;
/// 是否监听了
@property (nonatomic, assign) BOOL hasObsever;
@end


@implementation TNMicroShopInfoCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.shopImageView];
    [self.contentView addSubview:self.shopNameLabel];
    [self.contentView addSubview:self.honorLogoImageView];
    [self.contentView addSubview:self.shopNoLabel];
    [self.contentView addSubview:self.favoriteButton];
}
- (void)setModel:(TNMicroShopDetailInfoModel *)model {
    _model = model;
    if (HDIsStringNotEmpty(model.supplierImage)) {
        [HDWebImageManager setImageWithURL:model.supplierImage placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(70, 70)] imageView:self.shopImageView];
    } else {
        self.shopImageView.image = [UIImage imageNamed:@"tn_microshop_defalut"];
    }

    self.shopNameLabel.text = model.nickName;
    self.shopNoLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"wkqZNwOl", @"微店号"), model.supplierId];
    self.honorLogoImageView.hidden = !model.isHonor;
    self.favoriteButton.selected = model.collectFlag;
    if (!self.hasObsever) {
        @HDWeakify(self);
        [self.KVOController hd_observe:self.model keyPath:@"collectFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            self.favoriteButton.selected = self.model.collectFlag;
        }];
        self.hasObsever = YES;
    }
}
#pragma mark -收藏点击
- (void)onClickFavorite:(HDUIButton *)btn {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }
    @HDWeakify(self);
    if ([self.favoriteButton isSelected]) {
        // 取消
        [self.storeDTO cancelStoreFavoriteWithStoreNo:@"" storeType:1 supplierId:self.model.supplierId success:^{
            @HDStrongify(self);
            self.model.collectFlag = NO;
            self.favoriteButton.selected = NO;
            [HDTips showWithText:TNLocalizedString(@"tn_remove_favorite", @"取消收藏成功") inView:KeyWindow hideAfterDelay:3];
        } failure:nil];
    } else {
        [self.storeDTO addStoreFavoritesWithStoreNo:@"" storeType:1 supplierId:self.model.supplierId success:^{
            @HDStrongify(self);
            self.model.collectFlag = YES;
            self.favoriteButton.selected = YES;
            [HDTips showWithText:TNLocalizedString(@"tn_add_favorite", @"收藏成功") inView:KeyWindow hideAfterDelay:3];
        } failure:nil];
    }
}
- (void)updateConstraints {
    [self.shopImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(70), kRealWidth(70)));
    }];
    [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImageView.mas_right).offset(kRealWidth(12));
        make.top.equalTo(self.shopImageView.mas_top);
        if (self.honorLogoImageView.isHidden) {
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }
    }];
    if (!self.honorLogoImageView.isHidden) {
        [self.honorLogoImageView sizeToFit];
        [self.honorLogoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.shopNameLabel.mas_centerY);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.left.equalTo(self.shopNameLabel.mas_right).offset(kRealWidth(10));
        }];
        [self.honorLogoImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.shopNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    [self.shopNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shopNameLabel.mas_leading);
        make.top.equalTo(self.shopNameLabel.mas_bottom).offset(kRealWidth(10));
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.favoriteButton sizeToFit];
    [self.favoriteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopNoLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
/** @lazy shopImageView */
- (UIImageView *)shopImageView {
    if (!_shopImageView) {
        _shopImageView = [[UIImageView alloc] init];
        _shopImageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(70, 70)];
    }
    return _shopImageView;
}
/** @lazy shopNameLabel */
- (UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _shopNameLabel.font = [HDAppTheme.TinhNowFont fontSemibold:17];
        _shopNameLabel.numberOfLines = 2;
        _shopNameLabel.text = @"--";
    }
    return _shopNameLabel;
}
/** @lazy shopNoLabel */
- (UILabel *)shopNoLabel {
    if (!_shopNoLabel) {
        _shopNoLabel = [[UILabel alloc] init];
        _shopNoLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _shopNoLabel.font = HDAppTheme.TinhNowFont.standard12;
        _shopNoLabel.text = @"--";
    }
    return _shopNoLabel;
}
/** @lazy favoriteButton */
- (HDUIButton *)favoriteButton {
    if (!_favoriteButton) {
        _favoriteButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_favoriteButton setImage:[UIImage imageNamed:@"tinhnow_store_favorite_normal"] forState:UIControlStateNormal];
        [_favoriteButton setImage:[UIImage imageNamed:@"tinhnow_store_favorite_selected"] forState:UIControlStateSelected];
        [_favoriteButton addTarget:self action:@selector(onClickFavorite:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favoriteButton;
}
/** @lazy honorLogoImageView */
- (UIImageView *)honorLogoImageView {
    if (!_honorLogoImageView) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", @"tn_highquality_store", [TNMultiLanguageManager currentLanguage]];
        _honorLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    return _honorLogoImageView;
}
/** @lazy storeDTO */
- (TNStoreDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = [[TNStoreDTO alloc] init];
    }
    return _storeDTO;
}
@end

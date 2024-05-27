//
//  TNStoreIntroductionView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreIntroductionView.h"
#import "SAInternationalizationModel.h"
#import "SATalkingData.h"
#import "TNStoreDTO.h"
#import "TNStoreInfoRspModel.h"


@interface TNStoreIntroductionView ()
/// logo
@property (nonatomic, strong) UIImageView *logoImageView;
/// 店铺点击视图
@property (strong, nonatomic) UIView *storeTapView;
/// storename
@property (nonatomic, strong) UILabel *storeNameLabel;
/// jumpSign
@property (nonatomic, strong) UIImageView *arrowImageView;
/// 电话
@property (nonatomic, strong) HDUIButton *phoneCallButton;
/// 地址
@property (strong, nonatomic) UILabel *adressLabel;
/// 地址图片
@property (nonatomic, strong) UIImageView *adressImageView;
/// 营业时间
@property (nonatomic, strong) HDUIButton *timeButton;
/// 收藏按钮
@property (nonatomic, strong) HDUIButton *favoriteButton;
/// storeDTO
@property (nonatomic, strong) TNStoreDTO *storeDTO;
/// 海外购店铺标签
@property (strong, nonatomic) UIImageView *storeTagImageView;
/// 名称和 标签
@property (strong, nonatomic) UIStackView *nameStackView;
/// 是否监听了
@property (nonatomic, assign) BOOL hasObsever;
@end


@implementation TNStoreIntroductionView

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.logoImageView];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.phoneCallButton];
    [self addSubview:self.timeButton];
    [self addSubview:self.favoriteButton];
    [self addSubview:self.adressImageView];
    [self addSubview:self.adressLabel];
    [self addSubview:self.nameStackView];
    [self.nameStackView addArrangedSubview:self.storeNameLabel];
    [self.nameStackView addArrangedSubview:self.storeTagImageView];
    [self addSubview:self.storeTapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnStoreName:)];
    [self.storeTapView addGestureRecognizer:tap];
}
- (void)updateConstraints {
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.mas_top).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(70), kRealWidth(70)));
    }];

    [self.storeTapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.mas_top).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(25));
    }];
    if (!self.storeTagImageView.isHidden) {
        [self.storeTagImageView sizeToFit];
    }
    [self.nameStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(kRealWidth(15));
        make.top.equalTo(self.mas_top).offset(kRealWidth(10));
        make.right.lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-kRealWidth(10));
    }];

    [self.arrowImageView sizeToFit];
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.centerY.equalTo(self.nameStackView.mas_centerY);
    }];

    [self.phoneCallButton sizeToFit];
    [self.phoneCallButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(kRealWidth(15));
        make.top.equalTo(self.nameStackView.mas_bottom).offset(kRealWidth(6));
        make.right.lessThanOrEqualTo(self.favoriteButton.mas_left).offset(-kRealWidth(10));
    }];
    [self.timeButton sizeToFit];
    [self.timeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(kRealWidth(15));
        make.top.equalTo(self.phoneCallButton.mas_bottom).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.favoriteButton.mas_left).offset(-kRealWidth(10));
    }];
    if (!self.adressLabel.isHidden) {
        [self.adressImageView sizeToFit];
        [self.adressImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logoImageView.mas_bottom).offset(kRealWidth(15));
            make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        }];
        [self.adressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.adressImageView.mas_top).offset(2);
            make.left.equalTo(self.adressImageView.mas_right).offset(8);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-kRealWidth(15));
        }];
    }
    [self.favoriteButton sizeToFit];
    [self.favoriteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.centerY.equalTo(self.logoImageView.mas_centerY);
        make.size.mas_equalTo(self.favoriteButton.frame.size);
    }];

    [self.adressImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.adressLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    if (!self.storeTagImageView.isHidden) {
        [self.storeTagImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.storeNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    [super updateConstraints];
}
- (void)setStoreInfo:(TNStoreInfoRspModel *)storeInfo {
    _storeInfo = storeInfo;
    [HDWebImageManager setImageWithURL:storeInfo.logo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(70, 70) logoWidth:50] imageView:self.logoImageView];
    self.storeNameLabel.text = storeInfo.name.desc;
    if ([storeInfo.storeType isEqualToString:TNStoreTypeOverseasShopping]) {
        self.storeTagImageView.hidden = NO;
        self.storeTagImageView.image = [UIImage imageNamed:@"tn_global_k"];
    } else if ([storeInfo.storeType isEqualToString:TNStoreTypeSelf]) {
        self.storeTagImageView.hidden = NO;
        self.storeTagImageView.image = [UIImage imageNamed:@"tn_offcial_k"];
    } else {
        self.storeTagImageView.hidden = YES;
    }
    if (HDIsStringNotEmpty(storeInfo.phone)) {
        [self.phoneCallButton setTitle:storeInfo.phone forState:UIControlStateNormal];
    } else {
        [self.phoneCallButton setTitle:TNLocalizedString(@"tn_store_notContact", @"暂无联系方式") forState:UIControlStateNormal];
    }
    if (HDIsStringNotEmpty(storeInfo.address)) {
        self.adressLabel.text = storeInfo.address;
        self.adressLabel.hidden = NO;
        self.adressImageView.hidden = NO;
    } else {
        self.adressLabel.hidden = YES;
        self.adressImageView.hidden = YES;
    }
    if (HDIsStringNotEmpty(storeInfo.businessStartDate) && HDIsStringNotEmpty(storeInfo.businessEndDate)) {
        self.timeButton.hidden = NO;
        [self.timeButton setTitle:[NSString stringWithFormat:@"%@ - %@", storeInfo.businessStartDate, storeInfo.businessEndDate] forState:UIControlStateNormal];
    } else {
        self.timeButton.hidden = YES;
    }

    [self.favoriteButton setSelected:storeInfo.collectFlag];

    if (!self.hasObsever) {
        @HDWeakify(self);
        [self.KVOController hd_observe:self.storeInfo keyPath:@"collectFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            self.favoriteButton.selected = self.storeInfo.collectFlag;
        }];
        self.hasObsever = YES;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - 去店铺简介
- (void)clickOnStoreName:(UITapGestureRecognizer *)tap {
    if (HDIsStringEmpty(self.storeInfo.storeNo)) {
        return;
    }
    [SATalkingData trackEvent:[self.storeInfo.trackPrefixName stringByAppendingString:@"店铺主页_点击店铺头部（查看详情）"]];

    [TNEventTrackingInstance trackEvent:@"store_detail" properties:@{@"storeId": self.storeInfo.storeNo}];
    [HDMediator.sharedInstance navigaveToTinhNowStoreDetailsPage:@{@"storeNo": self.storeInfo.storeNo}];
}

- (void)hiddenFavoriteButton {
    self.favoriteButton.hidden = YES;
}
#pragma mark - 点击收藏按钮
- (void)clickOnFavoriteButton:(HDUIButton *)button {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }
    @HDWeakify(self);
    if ([self.favoriteButton isSelected]) {
        // 取消
        [self.storeDTO cancelStoreFavoriteWithStoreNo:self.storeInfo.storeNo storeType:0 supplierId:@"" success:^{
            @HDStrongify(self);
            self.storeInfo.collectFlag = NO;
            [HDTips showWithText:TNLocalizedString(@"tn_remove_favorite", @"取消收藏成功") inView:KeyWindow hideAfterDelay:3];
        } failure:nil];
    } else {
        [self.storeDTO addStoreFavoritesWithStoreNo:self.storeInfo.storeNo storeType:0 supplierId:@"" success:^{
            @HDStrongify(self);
            self.storeInfo.collectFlag = YES;
            [HDTips showWithText:TNLocalizedString(@"tn_add_favorite", @"收藏成功") inView:KeyWindow hideAfterDelay:3];
            [TNEventTrackingInstance trackEvent:@"favor" properties:@{@"storeId": self.storeInfo.storeNo, @"type": @"3"}];
        } failure:nil];
    }
}
/** @lazy logoImageView */
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 8.0f;
            view.layer.masksToBounds = YES;
        };
    }
    return _logoImageView;
}
/** @lazy storeName */
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.font = HDAppTheme.TinhNowFont.standard17B;
        _storeNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _storeNameLabel.numberOfLines = 1;
    }
    return _storeNameLabel;
}
/** @lazy arrowImageview */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}

/** @lazy phoneCallButton */
- (HDUIButton *)phoneCallButton {
    if (!_phoneCallButton) {
        _phoneCallButton = [[HDUIButton alloc] init];
        _phoneCallButton.imagePosition = HDUIButtonImagePositionLeft;
        [_phoneCallButton setImage:[UIImage imageNamed:@"tinhnow_store_phonecall"] forState:UIControlStateNormal];
        _phoneCallButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 8);
        _phoneCallButton.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_phoneCallButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_phoneCallButton setTitle:@"-" forState:UIControlStateNormal];
    }
    return _phoneCallButton;
}
/** @lazy timeButton */
- (HDUIButton *)timeButton {
    if (!_timeButton) {
        _timeButton = [[HDUIButton alloc] init];
        _timeButton.imagePosition = HDUIButtonImagePositionLeft;
        [_timeButton setImage:[UIImage imageNamed:@"tinhnow_store_time"] forState:UIControlStateNormal];
        _timeButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 8);
        _timeButton.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_timeButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_timeButton setTitle:@"-" forState:UIControlStateNormal];
    }
    return _timeButton;
}
/** @lazy favoriteButton */
- (HDUIButton *)favoriteButton {
    if (!_favoriteButton) {
        _favoriteButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_favoriteButton setImage:[UIImage imageNamed:@"tinhnow_store_favorite_normal"] forState:UIControlStateNormal];
        [_favoriteButton setImage:[UIImage imageNamed:@"tinhnow_store_favorite_selected"] forState:UIControlStateSelected];
        [_favoriteButton addTarget:self action:@selector(clickOnFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favoriteButton;
}
- (UILabel *)adressLabel {
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc] init];
        _adressLabel.numberOfLines = 0;
        _adressLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _adressLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _adressLabel;
}
/** @lazy adressImageView */
- (UIImageView *)adressImageView {
    if (!_adressImageView) {
        _adressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_store_address"]];
    }
    return _adressImageView;
}
/** @lazy storeDTO */
- (TNStoreDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = [[TNStoreDTO alloc] init];
    }
    return _storeDTO;
}
/** @lazy storeTapView */
- (UIView *)storeTapView {
    if (!_storeTapView) {
        _storeTapView = [[UIView alloc] init];
    }
    return _storeTapView;
}
/** @lazy globalImageView */
- (UIImageView *)storeTagImageView {
    if (!_storeTagImageView) {
        _storeTagImageView = [[UIImageView alloc] init];
    }
    return _storeTagImageView;
}
/** @lazy nameStackView */
- (UIStackView *)nameStackView {
    if (!_nameStackView) {
        _nameStackView = [[UIStackView alloc] init];
        _nameStackView.spacing = 10;
        _nameStackView.axis = UILayoutConstraintAxisHorizontal;
    }
    return _nameStackView;
}
@end

//
//  TNShopCarHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNShopCarHeaderView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAWindowManager.h"
#import "TNShoppingCarStoreModel.h"


@interface TNShopCarHeaderView ()
///
@property (strong, nonatomic) UIView *headerContainer;
/// 选中按钮
@property (strong, nonatomic) HDUIButton *selectBtn;
/// 店铺图标
@property (strong, nonatomic) UIImageView *storeImageView;
/// 店铺名称
@property (strong, nonatomic) UILabel *storeNameLabel;
/// 箭头图片
@property (strong, nonatomic) UIImageView *arrowImageView;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 电商店铺类型标签
@property (strong, nonatomic) UIImageView *storeTypeTag;
@end


@implementation TNShopCarHeaderView
- (void)hd_setupViews {
    //    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.headerContainer];
    [self.headerContainer addSubview:self.selectBtn];
    [self.headerContainer addSubview:self.storeImageView];
    [self.headerContainer addSubview:self.storeNameLabel];
    [self.headerContainer addSubview:self.arrowImageView];
    [self.headerContainer addSubview:self.lineView];
    [self.headerContainer addSubview:self.storeTypeTag];

    [self.storeNameLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.storeTypeTag setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreTitleHandler)];
    [self.contentView addGestureRecognizer:recognizer];
}
- (void)setModel:(TNShoppingCarStoreModel *)model {
    _model = model;
    self.selectBtn.selected = model.isSelected;
    self.storeNameLabel.text = model.storeName;
    if ((!model.isSelected && model.tempSelected) || model.allProductOffSale) {
        self.selectBtn.enabled = NO;
    } else {
        self.selectBtn.enabled = YES;
    }
    //电商店铺标签显示
    if ([model.type isEqualToString:TNStoreTypeOverseasShopping]) {
        self.storeTypeTag.hidden = NO;
        self.storeTypeTag.image = [UIImage imageNamed:@"tn_global_k"];
    } else if ([model.type isEqualToString:TNStoreTypeSelf]) {
        self.storeTypeTag.hidden = NO;
        self.storeTypeTag.image = [UIImage imageNamed:@"tn_offcial_k"];
    } else {
        self.storeTypeTag.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)clickedStoreTitleHandler {
    [SAWindowManager openUrl:@"SuperApp://TinhNow/StoreInfo" withParameters:@{@"storeNo": self.model.storeNo}];
}
- (void)updateConstraints {
    [self.headerContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
    }];
    [self.selectBtn sizeToFit];
    [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerContainer.mas_left).offset(kRealWidth(5));
        make.centerY.equalTo(self.headerContainer);
        make.size.mas_equalTo(self.selectBtn.bounds.size);
    }];
    [self.storeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.storeImageView.image.size);
        make.centerY.equalTo(self.selectBtn);
        make.left.equalTo(self.selectBtn.mas_right).offset(kRealWidth(5));
    }];
    [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectBtn);
        make.left.equalTo(self.storeImageView.mas_right).offset(kRealWidth(7));
    }];
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImageView.image.size);
        make.centerY.equalTo(self.selectBtn);
        make.left.equalTo(self.storeNameLabel.mas_right).offset(kRealWidth(5));
        if (self.storeTypeTag.isHidden) {
            make.right.lessThanOrEqualTo(self.headerContainer.mas_right).offset(-kRealWidth(10));
        }
    }];
    if (!self.storeTypeTag.isHidden) {
        [self.storeTypeTag sizeToFit];
        [self.storeTypeTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectBtn);
            make.left.equalTo(self.arrowImageView.mas_right).offset(kRealWidth(5));
            make.right.lessThanOrEqualTo(self.headerContainer.mas_right).offset(-kRealWidth(10));
        }];
    }
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);
        make.left.right.equalTo(self.headerContainer);
        make.bottom.equalTo(self.headerContainer.mas_bottom);
    }];
    [super updateConstraints];
}
- (HDUIButton *)selectBtn {
    if (!_selectBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"goods_unselected"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"goods_disabled"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.model.tempSelected = !self.model.tempSelected;
            !self.clickAllSelectedStoreProductCallBack ?: self.clickAllSelectedStoreProductCallBack();
        }];
        _selectBtn = button;
    }
    return _selectBtn;
}
/** @lazy storeNameLabel */
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.font = HDAppTheme.TinhNowFont.standard17B;
        _storeNameLabel.numberOfLines = 1;
        _storeNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _storeNameLabel;
}
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"arrow_narrow_gray"];
        _arrowImageView = imageView;
    }
    return _arrowImageView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}
- (UIImageView *)storeImageView {
    if (!_storeImageView) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"shopping_cart_shop"];
        _storeImageView = imageView;
    }
    return _storeImageView;
}

/** @lazy storeTypeTag */
- (UIImageView *)storeTypeTag {
    if (!_storeTypeTag) {
        _storeTypeTag = [[UIImageView alloc] init];
    }
    return _storeTypeTag;
}
/** @lazy headerContainer */
- (UIView *)headerContainer {
    if (!_headerContainer) {
        _headerContainer = [[UIView alloc] init];
        _headerContainer.backgroundColor = [UIColor whiteColor];
        _headerContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
        };
    }
    return _headerContainer;
}
@end

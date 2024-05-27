//
//  TNBargainSelectBottomView.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainSelectBottomView.h"
#import "SAAddressModel.h"
#import "SAShoppingAddressModel.h"
#import "TNBargainAdressView.h"
#import "TNBargainGoodSpecView.h"
#import "TNBargainGoodView.h"


@interface TNBargainSelectBottomView ()
/// 关闭按钮
@property (strong, nonatomic) HDUIButton *closeBtn;
/// 商品视图
@property (strong, nonatomic) TNBargainGoodView *goodView;
/// 规格视图
@property (strong, nonatomic) TNBargainGoodSpecView *specView;
/// 地址选择视图
@property (strong, nonatomic) TNBargainAdressView *adressView;
/// 确认按钮
@property (strong, nonatomic) SAOperationButton *confirBtn;
@end


@implementation TNBargainSelectBottomView

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self addSubview:self.closeBtn];
    [self.scrollViewContainer addSubview:self.goodView];
    [self.scrollViewContainer addSubview:self.adressView];
    [self.scrollViewContainer addSubview:self.specView];
    [self addSubview:self.confirBtn];
}
- (void)updateConstraints {
    [self.closeBtn sizeToFit];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.mas_top).offset(kRealWidth(12));
    }];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeBtn.mas_bottom).offset(kRealWidth(5));
        make.bottom.equalTo(self.confirBtn.mas_top);
        make.left.right.equalTo(self);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.goodView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollViewContainer);
        make.height.mas_equalTo(kRealWidth(130));
    }];
    [self.specView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodView.mas_bottom);
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.adressView.mas_top);
        CGFloat height = [self.specView getGoodSpecTableViewHeight];
        make.height.mas_equalTo(height);
    }];
    [self.adressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        CGFloat height = [self.adressView getAdressViewHeight];
        make.height.mas_equalTo(height);
        make.bottom.equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(15));
    }];
    [self.confirBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [super updateConstraints];
}
- (void)setViewModel:(TNBargainViewModel *)viewModel {
    _viewModel = viewModel;
    TNProductSkuModel *skuModel = [[TNProductSkuModel alloc] init];
    self.goodView.goodName = viewModel.goodModel.goodsName;
    skuModel.marketPrice = viewModel.goodModel.goodsPriceMoney;
    skuModel.lowestPrice = viewModel.goodModel.lowestPriceMoney;
    skuModel.thumbnail = viewModel.goodModel.images;
    skuModel.skuLargeImg = viewModel.goodModel.skuLargeImg;
    self.goodView.model = skuModel;
    self.adressView.addressModel = viewModel.addressModel;
    self.specView.skuModel = viewModel.skuModel;
    [self setNeedsUpdateConstraints];
}
#pragma mark - 外部调用 计算视图高度
- (void)layoutyImmediately {
    [self layoutIfNeeded]; //强制刷新一次布局 获取高度
    CGFloat height = 0;
    //关闭按钮到商品视图
    height += self.closeBtn.bottom + kRealWidth(10);
    //到商品视图的高度
    height += self.goodView.bottom;
    //增加规格高度
    height += self.specView.height;
    //    [self.specView getGoodSpecTableViewHeight];
    //地址高度
    height += [self.adressView getAdressViewHeight];
    //底部按钮间距
    height += kRealWidth(35);
    //底部按钮高度
    height += kRealWidth(45);
    //最高不超过2/3
    height = height > (kScreenHeight * 2) / 3.0 ? (kScreenHeight * 2) / 3.0 : height;

    self.size = CGSizeMake(kScreenWidth, height);
}
#pragma mark - method
- (void)closeClick {
    if (self.bargainCloseCallBack) {
        self.bargainCloseCallBack();
    }
}
- (void)confirClick {
    if (self.bargainConfirmCallBack) {
        self.bargainConfirmCallBack();
    }
}
//选择地址
- (void)chooseAdressClick {
    __block SAShoppingAddressModel *addressCellModel = self.viewModel.addressModel;
    @HDWeakify(self);
    void (^callback)(SAShoppingAddressModel *) = ^(SAShoppingAddressModel *addressModel) {
        addressCellModel = addressModel;
        @HDStrongify(self);
        self.viewModel.addressModel = addressModel;
        self.adressView.addressModel = addressModel;
        //更新按钮状态
        [self updateConfirBtnState];
    };

    SAAddressModel *addressModel = SAAddressModel.new;
    addressModel.lat = addressCellModel.latitude;
    addressModel.lon = addressCellModel.longitude;
    addressModel.addressNo = addressCellModel.addressNo;
    addressModel.address = addressCellModel.address;
    addressModel.consigneeAddress = addressCellModel.consigneeAddress;
    addressModel.fromType = SAAddressModelFromTypeOrderSubmit;
    [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback": callback, @"currentAddressModel": addressModel}];
}
- (void)updateConfirBtnState {
    if (self.viewModel.selectedSku != nil && self.viewModel.addressModel != nil && HDIsStringNotEmpty(self.viewModel.addressModel.addressNo)) {
        self.confirBtn.enabled = true;
    } else {
        self.confirBtn.enabled = false;
    }
}
/** @lazy priceLabel */
- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        _closeBtn.adjustsButtonWhenHighlighted = false;
        _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
/** @lazy goodView */
- (TNBargainGoodView *)goodView {
    if (!_goodView) {
        _goodView = [[TNBargainGoodView alloc] init];
    }
    return _goodView;
}
/** @lazy specView */
- (TNBargainGoodSpecView *)specView {
    if (!_specView) {
        _specView = [[TNBargainGoodSpecView alloc] init];
        @HDWeakify(self);
        _specView.selectedSpecCallBack = ^(TNProductSkuModel *_Nonnull sku) {
            @HDStrongify(self);
            self.viewModel.selectedSku = sku;
            //更新商品数据
            self.goodView.model = sku;
            //更新按钮状态
            [self updateConfirBtnState];
        };
    }
    return _specView;
}
/** @lazy closeBtn */
- (SAOperationButton *)confirBtn {
    if (!_confirBtn) {
        _confirBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        [_confirBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard17;
        [_confirBtn setTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons") forState:UIControlStateNormal];
        [_confirBtn addTarget:self action:@selector(confirClick) forControlEvents:UIControlEventTouchUpInside];
        _confirBtn.enabled = false;
        _confirBtn.cornerRadius = 0;
    }
    return _confirBtn;
}
/** @lazy adressView */
- (TNBargainAdressView *)adressView {
    if (!_adressView) {
        _adressView = [[TNBargainAdressView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAdressClick)];
        [_adressView addGestureRecognizer:tap];
    }
    return _adressView;
}
@end

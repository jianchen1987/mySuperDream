//
//  WMHomeTipView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMHomeTipView.h"
#import "SAAddressCacheAdaptor.h"
#import "SAAddressModel.h"
#import "WMOperationButton.h"


@interface WMHomeTipView ()
/// 图片
@property (nonatomic, strong) UIImageView *iconIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 去设置
@property (nonatomic, strong) WMOperationButton *gotoSettingsBTN;
/// 手动选择
@property (nonatomic, strong) WMOperationButton *manualChooseBTN;
/// 当前样式
@property (nonatomic, assign) WMHomeTipViewStyle style;
/// 参考 View，垂直居中使用
@property (nonatomic, strong) UIView *refView;

@end


@implementation WMHomeTipView

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.refView];
    [self addSubview:self.iconIV];
    [self addSubview:self.titleLB];
    [self addSubview:self.descLB];
    [self addSubview:self.gotoSettingsBTN];
    [self addSubview:self.manualChooseBTN];

    [self updateUIForStyle:WMHomeTipViewStyleNotInTheScopeOfDeliverying];

    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:20];
    };
}

- (void)hd_languageDidChanged {
    self.titleLB.text = WMLocalizedString(@"enable_location_service", @"Enable your location service");
    if (self.style == WMHomeTipViewStyleLackingLocationPermission) {
        self.descLB.text = WMLocalizedString(@"help_us_determine_your_location", @"This helps us accurately determine your location so that you can book faster and get more store information.");
    } else if (self.style == WMHomeTipViewStyleNotInTheScopeOfDeliverying) {
        self.descLB.text = WMLocalizedString(@"location_not_scope_delivery", @"Sorry, your current location is not in the scope of delivery.");
    }
    [self.gotoSettingsBTN setTitle:WMLocalizedString(@"go_to_setting", @"Go to Settings") forState:UIControlStateNormal];
    [self.manualChooseBTN setTitle:WMLocalizedString(@"manual_select", @"Manual selection") forState:UIControlStateNormal];
}

#pragma mark - public methods
- (void)updateUIForStyle:(WMHomeTipViewStyle)style {
    self.style = style;

    if (style == WMHomeTipViewStyleLackingLocationPermission) {
        self.gotoSettingsBTN.hidden = self.titleLB.hidden = false;
        [self.manualChooseBTN applyPropertiesWithStyle:WMOperationButtonStyleHollow];
        self.descLB.text = WMLocalizedString(@"help_us_determine_your_location", @"This helps us accurately determine your location so that you can book faster and get more store information.");
    } else if (style == WMHomeTipViewStyleNotInTheScopeOfDeliverying) {
        self.gotoSettingsBTN.hidden = self.titleLB.hidden = true;
        [self.manualChooseBTN applyPropertiesWithStyle:WMOperationButtonStyleSolid];
        self.descLB.text = WMLocalizedString(@"location_not_scope_delivery", @"Sorry, your current location is not in the scope of delivery.");
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    CGFloat buttonMargin = kRealWidth(17), bottomMargin = kRealWidth(45);
    [self.refView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV);
        if (self.style == WMHomeTipViewStyleNotInTheScopeOfDeliverying) {
            make.bottom.equalTo(self.manualChooseBTN);
            make.centerY.equalTo(self);
        } else if (self.style == WMHomeTipViewStyleLackingLocationPermission) {
            make.bottom.equalTo(self.descLB);
            make.centerY.equalTo(self).offset(-(buttonMargin + bottomMargin + 2 * HDAppTheme.value.buttonHeight) * 0.5);
        }
        make.centerX.width.equalTo(self);
    }];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(self.iconIV.image.size);
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLB.isHidden) {
            make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(15));
            make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
            make.centerX.equalTo(self);
        }
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIView *view = self.titleLB.isHidden ? self.iconIV : self.titleLB;
        make.top.equalTo(view.mas_bottom).offset(kRealWidth(15));
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
    }];
    [self.gotoSettingsBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.gotoSettingsBTN.isHidden) {
            make.bottom.equalTo(self.manualChooseBTN.mas_top).offset(-buttonMargin);
            make.width.equalTo(self).offset(-2 * kRealWidth(25));
            make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
            make.centerX.equalTo(self);
        }
    }];
    [self.manualChooseBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.style == WMHomeTipViewStyleNotInTheScopeOfDeliverying) {
            make.top.equalTo(self.descLB.mas_bottom).offset(bottomMargin);
        } else if (self.style == WMHomeTipViewStyleLackingLocationPermission) {
            make.bottom.equalTo(self).offset(-kRealWidth(45));
        }
        make.width.equalTo(self).offset(-2 * kRealWidth(25));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)refView {
    if (!_refView) {
        _refView = UIView.new;
    }
    return _refView;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"wm_home_placeholder"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:20];
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _descLB = label;
    }
    return _descLB;
}

- (WMOperationButton *)gotoSettingsBTN {
    if (!_gotoSettingsBTN) {
        WMOperationButton *button = [WMOperationButton buttonWithStyle:WMOperationButtonStyleSolid];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDSystemCapabilityUtil openAppSystemSettingPage];
        }];
        _gotoSettingsBTN = button;
    }
    return _gotoSettingsBTN;
}

- (WMOperationButton *)manualChooseBTN {
    if (!_manualChooseBTN) {
        WMOperationButton *button = [WMOperationButton buttonWithStyle:WMOperationButtonStyleHollow];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
                @HDStrongify(self);
                addressModel.fromType = SAAddressModelFromTypeOnceTime;
                // 如果选择的地址信息不包含省市字段，需要重新去解析一遍
                if (HDIsStringEmpty(addressModel.city) && HDIsStringEmpty(addressModel.subLocality)) {
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue);
                    [self.viewController.view showloading];
                    [SALocationUtil transferCoordinateToAddress:coordinate
                                                     completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                                         [self.viewController.view dismissLoading];
                                                         if (HDIsStringEmpty(address)) {
                                                             [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
                                                             return;
                                                         }
                                                         SAAddressModel *newAddressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                                         newAddressModel.lat = @(coordinate.latitude);
                                                         newAddressModel.lon = @(coordinate.longitude);
                                                         newAddressModel.address = address;
                                                         newAddressModel.consigneeAddress = consigneeAddress;
                                                         newAddressModel.fromType = SAAddressModelFromTypeOnceTime;
                                                         [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:newAddressModel];
                                                     }];
                } else {
                    [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
                }
            };
            /// 当前选择的地址模型
            //            SAAddressModel *currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
            SAAddressModel *currentAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
            [HDMediator.sharedInstance navigaveToChooseAddressViewController:@{@"callback": callback, @"currentAddressModel": currentAddressModel}];
        }];
        _manualChooseBTN = button;
    }
    return _manualChooseBTN;
}
@end

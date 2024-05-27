//
//  WMHomeAddressView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMHomeAddressView.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SAAddressCacheAdaptor.h"
#import "WMCustomViewActionView.h"

@interface WMHomeAddressView ()
/// 图标
@property (nonatomic, strong) UIImageView *iconIV;
/// 笼统地址
@property (nonatomic, strong) SALabel *generalAddressLB;
/// 详细地址
@property (nonatomic, strong) SALabel *detailAddressLB;
/// 详细地址后箭头
@property (nonatomic, strong) UIImageView *arrowIV;
/// 是否已经强转过金边
@property (nonatomic, assign) BOOL haveChanged;

@end


@implementation WMHomeAddressView
- (void)hd_setupViews {
    [self addSubview:self.iconIV];
    [self addSubview:self.generalAddressLB];
    [self addSubview:self.detailAddressLB];
    [self addSubview:self.arrowIV];

    [self addGestureRecognizer:self.hd_tapRecognizer];

    [self updateCurrentAdddress];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(self.iconIV.image.size);
            make.top.greaterThanOrEqualTo(self);
        }
    }];
    [self.generalAddressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.generalAddressLB.isHidden) {
            if (self.iconIV.isHidden) {
                make.left.equalTo(self);
            } else {
                make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
            }
            make.top.equalTo(self);
            make.right.lessThanOrEqualTo(self);
        }
    }];
    const CGFloat margin = 5;
    [self.detailAddressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.generalAddressLB.isHidden) {
            make.left.equalTo(self.generalAddressLB);
            make.top.equalTo(self.generalAddressLB.mas_bottom);
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        } else {
            if (self.iconIV.isHidden) {
                make.left.equalTo(self);
            } else {
                make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
            }
            if (self.style == AddressViewStyleNew) {
                make.top.equalTo(self).offset(kRealWidth(4));
            } else {
                make.top.equalTo(self);
            }
        }
        if (self.style == AddressViewStyleNew) {
            make.bottom.equalTo(self).offset(-kRealWidth(3));
        } else {
            make.bottom.equalTo(self);
        }
        if (self.hideArrowImage) {
            make.right.lessThanOrEqualTo(self).offset(-margin);
        } else {
            make.right.lessThanOrEqualTo(self).offset(-(margin + self.arrowIV.image.size.width));
        }
    }];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.hideArrowImage) {
            make.size.mas_equalTo(self.arrowIV.image.size);
            make.centerY.equalTo(self.detailAddressLB);
            if (self.style == AddressViewStyleNew) {
                make.left.equalTo(self.detailAddressLB.mas_right).offset(kRealWidth(4));
            } else {
                make.left.equalTo(self.detailAddressLB.mas_right).offset(margin);
            }
            make.right.lessThanOrEqualTo(self.mas_right);
        }
    }];
    [super updateConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^updateConstraintsWithAnimation)(void) = ^(void) {
        @HDStrongify(self);
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutIfNeeded];
        }];
    };

    [self.KVOController hd_observe:self.generalAddressLB keyPath:@"text" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        updateConstraintsWithAnimation();
    }];
    [self.KVOController hd_observe:self.detailAddressLB keyPath:@"text" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        updateConstraintsWithAnimation();
    }];
}

#pragma mark - setter
- (void)setHideArrowImage:(BOOL)hideArrowImage {
    _hideArrowImage = hideArrowImage;

    self.arrowIV.hidden = hideArrowImage;
    [self setNeedsUpdateConstraints];
}

- (void)setStyle:(AddressViewStyle)style {
    _style = style;

    switch (style) {
        case AddressViewStyleWhite: {
            self.iconIV.image = [UIImage imageNamed:@"search_address_white"];
            self.generalAddressLB.textColor = UIColor.whiteColor;
            self.detailAddressLB.textColor = UIColor.whiteColor;
            self.arrowIV.image = [UIImage imageNamed:@"address_dowm_white"];
            break;
        }
        case AddressViewStyleBlack: {
            self.iconIV.image = [UIImage imageNamed:@"search_address_icon"];
            self.generalAddressLB.textColor = HDAppTheme.color.G3;
            self.detailAddressLB.textColor = HDAppTheme.color.G1;
            self.arrowIV.image = [UIImage imageNamed:@"address_dowm"];
            break;
        }
        case AddressViewStyleNew: {
            self.iconIV.hidden = YES;
            self.detailAddressLB.textColor = HDAppTheme.WMColor.B3;
            self.detailAddressLB.font = [HDAppTheme.WMFont wm_boldForSize:15];
            self.generalAddressLB.hidden = YES;
            self.arrowIV.image = [UIImage imageNamed:@"yn_home_down"];
            [self setNeedsUpdateConstraints];
            break;
        }
    }
}

#pragma mark - public methods
- (void)updateCurrentAdddress {
    HDLog(@"%s", __func__);
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (!addressModel) {
        // 默认金边
        addressModel = SAAddressModel.new; /// wm_location_fail
        addressModel.address = SALocalizedString(@"choose_address", @"选择地址");
        //        [SACacheManager.shared setObject:addressModel forKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    }
    self.generalAddressLB.text = @"Phnom Penh";
    self.detailAddressLB.text = HDIsStringEmpty(addressModel.shortName) ? addressModel.fullAddress : addressModel.shortName;
    
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusNotAuthed && addressModel.fromType != SAAddressModelFromTypeOnceTime) {
        return;
    }
    
    if(self.haveChanged) return;
    
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/takeaway-merchant/app/super-app/check-city-service";
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = false;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lon"] = addressModel.lon.stringValue;
    params[@"lat"] = addressModel.lat.stringValue;
    
    request.requestParameter = params;

    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        NSDictionary *dic = response.responseObject;
        if([dic isKindOfClass:[NSDictionary class]] && ![dic[@"data"] boolValue]) {
            @HDWeakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @HDStrongify(self);
                WMNormalAlertConfig *config = WMNormalAlertConfig.new;
                @HDWeakify(self);
                config.confirmHandle = ^(WMNormalAlertView *_Nonnull alertView, HDUIButton *_Nonnull button) {
                    [alertView dismiss];
                    @HDStrongify(self);
                    //记录已经强转过
                    self.haveChanged = YES;
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(11.552, 104.926);
                    [SALocationUtil transferCoordinateToAddress:coordinate
                                                     completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                                         [self.viewController.view dismissLoading];
                                                         if (HDIsStringEmpty(address)) {
                                                             addressModel.address = WMLocalizedString(@"wm_unkown_oad", @"Unkown Road");
                                                             [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
                                                             return;
                                                         }
                                                         SAAddressModel *newAddressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                                         newAddressModel.lat = @(coordinate.latitude);
                                                         newAddressModel.lon = @(coordinate.longitude);
                                                         newAddressModel.address = address;
                                                         newAddressModel.consigneeAddress = consigneeAddress;
                                                         newAddressModel.fromType = addressModel.fromType;
                                                         [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:newAddressModel];
                        //五秒后改成重新需要弹窗提示
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.haveChanged = NO;
                        });
                                                     }];
                    
                };
                config.title = WMLocalizedString(@"wm_pickup_Kind reminder", @"温馨提示");
                config.contentAligment = NSTextAlignmentLeft;
                config.content = WMLocalizedString(@"wm_home_tip001", @"当前城市不在服务范围内，将为您跳转至金边");
                config.confirm = WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons");
                
                [WMCustomViewActionView WMAlertWithConfig:config];
            });
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {

    }];


}

#pragma mark - event response
- (void)hd_clickedViewHandler {
    !self.clickedHandler ?: self.clickedHandler();
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"search_address_icon"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)generalAddressLB {
    if (!_generalAddressLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 1;
        label.hidden = true;
        _generalAddressLB = label;
    }
    return _generalAddressLB;
}

- (SALabel *)detailAddressLB {
    if (!_detailAddressLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:14];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        _detailAddressLB = label;
    }
    return _detailAddressLB;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"address_dowm"];
        _arrowIV = imageView;
    }
    return _arrowIV;
}
@end

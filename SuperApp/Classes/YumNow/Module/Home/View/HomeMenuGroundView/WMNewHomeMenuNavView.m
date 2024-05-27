//
//  WMNewHomeMenuNavView.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewHomeMenuNavView.h"
#import "LKDataRecord.h"
#import "SAAddressCacheAdaptor.h"
#import "WMActionSheetView.h"
#import "WMActionSheetViewButton.h"
#import "WMHomeAddressView.h"
#import "WMUIButton.h"
#import "GNEvent.h"


@interface WMNewHomeMenuNavView ()
/// 返回按钮
@property (nonatomic, strong) HDUIButton *backBTN;
/// 外卖图标
@property (nonatomic, strong) HDUIButton *logoBtn;
/// 地址
@property (nonatomic, strong) WMHomeAddressView *addressView;
/// 收藏图标
@property (nonatomic, strong) WMUIButton *collectBTN;
/// 订单图标
@property (nonatomic, strong) WMUIButton *orderBTN;

@end


@implementation WMNewHomeMenuNavView

- (void)hd_setupViews {
    [self addSubview:self.backBTN];
    [self addSubview:self.logoBtn];
    [self addSubview:self.addressView];
    [self addSubview:self.collectBTN];
    [self addSubview:self.orderBTN];
    // 监听位置改变
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
}

- (void)updateConstraints {
    if (!self.backBTN.isHidden) {
        [self.backBTN sizeToFit];
        [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.backBTN.bounds.size);
            make.centerY.mas_offset(0);
            make.left.mas_equalTo(12);
        }];
    }

    [self.logoBtn sizeToFit];
    [self.logoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.backBTN.isHidden) {
            make.left.equalTo(self.backBTN.mas_right);
        } else {
            make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        }
        make.centerY.mas_offset(0);
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-14);
    }];

    [self.orderBTN sizeToFit];
    [self.orderBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(self.orderBTN.bounds.size.width);
        make.height.equalTo(self);
        make.right.mas_equalTo(-kRealWidth(15));
    }];

    [self.collectBTN sizeToFit];
    [self.collectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderBTN);
        make.height.equalTo(self);
        make.width.mas_equalTo(self.collectBTN.bounds.size.width);
        make.right.equalTo(self.orderBTN.mas_left).offset(-kRealWidth(20));
    }];

    [self.addressView sizeToFit];
    [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoBtn.mas_right).offset(4);
        make.right.equalTo(self.collectBTN.mas_left).offset(-HDAppTheme.value.padding.right);
        make.centerY.mas_offset(0);
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)dismiss {
    // 退出外卖首页清空通过tipView手动选择的地址
    //    [SAAddressCacheAdaptor removeWMOnceTimeAddress];
    [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"RT"} SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
    [self.viewController dismissAnimated:true completion:nil];
}

#pragma mark - Notification
- (void)userChangedLocationHandler:(NSNotification *)notification {
    SAClientType clientType = notification.userInfo[@"clientType"];
    if (!notification || [clientType isEqualToString:SAClientTypeMaster]) {
        [self.addressView updateCurrentAdddress];
    }
}

#pragma mark - private methods
- (void)navigaveToChooseAddressViewController {
    void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
        self.addressView.detailAddressLB.text = HDIsStringEmpty(addressModel.shortName) ? addressModel.address : addressModel.shortName;
        HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
        if (status == HDCLAuthorizationStatusNotAuthed) {
            addressModel.fromType = SAAddressModelFromTypeOnceTime;
        }
        // 如果选择的地址信息不包含省市字段，需要重新去解析一遍
        if (HDIsStringEmpty(addressModel.city) && HDIsStringEmpty(addressModel.subLocality)) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue);
            [self.viewController.view showloading];
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
                                             }];
        } else {
            [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
        }
    };
    /// 当前选择的地址模型
    //    SAAddressModel *currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *currentAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    [HDMediator.sharedInstance navigaveToChooseAddressViewController:@{@"callback": callback, @"currentAddressModel": currentAddressModel}];

    [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"AD"} SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
}

#pragma mark - public methods
- (void)refreshUIWithCriticalValue:(CGFloat)criticalValue offsetY:(CGFloat)offsetY completion:(void (^)(CGRect, CGFloat))completion {
    // 布局未完成
    if (criticalValue <= 0)
        return;

    CGFloat rate = offsetY / criticalValue;
    rate = rate > 0.98 ? 1 : rate;
    rate = rate < 0.02 ? 0 : rate;
    if (rate == 1) {
        [self.collectBTN setImage:[UIImage imageNamed:@"yn_home_searh"] forState:UIControlStateNormal];
        [self.orderBTN setImage:[UIImage imageNamed:@"yn_home_more"] forState:UIControlStateNormal];
        [self.collectBTN setTitle:nil forState:UIControlStateNormal];
        [self.orderBTN setTitle:nil forState:UIControlStateNormal];
        self.collectBTN.imagePosition = -1;
        self.orderBTN.imagePosition = -1;
        self.collectBTN.change = self.orderBTN.change = true;
    } else {
        [self.collectBTN setImage:[UIImage imageNamed:@"yn_home_collect"] forState:UIControlStateNormal];
        [self.orderBTN setImage:[UIImage imageNamed:@"yn_home_order"] forState:UIControlStateNormal];
        [self.collectBTN setTitle:WMLocalizedString(@"wm_collection", @"收藏") forState:UIControlStateNormal];
        [self.orderBTN setTitle:WMLocalizedString(@"order", @"订单") forState:UIControlStateNormal];
        self.collectBTN.imagePosition = HDUIButtonImagePositionTop;
        self.orderBTN.imagePosition = HDUIButtonImagePositionTop;
        self.collectBTN.change = self.orderBTN.change = false;
    }
}

- (void)setHideBackButton:(BOOL)hideBackButton {
    _hideBackButton = hideBackButton;
    self.backBTN.hidden = hideBackButton;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (WMHomeAddressView *)addressView {
    if (!_addressView) {
        _addressView = WMHomeAddressView.new;
        _addressView.style = AddressViewStyleNew;
        @HDWeakify(self);
        _addressView.clickedHandler = ^{
            @HDStrongify(self);
            [self navigaveToChooseAddressViewController];
        };
    }
    return _addressView;
}

- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yn_icon_navi_back_red"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        //        button.imageEdgeInsets = UIEdgeInsetsMake(10, kRealWidth(15), 10, kRealWidth(8.5));
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _backBTN = button;
    }
    return _backBTN;
}

- (HDUIButton *)logoBtn {
    if (!_logoBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        [button setTitle:@"FoodDelivery" forState:UIControlStateNormal];
        //        [button setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_home_location"] forState:UIControlStateNormal];
        //        button.titleLabel.font = HDAppTheme.WMFont.standard13;
        //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self navigaveToChooseAddressViewController];
        }];
        _logoBtn = button;
    }
    return _logoBtn;
}

- (WMUIButton *)collectBTN {
    if (!_collectBTN) {
        WMUIButton *button = [WMUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:10];
        button.imagePosition = HDUIButtonImagePositionTop;
        [button setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        button.spacingBetweenImageAndTitle = kRealWidth(2);
        [button setImage:[UIImage imageNamed:@"yn_home_collect"] forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"wm_collection", @"收藏") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.collectBTN.isChange) {
                [GNEvent eventResponder:self target:btn key:@"clickSearchAction" indexPath:nil info:nil];
            } else {
                [HDMediator.sharedInstance navigaveToStoreFavoriteViewController:@{}];
                [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"COLLECT"} SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
            }
        }];
        _collectBTN = button;
    }
    return _collectBTN;
}

- (WMUIButton *)orderBTN {
    if (!_orderBTN) {
        WMUIButton *button = [WMUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:10];
        [button setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        button.imagePosition = HDUIButtonImagePositionTop;
        [button setImage:[UIImage imageNamed:@"yn_home_order"] forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"order", @"订单") forState:UIControlStateNormal];
        button.spacingBetweenImageAndTitle = kRealWidth(2);
        button.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.orderBTN.isChange) {
                HDActionSheetViewConfig *config = HDActionSheetViewConfig.new;
                config.containerCorner = kRealWidth(12);
                config.lineColor = HDAppTheme.WMColor.lineColor1;
                config.lineHeight = 0.8;
                config.buttonHeight = kRealWidth(65);
                WMActionSheetView *sheetView = [WMActionSheetView alertViewWithCancelButtonTitle:nil config:config];
                sheetView.allowTapBackgroundDismiss = YES;
                sheetView.solidBackgroundColorAlpha = 0.5;
                [sheetView addButton:[WMActionSheetViewButton initWithTitle:WMLocalizedString(@"wm_collection", @"收藏") image:[UIImage imageNamed:@"yn_more_like"]
                                                                       type:HDActionSheetViewButtonTypeCustom
                                                                    handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                        [alertView dismiss];
                                                                        [HDMediator.sharedInstance navigaveToStoreFavoriteViewController:@{}];
                                                                        [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"COLLECT"}
                                                                                                    SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
                                                                    }]];
                [sheetView addButton:[WMActionSheetViewButton initWithTitle:SALocalizedString(@"order", @"订单") image:[UIImage imageNamed:@"yn_more_order"] type:HDActionSheetViewButtonTypeCustom
                                                                    handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                        [alertView dismiss];
                                                                        [HDMediator.sharedInstance navigaveToOrderListViewController:@{@"fromSource": @"WMNewHomeViewController"}];
                                                                        [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"ORDER"}
                                                                                                    SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
                                                                    }]];
                [sheetView show];
            } else {
                [HDMediator.sharedInstance navigaveToOrderListViewController:@{@"fromSource": @"WMNewHomeViewController"}];
            }
        }];
        _orderBTN = button;
    }
    return _orderBTN;
}
@end

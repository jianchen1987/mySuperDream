//
//  SACMSNavigationBarPlugin.m
//  SuperApp
//
//  Created by seeu on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSNavigationBarPlugin.h"
#import "LKDataRecord.h"
#import "SAAddressModel.h"
#import "SAAddressZoneModel.h"
#import "SAAggregateSearchViewController.h"
#import "SACMSNavigationBarPluginConfig.h"
#import "SAChooseCityViewController.h"
#import "SAChooseZoneDTO.h"
#import "SAChooseZoneViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <HDServiceKit/HDLocationManager.h>
#import <HDUIKit/NAT.h>
#import "SAAddressCacheAdaptor.h"


@interface SACMSNavigationBarPlugin ()
///< 容器
@property (nonatomic, strong) UIView *container;
///< 背景图片
@property (nonatomic, strong) UIImageView *backgroundImageView;
///< slogan
@property (nonatomic, strong) SDAnimatedImageView *slogon;
///< searchContainer
@property (nonatomic, strong) UIView *searchContainer;
///< searchImage
@property (nonatomic, strong) UIImageView *searchLogo;
///< search text
@property (nonatomic, strong) SALabel *searchPlaceholder;
///< 搜索栏
@property (nonatomic, strong) HDUIButton *searchButton;
///< 地理位置
@property (nonatomic, strong) UIView *lbsAreaContainer;
///< your location
@property (nonatomic, strong) SALabel *locationTitle;
///< city
@property (nonatomic, strong) SALabel *cityName;
///< 右边自定义坑位
@property (nonatomic, strong) SDAnimatedImageView *rightImageView;
///< 当前展示的地址
@property (nonatomic, strong) SAAddressModel *currentlyAddress;
///< 忽略位置变化
@property (nonatomic, assign) BOOL ignoreLocationChange;
///< navConfig
@property (nonatomic, strong) SACMSNavigationBarPluginConfig *navConfig;
///< dto
@property (nonatomic, strong) SAChooseZoneDTO *chooseZoneDTO;
@end


@implementation SACMSNavigationBarPlugin

- (void)hd_setupViews {
    self.ignoreLocationChange = NO;
    [self addSubview:self.container];
    [self.container addSubview:self.backgroundImageView];

    [self.container addSubview:self.slogon];
    UITapGestureRecognizer *imageGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnLeftImage:)];
    [self.slogon addGestureRecognizer:imageGes];

    [self.container addSubview:self.searchContainer];
    [self.searchContainer addSubview:self.searchLogo];
    [self.searchContainer addSubview:self.searchPlaceholder];
    UITapGestureRecognizer *searchGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnSearch:)];
    [self.searchContainer addGestureRecognizer:searchGes];

    [self.container addSubview:self.lbsAreaContainer];
    [self.lbsAreaContainer addSubview:self.locationTitle];
    [self.lbsAreaContainer addSubview:self.cityName];
    UITapGestureRecognizer *lbsGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnCity:)];
    [self.lbsAreaContainer addGestureRecognizer:lbsGes];

    [self.container addSubview:self.rightImageView];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnRightImage:)];
    [self.rightImageView addGestureRecognizer:rightTap];

    // 监听位置权限变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];

    // 监听位置管理器位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];

    // 监听手切位置改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
}

- (void)hd_languageDidChanged {
    self.searchPlaceholder.text = SALocalizedString(@"hamburger_pizza", @"Search");
    self.locationTitle.text = SALocalizedString(@"wownow_home_your_location", @"Your Location");

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];

    if (!self.backgroundImageView.isHidden) {
        [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.container);
        }];
    }

    if (!self.slogon.isHidden) {
        [self.slogon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.container.mas_left).offset(HDAppTheme.value.padding.left);
            make.centerY.equalTo(self.container.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 36));
        }];
    }

    if (!self.searchContainer.isHidden) {
        [self.searchContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.slogon.isHidden) {
                make.left.equalTo(self.slogon.mas_right).offset(HDAppTheme.value.padding.left);
            } else {
                make.left.equalTo(self.container.mas_left).offset(HDAppTheme.value.padding.left);
            }
            make.centerY.equalTo(self.container.mas_centerY);
            make.height.mas_equalTo(36);
            UIView *refView = !self.lbsAreaContainer.isHidden ? self.lbsAreaContainer : (!self.rightImageView.isHidden ? self.rightImageView : nil);
            if (refView) {
                make.right.equalTo(refView.mas_left).offset(-HDAppTheme.value.padding.right);
            } else {
                make.right.equalTo(self.container.mas_right).offset(-HDAppTheme.value.padding.right);
            }
        }];

        [self.searchLogo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchContainer.mas_left).offset(8);
            make.centerY.equalTo(self.searchContainer.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];

        [self.searchPlaceholder mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchLogo.mas_right).offset(8);
            make.centerY.equalTo(self.searchContainer.mas_centerY);
            make.right.equalTo(self.searchContainer.mas_right).offset(-8);
        }];
    }

    if (!self.lbsAreaContainer.isHidden) {
        [self.lbsAreaContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.container.mas_centerY);
            make.height.mas_equalTo(36);

            UIView *refView = !self.rightImageView.isHidden ? self.rightImageView : nil;
            if (refView) {
                make.right.equalTo(refView.mas_left).offset(-HDAppTheme.value.padding.right);
            } else {
                make.right.equalTo(self.container.mas_right).offset(-HDAppTheme.value.padding.right);
            }
        }];
        [self.locationTitle sizeToFit];
        [self.cityName sizeToFit];
        [self.locationTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lbsAreaContainer.mas_top);
            make.right.equalTo(self.lbsAreaContainer.mas_right);
            make.size.mas_equalTo(self.locationTitle.frame.size);
            if (self.locationTitle.frame.size.width > self.cityName.frame.size.width) {
                make.left.equalTo(self.lbsAreaContainer.mas_left);
            } else {
                make.left.greaterThanOrEqualTo(self.lbsAreaContainer.mas_left);
            }
        }];

        [self.cityName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.lbsAreaContainer.mas_bottom);
            make.right.equalTo(self.lbsAreaContainer.mas_right);
            //            make.size.mas_equalTo(self.cityName.frame.size);
            make.width.mas_lessThanOrEqualTo(kRealWidth(100));
            if (self.locationTitle.frame.size.width > self.cityName.frame.size.width) {
                make.left.greaterThanOrEqualTo(self.lbsAreaContainer.mas_left);
            } else {
                make.left.equalTo(self.lbsAreaContainer.mas_left);
            }
        }];
    }

    if (!self.rightImageView.isHidden) {
        [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.centerY.equalTo(self.container.mas_centerY);
            make.right.equalTo(self.container.mas_right).offset(-HDAppTheme.value.padding.right);
        }];
    }

    [super updateConstraints];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    [self requestLocationPermission];
}

#pragma mark - setter
- (void)setConfig:(SACMSPluginViewConfig *)config {
    [super setConfig:config];

    SACMSNavigationBarPluginConfig *navConfig = [SACMSNavigationBarPluginConfig yy_modelWithDictionary:[config getPluginContent]];
    self.navConfig = navConfig;

    self.backgroundColor = [UIColor hd_colorWithHexString:navConfig.backgroundColor];

    if (HDIsStringNotEmpty(navConfig.backgroundImage)) {
        self.backgroundImageView.hidden = NO;
        [HDWebImageManager setImageWithURL:navConfig.backgroundImage placeholderImage:nil imageView:self.backgroundImageView];
    } else {
        self.backgroundImageView.hidden = YES;
    }

    if (HDIsStringNotEmpty(navConfig.icon)) {
        self.slogon.hidden = NO;
        [HDWebImageManager setGIFImageWithURL:navConfig.icon size:CGSizeMake(80, 36) placeholderImage:[HDHelper placeholderImageWithCornerRadius:5 size:CGSizeMake(80, 36) logoWidth:18]
                                    imageView:self.slogon];
    } else {
        self.slogon.hidden = YES;
    }

    if (navConfig.enableSearch) {
        self.searchContainer.hidden = NO;
    } else {
        self.searchContainer.hidden = YES;
    }

    if (navConfig.enableLocation) {
        self.lbsAreaContainer.hidden = NO;
    } else {
        self.lbsAreaContainer.hidden = YES;
    }

    if (HDIsStringNotEmpty(navConfig.rightImage)) {
        self.rightImageView.hidden = NO;
        [HDWebImageManager setGIFImageWithURL:navConfig.rightImage size:CGSizeMake(36, 36) placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(36, 36)] imageView:self.rightImageView];
    } else {
        self.rightImageView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)requestLocationPermission {
    if (!self.navConfig || !self.navConfig.enableLocation) {
        return;
    }

    // 拿当前真实经纬度
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusAuthed) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;

            [SALocationUtil transferCoordinateToAddress:coordinate2D completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary *_Nullable addressDictionary) {
                SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                addressModel.lat = @(coordinate2D.latitude);
                addressModel.lon = @(coordinate2D.longitude);
                addressModel.address = address;
                addressModel.consigneeAddress = consigneeAddress;
                addressModel.fromType = SAAddressModelFromTypeLocate;
                addressModel.shortName
                    = HDIsStringNotEmpty(addressModel.city) ?
                          addressModel.city :
                          (HDIsStringNotEmpty(addressModel.state) ? addressModel.state :
                                                                    (HDIsStringNotEmpty(addressModel.country) ? addressModel.country : SALocalizedString(@"unknown_location", @"unknow")));
                if (HDIsObjectNil(self.currentlyAddress)) {
                    // 当前位置空，是第一次，直接赋值
                    [self updateCityNameWithAddressModel:addressModel];
                } else {
                    // 距离是否大于200
                    BOOL distanceWasFaraway = [HDLocationUtils distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.currentlyAddress.lat.doubleValue
                                                                                                               longitude:self.currentlyAddress.lon.doubleValue]
                                                                         toLocation:[[CLLocation alloc] initWithLatitude:addressModel.lat.doubleValue longitude:addressModel.lon.doubleValue]]
                                              > 200;
                    // 城市名是否不一样
                    BOOL nameWasDiff = ![self.currentlyAddress.shortName isEqualToString:addressModel.shortName];
                    // 当前顶部视图是否是绑定的控制器
                    BOOL visiableVCWasI = HDIsStringNotEmpty(self.bindVCName) && [self.bindVCName isEqualToString:NSStringFromClass([[SAWindowManager visibleViewController] class])];

                    if (distanceWasFaraway && nameWasDiff && visiableVCWasI && self.navConfig.enableLocation) {
                        // 再次确认
                        [self shouldAlertSwitchCityWithAddress:addressModel];
                    }
                }
            }];
        } else {
            [HDLocationManager.shared startUpdatingLocation];
        }
    } else if (status == HDCLAuthorizationStatusNotAuthed) {
        [self updateCityNameWithAddressModel:nil];
    } else if (status == HDCLAuthorizationStatusNotDetermined) {
        self.cityName.text = SALocalizedString(@"get_location", @"点击授权");
        [self setNeedsUpdateConstraints];
        // 判断是否已经展示过该 window
        BOOL hasShown = [[NSUserDefaults.standardUserDefaults objectForKey:@"hasShownChooseLanguageWindow"] boolValue];
        if (hasShown) [HDLocationManager.shared requestWhenInUseAuthorization];
    }
}

- (void)shouldAlertSwitchCityWithAddress:(SAAddressModel *)addressModel {
    // 获取城市编码
    [self.chooseZoneDTO fuzzyQueryZoneListWithoutDefaultWithProvince:addressModel.city district:addressModel.subLocality commune:nil latitude:addressModel.lat longitude:addressModel.lon
                                                             success:^(SAAddressZoneModel *_Nonnull zoneModel) {
                                                                 if (![addressModel.districtCode isEqualToString:zoneModel.code]) {
                                                                     HDLog(@"地区码不一样");
                                                                     [self alertUserToSwitchWithAddress:addressModel];
                                                                 }
                                                             }
                                                             failure:nil];
}

- (void)alertUserToSwitchWithAddress:(SAAddressModel *)addressModel {
    // 获取到的城市跟当前的城市不一样，提示
    [NAT showAlertWithMessage:[NSString stringWithFormat:SALocalizedString(@"location_switch_tips", @"检测到你当前在:%@, 是否切换城市"), addressModel.shortName]
        confirmButtonTitle:SALocalizedString(@"location_switch_confirm", @"切换") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];

            addressModel.fromType = SAAddressModelFromTypeUserChoosed;
            [self updateCityNameWithAddressModel:addressModel];
        }
        cancelButtonTitle:SALocalizedString(@"location_switch_continues", @"继续浏览") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
            // 忽略地址变化，不再提示
            self.ignoreLocationChange = YES;
        }];
}

#pragma mark - LocatinManagerDelegate
- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status != HDCLAuthorizationStatusNotDetermined) {
        [self requestLocationPermission];
    }
}

- (void)locationManagerMonitoredLocationChanged:(NSNotification *)notification {
    if (!self.ignoreLocationChange) {
        NSLog(@"位置变化了，处理业务逻辑");
        [self requestLocationPermission];
    }
    NSLog(@"位置变化了，被忽略了");
}

- (void)userChangedLocationHandler:(NSNotification *)noti {
        HDLog(@"用户手切地址了");

    if (!self.navConfig || !self.navConfig.enableLocation)
        return;

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];

    if (!addressModel)
        return;
    
    if (!HDIsObjectNil(self.currentlyAddress) &&
        [HDLocationUtils distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.currentlyAddress.lat.doubleValue longitude:self.currentlyAddress.lon.doubleValue]
                                   toLocation:[[CLLocation alloc] initWithLatitude:addressModel.lat.doubleValue longitude:addressModel.lon.doubleValue]]
            < 50.0) {
        HDLog(@"位置变化不大，不需要更新刷新首页导航栏地址");
        return;
    }
    
    [self updateCityNameWithAddressModel:addressModel];

//    if (addressModel) {
//        self.currentlyAddress = addressModel;
//        if (HDIsObjectNil(addressModel)) {
//            self.cityName.text = SALocalizedString(@"unknown_location", @"unknow");
//        } else {
//            self.cityName.text = (HDIsStringNotEmpty(addressModel.city) ?
//                                      addressModel.city :
//                                      (HDIsStringNotEmpty(addressModel.state) ? addressModel.state :
//                                                                                (HDIsStringNotEmpty(addressModel.country) ? addressModel.country : SALocalizedString(@"unknown_location", @"unknow"))));
//        }
//        [self setNeedsUpdateConstraints];
//    }
}

- (void)updateCityNameWithAddressModel:(SAAddressModel *_Nullable)addressModel {
    self.currentlyAddress = addressModel;

    if (HDIsObjectNil(addressModel)) {
        self.cityName.text = SALocalizedString(@"unknown_location", @"unknow");
    } else {
        self.cityName.text = HDIsStringNotEmpty(addressModel.shortName) ?
                                 addressModel.shortName :
                                 (HDIsStringNotEmpty(addressModel.city) ?
                                      addressModel.city :
                                      (HDIsStringNotEmpty(addressModel.state) ? addressModel.state :
                                                                                (HDIsStringNotEmpty(addressModel.country) ? addressModel.country : SALocalizedString(@"unknown_location", @"unknow"))));
    }

    !self.locationChangedHandler ?: self.locationChangedHandler(addressModel);
    [self setNeedsUpdateConstraints];
}

#pragma mark - Action
- (void)clickOnLeftImage:(UITapGestureRecognizer *)tap {
    if (self.navConfig && HDIsStringNotEmpty(self.navConfig.link)) {
        [SAWindowManager openUrl:self.navConfig.link withParameters:@{
            @"source" : [NSString stringWithFormat:@"%@.%@.icon", self.config.pageConfig.pageName, self.config.pluginName]
        }];
    }
    [LKDataRecord.shared traceClickEvent:@"click_navigationBarPlugin_icon" parameters:@{@"route": self.navConfig.link}
                                     SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName node:@"icon"]];
}
- (void)clickedOnSearch:(UITapGestureRecognizer *)tap {
    SAAddressModel *addressModel = nil;
    if (self.navConfig.enableLocation) {
        if (!HDIsObjectNil(self.currentlyAddress) && [HDLocationUtils isCoordinate2DValid:CLLocationCoordinate2DMake(self.currentlyAddress.lat.doubleValue, self.currentlyAddress.lon.doubleValue)]) {
            addressModel = self.currentlyAddress;
        }
    } else {
        // 没启用定位，直接用系统的位置
//        HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
//        if (status == HDCLAuthorizationStatusAuthed) {
//            addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
//        }
    }


    SAAggregateSearchViewController *vc = [[SAAggregateSearchViewController alloc] initWithRouteParameters:@{
        @"currentlyAddress": addressModel,
        @"source" : [NSString stringWithFormat:@"%@.%@.search", self.config.pageConfig.pageName, self.config.pluginName]
    }];
    [SAWindowManager navigateToViewController:vc];

    [LKDataRecord.shared traceClickEvent:@"click_navigationBarPlugin_search" parameters:@{} SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName node:@"search"]];
}

- (void)clickedOnCity:(UITapGestureRecognizer *)tap {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusNotDetermined) {
        [HDLocationManager.shared requestWhenInUseAuthorization];
        return;
    }

    @HDWeakify(self);
    void (^callback)(SAAddressZoneModel *) = ^(SAAddressZoneModel *zoneModel) {
        @HDStrongify(self);
        SAAddressModel *addressModel = SAAddressModel.new;
        addressModel.city = zoneModel.message.desc;
        addressModel.districtCode = zoneModel.code;
        addressModel.fromType = SAAddressModelFromTypeUserChoosed;
        if (!HDIsObjectNil(zoneModel.latitude) && !HDIsObjectNil(zoneModel.longitude)) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(zoneModel.latitude.doubleValue, zoneModel.longitude.doubleValue);
            if ([HDLocationManager.shared isCoordinate2DValid:coordinate]) {
                addressModel.lat = zoneModel.latitude;
                addressModel.lon = zoneModel.longitude;
            }
        }
        [self updateCityNameWithAddressModel:addressModel];
    };

    SAChooseCityViewController *vc = [[SAChooseCityViewController alloc] initWithRouteParameters:@{@"callback": callback}];
    [SAWindowManager navigateToViewController:vc];

    [LKDataRecord.shared traceClickEvent:@"click_navigationBarPlugin_lbs" parameters:@{} SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName node:@"lbs"]];
}

- (void)clickOnRightImage:(UITapGestureRecognizer *)tap {
    if (self.navConfig && HDIsStringNotEmpty(self.navConfig.rightImageLink)) {
        [SAWindowManager openUrl:self.navConfig.rightImageLink withParameters:@{
            @"source" : [NSString stringWithFormat:@"%@.%@.rightButton", self.config.pageConfig.pageName, self.config.pluginName]
        }];
    }

    [LKDataRecord.shared traceClickEvent:@"click_navigationBarPlugin_rightButton" parameters:@{} SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName
                                                                                                                   node:@"rightButton"]];
}

#pragma mark - lazy load
- (UIView *)container {
    if (!_container) {
        _container = UIView.new;
    }
    return _container;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = UIImageView.new;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (SDAnimatedImageView *)slogon {
    if (!_slogon) {
        _slogon = SDAnimatedImageView.new;
        _slogon.userInteractionEnabled = YES;
    }
    return _slogon;
}

- (UIView *)searchContainer {
    if (!_searchContainer) {
        _searchContainer = UIView.new;
        _searchContainer.backgroundColor = UIColor.whiteColor;
        _searchContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _searchContainer;
}

- (UIImageView *)searchLogo {
    if (!_searchLogo) {
        _searchLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wn_home_nav_search"]];
    }
    return _searchLogo;
}

- (SALabel *)searchPlaceholder {
    if (!_searchPlaceholder) {
        _searchPlaceholder = SALabel.new;
        _searchPlaceholder.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _searchPlaceholder.textColor = [UIColor hd_colorWithHexString:@"#999999"];
    }
    return _searchPlaceholder;
}

- (UIView *)lbsAreaContainer {
    if (!_lbsAreaContainer) {
        _lbsAreaContainer = UIView.new;
    }
    return _lbsAreaContainer;
}

- (SALabel *)locationTitle {
    if (!_locationTitle) {
        _locationTitle = SALabel.new;
        _locationTitle.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _locationTitle.textColor = [UIColor hd_colorWithHexString:@"#FEBCC6"];
    }
    return _locationTitle;
}

- (SALabel *)cityName {
    if (!_cityName) {
        _cityName = SALabel.new;
        _cityName.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        _cityName.textColor = [UIColor whiteColor];
        _cityName.numberOfLines = 1;
        _cityName.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _cityName.text = SALocalizedString(@"", @"");
    }
    return _cityName;
}

- (SDAnimatedImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = SDAnimatedImageView.new;
        _rightImageView.userInteractionEnabled = YES;
    }
    return _rightImageView;
}

- (SAChooseZoneDTO *)chooseZoneDTO {
    if (!_chooseZoneDTO) {
        _chooseZoneDTO = SAChooseZoneDTO.new;
    }
    return _chooseZoneDTO;
}

@end

//
//  SAChooseAddressMapViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChooseAddressMapViewController.h"
#import "SAAddressAutoCompleteRspModel.h"
#import "SAAddressModel.h"
#import "SAAddressSearchRspModel.h"
#import "SAAddressZoneModel.h"
#import "SAChooseAddressTipView.h"
#import "SAChooseAddressZoneView.h"
#import "SAChooseZoneDTO.h"
#import "SALocationUtil.h"
#import "SAMapView.h"
#import "SASearchAddressDTO.h"
#import "SASearchAddressResultTableViewCell.h"
#import "SATableView.h"
#import <HDServiceKit/HDLocationManager.h>


@interface SAChooseAddressMapViewController () <HDSearchBarDelegate, SAMapViewDelegate, UITableViewDelegate, UITableViewDataSource>
/// 选择地址回调
@property (nonatomic, copy) void (^choosedAddressBlock)(SAAddressModel *);
/// 当前选择的地址模型
@property (nonatomic, weak) SAAddressModel *currentAddressModel;
/// 城市选择
@property (nonatomic, strong) SAChooseAddressZoneView *chooseZoneView;
/// 搜索栏
@property (nonatomic, strong) HDSearchBar *searchBar;
/// 定位按钮
@property (nonatomic, strong) HDUIButton *locateBTN;
/// 确认按钮
@property (nonatomic, strong) SAOperationButton *cfmBTN;
/// 地图
@property (nonatomic, strong) SAMapView *mapView;
/// 大头针图片
@property (nonatomic, strong) UIImageView *annotationIV;
/// 提示
@property (nonatomic, strong) SAChooseAddressTipView *tipView;
/// 搜索结果
@property (nonatomic, strong) SATableView *tableView;
/// 记录当前地址
@property (nonatomic, strong) SAAddressModel *recordAddress;
/// 数据源
@property (nonatomic, strong) NSMutableArray<SAAddressAutoCompleteItem *> *dataSource;
/// 搜索关键词
@property (nonatomic, copy) NSString *keyWord;
/// 未授权弹窗
@property (nonatomic, strong) HDAlertView *unAuthedAlertView;
/// 搜索地址 DTO
@property (nonatomic, strong) SASearchAddressDTO *searchAddressDTO;
/// 是否以用户位置为地图中心
@property (nonatomic, assign) BOOL useUserLocationAsMapCenter;
/// 当前正在搜索的关键词
@property (nonatomic, copy) NSString *searchingKeyword;
/// 是否不需要主动pop
@property (nonatomic, assign) BOOL notNeedPop;

@property (nonatomic, copy) NSString *sessionToken; ///< 谷歌服务需要的token
/// zoneDTO
@property (nonatomic, strong) SAChooseZoneDTO *zoneDTO;
/// 搜索半径
@property (nonatomic, assign) CGFloat radius;
/// Geocode解析频次
@property (nonatomic, assign) SAChooseAddressMapGeocodeType style;
/// 确认按钮文字
@property (nonatomic, copy) NSString *buttonTitle;

@end


@implementation SAChooseAddressMapViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    void (^callback)(SAAddressModel *) = parameters[@"callback"];
    self.choosedAddressBlock = callback;
    self.currentAddressModel = parameters[@"currentAddressModel"];
    self.notNeedPop = [parameters[@"notNeedPop"] boolValue];
    self.style = [parameters[@"style"] integerValue];
    self.buttonTitle = parameters[@"buttonTitle"] ?: SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons");
    self.radius = 20000;

    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"search_address", @"搜索位置");
}

- (void)hd_setupViews {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.chooseZoneView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tipView];
    [self.view addSubview:self.annotationIV];
    [self.view addSubview:self.locateBTN];
    [self.view addSubview:self.cfmBTN];
    [self.view addSubview:self.tableView];

    // 监听位置权限变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];

    // 监听位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];

    // 如果外部传了地址，则使用外部地址作为中心，否则使用金边公司地址作为中心，此处与定位权限无关
    CLLocationCoordinate2D coordinate;
    if (HDIsObjectNil(self.currentAddressModel) || !self.currentAddressModel.isValid) {
        if (!HDLocationManager.shared.isCurrentCoordinate2DValid) {
            // 默认金边
//            coordinate = CLLocationCoordinate2DMake(11.568231, 104.909059);
            coordinate = CLLocationCoordinate2DMake(11.552, 104.926);
        } else {
            coordinate = HDLocationManager.shared.coordinate2D;
        }
    } else {
        self.recordAddress = self.currentAddressModel;
        coordinate = CLLocationCoordinate2DMake(self.currentAddressModel.lat.doubleValue, self.currentAddressModel.lon.doubleValue);
    }
    [self centerMapViewToCoordinate:coordinate];
    // 初始化地址
    //    [self.mapView.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.02, 0.02)) animated:YES];
}

- (void)hd_bindViewModel {
    // 解决事件冲突
    [self.KVOController hd_observe:self.tableView keyPath:@"hidden" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        BOOL isHidden = [change[NSKeyValueChangeNewKey] boolValue];
        if (isHidden) {
            [HDKeyboardManager.sharedInstance.touchResignedGestureIgnoreClasses removeObject:NSClassFromString(@"UITableViewCellContentView")];
        } else {
            [HDKeyboardManager.sharedInstance.touchResignedGestureIgnoreClasses addObject:NSClassFromString(@"UITableViewCellContentView")];
        }
    }];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];
}

- (void)updateViewConstraints {
    [self.cfmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.bottom.equalTo(self.view).offset(-kRealWidth(24));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(kRealWidth(25));
    }];

    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.equalTo(self.view);
        make.width.centerX.equalTo(self.view);
    }];

    [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.equalTo(self.view);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mapView);
        //        make.bottom.equalTo(self.cfmBTN);
    }];

    [self.locateBTN sizeToFit];
    [self.locateBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mapView).offset(-kRealWidth(15));
        make.bottom.equalTo(self.cfmBTN.mas_top).offset(-kRealWidth(15));
    }];

    [self.annotationIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.annotationIV.image.size);
        make.centerX.equalTo(self.mapView);
        make.bottom.equalTo(self.mapView.mas_centerY);
    }];

    [self.chooseZoneView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBar);
        make.left.equalTo(self.view).offset(HDAppTheme.value.padding.left);
    }];
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.equalTo(self.chooseZoneView.mas_right);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [super updateViewConstraints];
}

#pragma mark - Data
- (void)searchListForKeyWord:(NSString *)keyword {
    if ([self.searchingKeyword isEqualToString:keyword])
        return;
    self.searchingKeyword = keyword;

    if (HDIsStringEmpty(keyword))
        return;

    CLLocationCoordinate2D coordinate;
    if (!HDIsObjectNil(self.chooseZoneView.model.lat) && !HDIsObjectNil(self.chooseZoneView.model.lon)) {
        coordinate = CLLocationCoordinate2DMake(self.chooseZoneView.model.lat.doubleValue, self.chooseZoneView.model.lon.doubleValue);
    } else {
//        coordinate = CLLocationCoordinate2DMake(-91, -181);
        coordinate = CLLocationCoordinate2DMake(11.552, 104.926);
    }
    @HDWeakify(self);
    [self.searchAddressDTO searchAddressWithKeyword:keyword location:coordinate radius:self.radius sessionToken:self.sessionToken success:^(SAAddressAutoCompleteRspModel *_Nonnull rspModel) {
        NSArray<SAAddressAutoCompleteItem *> *list = rspModel.results;
        @HDStrongify(self);

        // 先判断当前界面搜索框是否还有关键词，如果在数据返回之前用户已经清空输入框，则不用刷新
        if (HDIsStringNotEmpty(self.keyWord) && [self.keyWord isEqualToString:keyword]) {
            if (list.count > 0) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:list];
                [self.tableView successGetNewDataWithNoMoreData:true];
            } else {
                [self.dataSource removeAllObjects];

                self.tableView.placeholderViewModel.title = [NSString stringWithFormat:WMLocalizedString(@"not_found_results", @"暂时没有找到'%@'的相关信息"), keyword];
                [self.tableView successGetNewDataWithNoMoreData:true];
            }
        } else {
            HDLog(@"搜索结果返回，但当前关键词已经清空或者关键词不匹配，不刷新界面");
        }

        self.tableView.hidden = false;
        [self showOrHiddenTipView];
        [SATalkingData trackEvent:@"谷歌服务_关键字搜索" label:@"" parameters:@{@"关键字": HDIsStringNotEmpty(keyword) ? keyword : @""}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"搜索出错：%@", error.localizedDescription);
    }];
}

#pragma mark - setter
- (void)setKeyWord:(NSString *)keyWord {
    _keyWord = keyWord;

    HDLog(@"关键词变化：%@", keyWord);
    if (!HDIsStringEmpty(keyWord)) {
        [HDFunctionThrottle throttleWithInterval:0.5 key:NSStringFromSelector(@selector(searchListForKeyWord:)) handler:^{
            [self searchListForKeyWord:keyWord];
        }];
    } else {
        [HDFunctionThrottle throttleCancelWithKey:NSStringFromSelector(@selector(searchListForKeyWord:))];
        self.tableView.hidden = true;
        [self showOrHiddenTipView];
    }
}

#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - HDSearchBarDelegate
- (BOOL)searchBarShouldClear:(HDSearchBar *)searchBar {
    self.keyWord = @"";
    self.searchingKeyword = nil;
    return true;
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    [searchBar setShowRightButton:true animated:true];

    self.tableView.hidden = !self.tableView.hd_hasData;
    [self showOrHiddenTipView];
    // 生成Token
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMddHHmmss"];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *sessionToken = [fmt stringFromDate:NSDate.date];
    sessionToken = [sessionToken stringByAppendingFormat:@"%04d", arc4random() % 10000];
    self.sessionToken = sessionToken;
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar {
    [searchBar setShowRightButton:false animated:true];
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0)) {
    [searchBar setShowRightButton:false animated:true];
}

- (void)searchBar:(HDSearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.keyWord = fixedKeywordWithOriginalKeyword(searchText);
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
    self.tableView.hidden = true;
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
    [self searchListForKeyWord:fixedKeywordWithOriginalKeyword(textField.text)];
    return true;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - SAMapViewDelegate
- (void)mapView:(SAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D coordinate = mapView.mapView.region.center;
    self.recordAddress = nil;
    // 当解析模式为每次都解析或者首次进入该页面未获取到地区时才解析
    if (self.style == SAChooseAddressMapGeocodeTypeDefault || HDIsObjectNil(self.chooseZoneView.model)) {
        [self updateTipViewWithCoordinate:coordinate completion:nil];
    }
}

#pragma mark - HDLocationManagerProtocol
- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusAuthed) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            if (self.useUserLocationAsMapCenter) {
                CLLocationCoordinate2D coordinate = HDLocationManager.shared.coordinate2D;
                [self centerMapViewToCoordinate:coordinate];
                //                [self.mapView.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.02, 0.02)) animated:YES];
                self.useUserLocationAsMapCenter = false;
            }
        } else {
            [HDLocationManager.shared startUpdatingLocation];
        }
    }
    if (status != HDCLAuthorizationStatusNotAuthed) {
        if (self.unAuthedAlertView) {
            [self.unAuthedAlertView dismiss];
        }
    }
}

- (void)locationManagerMonitoredLocationChanged:(NSNotification *)notification {
    if (self.useUserLocationAsMapCenter) {
        CLLocationCoordinate2D coordinate = HDLocationManager.shared.coordinate2D;
        [self centerMapViewToCoordinate:coordinate];
        self.useUserLocationAsMapCenter = false;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;

    SAAddressAutoCompleteItem *model = self.dataSource[indexPath.row];

    SASearchAddressResultTableViewCell *cell = [SASearchAddressResultTableViewCell cellWithTableView:tableView];
    cell.model = model;

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SAAddressAutoCompleteItem *model = self.dataSource[indexPath.row];
    self.keyWord = @"";
    [self showloading];
    @HDWeakify(self);
    [self.searchAddressDTO getPlaceDetailsWithPlaceId:model.placeId sessionToken:self.sessionToken success:^(SAAddressSearchRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        // 地图定位
        if ([rspModel.status isEqualToString:@"OK"]) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(rspModel.result.geometry.location.lat.doubleValue, rspModel.result.geometry.location.lng.doubleValue);
            [self.mapView.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.008, 0.008)) animated:YES];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark - private methods
- (void)centerMapViewToCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.mapView.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.002, 0.002)) animated:YES];
    //    HDLog(@"当前的span: %f , %f", self.mapView.mapView.region.span.latitudeDelta, self.mapView.mapView.region.span.longitudeDelta);
    //    [self.mapView.mapView setCenterCoordinate:coordinate animated:YES];
}

- (void)updateTipViewWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(void (^_Nullable)(BOOL))completion {
    [SALocationUtil transferCoordinateToAddress:coordinate
                                     completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                         if (HDIsStringEmpty(address)) {
                                             NSString *address = SALocalizedString(@"address_unknow", @"unknow");
                                             [self.tipView updateUIWithSubTitle:address];
                                             !completion ?: completion(false);
                                         } else {
                                             SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                             addressModel.lat = @(coordinate.latitude);
                                             addressModel.lon = @(coordinate.longitude);
                                             addressModel.address = address;
                                             addressModel.consigneeAddress = consigneeAddress;
                                             addressModel.fromType = SAAddressModelFromTypeMap;
                                             self.recordAddress = addressModel;
                                             [self.tipView updateUIWithSubTitle:addressModel.fullAddress];
                                             if (HDIsObjectNil(self.chooseZoneView.model)) {
                                                 self.chooseZoneView.model = addressModel;
                                             }
                                             !completion ?: completion(true);
                                         }
                                     }];
}

- (void)confirm {
    !self.choosedAddressBlock ?: self.choosedAddressBlock(self.recordAddress);
    if (!self.notNeedPop) {
        [self dismissAnimated:true completion:nil];
    }
}

- (void)showOrHiddenTipView {
    if (self.style == SAChooseAddressMapGeocodeTypeOnce) {
        self.tipView.hidden = true;
        return;
    }
    self.tipView.hidden = !self.tableView.isHidden;
}

NS_INLINE NSString *fixedKeywordWithOriginalKeyword(NSString *originalKeyword) {
    // 去除两端空格
    NSString *keyWord = [originalKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除连续空格
    while ([keyWord rangeOfString:@"  "].location != NSNotFound) {
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return [keyWord copy];
}

#pragma mark - event response
- (void)clickedTableViewBackgroundViewHandler {
    [self.searchBar resignFirstResponder];
    self.tableView.hidden = true;
    [self showOrHiddenTipView];
}

- (void)clickedCfmBTNHandler {
    @HDWeakify(self);
    void (^confirmBlock)(void) = ^{
        @HDStrongify(self);
        if (!self.recordAddress.isNeedCompleteAddress) {
            [self dismissLoading];
            [self confirm];
            return;
        }
        @HDWeakify(self);
        [self.zoneDTO fuzzyQueryZoneListWithProvince:self.recordAddress.city district:self.recordAddress.subLocality commune:nil latitude:self.recordAddress.lat longitude:self.recordAddress.lon
            success:^(SAAddressZoneModel *_Nonnull zoneModel) {
                @HDStrongify(self);
                [self dismissLoading];
                [self parseAddressZoneModel:zoneModel];
                [self confirm];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self dismissLoading];
                [NAT showToastWithTitle:nil content:SALocalizedString(@"failed_get_address_code", @"获取地址编码失败") type:HDTopToastTypeInfo];
            }];
    };

    // 判断当前地图中心点是否解析过，没解析过先解析
    if (HDIsObjectNil(self.recordAddress)) {
        [self showloading];
        [self updateTipViewWithCoordinate:self.mapView.mapView.region.center completion:^(BOOL success) {
            if (success) {
                confirmBlock();
            } else {
                [self dismissLoading];
                [NAT showToastWithTitle:nil content:SALocalizedString(@"failed_get_address", @"获取地址失败") type:HDTopToastTypeInfo];
            }
        }];
    } else {
        [self showloading];
        confirmBlock();
    }
}

- (void)parseAddressZoneModel:(SAAddressZoneModel *)addressZoneModel {
    if (HDIsObjectNil(addressZoneModel)) {
        HDLog(@"获取地址编码失败");
        return;
    }
    SAAddressZoneModel *currentZoneModel = addressZoneModel;
    while (!HDIsObjectNil(currentZoneModel)) {
        if (currentZoneModel.zlevel == SAAddressZoneLevelProvince) {
            self.recordAddress.provinceCode = currentZoneModel.code;
        } else if (currentZoneModel.zlevel == SAAddressZoneLevelDistrict) {
            self.recordAddress.districtCode = currentZoneModel.code;
        }
        currentZoneModel = currentZoneModel.children.firstObject;
    }
}

- (void)clickedLocateBTNHander {
    self.useUserLocationAsMapCenter = true;
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusNotAuthed) {
        // 未授权
        self.unAuthedAlertView = [SALocationUtil showUnAuthedTipConfirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            // 打开系统设置
            [HDSystemCapabilityUtil openAppSystemSettingPage];
        } cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
        }];
    } else if (status == HDCLAuthorizationStatusAuthed) {
        if (self.unAuthedAlertView) {
            [self.unAuthedAlertView dismiss];
        }
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            CLLocationCoordinate2D coordinate = HDLocationManager.shared.coordinate2D;
            [self centerMapViewToCoordinate:coordinate];
            self.useUserLocationAsMapCenter = false;
        } else {
            [HDLocationManager.shared startUpdatingLocation];
        }
    } else if (status == HDCLAuthorizationStatusNotDetermined) {
        if (self.unAuthedAlertView) {
            [self.unAuthedAlertView dismiss];
        }
        [HDLocationManager.shared requestWhenInUseAuthorization];
    }
}

- (void)chooseZoneHandler {
    void (^callback)(SAAddressZoneModel *) = ^(SAAddressZoneModel *zoneModel) {
        self.radius = zoneModel.radius <= 0 ? 20000 : zoneModel.radius;

        SAAddressModel *addressModel = SAAddressModel.new;
        addressModel.subLocality = zoneModel.message.desc;
        if (!HDIsObjectNil(zoneModel.latitude) && !HDIsObjectNil(zoneModel.longitude)) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(zoneModel.latitude.doubleValue, zoneModel.longitude.doubleValue);
            if ([HDLocationManager.shared isCoordinate2DValid:coordinate]) {
                addressModel.lat = zoneModel.latitude;
                addressModel.lon = zoneModel.longitude;
                [self centerMapViewToCoordinate:coordinate];
            }
        }
        self.chooseZoneView.model = addressModel;
    };
    [HDMediator.sharedInstance navigaveToChooseZoneViewController:@{@"callback": callback}];
}

#pragma mark - lazy load
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.textFieldHeight = 35;
        _searchBar.placeholderColor = HDAppTheme.color.G3;
        _searchBar.placeHolder = SALocalizedString(@"search_location", @"Search location");
        _searchBar.inputFieldBackgrounColor = [HDAppTheme.color.G4 colorWithAlphaComponent:0.7];
        [_searchBar setRightButtonTitle:SALocalizedString(@"cancel", @"Cancel")];
        [_searchBar setLeftButtonTitle:@""];
    }
    return _searchBar;
}

- (SAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[SAMapView alloc] init];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (HDUIButton *)locateBTN {
    if (!_locateBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"location_fix"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button addTarget:self action:@selector(clickedLocateBTNHander) forControlEvents:UIControlEventTouchUpInside];
        _locateBTN = button;
    }
    return _locateBTN;
}

- (SAOperationButton *)cfmBTN {
    if (!_cfmBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.cornerRadius = 22.5;
        [button setTitle:self.buttonTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedCfmBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _cfmBTN = button;
    }
    return _cfmBTN;
}

- (UIImageView *)annotationIV {
    if (!_annotationIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"annotation_user"];
        _annotationIV = imageView;
    }
    return _annotationIV;
}

- (SAChooseAddressTipView *)tipView {
    if (!_tipView) {
        _tipView = SAChooseAddressTipView.new;
        _tipView.hidden = self.style == SAChooseAddressMapGeocodeTypeOnce;
    }
    return _tipView;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _tableView.bounces = false;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        _tableView.backgroundView = UIView.new;
        _tableView.backgroundView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];

        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"placeholder_store_off";
        placeHolderModel.titleFont = HDAppTheme.font.standard3;
        placeHolderModel.titleColor = HDAppTheme.color.G3;
        placeHolderModel.needRefreshBtn = false;
        placeHolderModel.backgroundColor = UIColor.whiteColor;
        _tableView.placeholderViewModel = placeHolderModel;

        UITapGestureRecognizer *recoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedTableViewBackgroundViewHandler)];
        [_tableView.backgroundView addGestureRecognizer:recoginzer];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.hidden = true;
    }
    return _tableView;
}

- (NSMutableArray<SAAddressAutoCompleteItem *> *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.array; });
}

- (SASearchAddressDTO *)searchAddressDTO {
    if (!_searchAddressDTO) {
        _searchAddressDTO = SASearchAddressDTO.new;
    }
    return _searchAddressDTO;
}

- (SAChooseAddressZoneView *)chooseZoneView {
    if (!_chooseZoneView) {
        _chooseZoneView = SAChooseAddressZoneView.new;
        [_chooseZoneView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseZoneHandler)]];
    }
    return _chooseZoneView;
}

- (SAChooseZoneDTO *)zoneDTO {
    if (!_zoneDTO) {
        _zoneDTO = SAChooseZoneDTO.new;
    }
    return _zoneDTO;
}

@end

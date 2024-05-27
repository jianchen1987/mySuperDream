//
//  PNMSMapAddressView.m
//  SuperApp
//
//  Created by xixi on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSMapAddressView.h"
#import "HDLocationManager.h"
#import "PNLocationView.h"
#import "PNMSMapAddressModel.h"
#import "PNMSMapAddressViewModel.h"
#import "PNOutletViewModel.h"
#import "PNSingleSelectedAlertView.h"
#import "PNTableView.h"
#import "SAAddressAutoCompleteItem.h"
#import "SAAddressAutoCompleteRspModel.h"
#import "SAAddressModel.h"
#import "SAAddressSearchRspModel.h"
#import "SACommonConst.h"
#import "SALocationUtil.h"
#import "SAMapView.h"
#import "SASearchAddressDTO.h"
#import "SASearchAddressResultTableViewCell.h"


@interface PNMSMapAddressView () <MKMapViewDelegate, HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) HDUIButton *provinceBtn;
@property (nonatomic, strong) UIImageView *centerAnnationImgView;
@property (nonatomic, strong) SAMapView *mapView;
@property (nonatomic, strong) PNLocationView *userLocationView;
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) PNOperationButton *confirmBtn;
@property (nonatomic, strong) HDSearchBar *searchBar;
@property (nonatomic, strong) SASearchAddressDTO *searchAddressDTO;
@property (nonatomic, strong) NSString *searchingKeyword;
@property (nonatomic, strong) NSString *keyWord;
///< 谷歌服务需要的token
@property (nonatomic, copy) NSString *sessionToken;
/// 未授权弹窗
@property (nonatomic, strong) HDAlertView *unAuthedAlertView;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;

@property (nonatomic, strong) PNMSMapAddressViewModel *viewModel;
@end


@implementation PNMSMapAddressView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.viewModel getProvinces];

    [self.KVOController hd_observe:self.viewModel keyPath:@"provincesRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (!WJIsObjectNil(self.viewModel.provincesArray) && WJIsStringEmpty(self.viewModel.currentSelectProvince)) {
            [self handleSelectProvince];
        }
    }];
}

- (void)hd_setupViews {
    [self addSubview:self.topBgView];
    [self addSubview:self.mapView];
    [self.topBgView addSubview:self.provinceBtn];
    [self.topBgView addSubview:self.searchBar];
    [self addSubview:self.centerAnnationImgView];
    [self addSubview:self.userLocationView];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.confirmBtn];

    // 监听位置权限变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];

    // 监听位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];

    if (!WJIsObjectNil(self.viewModel.addressModel.lat) && !WJIsObjectNil(self.viewModel.addressModel.lon)) {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(self.viewModel.addressModel.lat.doubleValue, self.viewModel.addressModel.lon.doubleValue);
        if ([HDLocationManager.shared isCoordinate2DValid:coor]) {
            [self pn_setCenterCoordinate:coor];
        } else {
            [self initUserLocationAnnation];
        }
    } else {
        [self initUserLocationAnnation];
    }
}

- (void)initUserLocationAnnation {
    CLLocationCoordinate2D coordinate;
    if ([HDLocationManager.shared isCurrentCoordinate2DValid]) {
        coordinate = HDLocationManager.shared.realCoordinate2D;
    } else {
        coordinate = kDefaultLocationPhn;
    }

    [self pn_setCenterCoordinate:coordinate];
}

- (void)updateConstraints {
    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(kRealWidth(56)));
    }];

    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.topBgView.mas_bottom);
        make.bottom.mas_equalTo(self.bottomBgView.mas_top);
    }];

    [self.provinceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgView.mas_left);
        make.width.equalTo(@(self.provinceBtn.width + kRealWidth(24)));
        make.height.equalTo(@(self.provinceBtn.height + kRealWidth(8)));
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
    }];

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.provinceBtn.mas_right);
        make.right.mas_equalTo(self.topBgView.mas_right);
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(self.topBgView.mas_centerY);
    }];

    [self.centerAnnationImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.centerAnnationImgView.image.size);
        make.centerX.equalTo(self.mapView);
        make.bottom.equalTo(self.mapView.mas_centerY);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.top.mas_equalTo(self.topBgView.mas_bottom);
    }];

    [self.userLocationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];

    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomBgView.mas_top).offset(kRealWidth(8));
        make.left.mas_equalTo(self.bottomBgView.mas_left).offset(kRealWidth(16));
        make.right.mas_equalTo(self.bottomBgView.mas_right).offset(kRealWidth(-16));
        make.bottom.mas_equalTo(self.bottomBgView.mas_bottom).offset(-(kRealWidth(24) + kiPhoneXSeriesSafeBottomHeight));
        make.height.equalTo(@(48));
    }];

    [super updateConstraints];
}

#pragma mark
NS_INLINE NSString *fixedKeywordWithOriginalKeyword(NSString *originalKeyword) {
    // 去除两端空格
    NSString *keyWord = [originalKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除连续空格
    while ([keyWord rangeOfString:@"  "].location != NSNotFound) {
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return [keyWord copy];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];
}

/// 用户主动点击了 定位
- (void)clickedLocateBTNHander {
    //    self.useUserLocationAsMapCenter = true;
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
            CLLocationCoordinate2D coordinate = HDLocationManager.shared.realCoordinate2D;

            HDLog(@"定位： %f - %f", coordinate.latitude, coordinate.longitude);
            //            self.viewModel.addressModel = nil;
            [self pn_setCenterCoordinate:coordinate];
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

#pragma mark
#pragma mark - HDLocationManagerProtocol
- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    HDLog(@"定位权限更变了");
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusAuthed) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            CLLocationCoordinate2D coordinate = HDLocationManager.shared.realCoordinate2D;
            HDLog(@"定位： %f - %f", coordinate.latitude, coordinate.longitude);
            [self pn_setCenterCoordinate:coordinate];
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
    HDLog(@"定位更变了");
    CLLocationCoordinate2D coordinate = HDLocationManager.shared.realCoordinate2D;
    [self pn_setCenterCoordinate:coordinate];
}

#pragma mark
- (void)pn_setCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    self.centerCoordinate = coordinate;
    HDLog(@"中心点是： %f - %f", coordinate.latitude, coordinate.longitude);
    [self.mapView.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.02, 0.02))];
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
            [self pn_setCenterCoordinate:coordinate];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
#pragma mark - Data
- (void)searchListForKeyWord:(NSString *)keyword {
    if ([self.searchingKeyword isEqualToString:keyword])
        return;
    self.searchingKeyword = keyword;

    if (HDIsStringEmpty(keyword))
        return;

    @HDWeakify(self);
    [self.searchAddressDTO searchAddressWithKeyword:keyword location:self.centerCoordinate radius:20000 sessionToken:self.sessionToken success:^(SAAddressAutoCompleteRspModel *_Nonnull rspModel) {
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
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"搜索出错：%@", error.localizedDescription);
    }];
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

- (void)showOrHiddenTipView {
    //    self.tipView.hidden = !self.tableView.isHidden;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditing:YES];
}

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

#pragma mark action
#pragma mark
- (void)chooseAddressAction:(CLLocationCoordinate2D)coordinate {
    if (WJIsStringEmpty(self.viewModel.currentSelectProvince)) {
        return;
    }

    /// 没有更变过中心点就直接返回
    if (self.viewModel.addressModel.lat.doubleValue == coordinate.latitude && self.viewModel.addressModel.lon.doubleValue == coordinate.longitude) {
        [self.viewController.navigationController popViewControllerAnimated:YES];
        return;
    }

    [self showloading];
    @HDWeakify(self);
    [SALocationUtil transferCoordinateToAddress:coordinate
                                     completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                         @HDStrongify(self);
                                         [self dismissLoading];
                                         SAAddressModel *addressModel;
                                         if (HDIsStringEmpty(address)) {
                                             addressModel = [[SAAddressModel alloc] init];
                                             addressModel.address = SALocalizedString(@"address_unknow", @"unknow");
                                         } else {
                                             addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                             addressModel.lat = @(coordinate.latitude);
                                             addressModel.lon = @(coordinate.longitude);
                                             addressModel.address = address;
                                             addressModel.consigneeAddress = consigneeAddress;

                                             /// 在这里强行赋值 [开通上传的省份是 用户选的省]
                                             addressModel.state = self.viewModel.currentSelectProvince;
                                             HDLog(@"%@", addressModel.description);
                                         }
                                         !self.viewModel.choosedAddressBlock ?: self.viewModel.choosedAddressBlock(addressModel);
                                         [self.viewController.navigationController popViewControllerAnimated:YES];
                                     }];
}

- (void)handleSelectProvince {
    NSMutableArray *showArray = [NSMutableArray array];
    [self.viewModel.provincesArray enumerateObjectsUsingBlock:^(PNMSMapAddressModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
        model.name = obj.msg;
        model.itemId = obj.code;
        if ([self.viewModel.currentSelectProvince isEqualToString:model.name]) {
            model.isSelected = YES;
        }
        [showArray addObject:model];
    }];

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:showArray title:PNLocalizedString(@"pn_select_province", @"请选择省份")
                                                                                  forceSelect:WJIsStringEmpty(self.viewModel.currentSelectProvince) ? YES : NO];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        self.viewModel.currentSelectProvince = model.name;
        [self.provinceBtn setTitle:model.name forState:0];
        [self.provinceBtn sizeToFit];

        [self setNeedsUpdateConstraints];
    };
    [alertView show];
}

#pragma mark
/// 用户位置改变
- (void)mapView:(SAMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    HDLog(@"🦋🦋🦋用户位置改变: %@", userLocation);
    //    self.userAnnotation.coordinate = userLocation.location.coordinate;
}

/// 地图中心改变
- (void)mapView:(SAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    HDLog(@"地图中心改变");
    [self setCenterCoordinate:mapView.mapView.centerCoordinate];
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
    }
    return _tableView;
}

- (SAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[SAMapView alloc] init];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.inputFieldBackgrounColor = HDAppTheme.PayNowColor.backgroundColor;
        _searchBar.delegate = self;
        _searchBar.textFieldHeight = 44;
        _searchBar.showBottomShadow = false;
        [_searchBar setRightButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消")];
        _searchBar.placeHolder = PNLocalizedString(@"pn_ms_search_address", @"请输入地址搜索");
        _searchBar.placeholderColor = HDAppTheme.PayNowColor.c999999;
        _searchBar.searchImage = [UIImage imageNamed:@"pn_ms_search_black"];
        [_searchBar setLeftButtonImage:UIImage.new];
    }
    return _searchBar;
}

- (SASearchAddressDTO *)searchAddressDTO {
    if (!_searchAddressDTO) {
        _searchAddressDTO = [[SASearchAddressDTO alloc] init];
    }
    return _searchAddressDTO;
}

- (PNOperationButton *)confirmBtn {
    if (!_confirmBtn) {
        PNOperationButton *button = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [button setTitle:PNLocalizedString(@"pn_ms_use_adddress", @"选择该地址") forState:UIControlStateNormal];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self chooseAddressAction:self.centerCoordinate];
        }];

        _confirmBtn = button;
    }
    return _confirmBtn;
}

- (PNLocationView *)userLocationView {
    if (!_userLocationView) {
        _userLocationView = [[PNLocationView alloc] init];
        @HDWeakify(self);
        _userLocationView.buttonClickBlock = ^{
            @HDStrongify(self);
            [self clickedLocateBTNHander];
        };
    }
    return _userLocationView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIImageView *)centerAnnationImgView {
    if (!_centerAnnationImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_select_point"];
        _centerAnnationImgView = imageView;
    }
    return _centerAnnationImgView;
}

- (HDUIButton *)provinceBtn {
    if (!_provinceBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:UIControlStateNormal];
        [button setTitle:WJIsStringNotEmpty(self.viewModel.currentSelectProvince) ? self.viewModel.currentSelectProvince : PNLocalizedString(@"pn_select_province", @"选择省份")
                forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_arrow_down_black"] forState:0];
        [button setImagePosition:HDUIButtonImagePositionRight];
        button.spacingBetweenImageAndTitle = kRealWidth(10);
        button.adjustsButtonWhenHighlighted = NO;
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14M;
        [button sizeToFit];

        _provinceBtn = button;

        @HDWeakify(self);
        [_provinceBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self handleSelectProvince];
        }];
    }
    return _provinceBtn;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _topBgView = view;
    }
    return _topBgView;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bottomBgView = view;
    }
    return _bottomBgView;
}

@end

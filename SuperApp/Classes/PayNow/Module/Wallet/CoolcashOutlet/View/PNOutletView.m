//
//  PNOutletView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNOutletView.h"
#import "HDAlertView.h"
#import "HDLocationManager.h"
#import "HDSearchBar.h"
#import "MKMapView+ZoomLevel.h"
#import "NSObject+HDKitCore.h"
#import "PNAgentInfoModel.h"
#import "PNAgentView.h"
#import "PNLocationView.h"
#import "PNOutletViewModel.h"
#import "PNTableView.h"
#import "SAAddressAutoCompleteItem.h"
#import "SAAddressAutoCompleteRspModel.h"
#import "SAAddressSearchRspModel.h"
#import "SACommonConst.h"
#import "SALocationUtil.h"
#import "SAMapView.h"
#import "SASearchAddressDTO.h"
#import "SASearchAddressResultTableViewCell.h"
#import <MapKit/MapKit.h>

static NSString *const kPNType = @"pnType";
static NSString *const kPNDataModel = @"pn_dataModel";

typedef enum : NSUInteger {
    PNAnnotationType_UserSelect,
    PNAnnotationType_UserLocation,
    PNAnnotationType_CoolCashOutle,
} PNAnnotationType;


@interface PNOutletView () <MKMapViewDelegate, HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNAgentView *agentView;
@property (nonatomic, strong) UIImageView *centerAnnationImgView;
@property (nonatomic, strong) SAMapView *mapView;
@property (nonatomic, strong) PNLocationView *userLocationView;
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
@property (nonatomic, strong) PNOutletViewModel *viewModel;
///大头针数据源 - coolcash网点annotation数据源
@property (nonatomic, strong) NSMutableArray<SAAnnotation *> *annotationArray;

@property (nonatomic, strong) SAAnnotation *userAnnotation;
@property (nonatomic, assign) BOOL flag;
@end


@implementation PNOutletView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        /// 先移除 现有的 annotation 再清空 annotationArray
        [self.mapView.mapView removeAnnotations:self.annotationArray];
        [self.annotationArray removeAllObjects];

        for (PNAgentInfoModel *model in self.viewModel.coolcashDataSourceArray) {
            [self.annotationArray addObject:[self annotation:CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue) type:PNAnnotationType_CoolCashOutle dataModel:model]];
        }
        if (self.annotationArray.count > 0) {
            [self.mapView.mapView addAnnotations:self.annotationArray];
            //                                     [self.mapView.mapView zoomToFitMapAnnotationsWithCenterCoordinate:self.viewModel.selectCoordinate
            //                                     annotations:self.annotationArray];
        }
    }];
}

- (void)initUserLocationAnnation {
    CLLocationCoordinate2D coordinate;
    if ([HDLocationManager.shared isCurrentCoordinate2DValid]) {
        coordinate = HDLocationManager.shared.realCoordinate2D;
    } else {
        coordinate = kDefaultLocationPhn;
    }

    [self setCenterCoordinateAfterToSearch:coordinate];
}

- (void)hd_setupViews {
    [self addSubview:self.mapView];
    [self addSubview:self.searchBar];
    [self addSubview:self.centerAnnationImgView];
    [self addSubview:self.userLocationView];
    [self addSubview:self.agentView];
    [self addSubview:self.tableView];

    // 监听位置权限变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];

    // 监听位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];

    [self initUserLocationAnnation];
}

- (void)updateConstraints {
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(15));
        make.height.equalTo(@(kRealWidth(44)));
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
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(kRealWidth(5));
    }];

    [self.userLocationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    [self.agentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(kRealWidth(5));
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

/// 0 用户搜索选择的点  1 coolcash 网点    2用户当前定位
- (SAAnnotation *)annotation:(CLLocationCoordinate2D)coordinate type:(PNAnnotationType)type dataModel:(PNAgentInfoModel *)model {
    SAAnnotation *sa = [[SAAnnotation alloc] init];
    sa.coordinate = coordinate;
    sa.type = SAAnnotationTypeCustom;
    if (type == PNAnnotationType_UserSelect) {
        // 用户选择的地址
        sa.logoImage = [UIImage imageNamed:@"pn_select_point"];
    } else if (type == PNAnnotationType_CoolCashOutle) {
        // coolcash 的icon
        sa.logoImage = [UIImage imageNamed:@"pn_coolcash_outlet_poinit"];
    } else if (type == PNAnnotationType_UserLocation) {
        // 用户当前定位的地址
        sa.logoImage = [UIImage imageNamed:@"pn_user_point"];
    }

    [sa hd_bindObjectWeakly:@(type) forKey:kPNType];
    [sa hd_bindObjectWeakly:model forKey:kPNDataModel];
    return sa;
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
            [self setCenterCoordinateAfterToSearch:coordinate];
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
            self.userAnnotation.coordinate = coordinate;
            self.viewModel.selectCoordinate = coordinate;
            [self.mapView.mapView setRegion:MKCoordinateRegionMake(self.userAnnotation.coordinate, MKCoordinateSpanMake(0.02, 0.02))];
            [self.viewModel searchNearCoolCashMerchant];
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
    [self setCenterCoordinateAfterToSearch:coordinate];
}

#pragma mark
- (void)setCenterCoordinateAfterToSearch:(CLLocationCoordinate2D)coordinate {
    self.userAnnotation.coordinate = coordinate;
    self.viewModel.selectCoordinate = coordinate;
    [self.mapView.mapView setRegion:MKCoordinateRegionMake(self.userAnnotation.coordinate, MKCoordinateSpanMake(0.02, 0.02))];
    [self.viewModel searchNearCoolCashMerchant];
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
            self.viewModel.selectCoordinate = coordinate;
            [self.viewModel searchNearCoolCashMerchant];
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
    [self.searchAddressDTO searchAddressWithKeyword:keyword location:self.viewModel.selectCoordinate radius:20000 sessionToken:self.sessionToken
        success:^(SAAddressAutoCompleteRspModel *_Nonnull rspModel) {
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

#pragma mark
/// 用户位置改变
- (void)mapView:(SAMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    HDLog(@"🦋🦋🦋用户位置改变: %@", userLocation);
    self.userAnnotation.coordinate = userLocation.location.coordinate;
}

/// 地图中心改变
- (void)mapView:(SAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    HDLog(@"地图中心改变");

    NSString *sLongitude = [NSString stringWithFormat:@"%f", self.viewModel.selectCoordinate.longitude];
    NSString *sLatitude = [NSString stringWithFormat:@"%f", self.viewModel.selectCoordinate.latitude];
    NSString *cLongitude = [NSString stringWithFormat:@"%f", mapView.mapView.centerCoordinate.longitude];
    NSString *cLatitude = [NSString stringWithFormat:@"%f", mapView.mapView.centerCoordinate.latitude];
    if (![sLongitude isEqualToString:cLongitude] && ![sLatitude isEqualToString:cLatitude]) {
        self.viewModel.selectCoordinate = mapView.mapView.centerCoordinate;
        HDLog(@"开始调用接口了");
        [self.viewModel searchNearCoolCashMerchant];
    }
}

/// 点击了 目标
- (void)mapView:(SAMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:SAAnnotationView.class]) {
        SAAnnotationView *saView = (SAAnnotationView *)view;
        SAAnnotation *annotation = saView.annotation;
        HDLog(@"click: %f - %f", annotation.coordinate.latitude, annotation.coordinate.longitude);

        PNAnnotationType type = [[annotation hd_getBoundObjectForKey:kPNType] integerValue];
        if (type == PNAnnotationType_CoolCashOutle) {
            annotation.logoImage = [UIImage imageNamed:@"pn_coolcash_outlet_poinit_select"];
            saView.annotation = annotation;

            PNAgentInfoModel *infoModel = [annotation hd_getBoundObjectForKey:kPNDataModel];
            if (!WJIsObjectNil(infoModel)) {
                self.agentView.model = infoModel;
                [self.agentView showInView:self];
            }
        }
    }
}

/// 取消点击了 目标
- (void)mapView:(SAMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:SAAnnotationView.class]) {
        SAAnnotationView *saView = (SAAnnotationView *)view;
        SAAnnotation *annotation = saView.annotation;
        PNAnnotationType type = [[annotation hd_getBoundObjectForKey:kPNType] integerValue];
        if (type == PNAnnotationType_CoolCashOutle) {
            annotation.logoImage = [UIImage imageNamed:@"pn_coolcash_outlet_poinit"];
            saView.annotation = annotation;
        }
    }
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

- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        _annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.backgroundColor = [HDAppTheme.PayNowColor.cFFFFFF colorWithAlphaComponent:0.0];
        _searchBar.delegate = self;
        _searchBar.textFieldHeight = 35;
        _searchBar.showBottomShadow = false;
        [_searchBar setRightButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消")];
        _searchBar.placeHolder = PNLocalizedString(@"search_neary_agent", @"输入地址搜索附近代理商");
        _searchBar.placeholderColor = HDAppTheme.color.G3;
        _searchBar.inputFieldBackgrounColor = [HDAppTheme.PayNowColor.cFFFFFF colorWithAlphaComponent:0.8];
        [_searchBar setLeftButtonImage:UIImage.new];
        _searchBar.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(22)];
        };
    }
    return _searchBar;
}

- (SASearchAddressDTO *)searchAddressDTO {
    if (!_searchAddressDTO) {
        _searchAddressDTO = [[SASearchAddressDTO alloc] init];
    }
    return _searchAddressDTO;
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

- (PNAgentView *)agentView {
    if (!_agentView) {
        _agentView = [[PNAgentView alloc] init];
        _agentView.hidden = YES;
        _agentView.model = [PNAgentInfoModel new];
        //        [_agentView hiddenView];
        @HDWeakify(self);
        _agentView.clickTapHiddenBlock = ^{
            @HDStrongify(self);
            [self.mapView.mapView deselectAnnotation:nil animated:NO];
        };
    }
    return _agentView;
}

- (UIImageView *)centerAnnationImgView {
    if (!_centerAnnationImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_select_point"];
        //        imageView.image = [UIImage imageNamed:@"annotation_user"];
        _centerAnnationImgView = imageView;
    }
    return _centerAnnationImgView;
}

- (SAAnnotation *)userAnnotation {
    if (!_userAnnotation) {
        _userAnnotation = [self annotation:CLLocationCoordinate2DMake(0, 0) type:PNAnnotationType_UserLocation dataModel:nil];
    }
    return _userAnnotation;
}

//- (SAAnnotation *)centerAnnotation {
//    if (!_centerAnnotation) {
//        _centerAnnotation = [self annotation:CLLocationCoordinate2DMake(0, 0) type:PNAnnotationType_UserSelect dataModel:nil];
//        _centerAnnotation.logoImage = [UIImage imageNamed:@"pn_select_point"];
//    }
//    return _centerAnnotation;
//}
@end

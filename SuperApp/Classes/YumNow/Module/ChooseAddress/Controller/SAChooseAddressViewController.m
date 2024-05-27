//
//  SAChooseAddressViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChooseAddressViewController.h"
#import "SAAddressAutoCompleteRspModel.h"
#import "SAAddressModel.h"
#import "SAAddressSearchRspModel.h"
#import "SAApolloManager.h"
#import "SAChooseAddressZoneView.h"
#import "SAImageTitleTableViewCell.h"
#import "SALocationUtil.h"
#import "SASearchAddressDTO.h"
#import "SASearchAddressResultTableViewCell.h"
#import "SAShoppingAddressDTO.h"
#import "SAShoppingAddressModel.h"
#import "SAShoppingAddressTableViewCell.h"
#import "SATableView.h"
#import "WMAddressCell.h"
#import "WMAddressManageCell.h"
#import "WMChooseAddressViewModel.h"
#import "WMHistoryTableViewCell.h"
#import "WMQueryNearbyStoreRspModel.h"
#import <HDServiceKit/HDLocationManager.h>


@interface SAChooseAddressViewController () <HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
/// 选择地址回调
@property (nonatomic, copy) void (^choosedAddressBlock)(SAAddressModel *);
/// 当前选择的地址模型
@property (nonatomic, weak) SAAddressModel *currentAddressModel;
/// 历史地址模型
@property (nonatomic, strong) WMChooseAddressViewModel *historyViewModel;
/// 搜索栏
@property (nonatomic, strong) HDSearchBar *searchBar;
/// 默认列表
@property (nonatomic, strong) SATableView *listView;
/// 搜索结果
@property (nonatomic, strong) SATableView *tableView;
/// 搜索关键词
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *listDataSource;
/// 数据源
@property (nonatomic, strong) NSMutableArray<SAAddressAutoCompleteItem *> *dataSource;
@property (nonatomic, copy) void (^locationManagerLocateSuccessHandler)(void);
/// 搜索地址 DTO
@property (nonatomic, strong) SASearchAddressDTO *searchAddressDTO;
/// 地址 DTO
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;
/// 当前正在搜索的关键词
@property (nonatomic, copy) NSString *searchingKeyword;
@property (nonatomic, copy) NSString *sessionToken; ///< 会话id

/// 历史地址
@property (nonatomic, strong) NSMutableArray<SAAddressModel *> *historyArr;
/// 管理按钮
@property (nonatomic, strong) HDUIButton *manageBTN;
@end


@implementation SAChooseAddressViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    void (^callback)(SAAddressModel *) = parameters[@"callback"];
    self.choosedAddressBlock = callback;
    self.currentAddressModel = parameters[@"currentAddressModel"];

    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"choose_address", @"选择地址");
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 0;

    [self.view addSubview:self.listView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBar];

    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.manageBTN];

    // 监听位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];
}

- (void)hd_getNewData {
    //    [self showloading];
    @HDWeakify(self);

    double lat = 0;
    double lon = 0;
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusAuthed && HDLocationManager.shared.isCurrentCoordinate2DValid) {
        lat = HDLocationManager.shared.coordinate2D.latitude;
        lon = HDLocationManager.shared.coordinate2D.longitude;
    }
    [self.addressDTO getSearchAddressListWithLog:lat lat:lon Success:^(NSArray<SAShoppingAddressModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self dismissLoading];
        [self changeDataWithTag:@"my_address" list:list];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];

    NSArray *historyArr = [SACacheManager.shared objectForKey:kCacheKeyUserHistory type:SACacheTypeDocumentNotPublic];
    self.historyArr = [NSMutableArray arrayWithArray:historyArr ?: @[]];
    self.historyArr = (NSMutableArray *)[[self.historyArr reverseObjectEnumerator] allObjects];
    [self changeDataWithTag:@"history_address" list:self.historyArr];
}

// 通过tag改变对应的section的list数据
- (void)changeDataWithTag:(NSString *)tag list:(NSArray *)list {
    [self.listDataSource enumerateObjectsUsingBlock:^(HDTableViewSectionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.headerModel && [obj.headerModel.tag isEqualToString:tag]) {
            NSMutableArray *marr = [NSMutableArray arrayWithArray:obj.list];
            if ([tag isEqualToString:@"my_address"]) {
                marr = [NSMutableArray new];
                [obj.list enumerateObjectsUsingBlock:^(WMAddressManageCellModel *_Nonnull modelObject, NSUInteger idx, BOOL *_Nonnull stop) {
                    if (![NSStringFromClass([modelObject class]) isEqualToString:@"SAShoppingAddressModel"]) {
                        if ([modelObject isKindOfClass:WMAddressManageCellModel.class]) {
                            if (modelObject.tag == 1 && list.count >= 5) {
                                modelObject.tag = 2;
                                modelObject.title = WMLocalizedString(@"wm_address_manage", @"wm_address_manage");
                                modelObject.change = YES;
                                [marr addObject:modelObject];
                            } else if (modelObject.tag == 2 && list.count < 5 && modelObject.change) {
                                modelObject.tag = 1;
                                modelObject.change = NO;
                                modelObject.title = WMLocalizedString(@"wm_address_add", @"wm_address_add");
                                [marr addObject:modelObject];
                            } else {
                                [marr addObject:modelObject];
                            }
                        } else {
                            [marr addObject:modelObject];
                        }
                    }
                }];
                self.manageBTN.hidden = true;
                for (int j = 0; j < list.count; j++) {
                    [marr insertObject:list[j] atIndex:j + 1];
                }
            } else if ([tag isEqualToString:@"history_address"]) {
                id firstObject = marr.firstObject;
                [marr removeAllObjects];
                [marr addObject:firstObject];
                for (SAAddressModel *saModel in list) {
                    SAShoppingAddressModel *address = [SAShoppingAddressModel shoppingAddressModelWithAddressModel:saModel];
                    if (address) {
                        [marr addObject:address];
                    }
                }
            }
            obj.list = [NSArray arrayWithArray:marr];
            if (self.listView) {
                [self.listView successGetNewDataWithNoMoreData:NO];
            }
            *stop = YES;
            return;
        }
    }];
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

- (void)updateViewConstraints {
    [self.listView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.width.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.listView);
    }];

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.equalTo(self.view).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    //
    //    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    //        make.left.right.equalTo(self.view);
    //        make.height.mas_equalTo(50);
    //    }];
    [super updateViewConstraints];
}

#pragma mark - 响应链传递
- (void)respondEvent:(NSObject<GNEvent> *)event {
    if ([event.key isEqualToString:@"clearAction"]) {
        //删除本地历史
        if (!HDIsArrayEmpty(self.historyArr)) {
            [self.historyViewModel localClearHistoryAddress];
            [self.historyArr removeAllObjects];
            [self changeDataWithTag:@"history_address" list:self.historyArr];
        }
    }
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
    [self.searchBar setRightButtonTitle:SALocalizedString(@"cancel", @"取消")];

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Data
- (void)searchListForKeyWord:(NSString *)keyword {
    if ([self.searchingKeyword isEqualToString:keyword])
        return;
    self.searchingKeyword = keyword;

    if (HDIsStringEmpty(keyword))
        return;

    @HDWeakify(self);
    [self.searchAddressDTO searchAddressWithKeyword:keyword location:[HDLocationManager shared].coordinate2D radius:20000 sessionToken:self.sessionToken
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

    [SATalkingData trackEvent:@"谷歌服务_关键字搜索" label:@"" parameters:@{@"关键字": HDIsStringNotEmpty(keyword) ? keyword : @""}];
}

#pragma mark - HDLocationManagerProtocol
- (void)locationManagerMonitoredLocationChanged:(NSNotification *)notification {
    if (self.locationManagerLocateSuccessHandler) {
        self.locationManagerLocateSuccessHandler();
        // 清空
        self.locationManagerLocateSuccessHandler = nil;
    }
}

#pragma mark - chooseZoneHandler
- (void)chooseZoneHandler {
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView)
        return 1;
    return self.listDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView)
        return self.dataSource.count;

    NSArray *list = self.listDataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.row >= self.dataSource.count)
            return UITableViewCell.new;
        SAAddressAutoCompleteItem *model = self.dataSource[indexPath.row];
        SASearchAddressResultTableViewCell *cell = [SASearchAddressResultTableViewCell cellWithTableView:tableView];
        cell.model = model;

        return cell;
    }

    if (indexPath.section >= self.listDataSource.count)
        return UITableViewCell.new;

    HDTableViewSectionModel *sectionModel = self.listDataSource[indexPath.section];

    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SAShoppingAddressModel.class]) {
        SAShoppingAddressModel *trueModel = (SAShoppingAddressModel *)model;
        trueModel.cellType = SAShoppingAddressCellTypeChoose;
        WMAddressCell *cell = [WMAddressCell cellWithTableView:tableView];
        cell.hide = [sectionModel.headerModel.tag isEqualToString:@"history_address"];
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:SAImageTitleTableViewCellModel.class]) {
        SAImageTitleTableViewCell *cell = [SAImageTitleTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:WMHistoryTableViewCellModel.class]) {
        WMHistoryTableViewCell *cell = [WMHistoryTableViewCell cellWithTableView:tableView];
        cell.historyModel = model;
        return cell;
    } else if ([model isKindOfClass:WMAddressManageCellModel.class]) {
        WMAddressManageCell *cell = [WMAddressManageCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView)
        return nil;

    HDTableViewSectionModel *sectionModel = self.listDataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.titleFont = HDAppTheme.font.standard2Bold;
    model.marginToBottom = kRealWidth(10);
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView)
        return CGFLOAT_MIN;

    HDTableViewSectionModel *sectionModel = self.listDataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return 40;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self.view endEditing:true];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.tableView) {
        SAAddressAutoCompleteItem *model = self.dataSource[indexPath.row];
        [self showloading];
        @HDWeakify(self);
        [self.searchAddressDTO getPlaceDetailsWithPlaceId:model.placeId sessionToken:self.sessionToken success:^(SAAddressSearchRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];
            if ([rspModel.status isEqualToString:@"OK"]) {
                CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(rspModel.result.geometry.location.lat.doubleValue, rspModel.result.geometry.location.lng.doubleValue);
                [SALocationUtil transferCoordinateToAddress:locationCoordinate
                                                 completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                                     SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                                     addressModel.lat = @(locationCoordinate.latitude);
                                                     addressModel.lon = @(locationCoordinate.longitude);
                                                     addressModel.address = address;
                                                     addressModel.consigneeAddress = consigneeAddress;
                                                     addressModel.fromType = SAAddressModelFromTypeSearch;
                                                     [self chooseAddressModel:addressModel];
                                                     [SATalkingData trackEvent:@"外卖选择地址_搜索结果" label:@""];
                                                 }];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];

        return;
    }
    HDTableViewSectionModel *sectionModel = self.listDataSource[indexPath.section];
    id model = sectionModel.list[indexPath.row];

    if ([model isKindOfClass:SAShoppingAddressModel.class]) {
        SAShoppingAddressModel *trueModel = (SAShoppingAddressModel *)model;
        SAAddressModel *addressModel = [SAAddressModel addressModelWithShoppingAddressModel:trueModel];
        addressModel.fromType = SAAddressModelFromTypeAddressList;
        NSString *string = @"0";
        if ([@[@"1", @"true", @"yes"] containsObject:trueModel.isDefault.lowercaseString]) {
            string = @"1";
        }
        addressModel.temp = string;
        addressModel.gender = [NSString stringWithFormat:@"%@", trueModel.gender];
        WMAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WMAddressCell.class)];
        cell.select = YES;
        [self chooseAddressModel:addressModel];
        [self.historyViewModel localSaveHistoryAddress:addressModel];
    } else if ([model isKindOfClass:SAImageTitleTableViewCellModel.class]) {
        SAImageTitleTableViewCellModel *trueModel = (SAImageTitleTableViewCellModel *)model;
        if (trueModel.tag == 1) {
            // 使用定位地址
            [SATalkingData trackEvent:@"外卖选择地址_当前位置" label:@""];
            [self setAddressWithCurrentLocation];
        } else if (trueModel.tag == 2) {
            // 地图中选择
            void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
                [self chooseAddressModel:addressModel];
                [self.historyViewModel localSaveHistoryAddress:addressModel];
            };
            [SATalkingData trackEvent:@"外卖选择地址_地图选择" label:@""];
            // 读取缓存中的配置
            SAChooseAddressMapGeocodeType geocodeType = SAChooseAddressMapGeocodeTypeDefault;
            NSString *buttonTitle = nil;
            NSString *yumNowswitch = [SAApolloManager getApolloConfigForKey:ApolloConfigKeyYumNowSelectAddressInMapForSearchStore];
            if ([yumNowswitch isEqualToString:@"on"]) {
                geocodeType = SAChooseAddressMapGeocodeTypeOnce;
                buttonTitle = SALocalizedString(@"nearby_shop", @"附近商家");
            }
            [HDMediator.sharedInstance navigaveToChooseAddressInMapViewController:
                                           @{@"callback": callback, @"notNeedPop": @true, @"currentAddressModel": self.currentAddressModel, @"style": @(geocodeType), @"buttonTitle": buttonTitle}];
        } else if (trueModel.tag == 3) {
            //            [SATalkingData trackEvent:@"外卖选择地址_地址簿" label:@""];
            //
            //            // 从地址簿选择
            //            void (^callback)(SAShoppingAddressModel *, SAAddressModelFromType) = ^(SAShoppingAddressModel *shoppingAddressModel, SAAddressModelFromType fromType) {
            //                SAAddressModel *addressModel = [SAAddressModel addressModelWithShoppingAddressModel:shoppingAddressModel];
            //                addressModel.fromType = fromType;
            //                [self chooseAddressModel:addressModel];
            //            };
            //            [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback": callback,
            //                                                                                 @"notNeedPop": @true,
            //                                                                                 @"currentAddressModel": self.currentAddressModel}];
        }
    } else if ([model isKindOfClass:WMAddressManageCellModel.class]) {
        WMAddressManageCellModel *trueModel = (WMAddressManageCellModel *)model;
        if (trueModel.tag == 2) {
            [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:nil];
        } else if (trueModel.tag == 1) {
            [HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:nil];
        }
    }
}

#pragma mark - private methods
- (void)chooseAddressModel:(SAAddressModel *)addressModel {
    // V 2.0.0 修改去除校验逻辑
    !self.choosedAddressBlock ?: self.choosedAddressBlock(addressModel);
    NSUInteger selfIndex = [self.navigationController.viewControllers indexOfObject:self];
    NSInteger popIndex = selfIndex - 1;
    if (popIndex >= 0 && self.navigationController.viewControllers.count > popIndex) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[popIndex] animated:true];
    }
}
- (void)setAddressWithCurrentLocation {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusAuthed) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
            [SALocationUtil transferCoordinateToAddress:coordinate2D
                                             completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                                 if (HDIsStringNotEmpty(address)) {
                                                     SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                                     addressModel.lat = @(coordinate2D.latitude);
                                                     addressModel.lon = @(coordinate2D.longitude);
                                                     addressModel.address = address;
                                                     addressModel.consigneeAddress = consigneeAddress;
                                                     addressModel.fromType = SAAddressModelFromTypeLocate;
                                                     [self chooseAddressModel:addressModel];
                                                 } else {
                                                     [NAT showToastWithTitle:nil content:SALocalizedString(@"unknown_location", @"未知位置") type:HDTopToastTypeError];
                                                 }
                                             }];
        } else {
            [HDLocationManager.shared startUpdatingLocation];
            @HDWeakify(self);
            self.locationManagerLocateSuccessHandler = ^{
                @HDStrongify(self);
                [self setAddressWithCurrentLocation];
            };
        }
    } else if (status == HDCLAuthorizationStatusNotDetermined) {
        [HDLocationManager.shared requestWhenInUseAuthorization];
        @HDWeakify(self);
        self.locationManagerLocateSuccessHandler = ^{
            @HDStrongify(self);
            [self setAddressWithCurrentLocation];
        };
    } else {
        // 未授权
        [SALocationUtil showUnAuthedTipConfirmButtonHandler:nil cancelButtonHandler:nil];
    }
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

#pragma mark - private methods
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
}

#pragma mark 计算两点坐标
- (CLLocationDistance)getDistanceLat1:(double)lat1 whitLng1:(double)lng1 whitLat2:(double)lat2 whitLng2:(double)lng2 {
    CLLocation *current = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *before = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    CLLocationDistance meters = [current distanceFromLocation:before];
    return meters;
}

#pragma mark - lazy load
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.textFieldHeight = 35;
        _searchBar.showBottomShadow = true;
        _searchBar.placeHolder = SALocalizedString(@"search_location", @"Search location");
        _searchBar.placeholderColor = HDAppTheme.color.G3;
        _searchBar.inputFieldBackgrounColor = [HDAppTheme.color.G4 colorWithAlphaComponent:0.7];
        [_searchBar setLeftButtonImage:UIImage.new];
    }
    return _searchBar;
}

- (SATableView *)listView {
    if (!_listView) {
        _listView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.needRefreshHeader = false;
        _listView.needRefreshFooter = false;
        _listView.rowHeight = UITableViewAutomaticDimension;
        _listView.estimatedRowHeight = 50;
    }
    return _listView;
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
        _tableView.rowHeight = UITableViewAutomaticDimension;

        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"placeholder_store_off";
        placeHolderModel.titleFont = HDAppTheme.font.standard3;
        placeHolderModel.titleColor = HDAppTheme.color.G3;
        placeHolderModel.needRefreshBtn = false;
        placeHolderModel.backgroundColor = UIColor.whiteColor;
        _tableView.placeholderViewModel = placeHolderModel;

        UITapGestureRecognizer *recoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedTableViewBackgroundViewHandler)];
        [_tableView.backgroundView addGestureRecognizer:recoginzer];

        _tableView.estimatedRowHeight = 50;
        _tableView.hidden = true;
    }
    return _tableView;
}

- (NSMutableArray<SAAddressAutoCompleteItem *> *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.array; });
}

- (NSArray<HDTableViewSectionModel *> *)listDataSource {
    if (!_listDataSource) {
        NSMutableArray<HDTableViewSectionModel *> *dataSource = [NSMutableArray arrayWithCapacity:2];
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:2];
        SAImageTitleTableViewCellModel *model = SAImageTitleTableViewCellModel.new;
        model.image = [UIImage imageNamed:@"address_location"];
        model.title = SALocalizedString(@"use_current_location", @"使⽤当前位置");
        model.tag = 1;
        [list addObject:model];
        sectionModel.list = list;
        [dataSource addObject:sectionModel];

        sectionModel = HDTableViewSectionModel.new;
        list = [NSMutableArray arrayWithCapacity:2];
        model = SAImageTitleTableViewCellModel.new;
        model.image = [UIImage imageNamed:@"address_scale"];
        model.title = SALocalizedString(@"select_in_map", @"在地图中选择");
        model.tag = 2;
        [list addObject:model];
        sectionModel.list = list;
        [dataSource addObject:sectionModel];

        WMHistoryTableViewCellModel *historyModel = WMHistoryTableViewCellModel.new;
        sectionModel = HDTableViewSectionModel.new;
        list = [NSMutableArray arrayWithCapacity:2];
        historyModel.image = [UIImage imageNamed:@"address_zhong"];
        historyModel.title = WMLocalizedString(@"wm_address_history", @"wm_address_history");
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.tag = @"history_address";
        [list addObject:historyModel];
        sectionModel.list = list;
        [dataSource addObject:sectionModel];

        // 登录了才添加
        if (SAUser.hasSignedIn) {
            sectionModel = HDTableViewSectionModel.new;
            list = [NSMutableArray arrayWithCapacity:2];
            model = SAImageTitleTableViewCellModel.new;
            model.image = [UIImage imageNamed:@"address_ma"];
            model.title = SALocalizedString(@"my_address", @"Open address book");
            sectionModel.headerModel = HDTableHeaderFootViewModel.new;
            sectionModel.headerModel.tag = @"my_address";
            model.tag = 3;
            [list addObject:model];

            WMAddressManageCellModel *manageModel = WMAddressManageCellModel.new;
            manageModel.title = WMLocalizedString(@"wm_address_add", @"wm_address_add");
            manageModel.tag = 1;
            [list addObject:manageModel];

            //             manageModel = WMAddressManageCellModel.new;
            //             manageModel.title = WMLocalizedString(@"wm_address_manage", @"wm_address_manage");
            //             manageModel.tag = 2;
            //             [list addObject:manageModel];

            sectionModel.list = list;
            [dataSource addObject:sectionModel];
        }
        _listDataSource = dataSource;
    }
    return _listDataSource;
}

- (SASearchAddressDTO *)searchAddressDTO {
    if (!_searchAddressDTO) {
        _searchAddressDTO = SASearchAddressDTO.new;
    }
    return _searchAddressDTO;
}
- (SAShoppingAddressDTO *)addressDTO {
    if (!_addressDTO) {
        _addressDTO = SAShoppingAddressDTO.new;
    }
    return _addressDTO;
}
- (NSMutableArray<SAAddressModel *> *)historyArr {
    if (!_historyArr) {
        _historyArr = NSMutableArray.new;
    }
    return _historyArr;
}
- (WMChooseAddressViewModel *)historyViewModel {
    if (!_historyViewModel) {
        _historyViewModel = WMChooseAddressViewModel.new;
    }
    return _historyViewModel;
}

- (HDUIButton *)manageBTN {
    if (!_manageBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:SALocalizedString(@"Manage", @"管理") forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:nil];
        }];
        _manageBTN = button;
    }
    return _manageBTN;
}
@end

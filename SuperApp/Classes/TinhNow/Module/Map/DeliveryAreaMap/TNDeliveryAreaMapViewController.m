//
//  TNDeliveryAreaMapViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNDeliveryAreaMapViewController.h"
#import "HDAppTheme+TinhNow.h"
#import "SAMapView.h"
#import "SAShoppingAddressDTO.h"
#import "TNAdressChangeTipsAlertView.h"
#import "TNDeliveryAreaMapBottomTipView.h"
#import "TNDeliveryAreaMapDTO.h"
#import "TNDeliveryAreaMapModel.h"
#import "TNEnum.h"
#import "TNMapZoomOprateView.h"
//#import "TNTextAnnotationView.h"
#import "SAAddressModel.h"
#import <MapKit/MapKit.h>


@interface TNDeliveryAreaMapViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate>
/// mapView
@property (strong, nonatomic) MKMapView *mapView;
/// 地址管理dto
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;
/// 收货地址大头针
@property (strong, nonatomic) SAAnnotation *storeAnnotation;
/// 操作地图缩放
@property (strong, nonatomic) TNMapZoomOprateView *oprateView;
/// 底部视图
@property (strong, nonatomic) TNDeliveryAreaMapBottomTipView *bottomTipView;
///  查看配送区域按钮
@property (strong, nonatomic) HDUIButton *watchDeliverAreaBtn;
/// 区域数据dto
@property (strong, nonatomic) TNDeliveryAreaMapDTO *mapDTO;
/// 收货地址
@property (strong, nonatomic) SAShoppingAddressModel *addressModel;
/// 地图中心点
@property (nonatomic, assign) MKCoordinateRegion region;
/// 地图数据模型
@property (strong, nonatomic) TNDeliveryAreaMapModel *mapModel;
/// 店铺销售区域 中心坐标点数组
@property (strong, nonatomic) NSMutableArray *storeOversList;
/// 覆盖物数组
@property (strong, nonatomic) NSMutableArray<MKOverlayPathRenderer *> *renderArray;
/// 当前区域模型
@property (strong, nonatomic) TNDeliveryAreaStoreInfoModel *currentDeliverAreaModel;
/// 跳转红区专题回调
@property (nonatomic, copy) void (^backRedSpecialCallBack)(NSString *activityId, SAShoppingAddressModel *addressModel, BOOL deliverValid);
/// 是否来自红区酒水专题页面
@property (nonatomic, assign) BOOL isFromRedZoneSpeciaVC;
@end


@implementation TNDeliveryAreaMapViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.addressModel = parameters[@"addressModel"];
        self.backRedSpecialCallBack = parameters[@"callBack"];
        NSNumber *isFromZone = parameters[@"isFromRedZone"];
        if (isFromZone != nil) {
            self.isFromRedZoneSpeciaVC = [isFromZone boolValue];
        }
    }
    return self;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"XGVcadlQ", @"配送区域");
}
- (void)hd_setupViews {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.oprateView];
    [self.view addSubview:self.bottomTipView];
    [self.view addSubview:self.watchDeliverAreaBtn];
    if ([SAUser hasSignedIn] && (HDIsObjectNil(self.addressModel) || HDIsStringEmpty(self.addressModel.addressNo))) {
        [self getDefaultAddress];
    } else {
        [self getLocationAdress];
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self.mapView addGestureRecognizer:tap];
}
#pragma mark -点击地图 选中地图
- (void)tapClick:(UITapGestureRecognizer *)tap {
    CLLocationCoordinate2D tapCoordinate = [self.mapView convertPoint:[tap locationInView:self.mapView] toCoordinateFromView:self.mapView];
    MKOverlayPathRenderer *targetRender = [self getTargetMapOverlayByCoor:tapCoordinate];
    [self setRendererSelection:targetRender];
    ///更新底部专题标题的选中
    [self.bottomTipView updateStoreTagSelected];
}
#pragma mark -通过经纬度  获得该经纬度所在的销售区域
- (MKOverlayPathRenderer *)getTargetMapOverlayByCoor:(CLLocationCoordinate2D)coor {
    MKMapPoint tapPoint = MKMapPointForCoordinate(coor);
    __block MKOverlayPathRenderer *targetRender = nil;
    [self.renderArray enumerateObjectsUsingBlock:^(MKOverlayPathRenderer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        CGPoint targetPoint = [obj pointForMapPoint:tapPoint];
        if (CGPathContainsPoint(obj.path, NULL, targetPoint, YES)) {
            targetRender = obj;
            *stop = YES;
        }
    }];
    return targetRender;
}
#pragma mark -设置销售区域的选中
- (void)setRendererSelection:(MKOverlayPathRenderer *)renderer {
    if (HDIsObjectNil(renderer)) {
        return;
    }
    MKShape *overlay = renderer.overlay;
    NSString *speciaId = [overlay hd_getBoundObjectForKey:@"specialId"];
    //当前区域模型
    [self.mapModel.storeInfoDTOList enumerateObjectsUsingBlock:^(TNDeliveryAreaStoreInfoModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.specialId isEqualToString:speciaId]) {
            self.currentDeliverAreaModel = obj;
            obj.isSelected = YES;
        } else {
            obj.isSelected = NO;
        }
    }];

    [self.renderArray enumerateObjectsUsingBlock:^(MKOverlayPathRenderer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj == renderer) {
            obj.fillColor = [obj.fillColor colorWithAlphaComponent:0.5];
            obj.lineDashPattern = @[];
        } else {
            obj.fillColor = [obj.fillColor colorWithAlphaComponent:0.3];
            obj.lineDashPattern = @[@2, @4];
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark - 刷新地图
- (void)updateMapData {
    if (!HDIsObjectNil(self.addressModel) && !HDIsObjectNil(self.addressModel.latitude) && !HDIsObjectNil(self.addressModel.longitude) && HDIsStringNotEmpty(self.addressModel.address)) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.addressModel.latitude.doubleValue, self.addressModel.longitude.doubleValue);
        self.storeAnnotation.coordinate = coordinate;
        [self.mapView removeAnnotation:self.storeAnnotation];
        [self.mapView addAnnotation:self.storeAnnotation];
        [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.25, 0.25)) animated:YES];
    }
    //获取店铺区域数据
    [self loadStoreRegionListData];
}
#pragma mark - 更新地图中心点及显示级别
- (void)updateMapViewCenterAndLeavel {
    if (!HDIsObjectNil(self.addressModel) && HDIsStringNotEmpty(self.addressModel.address) && !HDIsArrayEmpty(self.storeOversList)) {
        CLLocationCoordinate2D adressCoor = CLLocationCoordinate2DMake(self.addressModel.latitude.doubleValue, self.addressModel.longitude.doubleValue);
        MKMapPoint adressPoint = MKMapPointForCoordinate(adressCoor);
        UIImage *annImage = [self getAnnotionImage];
        MKMapSize size = MKMapSizeMake(annImage.size.width, annImage.size.height);
        MKMapRect adressRect = MKMapRectMake(adressPoint.x, adressPoint.y, size.width, size.height);
        adressRect = [self.mapView mapRectThatFits:adressRect];
        MKMapRect overlaysRect = [self mapRectForOverlays:self.storeOversList];
        MKMapRect targetRect = MKMapRectUnion(adressRect, overlaysRect);
        targetRect = [self.mapView mapRectThatFits:targetRect];
        [self.mapView setVisibleMapRect:targetRect edgePadding:UIEdgeInsetsMake(40, 40, 40, 40) animated:YES];
    } else {
        [self showMapCenterByStoreArea];
    }
}
#pragma mark - 获取所有overlays 的集合MKMapRect
- (MKMapRect)mapRectForOverlays:(NSArray *)overlays {
    if (HDIsArrayEmpty(overlays)) {
        return MKMapRectNull;
    }
    MKMapRect mapRect;
    id<MKOverlay> firstOverlay = overlays.firstObject;
    mapRect = firstOverlay.boundingMapRect;
    if (overlays.count == 1) {
        return mapRect;
    }
    for (int i = 1; i < overlays.count; i++) {
        id<MKOverlay> overlay = overlays[i];
        mapRect = MKMapRectUnion(mapRect, overlay.boundingMapRect);
    }
    return mapRect;
}
#pragma mark - 获取区域地址数据
- (void)loadStoreRegionListData {
    [self.view showloading];
    [self removePlaceHolder];
    @HDWeakify(self); //@"TN1152"
    [self.mapDTO queryStoreRegionListWithLongitude:self.addressModel.longitude latitude:self.addressModel.latitude success:^(TNDeliveryAreaMapModel *_Nonnull model) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.mapModel = model;
        //删除旧的
        [self.mapView removeOverlays:self.storeOversList];
        [self.mapView removeAnnotations:self.storeOversList];
        [self.storeOversList removeAllObjects];
        [self.renderArray removeAllObjects];
        if (!HDIsArrayEmpty(model.storeInfoDTOList)) {
            for (TNDeliveryAreaStoreInfoModel *infoModel in model.storeInfoDTOList) {
                [self addRenderer:infoModel];
            }
        }
        //更新中心点
        [self updateMapViewCenterAndLeavel];
        //显示底部提示
        [self showBottomTipView];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self loadStoreRegionListData];
        }];
    }];
}

#pragma mark - 获取默认收货地址
- (void)getDefaultAddress {
    @HDWeakify(self);
    [self.view showloading];
    [self.addressDTO getDefaultAddressSuccess:^(SAShoppingAddressModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (!HDIsObjectNil(rspModel)) {
            self.addressModel = rspModel;
            [self updateMapData];
        } else {
            //没有默认地址  选择定位
            [self getLocationAdress];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self getLocationAdress];
    }];
}
//获取定位地址
- (void)getLocationAdress {
    //    SAAddressModel *currentlyAddress = [SACacheManager.shared objectForKey:kCacheKeyUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    //    self.addressModel = [[SAShoppingAddressModel alloc] init];
    //    self.addressModel.latitude = currentlyAddress.lat;
    //    self.addressModel.longitude = currentlyAddress.lon;
    [self updateMapData];
}
//#pragma mark - 要求选择地址弹窗
//- (void)showAlertView {
//    //选择地址弹窗
//    TNAdressChangeTipsAlertConfig *config = [[TNAdressChangeTipsAlertConfig alloc] init];
//    config.alertType = TNAdressTipsAlertTypeChooseAdress;
//    config.title = TNLocalizedString(@"XDIeNGvw", @"请先选择收货地址，以便查看商品的配送范围");
//    @HDWeakify(self);
//    TNAlertAction *chooseAdressAction = [TNAlertAction actionWithTitle:TNLocalizedString(@"lps6Jl61", @"选择收货地址")
//                                                               handler:^(TNAlertAction *_Nonnull action) {
//                                                                   @HDStrongify(self);
//                                                                   [self clickAdressSelect];
//                                                               }];
//    TNAlertAction *backHomeAction = [TNAlertAction actionWithTitle:TNLocalizedString(@"5lKamBqi", @"返回")
//                                                           handler:^(TNAlertAction *_Nonnull action) {
//                                                               @HDStrongify(self);
//                                                               [self.navigationController popViewControllerAnimated:YES];
//                                                           }];
//    backHomeAction.textColor = HexColor(0x5D667F);
//    config.actions = @[ chooseAdressAction, backHomeAction ];
//    TNAdressChangeTipsAlertView *alertView = [TNAdressChangeTipsAlertView alertViewWithConfig:config];
//    [alertView show];
//}
#pragma mark -进入选择地址页面
- (void)clickAdressSelect {
    @HDWeakify(self);
    void (^cancelCallBack)(void) = ^{
        @HDStrongify(self);
        if (HDIsObjectNil(self.addressModel)) {
        }
    };
    void (^callback)(SAShoppingAddressModel *) = ^(SAShoppingAddressModel *addressModel) {
        @HDStrongify(self);
        self.addressModel = addressModel;
        [self updateMapData];
    };
    [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback": callback, @"cancelCallBack": cancelCallBack}];
}
#pragma mark - 显示提示视图
- (void)showBottomTipView {
    self.bottomTipView.hidden = NO;
    self.bottomTipView.model = self.mapModel;
    self.bottomTipView.adressName = self.addressModel.address;
    [self.view setNeedsUpdateConstraints];
}
#pragma mark - 显示店铺中心点
- (void)showMapCenterByStoreArea {
    if (!HDIsArrayEmpty(self.storeOversList)) {
        MKMapRect rect = [self mapRectForOverlays:self.storeOversList];
        rect = [self.mapView mapRectThatFits:rect];
        [self.mapView setVisibleMapRect:rect edgePadding:UIEdgeInsetsMake(15, 15, 15, 15) animated:YES];
    }
}

#pragma mark - 加入销售区域 地图绘制
- (void)addRenderer:(TNDeliveryAreaStoreInfoModel *)infoModel {
    if (infoModel.regionType == TNRegionTypeSpecifiedArea) {
        //指定区域
        NSInteger count = infoModel.storeLatLonDTOList.count;
        CLLocationCoordinate2D point[count];
        for (NSInteger i = 0; i < count; i++) {
            TNCoordinateModel *model = infoModel.storeLatLonDTOList[i];
            point[i] = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
        }
        MKPolygon *poly = [MKPolygon polygonWithCoordinates:point count:count];
        //        poly.title = infoModel.storeName;
        [poly hd_bindObjectWeakly:infoModel.specialId forKey:@"specialId"];
        [poly hd_bindObjectWeakly:infoModel.color forKey:@"fillColor"];
        [self.storeOversList addObject:poly];
        [self.mapView addOverlay:poly];
        //        [self.mapView addAnnotation:poly];
    } else if (infoModel.regionType == TNRegionTypeSpecifiedRange) {
        //指定范围
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([infoModel.latitude doubleValue], [infoModel.longitude doubleValue]);
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:coor radius:[infoModel.areaSize doubleValue] * 1000];
        //        circle.title = infoModel.storeName;
        [circle hd_bindObjectWeakly:infoModel.specialId forKey:@"specialId"];
        [circle hd_bindObjectWeakly:infoModel.color forKey:@"fillColor"];
        [self.storeOversList addObject:circle];
        [self.mapView addOverlay:circle];
        //        [self.mapView addAnnotation:circle];
    }
}
#pragma mark - WKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:SAAnnotation.class]) {
        MKAnnotationView *view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(MKAnnotationView.class)];
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(MKAnnotationView.class)];
        }
        view.annotation = annotation;
        view.image = [self getAnnotionImage];
        return view;
    }
    //不显示仓库地址  快消品3.4.2
    //    else if ([annotation isKindOfClass:MKPolygon.class] || [annotation isKindOfClass:MKCircle.class]) {
    //        TNTextAnnotationView *view = (TNTextAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(TNTextAnnotationView.class)];
    //        if (!view) {
    //            view = [[TNTextAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(TNTextAnnotationView.class)];
    //        }
    //        view.annotation = annotation;
    //        return view;
    //    }
    return nil;
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isMemberOfClass:MKPolygon.class]) {
        MKPolygon *polygon = (MKPolygon *)overlay;
        MKPolygonRenderer *render = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
        [self setRendererColorBy:polygon renderer:render];
        return render;
    } else if ([overlay isMemberOfClass:MKCircle.class]) {
        MKCircle *circle = (MKCircle *)overlay;
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithCircle:circle];
        [self setRendererColorBy:circle renderer:circleRender];
        return circleRender;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray<MKOverlayRenderer *> *)renderers {
    //如果 没有任何配送区域合适  默认选中一个店铺
    if (self.renderArray.count == self.mapModel.storeInfoDTOList.count) {
        if (!HDIsArrayEmpty(self.mapModel.storeInfoDTOList)) {
            __block BOOL hasDeleverValid = NO;
            [self.mapModel.storeInfoDTOList enumerateObjectsUsingBlock:^(TNDeliveryAreaStoreInfoModel *_Nonnull infoModel, NSUInteger idx, BOOL *_Nonnull stop) {
                if (infoModel.deliveryValid) {
                    hasDeleverValid = YES;
                    [self.renderArray enumerateObjectsUsingBlock:^(MKOverlayPathRenderer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        MKShape *overlay = obj.overlay;
                        NSString *speciaId = [overlay hd_getBoundObjectForKey:@"specialId"];
                        if ([infoModel.specialId isEqualToString:speciaId]) {
                            [self setRendererSelection:obj];
                            *stop = YES;
                        }
                    }];
                    *stop = YES;
                }
            }];
            if (!hasDeleverValid) {
                [self setRendererSelection:self.renderArray.firstObject];
            }
        }
    }
}

- (void)setRendererColorBy:(MKShape *)overlay renderer:(MKOverlayPathRenderer *)renderer {
    NSString *colorStr = [overlay hd_getBoundObjectForKey:@"fillColor"];
    UIColor *color;
    if (HDIsStringNotEmpty(colorStr)) {
        color = [UIColor hd_colorWithHexString:colorStr];
    } else {
        color = HDAppTheme.TinhNowColor.C1;
    }
    renderer.fillColor = [color colorWithAlphaComponent:0.3];
    renderer.strokeColor = [HDAppTheme.TinhNowColor.cFF2323 colorWithAlphaComponent:0.7];
    renderer.lineDashPattern = @[@2, @4];
    renderer.lineWidth = 2;
    //保存
    [self.renderArray addObject:renderer];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.span = mapView.region.span;
    region.center = centerCoordinate;
    self.region = region;
}

- (void)updateViewConstraints {
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (!self.bottomTipView.isHidden) {
            make.bottom.equalTo(self.bottomTipView.mas_top).offset(kRealWidth(20));
        } else {
            make.bottom.equalTo(self.view);
        }
    }];

    [self.oprateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(10));
        if (self.bottomTipView.isHidden) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-kRealWidth(120));
        } else {
            make.bottom.equalTo(self.watchDeliverAreaBtn.mas_top).offset(-kRealWidth(20));
        }
    }];
    if (!self.bottomTipView.isHidden) {
        [self.bottomTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
        }];
        [self.watchDeliverAreaBtn sizeToFit];
        [self.watchDeliverAreaBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-kRealWidth(10));
            make.height.mas_offset(kRealWidth(30));
            make.bottom.equalTo(self.bottomTipView.mas_top).offset(-kRealWidth(10));
        }];
    }
    [super updateViewConstraints];
}
- (void)setCurrentDeliverAreaModel:(TNDeliveryAreaStoreInfoModel *)currentDeliverAreaModel {
    _currentDeliverAreaModel = currentDeliverAreaModel;
    //没有地址就地址就不展示
    if (!HDIsObjectNil(self.addressModel) && HDIsStringNotEmpty(self.addressModel.address)) {
        self.bottomTipView.tips = currentDeliverAreaModel.addressTipsInfo;
    }
}
- (UIImage *)getAnnotionImage {
    NSString *imageName;
    if ([TNMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        imageName = @"tn_pin_adress_zh";
    } else if ([TNMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        imageName = @"tn_pin_adress_km";
    } else {
        imageName = @"tn_pin_adress_en";
    }
    return [UIImage imageNamed:imageName];
}
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
    }
    return _mapView;
}
/** @lazy addressDTO */
- (SAShoppingAddressDTO *)addressDTO {
    if (!_addressDTO) {
        _addressDTO = [[SAShoppingAddressDTO alloc] init];
    }
    return _addressDTO;
}
- (SAAnnotation *)storeAnnotation {
    if (!_storeAnnotation) {
        _storeAnnotation = SAAnnotation.new;
    }
    return _storeAnnotation;
}
/** @lazy mapDTO */
- (TNDeliveryAreaMapDTO *)mapDTO {
    if (!_mapDTO) {
        _mapDTO = [[TNDeliveryAreaMapDTO alloc] init];
    }
    return _mapDTO;
}

/** @lazy oprateView */
- (TNMapZoomOprateView *)oprateView {
    if (!_oprateView) {
        _oprateView = [[TNMapZoomOprateView alloc] init];
        @HDWeakify(self);
        _oprateView.enlargeClickCallBack = ^{
            @HDStrongify(self);
            CLLocationCoordinate2D center = self.region.center;
            MKCoordinateSpan span = MKCoordinateSpanMake(self.region.span.latitudeDelta * 0.5, self.region.span.longitudeDelta * 0.5);
            [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
        };
        _oprateView.smallClickCallBack = ^{
            @HDStrongify(self);
            CLLocationCoordinate2D center = self.region.center;
            MKCoordinateSpan span = MKCoordinateSpanMake(self.region.span.latitudeDelta * 2, self.region.span.longitudeDelta * 2);
            [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
        };
    }
    return _oprateView;
}

/** @lazy bottomTipView */
- (TNDeliveryAreaMapBottomTipView *)bottomTipView {
    if (!_bottomTipView) {
        _bottomTipView = [[TNDeliveryAreaMapBottomTipView alloc] init];
        _bottomTipView.hidden = YES;
        @HDWeakify(self);
        _bottomTipView.activityClickCallBack = ^{
            @HDStrongify(self);
            if (!HDIsObjectNil(self.currentDeliverAreaModel)) {
                if (self.isFromRedZoneSpeciaVC) {
                    //上个页面是红区专题  直接返回上个页面
                    !self.backRedSpecialCallBack ?: self.backRedSpecialCallBack(self.currentDeliverAreaModel.specialId, self.addressModel, self.currentDeliverAreaModel.deliveryValid);
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    //进入新的红区专题
                    [SAWindowManager openUrl:@"SuperApp://TinhNow/redZoneSpecialActivity" withParameters:@{
                        @"activityNo": self.currentDeliverAreaModel.specialId,
                        @"addressModel": self.addressModel,
                        @"type": @(1),
                        @"deliveryValid": @(self.currentDeliverAreaModel.deliveryValid)
                    }];
                }
            }
        };
        _bottomTipView.adressClickCallBack = ^{
            @HDStrongify(self);
            [self clickAdressSelect];
        };
        _bottomTipView.storeTagClickCallBack = ^(TNDeliveryAreaStoreInfoModel *_Nonnull model) {
            @HDStrongify(self);
            __block MKOverlayPathRenderer *targetRenderer;
            [self.renderArray enumerateObjectsUsingBlock:^(MKOverlayPathRenderer *_Nonnull renderer, NSUInteger idx, BOOL *_Nonnull stop) {
                MKShape *overlay = renderer.overlay;
                NSString *speciaId = [overlay hd_getBoundObjectForKey:@"specialId"];
                if ([model.specialId isEqualToString:speciaId]) {
                    targetRenderer = renderer;
                    *stop = YES;
                }
            }];
            [self setRendererSelection:targetRenderer];
        };
        _bottomTipView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
        };
    }
    return _bottomTipView;
}
/** @lazy watchDeliverAreaBtn */
- (HDUIButton *)watchDeliverAreaBtn {
    if (!_watchDeliverAreaBtn) {
        _watchDeliverAreaBtn = [[HDUIButton alloc] init];
        _watchDeliverAreaBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [_watchDeliverAreaBtn setTitle:TNLocalizedString(@"hwwfhcdv", @"配送范围") forState:UIControlStateNormal];
        [_watchDeliverAreaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_watchDeliverAreaBtn setImage:[UIImage imageNamed:@"tn_deliver_map_send_area"] forState:UIControlStateNormal];
        _watchDeliverAreaBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:10];
        _watchDeliverAreaBtn.spacingBetweenImageAndTitle = 5;
        _watchDeliverAreaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _watchDeliverAreaBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        _watchDeliverAreaBtn.layer.cornerRadius = 15;
        _watchDeliverAreaBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _watchDeliverAreaBtn.layer.shadowColor = HexColor(0xB95F00).CGColor;
        @HDWeakify(self);
        [_watchDeliverAreaBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self showMapCenterByStoreArea];
        }];
    }
    return _watchDeliverAreaBtn;
}
/** @lazy storeOversList */
- (NSMutableArray *)storeOversList {
    if (!_storeOversList) {
        _storeOversList = [NSMutableArray array];
    }
    return _storeOversList;
}
/** @lazy renderArray */
- (NSMutableArray<MKOverlayPathRenderer *> *)renderArray {
    if (!_renderArray) {
        _renderArray = [NSMutableArray array];
    }
    return _renderArray;
}
@end

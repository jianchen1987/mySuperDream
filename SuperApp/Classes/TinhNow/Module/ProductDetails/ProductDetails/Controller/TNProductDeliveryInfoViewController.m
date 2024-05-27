//
//  TNProductDeliveryInfoViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDeliveryInfoViewController.h"
#import "SATableView.h"
#import "TNProductDeliveryDescCell.h"
#import "TNProductDeliveryShipCell.h"
#import "TNProductDeliveryIntroductionCell.h"
#import "TNProductDTO.h"
#import "TNProductDetailsRspModel.h"
#import "TNDeliverInfoModel.h"
#import "TNAdaptImagesCell.h"
#import "TNDeliverFlowModel.h"


@interface TNProductDeliveryInfoViewController () <UITableViewDelegate, UITableViewDataSource>
/// tableView
@property (strong, nonatomic) SATableView *tableView;
/// 数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 配送说明
@property (strong, nonatomic) HDTableViewSectionModel *deliveryDescSectionModel;
/// 运费
@property (strong, nonatomic) HDTableViewSectionModel *shipSectionModel;
/// 配送文本和视频介绍
@property (strong, nonatomic) HDTableViewSectionModel *deliveryInfoSectionModel;
/// 配送图片绍
@property (strong, nonatomic) HDTableViewSectionModel *imgsSectionModel;
/// dto
@property (strong, nonatomic) TNProductDTO *productDto;
/// 店铺ID
@property (nonatomic, copy) NSString *storeId;
/// 配送范围信息
@property (nonatomic, copy) NSString *saleRegionStr;
/// 配送数据
@property (strong, nonatomic) TNDeliverInfoModel *infoModel;

@end


@implementation TNProductDeliveryInfoViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.storeId = [parameters objectForKey:@"storeId"];
    self.saleRegionStr = [parameters objectForKey:@"region"];
    return self;
}
- (void)hd_setupViews {
    [self.view addSubview:self.tableView];

    [self loadData];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"yQCmXdeH", @"配送信息");
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
#pragma mark - 获取数据
- (void)loadData {
    [self.view showloading];
    @HDWeakify(self);
    [self.productDto queryFreightDataWithStoreId:self.storeId Success:^(TNDeliverInfoModel *_Nonnull model) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.infoModel = model;
        self.infoModel.contentText = self.saleRegionStr;
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:@[self.deliveryDescSectionModel, self.shipSectionModel, self.deliveryInfoSectionModel]];
        //如果有图文  就显示图文
        if (!HDIsArrayEmpty(self.infoModel.deliverInfoImages)) {
            [self.dataSource addObject:self.imgsSectionModel];
        }
        [self.tableView successGetNewDataWithNoMoreData:YES];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self.tableView failGetNewData];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (sectionModel == self.deliveryDescSectionModel) {
        TNProductDeliveryDescCell *cell = [TNProductDeliveryDescCell cellWithTableView:self.tableView];
        cell.model = self.infoModel.flowModel;
        return cell;
    } else if (sectionModel == self.shipSectionModel) {
        TNProductDeliveryShipCell *cell = [TNProductDeliveryShipCell cellWithTableView:self.tableView];
        cell.infoModel = self.infoModel;
        return cell;
    } else if (sectionModel == self.deliveryInfoSectionModel) {
        TNProductDeliveryIntroductionCell *cell = [TNProductDeliveryIntroductionCell cellWithTableView:self.tableView];
        cell.infoModel = self.infoModel;
        return cell;
    } else if (sectionModel == self.imgsSectionModel) {
        TNAdaptImagesCell *cell = [TNAdaptImagesCell cellWithTableView:self.tableView];
        cell.images = self.infoModel.deliverInfoImages;
        @HDWeakify(self);
        cell.getRealImageSizeCallBack = ^{
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel == self.imgsSectionModel) {
        //图片的如果又有视频  就要分割
        if (!HDIsObjectNil(self.infoModel.overseaVideo) && HDIsStringNotEmpty(self.infoModel.overseaVideo.coverUrl)) {
            return kRealWidth(10);
        } else {
            return 0.01;
        }
    }
    return kRealWidth(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HexColor(0xF5F7FA);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/** @lazy deliveryDescSectionModel */
- (HDTableViewSectionModel *)deliveryDescSectionModel {
    if (!_deliveryDescSectionModel) {
        _deliveryDescSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _deliveryDescSectionModel;
}
/** @lazy shipSectionModel */
- (HDTableViewSectionModel *)shipSectionModel {
    if (!_shipSectionModel) {
        _shipSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _shipSectionModel;
}
/** @lazy deliveryDescModel */
- (HDTableViewSectionModel *)deliveryInfoSectionModel {
    if (!_deliveryInfoSectionModel) {
        _deliveryInfoSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _deliveryInfoSectionModel;
}
/** @lazy imgsSectionModel */
- (HDTableViewSectionModel *)imgsSectionModel {
    if (!_imgsSectionModel) {
        _imgsSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _imgsSectionModel;
}
/** @lazy productDto */
- (TNProductDTO *)productDto {
    if (!_productDto) {
        _productDto = [[TNProductDTO alloc] init];
    }
    return _productDto;
}
@end

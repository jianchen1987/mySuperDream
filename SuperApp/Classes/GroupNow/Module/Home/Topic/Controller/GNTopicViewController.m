//
//  GNTopicViewController.m
//  SuperApp
//
//  Created by wmz on 2022/2/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNTopicViewController.h"
#import "GNCollectionView.h"
#import "GNTableView.h"
#import "GNTopicProductCell.h"
#import "GNTopicViewModel.h"
#import "HDCollectionViewVerticalLayout.h"


@interface GNTopicViewController () <GNTableViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// viewModel
@property (nonatomic, strong) GNTopicViewModel *viewModel;
/// productView
@property (nonatomic, strong) GNCollectionView *productView;
/// storeView
@property (nonatomic, strong) GNTableView *storeView;
/// topicPageNo
@property (nonatomic, strong) NSString *topicPageNo;
/// 专题图片
@property (nonatomic, strong) UIImageView *topicIV;
/// pageNum
@property (nonatomic, assign) NSInteger pageNum;
/// 占位
@property (nonatomic, strong) UIViewPlaceholderViewModel *placeholderViewModel;
/// storeArray
@property (nonatomic, strong) NSMutableArray *storeArray;
/// productArray
@property (nonatomic, strong) NSMutableArray *productArray;

@end


@implementation GNTopicViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.topicPageNo = parameters[@"activityNo"];
    }
    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.topicIV];
    [self.view addSubview:self.productView];
    [self.view addSubview:self.storeView];
    self.topicIV.hidden = YES;
    self.productView.frame = self.storeView.frame = CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight - kNavigationBarH);
    self.storeView.delegate = self.storeView.provider;
    self.storeView.dataSource = self.storeView.provider;

    @HDWeakify(self);
    self.productView.tappedRefreshBtnHandler = self.productView.requestNewDataHandler = self.storeView.tappedRefreshBtnHandler = self.storeView.requestNewDataHandler = ^{
        @HDStrongify(self);
        self.pageNum = 1;
        [self gn_getNewData];
    };
    self.productView.requestMoreDataHandler = self.storeView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        self.pageNum += 1;
        [self gn_getNewData];
    };
}

- (void)gn_getNewData {
    @HDWeakify(self);
    [self.viewModel getStoreTopicWithTopicCode:self.topicPageNo pageNum:self.pageNum completion:^(GNTopicModel *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self);
        self.topicIV.hidden = NO;
        self.storeView.GNdelegate = self;
        [self.view hd_removePlaceholderView];
        if (error) {
            if (self.pageNum == 1) {
                self.productView.hidden = YES;
                self.storeView.hidden = YES;
                [self.view hd_showPlaceholderViewWithModel:self.placeholderViewModel];
            }
        } else {
            if (self.pageNum == 1) {
                self.boldTitle = rspModel.name.desc;
                self.productView.hidden = YES;
                self.storeView.hidden = YES;

                if ([rspModel.type isEqualToString:@"gStore"]) {
                    self.storeArray = [NSMutableArray arrayWithArray:rspModel.stores];
                    self.storeView.hidden = NO;
                    [self.storeView addSubview:self.topicIV];
                    [self.storeView reloadData:rspModel.stores.count < 20];
                } else if ([rspModel.type isEqualToString:@"gProduct"]) {
                    self.productArray = [NSMutableArray arrayWithArray:rspModel.products];
                    self.productView.hidden = NO;
                    [self.productView addSubview:self.topicIV];
                    [self.productView reloadNewData:rspModel.products.count < 20];
                }

                [self.topicIV sd_setImageWithURL:[NSURL URLWithString:rspModel.image.desc]
                                placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, kRealHeight(130)) logoWidth:kRealHeight(65)]
                                       completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                           CGFloat height = 0;
                                           if (!error) {
                                               height = kScreenWidth / (image.size.width / image.size.height);
                                           }

                                           if ([rspModel.type isEqualToString:@"gStore"]) {
                                               self.topicIV.frame = CGRectMake(0, -height, kScreenWidth, height);
                                           } else if ([rspModel.type isEqualToString:@"gProduct"]) {
                                               self.topicIV.frame = CGRectMake(0, -height, kScreenWidth, height);
                                           } else {
                                               self.topicIV.frame = CGRectMake(0, kNavigationBarH, kScreenWidth, height);
                                           }
                                           if (height) {
                                               self.storeView.contentInset = UIEdgeInsetsMake(height, 0, kiPhoneXSeriesSafeBottomHeight, 0);
                                               self.productView.contentInset = UIEdgeInsetsMake(height, 0, kiPhoneXSeriesSafeBottomHeight, 0);
                                               self.storeView.mj_header.ignoredScrollViewContentInsetTop = height;
                                               self.productView.mj_header.ignoredScrollViewContentInsetTop = height;
                                               self.storeView.contentOffset = CGPointMake(0, -height);
                                               self.productView.contentOffset = CGPointMake(0, -height);
                                           }
                                       }];
            } else {
                if ([rspModel.type isEqualToString:@"gStore"]) {
                    [self.storeArray addObjectsFromArray:rspModel.stores];
                    [self.storeView reloadData:rspModel.stores.count < 20];
                } else if ([rspModel.type isEqualToString:@"gProduct"]) {
                    [self.productArray addObjectsFromArray:rspModel.products];
                    [self.productView reloadMoreData:rspModel.products.count < 20];
                }
            }
        }
    }];
}

#pragma - mark GNTableViewProtocol
- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return self.storeArray;
}

#pragma - mark UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNTopicProductCell *cell = [GNTopicProductCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    GNProductModel *model = self.productArray[indexPath.row];
    model.indexPath = indexPath;
    [cell setGNModel:model];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(10), kRealWidth(15));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNProductModel *model = self.productArray[indexPath.row];
    return CGSizeMake(floor((kScreenWidth - kRealWidth(40)) / 2.0), [model itemHeight]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(10);
}

#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productArray.count;
}

- (GNTopicViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = GNTopicViewModel.new;
    }
    return _viewModel;
}

- (UIImageView *)topicIV {
    if (!_topicIV) {
        _topicIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealHeight(130))];
    }
    return _topicIV;
}

- (GNTableView *)storeView {
    if (!_storeView) {
        _storeView = [[GNTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _storeView.needRefreshHeader = YES;
        _storeView.needRefreshFooter = YES;
    }
    return _storeView;
}

- (GNCollectionView *)productView {
    if (!_productView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        _productView = [[GNCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _productView.needRefreshHeader = YES;
        _productView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        _productView.delegate = self;
        _productView.dataSource = self;
        _productView.needRefreshFooter = YES;
        MJRefreshAutoStateFooter *foot = (MJRefreshAutoStateFooter *)_productView.mj_footer;
        [foot setTitle:@"——  END LINE  ——" forState:MJRefreshStateNoMoreData];
    }
    return _productView;
}

- (UIViewPlaceholderViewModel *)placeholderViewModel {
    if (!_placeholderViewModel) {
        @HDWeakify(self) UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.image = @"placeholder_network_error";
        model.title = SALocalizedString(@"network_error", @"网络开小差啦");
        model.needRefreshBtn = YES;
        model.refreshBtnTitle = SALocalizedString(@"refresh", @"刷新");
        model.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self) self.pageNum = 1;
            [self.view hd_removePlaceholderView];
            self.storeView.delegate = self.storeView.provider;
            self.storeView.dataSource = self.storeView.provider;
            self.storeView.hidden = NO;
            [self gn_getNewData];
        };
        _placeholderViewModel = model;
    }
    return _placeholderViewModel;
}

- (NSInteger)pageNum {
    if (!_pageNum) {
        _pageNum = 1;
    }
    return _pageNum;
}

- (NSMutableArray *)productArray {
    if (!_productArray) {
        _productArray = NSMutableArray.new;
    }
    return _productArray;
}

- (NSMutableArray *)storeArray {
    if (!_storeArray) {
        _storeArray = NSMutableArray.new;
    }
    return _storeArray;
}

- (BOOL)needLogin {
    return NO;
}

- (BOOL)needClose {
    return YES;
}

@end

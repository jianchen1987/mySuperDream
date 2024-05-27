//
//  SACMSWaterfallViewController+waterfall.m
//  SuperApp
//
//  Created by seeu on 2023/11/29.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallViewController+waterfall.h"
#import <HDKitCore/HDAssociatedObjectHelper.h>
#import "SACMSPageViewConfig.h"
#import "SACMSWaterfallPageViewConfig.h"
#import "SAAddressModel.h"
#import "SACMSWaterfallCategoryCollectionReusableView.h"
#import "SACMSWaterfallCategoryTitleRspModel.h"
#import "SACMSWaterfallDataSourceRspModel.h"
#import "SANoDataCellModel.h"
#import "SACMSCollectionViewCell.h"
#import "SACMSUserGeneratedContentCollectionViewCell.h"
#import "SACMSWaterfallCategoryTitleRspModel.h"
#import "SACMSWaterfallCollectionViewCell.h"
#import "SACMSWaterfallRecommandCollectionViewCell.h"
#import "SANoDataCollectionViewCell.h"
#import "LKDataRecord.h"


#define kWaterfallCellMaxWidth ((kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right - kRealWidth(7)) / 2.0)


@implementation SACMSWaterfallViewController (waterfall)

HDSynthesizeNSUIntegerProperty(currentPage, setCurrentPage);
HDSynthesizeIdStrongProperty(waterfallConfig, setWaterfallConfig);
HDSynthesizeIdStrongProperty(categoryTitleViewConfig, setCategoryTitleViewConfig);
HDSynthesizeIdStrongProperty(currentCategory, setCurrentCategory);

#pragma mark - public methods
- (void)generateWaterfallTemplateWithPageConfig:(SACMSPageViewConfig *)pageConfig {
    self.collectionView.needRefreshFooter = YES;

    dispatch_group_t task = dispatch_group_create();
    // 瀑布流
    SACMSWaterfallPageViewConfig *waterfallConfig = [SACMSWaterfallPageViewConfig yy_modelWithDictionary:pageConfig.getPageTemplateContent];

    dispatch_group_enter(task);
    if (waterfallConfig && HDIsStringNotEmpty(waterfallConfig.categoryDataSource)) {
        // 配置标题栏
        [self generateWaterfallCategoryViewWithConfig:waterfallConfig finish:^{
            dispatch_group_leave(task);
        }];
    } else {
        self.categoryTitleViewConfig = nil;
        dispatch_group_leave(task);
    }

    __block BOOL noMoreData = YES;

    dispatch_group_enter(task);
    if (waterfallConfig && HDIsStringNotEmpty(waterfallConfig.waterfallDataSource)) {
        [self generateWaterfallSectionWithConfig:waterfallConfig finish:^(BOOL hasNextPage) {
            noMoreData = !hasNextPage;
            dispatch_group_leave(task);
        }];
    } else {
        self.waterfallConfig = nil;
        self.waterfallSection.list = @[];
        dispatch_group_leave(task);
    }

    dispatch_group_notify(task, dispatch_get_main_queue(), ^{
        //配置插件
        [self.collectionView successGetNewDataWithNoMoreData:noMoreData];
    });
}

- (void)waterfallTemplateLoadMoreData {
    @HDWeakify(self);
    [self getWaterfallDataWithPage:++self.currentPage category:self.currentCategory.associatedValue finish:^(BOOL hasNextPage) {
        @HDStrongify(self);
        [self.collectionView successLoadMoreDataWithNoMoreData:!hasNextPage];
    }];
}

#pragma mark - over write
- (UICollectionReusableView *)waterfallTemplateCollectionView:(UICollectionView *)collectionView
                            viewForSupplementaryElementOfKind:(NSString *)kind
                                                  atIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section >= self.dataSource.count) {
        return nil;
    }
    id sectionModel = self.dataSource[indexPath.section];
    
    if ([sectionModel isEqual:self.waterfallSection] && self.categoryTitleViewConfig && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SACMSWaterfallCategoryCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                withReuseIdentifier:NSStringFromClass(SACMSWaterfallCategoryCollectionReusableView.class)
                                                                                                       forIndexPath:indexPath];
        if (!view) {
            view = [[SACMSWaterfallCategoryCollectionReusableView alloc] init];
        }
        view.model = self.categoryTitleViewConfig;
        @HDWeakify(self);
        view.clickedOnCategory = ^(SACMSCategoryTitleModel *_Nonnull model, SACMSWaterfallCategoryCollectionReusableView *view) {
            @HDStrongify(self);
            [self showloading];
            self.currentCategory = model;
            [self getWaterfallDataWithPage:1 category:self.currentCategory.associatedValue finish:^(BOOL hasNextPage) {
                [self dismissLoading];
                [self.collectionView successGetNewDataWithNoMoreData:!hasNextPage scrollToTop:NO];

                UICollectionViewLayoutAttributes *layouts = nil;
                if (self.waterfallSection.list.count) {
                    layouts = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.dataSource indexOfObject:self.waterfallSection]]];
                } else {
                    layouts = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.dataSource indexOfObject:self.noDataSection]]];
                }
                if (!HDIsObjectNil(layouts)) {
                    [self.collectionView setContentOffset:CGPointMake(0, layouts.frame.origin.y - kRealHeight(50) - kRealHeight(8)) animated:YES];
                } else {
                    [self.collectionView setContentOffset:CGPointMake(0, view.frame.origin.y) animated:YES];
                }
            }];
        };
        return view;

    } else {
        return nil;
    }
}

- (UICollectionViewCell *)waterfallTemplateCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *tmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    
    if(indexPath.section >= self.dataSource.count) {
        return tmp;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    
    if (indexPath.row >= sectionModel.list.count) {
        return tmp;
    }

    id model = sectionModel.list[indexPath.row];

    if ([model isKindOfClass:SACMSWaterfallCellModel.class]) { // 瀑布流cell
        SACMSWaterfallCellModel *trueMoel = (SACMSWaterfallCellModel *)model;

        if (trueMoel.cellType == SACMSWaterfallCellTypeHomeRecommand) {
            SACMSWaterfallRecommandCollectionViewCell *cell = [SACMSWaterfallRecommandCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                                     identifier:NSStringFromClass(SACMSWaterfallRecommandCollectionViewCell.class)];
            cell.model = trueMoel;
            @HDWeakify(self);
            cell.cellDidDeletedHandler = ^(SACMSWaterfallCellModel *_Nonnull model) {
                @HDStrongify(self);
                NSInteger row = [self.waterfallSection.list indexOfObject:model];
                NSInteger section = [self.dataSource indexOfObject:self.waterfallSection];

                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:self.waterfallSection.list];
                [tmp removeObject:model];
                self.waterfallSection.list = [NSArray arrayWithArray:tmp];
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]]];
            };

            return cell;

        } else {
            SACMSWaterfallCollectionViewCell *cell = [SACMSWaterfallCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                   identifier:NSStringFromClass(SACMSWaterfallCollectionViewCell.class)];
            cell.model = trueMoel;
            @HDWeakify(self);
            cell.cellDidDeletedHandler = ^(SACMSWaterfallCellModel *_Nonnull model) {
                @HDStrongify(self);
                NSInteger row = [self.waterfallSection.list indexOfObject:model];
                NSInteger section = [self.dataSource indexOfObject:self.waterfallSection];

                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:self.waterfallSection.list];
                [tmp removeObject:model];
                self.waterfallSection.list = [NSArray arrayWithArray:tmp];
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]]];
            };
            return cell;
        }
    } else if ([model isKindOfClass:SANoDataCellModel.class]) { // 没有数据的占位
        SANoDataCellModel *trueModel = (SANoDataCellModel *)model;
        SANoDataCollectionViewCell *cell = [SANoDataCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SANoDataCollectionViewCell.class)];
        cell.model = trueModel;
        return cell;

    } else if ([model isKindOfClass:SACMSPlaceholderCollectionViewCellModel.class]) { // 瀑布流占位图
        SACMSPlaceholderCollectionViewCell *cell = [SACMSPlaceholderCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                   identifier:NSStringFromClass(SACMSPlaceholderCollectionViewCell.class)];
        return cell;

    } else if ([model isKindOfClass:SACMSWaterfallSkeletonCollectionViewCellModel.class]) { // 瀑布流加载骨架
        SACMSWaterfallSkeletonCollectionViewCell *cell = [SACMSWaterfallSkeletonCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                               identifier:NSStringFromClass(SACMSWaterfallSkeletonCollectionViewCell.class)];
        SACMSWaterfallSkeletonCollectionViewCellModel *trueModel = (SACMSWaterfallSkeletonCollectionViewCellModel *)model;
        cell.model = trueModel;
        return cell;
    } else {
        return tmp;
    }
}

- (void)waterfallTemplateCollectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:SACMSWaterfallSkeletonCollectionViewCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}

- (CGSize)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section >= self.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    
    if (indexPath.row >= sectionModel.list.count) {
        HDLog(@"数组越界：section %zd, row:%zd", indexPath.section, indexPath.row);
        return CGSizeZero;
    }

    id model = sectionModel.list[indexPath.row];

    if ([model isKindOfClass:SACMSWaterfallCellModel.class]) {
        SACMSWaterfallCellModel *trueModel = (SACMSWaterfallCellModel *)model;
        return CGSizeMake(kWaterfallCellMaxWidth, [trueModel heightWithWidth:kWaterfallCellMaxWidth]);

    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        return CGSizeMake(kScreenWidth, CGRectGetHeight(self.collectionView.frame) - kRealHeight(50));

    } else if ([model isKindOfClass:SACMSPlaceholderCollectionViewCellModel.class]) {
        return CGSizeMake(kWaterfallCellMaxWidth, kRealHeight(200));

    } else if ([model isKindOfClass:SACMSWaterfallSkeletonCollectionViewCellModel.class]) {
        SACMSWaterfallSkeletonCollectionViewCellModel *trueModel = (SACMSWaterfallSkeletonCollectionViewCellModel *)model;
        return CGSizeMake(kWaterfallCellMaxWidth, trueModel.cellHeight);

    } else {
        return CGSizeZero;
    }
}

- (CGSize)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if(section >= self.dataSource.count) {
    return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    
    if ([sectionModel isEqual:self.waterfallSection] && self.categoryTitleViewConfig) {
        return CGSizeMake(kScreenWidth, kRealHeight(50));

    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if(section >= self.dataSource.count) {
        return UIEdgeInsetsZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if([sectionModel isEqual:self.waterfallSection]) {
        return UIEdgeInsetsMake(kRealHeight(8), HDAppTheme.value.padding.left, kRealWidth(8), HDAppTheme.value.padding.right);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGFloat)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if(section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if([sectionModel isEqual:self.waterfallSection]) {
        return kRealWidth(8);
    } else {
        return 0;
    }
}

- (CGFloat)waterfallTemplateCollectionView:(UICollectionView *)collectionView
                                    layout:(UICollectionViewLayout *)collectionViewLayout
  minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if([sectionModel isEqual:self.waterfallSection]) {
        return kRealWidth(7);
    } else {
        return 0;
    }
}

- (NSInteger)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if(section >= self.dataSource.count) {
        return 1;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if([sectionModel isEqual:self.waterfallSection]) {
        return 2;
    } else {
        return 1;
    }
}

- (void)waterfallTemplateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return;
    }

    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if(indexPath.row >= sectionModel.list.count) {
        return;
    }
    
    id model = sectionModel.list[indexPath.row];

    if ([model isKindOfClass:SACMSWaterfallCellModel.class]) {
        SACMSWaterfallCellModel *trueModel = (SACMSWaterfallCellModel *)model;
        if (HDIsStringNotEmpty(trueModel.contentLink)) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
            dic[@"associatedId"] = trueModel.contentNo;
            if (HDIsObjectNil(self.categoryTitleViewConfig)) {
                dic[@"source"] = [NSString stringWithFormat:@"%@.waterfall.node@%zd", self.pageConfig.pageName, indexPath.row];
            } else {
                __block NSUInteger categoryIdx = 0;
                [self.categoryTitleViewConfig.titles enumerateObjectsUsingBlock:^(SACMSCategoryTitleModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([obj.associatedValue isEqualToString:self.currentCategory.associatedValue]) {
                        categoryIdx = idx;
                        *stop = YES;
                    }
                }];

                dic[@"source"] = [NSString stringWithFormat:@"%@.waterfall.%@@%zd.node@%zd",
                                                            self.pageConfig.pageName,
                                                            HDIsObjectNil(self.currentCategory) ? self.categoryTitleViewConfig.titles.firstObject.title.desc : self.currentCategory.title.desc,
                                                            categoryIdx,
                                                            indexPath.row];
            }

            if (self.isRedirectionParams && HDIsStringNotEmpty(self.taskId)) {
                // 透传任务ID
                dic[@"taskId"] = self.taskId;
            }

            [SAWindowManager openUrl:[trueModel.contentLink hd_urlAppendParams:dic] withParameters:nil];
        }
        [self markContentReadedWithCellModel:trueModel];

        [LKDataRecord.shared traceEvent:@"click_pv_waterfall_cell" name:@"" parameters:@{
            @"contentNo": trueModel.contentNo,
            @"link": trueModel.contentLink

        }
                                    SPM:[LKSPM SPMWithPage:self.pageConfig.pageName area:@"" node:[NSString stringWithFormat:@"waterfall@%zd", indexPath.row]]];
    }
}

#pragma mark - private methods

/// 配置瀑布流分类header
- (void)generateWaterfallCategoryViewWithConfig:(SACMSWaterfallPageViewConfig *)config finish:(void (^)(void))finish {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = config.categoryDataSource;
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    if (!HDIsObjectNil(self.currentAddress) && HDIsStringNotEmpty(self.currentAddress.districtCode)) {
        params[@"cityCode"] = self.currentAddress.districtCode;
    }

    if (!HDIsObjectNil(self.currentAddress)) {
        params[@"latitude"] = self.currentAddress.lat.stringValue;
        params[@"longitude"] = self.currentAddress.lon.stringValue;
    }

    request.requestParameter = params;
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        SACMSWaterfallCategoryTitleRspModel *rsp = [SACMSWaterfallCategoryTitleRspModel yy_modelWithJSON:rspModel.data];
        if (rsp.list.count > 0) {
            self.categoryTitleViewConfig = [[SACMSWaterfallCategoryCollectionReusableViewModel alloc] init];
            self.categoryTitleViewConfig.tintColor = config.categoryColor;
            self.categoryTitleViewConfig.fontSize = config.categoryFont;
            self.categoryTitleViewConfig.titles = [rsp.list copy];
        } else {
            self.categoryTitleViewConfig = nil;
        }

        !finish ?: finish();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !finish ?: finish();
    }];
}

- (void)generateWaterfallSectionWithConfig:(SACMSWaterfallPageViewConfig *)config finish:(void (^)(BOOL hasNextPage))finish {
    self.waterfallConfig = config;
    [self getWaterfallDataWithPage:1 category:self.currentCategory.associatedValue finish:finish];
}

- (void)getWaterfallDataWithPage:(NSUInteger)page category:(NSString *_Nullable)category finish:(void (^)(BOOL hasNextPage))finish {
    if (HDIsObjectNil(self.waterfallConfig)) {
        !finish ?: finish(NO);
        return;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = self.waterfallConfig.waterfallDataSource;
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = @(page);
    params[@"pageSize"] = @(10);
    if (HDIsStringNotEmpty(category)) {
        params[@"contentCategory"] = category;
    }
    params[@"contentLanguage"] = SAMultiLanguageManager.currentLanguage;


    if (!HDIsObjectNil(self.currentAddress)) {
        params[@"latitude"] = self.currentAddress.lat.stringValue;
        params[@"longitude"] = self.currentAddress.lon.stringValue;
        params[@"areaCode"] = HDIsStringNotEmpty(self.currentAddress.districtCode) ? self.currentAddress.districtCode : @"855120000";
    }

    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }

    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        SACMSWaterfallDataSourceRspModel *rsp = [SACMSWaterfallDataSourceRspModel yy_modelWithJSON:rspModel.data];
        self.currentPage = page;

        NSMutableArray<SAModel *> *tmp = [[NSMutableArray alloc] initWithCapacity:10];
        [rsp.list enumerateObjectsUsingBlock:^(SACMSWaterfallCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.cellWidth = kWaterfallCellMaxWidth;
            obj.taskId = [self.taskId copy];
        }];
        if (1 == page) {
            if (rsp.list.count == 0) {
                self.collectionView.needRefreshFooter = NO;
                self.noDataSection.list = @[SANoDataCellModel.new];
            } else {
                self.collectionView.needRefreshFooter = YES;
                self.noDataSection.list = @[];
            }

            [tmp addObjectsFromArray:rsp.list];

        } else {
            [tmp addObjectsFromArray:[self.waterfallSection.list hd_filterWithBlock:^BOOL(id _Nonnull item) {
                     return ![item isKindOfClass:SACMSPlaceholderCollectionViewCellModel.class] && ![item isKindOfClass:SACMSWaterfallSkeletonCollectionViewCellModel.class];
                 }]];
            [tmp addObjectsFromArray:rsp.list];
        }
        // 为了标题置顶，动态添加占位cell
        if (!HDIsObjectNil(self.categoryTitleViewConfig) && tmp.count < 8 && tmp.count > 0) {
            for (NSUInteger i = tmp.count; i < 8; i++) {
                [tmp addObject:SACMSPlaceholderCollectionViewCellModel.new];
            }
        }

        self.waterfallSection.list = tmp;

        !finish ?: finish(rsp.hasNextPage);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !finish ?: finish(NO);
    }];
}

- (void)markContentReadedWithCellModel:(SACMSWaterfallCellModel *)model {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/discovery/view/log/save.do";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }
    params[@"bizType"] = HDIsStringNotEmpty(model.bizType) ? model.bizType : @"discovery";
    params[@"bizId"] = model.contentNo;

    request.requestParameter = params;
    [request startWithSuccess:nil failure:nil];
}


@end

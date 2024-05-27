//
//  TNKingKongAreaAppGroupView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNKingKongAreaAppGroupView.h"
#import "LKDataRecord.h"
#import "SAAppFunctionModel.h"
#import "SATalkingData.h"

NSString *const kTNFunctionThrottleKeyShowKingKongAreaNewFunctionGuide = @"tinhnow.functionThrottle.key.showFunctionGuide";


@interface TNKingKongAreaAppGroupView ()
@property (nonatomic, strong) HDGridView *gridView; ///< gridView
@end


@implementation TNKingKongAreaAppGroupView
- (void)hd_setupViews {
    [self.contentView addSubview:self.gridView];
}

- (void)updateConstraints {
    [self.gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

#pragma mark - public methods
- (void)reloadData {
    [self.gridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (id model in self.dataSource) {
        TNKingKongAreaAppView *cell = TNKingKongAreaAppView.new;
        if ([model isKindOfClass:SAAppFunctionModel.class]) {
            cell.model = (SAAppFunctionModel *)model;
        } else if ([model isKindOfClass:SAKingKongAreaItemConfig.class]) {
            cell.config = (SAKingKongAreaItemConfig *)model;
        }
        UITapGestureRecognizer *recoginer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCellHandler:)];
        [cell addGestureRecognizer:recoginer];

        [self.gridView addSubview:cell];
    }
}

#pragma mark - event response
- (void)clickedCellHandler:(UITapGestureRecognizer *)recoginer {
    // 取消显示引导的函数节流
    dispatch_throttle_cancel(kTNFunctionThrottleKeyShowKingKongAreaNewFunctionGuide);

    TNKingKongAreaAppView *cell = (TNKingKongAreaAppView *)recoginer.view;
    id model = cell.currentConfig;
    if ([model isKindOfClass:SAAppFunctionModel.class]) {
        SAAppFunctionModel *functionModel = model;
        NSString *url = [NSString stringWithFormat:@"%@://%@", functionModel.routeScheme, functionModel.routePath];
        if ([SAWindowManager canOpenURL:url]) {
            [SAWindowManager openUrl:url withParameters:functionModel.routeParams];
        } else {
            !self.canNotOpenRouteHandler ?: self.canNotOpenRouteHandler(url);
        }

    } else if ([model isKindOfClass:SAKingKongAreaItemConfig.class]) {
        SAKingKongAreaItemConfig *config = model;
        NSString *url = config.url;
        if ([SAWindowManager canOpenURL:url]) {
            [SAWindowManager openUrl:url withParameters:nil];
            [SATalkingData trackEvent:@"TinhNow_首页_功能点击" label:config.name.desc parameters:@{@"排序": @(config.index), @"来源": @"金刚区", @"路由": config.url}];

            [LKDataRecord.shared traceClickEvent:config.name.desc parameters:@{@"route": config.url} SPM:[LKSPM SPMWithPage:@"TNHomeViewController" area:@"TNKingkongArea@2"
                                                                                                                       node:[NSString stringWithFormat:@"node@%zd", config.index - 1]]];

        } else {
            !self.canNotOpenRouteHandler ?: self.canNotOpenRouteHandler(url);
        }
    }
}

#pragma mark - getters and setters
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;

    [self reloadData];
}

- (NSArray<TNKingKongAreaAppView *> *)shouldShowGuideViewArray {
    // 获取可见的 cell
    NSArray<TNKingKongAreaAppView *> *visibleCells = [self.gridView.subviews hd_filterWithBlock:^BOOL(__kindof UIView *_Nonnull item) {
        return [item isKindOfClass:TNKingKongAreaAppView.class];
    }];

    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    const CGFloat minimumY = 50 + UIApplication.sharedApplication.statusBarFrame.size.height;
    const CGFloat maxY = kScreenHeight - kTabBarH;
    // 过滤
    visibleCells = [visibleCells filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TNKingKongAreaAppView *_Nullable cell, NSDictionary<NSString *, id> *_Nullable bindings) {
                                     CGRect fromRect = [cell convertRect:cell.bounds toView:keyWindow];
                                     BOOL isVisable = fromRect.origin.y >= minimumY && (fromRect.origin.y + fromRect.size.height) <= maxY;
                                     SAKingKongAreaItemConfig *model = cell.config;
                                     return model && model.hasUpdated && !model.hasDisplayedNewFunctionGuide && HDIsStringNotEmpty(model.guideDesc.desc) && isVisable;
                                 }]];
    // 排序
    visibleCells = [visibleCells sortedArrayUsingComparator:^NSComparisonResult(TNKingKongAreaAppView *_Nonnull obj1, TNKingKongAreaAppView *_Nonnull obj2) {
        return obj1.config.index > obj2.config.index;
    }];
    return visibleCells;
}

#pragma mark - lazy load
- (HDGridView *)gridView {
    if (!_gridView) {
        _gridView = HDGridView.new;
        _gridView.columnCount = kCollectionViewColumn;
        _gridView.rowHeight = kCollectionCellH;
        _gridView.edgeInsets = KCollectionEdgeInsets;
    }
    return _gridView;
}
@end

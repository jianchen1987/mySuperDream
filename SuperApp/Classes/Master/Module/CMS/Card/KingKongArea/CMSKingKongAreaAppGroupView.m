//
//  CMSKingKongAreaAppGroupView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "CMSKingKongAreaAppGroupView.h"

NSString *const kCMSFunctionThrottleKeyShowKingKongAreaNewFunctionGuide = @"cms.functionThrottle.key.showFunctionGuide";


@interface CMSKingKongAreaAppGroupView ()
@property (nonatomic, strong) HDGridView *gridView; ///< gridView
@end


@implementation CMSKingKongAreaAppGroupView
- (void)hd_setupViews {
    [self.contentView addSubview:self.gridView];
}

- (void)updateConstraints {
    [self.gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.bottom.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

#pragma mark - public methods
- (void)reloadData {
    [self.gridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (id model in self.dataSource) {
        CMSKingKongAreaAppView *cell = CMSKingKongAreaAppView.new;
        if ([model isKindOfClass:CMSKingKongAreaItemConfig.class]) {
            cell.config = (CMSKingKongAreaItemConfig *)model;
            [self.gridView addSubview:cell];
        }
        UITapGestureRecognizer *recoginer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCellHandler:)];
        [cell addGestureRecognizer:recoginer];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedCellHandler:(UITapGestureRecognizer *)recoginer {
    // 取消显示引导的函数节流
    dispatch_throttle_cancel(kCMSFunctionThrottleKeyShowKingKongAreaNewFunctionGuide);

    CMSKingKongAreaAppView *cell = (CMSKingKongAreaAppView *)recoginer.view;
    NSUInteger idx = [self.dataSource indexOfObject:cell.config];
    !self.clickKingKongArea ?: self.clickKingKongArea(cell.config.node, cell.config.link, idx);
}

#pragma mark - getters and setters
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;

    [self reloadData];
}

- (NSArray<CMSKingKongAreaAppView *> *)shouldShowGuideViewArray {
    // 获取可见的 cell
    NSArray<CMSKingKongAreaAppView *> *visibleCells = [self.gridView.subviews hd_filterWithBlock:^BOOL(__kindof UIView *_Nonnull item) {
        return [item isKindOfClass:CMSKingKongAreaAppView.class];
    }];

    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    const CGFloat minimumY = 50 + UIApplication.sharedApplication.statusBarFrame.size.height;
    const CGFloat maxY = kScreenHeight - kTabBarH;
    // 过滤
    visibleCells = [visibleCells filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CMSKingKongAreaAppView *_Nullable cell, NSDictionary<NSString *, id> *_Nullable bindings) {
                                     CGRect fromRect = [cell convertRect:cell.bounds toView:keyWindow];
                                     BOOL isVisable = fromRect.origin.y >= minimumY && (fromRect.origin.y + fromRect.size.height) <= maxY;
                                     CMSKingKongAreaItemConfig *model = cell.config;
                                     return model && model.hasUpdated && !model.hasDisplayedNewFunctionGuide && HDIsStringNotEmpty(model.funcGuideDesc) && isVisable;
                                 }]];
    return visibleCells;
}

#pragma mark - lazy load
- (HDGridView *)gridView {
    if (!_gridView) {
        _gridView = HDGridView.new;
        _gridView.columnCount = kCMSCollectionViewColumn;
        _gridView.rowHeight = kCMSCollectionCellH;
        _gridView.edgeInsets = KCMSCollectionEdgeInsets;
    }
    return _gridView;
}

@end

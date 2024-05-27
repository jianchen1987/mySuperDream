//
//  SAExpiredUsedCouponsViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAExpiredUsedCouponsViewController.h"
#import "LKDataRecord.h"
#import "SABusinessCouponCountRspModel.h"
#import "SACouponListChildViewControllerConfig.h"
#import "SACouponListViewController.h"
#import "SACouponListViewModel.h"
#import "SACouponTicketDTO.h"
#import <HDUIKit/HDCategoryView.h>


@interface SAExpiredUsedCouponsViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate>
/// DTO
@property (nonatomic, strong) SACouponTicketDTO *couponTicketDTO;
/// 业务线 YumNow：外卖 TinhNow:电商 PhoneTopUp：话费充值 为空代表所有业务线
@property (nonatomic, copy) SAClientType businessLine;

/// 优惠券类型 9-全部 15-现金券 34-运费券 37-支付券
@property (nonatomic, assign) SACouponListCouponType couponType;

@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;                           ///<
@property (nonatomic, strong) NSMutableArray<SACouponListChildViewControllerConfig *> *configs; ///< 配置
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;                   ///< 容器
/// 标题栏阴影图层
@property (nonatomic, strong) CAShapeLayer *categoryTitleViewShadowLayer;
@property (nonatomic, assign) BOOL showCategoryTitle; ///< 是否显示标题栏

@end


@implementation SAExpiredUsedCouponsViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    NSString *busLine = parameters[@"businessLine"];
    self.businessLine = HDIsStringNotEmpty(busLine) ? busLine : SAClientTypeAll;
    self.couponType = [parameters[@"couponType"] integerValue] != 0 ? [parameters[@"couponType"] integerValue] : SACouponListCouponTypeAll;
    self.showCategoryTitle = YES;
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"coupons_used_record", @"优惠券使用记录");
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 0;
    self.view.backgroundColor = HDAppTheme.color.sa_backgroundColor;
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.categoryTitleView];
    @HDWeakify(self);
    self.categoryTitleView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.categoryTitleViewShadowLayer) {
            [self.categoryTitleViewShadowLayer removeFromSuperlayer];
            self.categoryTitleViewShadowLayer = nil;
        }
        self.categoryTitleViewShadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1
                                                        shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor
                                                          fillColor:UIColor.whiteColor.CGColor
                                                       shadowOffset:CGSizeMake(0, 3)];
    };
}

- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
    }];

    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (self.showCategoryTitle) {
            make.top.equalTo(self.categoryTitleView.mas_bottom);
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        }
    }];

    [super updateViewConstraints];
}

#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<HDCategoryListContentViewDelegate> listVC = self.configs[index].vc;
    return listVC;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configs.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
    SACouponListChildViewControllerConfig *config = self.configs[index];
    [LKDataRecord.shared traceEvent:@"click_coupon_used_history_category" name:config.title parameters:nil SPM:[LKSPM SPMWithPage:@"SAExpiredUsedCouponsViewController" area:@""
                                                                                                                             node:[NSString stringWithFormat:@"node@%zd", index]]];
}

#pragma mark - SAViewModelProtocol
- (BOOL)allowContinuousBePushed {
    return true;
}

#pragma mark - lazy load
- (SACouponTicketDTO *)couponTicketDTO {
    if (!_couponTicketDTO) {
        _couponTicketDTO = SACouponTicketDTO.new;
    }
    return _couponTicketDTO;
}

- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryTitleView.new;
        _categoryTitleView.titles = [self.configs mapObjectsUsingBlock:^id _Nonnull(SACouponListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];

        _categoryTitleView.titleSelectedColor = HDAppTheme.color.sa_C1;
        _categoryTitleView.titleColor = [UIColor hd_colorWithHexString:@"999999"];

        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = HDAppTheme.color.sa_C1;
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = kRealWidth(20);
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = UIColor.whiteColor;
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}

- (NSMutableArray<SACouponListChildViewControllerConfig *> *)configs {
    if (!_configs) {
        NSMutableArray<SACouponListChildViewControllerConfig *> *configList = [NSMutableArray arrayWithCapacity:5];
        SACouponListViewController *vc = [[SACouponListViewController alloc]
            initWithRouteParameters:
                @{@"businessLine": self.businessLine, @"couponType": @(self.couponType), @"couponState": @(SACouponStateUsed), @"style": @(SACouponListViewStyleSubView), @"showFilterBar": @(0)}];
        SACouponListChildViewControllerConfig *config = [SACouponListChildViewControllerConfig configWithTitle:SALocalizedString(@"used", @"已使用") vc:vc couponType:self.couponType];
        [configList addObject:config];

        vc = [[SACouponListViewController alloc]
            initWithRouteParameters:
                @{@"businessLine": self.businessLine, @"couponType": @(self.couponType), @"couponState": @(SACouponStateExpired), @"style": @(SACouponListViewStyleSubView), @"showFilterBar": @(0)}];
        config = [SACouponListChildViewControllerConfig configWithTitle:SALocalizedString(@"expired", @"已过期") vc:vc couponType:self.couponType];
        [configList addObject:config];

        _configs = configList;
    }
    return _configs;
}

@end

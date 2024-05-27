//
//  SAMyCouponsViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMyCouponsViewController.h"
#import "LKDataRecord.h"
#import "SAApolloManager.h"
#import "SABusinessCouponCountRspModel.h"
#import "SACouponListChildViewControllerConfig.h"
#import "SACouponListViewController.h"
#import "SACouponListViewModel.h"
#import "SACouponTicketDTO.h"
#import "SAExpiredUsedCouponsViewController.h"
#import <HDUIKit/HDCategoryView.h>


@interface SAMyCouponsViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate>
/// DTO
@property (nonatomic, strong) SACouponTicketDTO *couponTicketDTO;
/// 过期优惠券按钮
@property (nonatomic, strong) HDUIButton *pastCouponBTN;
/// 业务线 YumNow：外卖 TinhNow:电商 PhoneTopUp：话费充值 为空代表所有业务线
@property (nonatomic, copy) SAClientType businessLine;

@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;                           ///<
@property (nonatomic, strong) NSMutableArray<SACouponListChildViewControllerConfig *> *configs; ///< 配置
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;                   ///< 容器
/// 标题栏阴影图层
@property (nonatomic, strong) CAShapeLayer *categoryTitleViewShadowLayer;
@property (nonatomic, assign) BOOL showCategoryTitle; ///< 是否显示标题栏
///< 获取更多优惠券按钮
@property (nonatomic, strong) SAOperationButton *getMoreCouponBtn;
/// 底部阴影
@property (nonatomic, strong) UIView *bottomShadowView;
///< 获取更多优惠券链接
@property (nonatomic, copy) NSString *getMoreCouponsUrlStr;
/// 积分换券
@property (nonatomic, copy) NSString *savePointExchangeCouponUrlStr;
///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;
@end


@implementation SAMyCouponsViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    NSString *busLine = parameters[@"businessLine"];
    self.businessLine = HDIsStringNotEmpty(busLine) ? busLine : SAClientTypeMaster;
    self.showCategoryTitle = NO;
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"coupon_ticket", @"优惠券");
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.pastCouponBTN];
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 0;
    self.view.backgroundColor = HDAppTheme.color.sa_backgroundColor;
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];

    NSString *moreCouponUrl = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeyGetMoreCoupons];

    if (HDIsStringNotEmpty(moreCouponUrl)) {
        self.getMoreCouponBtn.hidden = NO;
        self.bottomShadowView.hidden = NO;
        self.getMoreCouponsUrlStr = moreCouponUrl;

        self.savePointExchangeCouponUrlStr = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeyGetMorePayCoupons];

    } else {
        self.getMoreCouponBtn.hidden = YES;
        self.bottomShadowView.hidden = YES;
    }
    [self.view addSubview:self.getMoreCouponBtn];
    [self.view addSubview:self.bottomShadowView];
}

- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
    }];

    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (self.showCategoryTitle) {
            make.top.equalTo(self.categoryTitleView.mas_bottom);
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        }
        if (!self.getMoreCouponBtn.isHidden) {
            make.bottom.equalTo(self.getMoreCouponBtn.mas_top);
        } else {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
    }];

    if (!self.getMoreCouponBtn.isHidden) {
        [self.getMoreCouponBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.height.mas_equalTo(kRealHeight(44));
        }];
        [self.bottomShadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.getMoreCouponBtn.mas_top);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(kRealWidth(8));
        }];
    }

    [super updateViewConstraints];
}

- (void)hd_getNewData {
    @HDWeakify(self);
    [self.couponTicketDTO getBusinessCouponCountWithOperatorNo:SAUser.shared.operatorNo success:^(SABusinessCouponCountRspModel *rspModel) {
        @HDStrongify(self);

        for (SABusinessCouponCountModel *model in rspModel.coupon) {
            NSArray<SACouponListChildViewControllerConfig *> *result = [self.configs hd_filterWithBlock:^BOOL(SACouponListChildViewControllerConfig *_Nonnull item) {
                return item.couponType == model.couponType;
            }];

            NSString *countStr = model.total > 99 ? @"99+" : [NSString stringWithFormat:@"%zd", model.total];
            if (result.count) {
                // 已存在，更新未读数
                SACouponListChildViewControllerConfig *config = result.firstObject;

                config.title = [NSString stringWithFormat:@"%@(%@)", [self getCouponNameWithCouponType:model.couponType], countStr];
            } else {
                // 不存在，且数量大于0 添加
                SACouponListViewController *vc = [[SACouponListViewController alloc] initWithRouteParameters:@{
                    @"couponState": @(SACouponStateUnused),
                    @"style": @(SACouponListViewStyleSubView),
                    @"showFilterBar": @(1),
                    @"couponType": @(model.couponType),
                    @"source" : HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : @"",
                    @"associatedId" : self.viewModel.associatedId
                }];
                NSString *title = [NSString stringWithFormat:@"%@(%@)", [self getCouponNameWithCouponType:model.couponType], countStr];
                SACouponListChildViewControllerConfig *config = [SACouponListChildViewControllerConfig configWithTitle:title vc:vc couponType:model.couponType];
                [self.configs addObject:config];
            }
        }

        if (self.configs.count > 1) {
            self.showCategoryTitle = YES;
            [self.view bringSubviewToFront:self.categoryTitleView];
        } else {
            self.showCategoryTitle = NO;
            [self.view sendSubviewToBack:self.categoryTitleView];
        }

        self.categoryTitleView.titles = [self.configs mapObjectsUsingBlock:^id _Nonnull(SACouponListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];
        [self.categoryTitleView reloadDataWithoutListContainer];
        [self.view setNeedsUpdateConstraints];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

#pragma mark - action
- (void)clickOnGetMoreCouponsButton:(SAOperationButton *)button {
    if (HDIsStringNotEmpty(self.savePointExchangeCouponUrlStr) && [button.currentTitle isEqualToString:SALocalizedString(@"coupon_match_SavePointExchangeCoupon", @"积分兑券")]) {
        [SAWindowManager openUrl:self.savePointExchangeCouponUrlStr withParameters:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|优惠券列表.积分兑券"] : @"优惠券列表.积分兑券",
            @"associatedId" : self.viewModel.associatedId
        }];
        return;
    }

    if (HDIsStringNotEmpty(self.getMoreCouponsUrlStr)) {
        [SAWindowManager openUrl:self.getMoreCouponsUrlStr withParameters:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|优惠券列表.更多"] : @"优惠券列表.更多",
            @"associatedId" : self.viewModel.associatedId
        }];
    }
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
    if (config.couponType == SACouponListCouponTypePaymentCoupon && HDIsStringNotEmpty(self.savePointExchangeCouponUrlStr)) {
        [self.getMoreCouponBtn setTitle:SALocalizedString(@"coupon_match_SavePointExchangeCoupon", @"积分兑券") forState:UIControlStateNormal];
    } else {
        [self.getMoreCouponBtn setTitle:SALocalizedString(@"coupon_match_GoCouponCenter", @"去领券中心") forState:UIControlStateNormal];
    }
    [LKDataRecord.shared traceEvent:@"click_my_coupon_category" name:[NSString stringWithFormat:@"coupon_type_%zd", config.couponType] parameters:nil
                                SPM:[LKSPM SPMWithPage:@"SAMyCouponsViewController" area:@"" node:[NSString stringWithFormat:@"node@%zd", index]]];
}

#pragma mark - SAViewModelProtocol
- (BOOL)allowContinuousBePushed {
    return true;
}

#pragma mark - prviate method
- (NSString *)getCouponNameWithCouponType:(SACouponListCouponType)type {
    if (type == SACouponListCouponTypeAll) {
        return SALocalizedString(@"coupon_match_All", @"全部");
    } else if (type == SACouponListCouponTypeCashCoupon) {
        return SALocalizedString(@"coupon_match_CashCoupon", @"现金券");
    } else if (type == SACouponListCouponTypeExpressCoupon) {
        return SALocalizedString(@"coupon_match_ExpressCoupon", @"运费券");
    } else if (type == SACouponListCouponTypePaymentCoupon) {
        return SALocalizedString(@"coupon_match_PaymentCoupon", @"支付券");
    } else {
        return SALocalizedString(@"coupon_match_All", @"全部");
    }
}

#pragma mark - lazy load
- (SACouponTicketDTO *)couponTicketDTO {
    if (!_couponTicketDTO) {
        _couponTicketDTO = SACouponTicketDTO.new;
    }
    return _couponTicketDTO;
}

- (HDUIButton *)pastCouponBTN {
    if (!_pastCouponBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        [button setImage:[UIImage imageNamed:@"coupon_expired_used"] forState:UIControlStateNormal];
        [button setTitle:SALocalizedString(@"coupon_match_UsageRecord", @"使用记录") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor hd_colorWithHexString:@"333333"] forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:14];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            SAExpiredUsedCouponsViewController *vc = [[SAExpiredUsedCouponsViewController alloc] initWithRouteParameters:@{}];
            [SAWindowManager navigateToViewController:vc];

            [LKDataRecord.shared traceEvent:@"click_invaid_coupons_button" name:@"点击失效优惠券按钮" parameters:nil SPM:[LKSPM SPMWithPage:@"SAMyCouponsViewController" area:@"" node:@""]];
        }];
        _pastCouponBTN = button;
    }
    return _pastCouponBTN;
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
        
        SACouponListViewController *vc = [[SACouponListViewController alloc] initWithRouteParameters:@{
            @"businessLine": SAClientTypeAll,
            @"couponState": @(SACouponStateUnused),
            @"style": @(SACouponListViewStyleSubView),
            @"showFilterBar": @(1),
            @"couponType": @(SACouponListCouponTypeAll),
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : @"",
            @"associatedId" : self.viewModel.associatedId
        }];
        SACouponListChildViewControllerConfig *config = [SACouponListChildViewControllerConfig configWithTitle:[self getCouponNameWithCouponType:SACouponListCouponTypeAll] vc:vc
                                                                                                    couponType:SACouponListCouponTypeAll];
        [configList addObject:config];

        _configs = configList;
    }
    return _configs;
}

- (SAOperationButton *)getMoreCouponBtn {
    if (!_getMoreCouponBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithType:UIButtonTypeCustom];

        [button setImage:[UIImage imageNamed:@"coupon_more_coupons"] forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font boldForSize:14];
        [button setTitle:SALocalizedString(@"coupon_match_GoCouponCenter", @"去领券中心") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickOnGetMoreCouponsButton:) forControlEvents:UIControlEventTouchUpInside];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        _getMoreCouponBtn = button;
    }
    return _getMoreCouponBtn;
}

- (UIView *)bottomShadowView {
    if (!_bottomShadowView) {
        _bottomShadowView = UIView.new;
        _bottomShadowView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = view.bounds;
            gl.endPoint = CGPointMake(0.5, 0);
            gl.startPoint = CGPointMake(0.5, 1);
            gl.colors = @[
                (__bridge id)[UIColor colorWithRed:243 / 255.0 green:244 / 255.0 blue:250 / 255.0 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:243 / 255.0 green:244 / 255.0 blue:250 / 255.0 alpha:0.0].CGColor
            ];
            gl.locations = @[@(0), @(1.0f)];
            [view.layer addSublayer:gl];
        };
    }
    return _bottomShadowView;
}

- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end

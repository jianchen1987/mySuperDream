//
//  TNSellerOrderViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderViewController.h"
#import "TNMenuNavView.h"
#import "TNSellerOrderConfig.h"
#import "TNSellerOrderView.h"


@interface TNSellerOrderViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryDotView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
@property (strong, nonatomic) NSMutableArray<TNSellerOrderConfig *> *configList; ///<数据源
@end


@implementation TNSellerOrderViewController
- (void)hd_setupViews {
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"rUtm0BHF", @"订单明细");
    HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];

    self.hd_navigationItem.leftBarButtonItem = nil;
}
- (void)rightItemClick {
    HDAlertViewConfig *config = [[HDAlertViewConfig alloc] init];
    config.titleFont = [HDAppTheme.TinhNowFont fontSemibold:15];
    config.titleColor = HDAppTheme.TinhNowColor.G1;
    config.messageFont = HDAppTheme.TinhNowFont.standard12;
    config.messageColor = HDAppTheme.TinhNowColor.G2;
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:TNLocalizedString(@"yGDiKRr0", @"收益说明")
                                                     message:TNLocalizedString(@"mRYU5bxb",
                                                                               @"已支付、已取消订单状态显示：预估收益（扣完服务费后的金额）\n\n "
                                                                               @"已完成订单状态显示：结算收益（扣完服务费后的金额）\n\n海外购订单物流状态为国际运输中就显示结算收"
                                                                               @"益（扣完服务费后的金额）\n\n海外购已结算订单产生售后时（订单取消），对应该笔订单产生的收益需扣回")
                                                      config:config];
    alertView.identitableString = TNLocalizedString(@"rUtm0BHF", @"订单明细");
    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") type:HDAlertViewButtonTypeCustom
                                                           handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                               [alertView dismiss];
                                                           }];
    [alertView addButtons:@[button]];
    [alertView show];
}
- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    TNSellerOrderConfig *config = self.configList[index];
    TNSellerOrderView *listView = [[TNSellerOrderView alloc] initWithStatus:config.status];
    return listView;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
}
- (HDCategoryDotView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryDotView.new;
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(TNSellerOrderConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 10;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        //        lineView.verticalMargin = 4;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontRegular:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}
//- (TNMenuNavView *)navBarView {
//    if (!_navBarView) {
//        _navBarView = [[TNMenuNavView alloc] init];
//        _navBarView.title = TNLocalizedString(@"rUtm0BHF", @"订单明细");
//        _navBarView.rightImage = @"tn_order_explan";
//        _navBarView.rightImageInset = 15.0f;
//        _navBarView.clickedRightViewBlock = ^{
//            HDAlertViewConfig *config = [[HDAlertViewConfig alloc] init];
//            config.titleFont = [HDAppTheme.TinhNowFont fontSemibold:15];
//            config.titleColor = HDAppTheme.TinhNowColor.G1;
//            config.messageFont = HDAppTheme.TinhNowFont.standard12;
//            config.messageColor = HDAppTheme.TinhNowColor.G2;
//            HDAlertView *alertView = [HDAlertView alertViewWithTitle:TNLocalizedString(@"yGDiKRr0", @"收益说明")
//                                                             message:TNLocalizedString(@"mRYU5bxb", @"已支付、已取消订单状态显示：预估收益（扣完服务费后的金额）\n\n "
//                                                                                                    @"已完成订单状态显示：结算收益（扣完服务费后的金额）\n\n海外购订单物流状态为国际运输中就显示结算收"
//                                                                                                    @"益（扣完服务费后的金额）\n\n海外购已结算订单产生售后时（订单取消），对应该笔订单产生的收益需扣回")
//                                                              config:config];
//            alertView.identitableString = TNLocalizedString(@"rUtm0BHF", @"订单明细");
//            HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了")
//                                                                      type:HDAlertViewButtonTypeCustom
//                                                                   handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
//                                                                       [alertView dismiss];
//                                                                   }];
//            [alertView addButtons:@[ button ]];
//            [alertView show];
//        };
//
//        [_navBarView updateConstraintsAfterSetInfo];
//    }
//    return _navBarView;
//}
/** @lazy configList */
- (NSMutableArray *)configList {
    if (!_configList) {
        _configList = [NSMutableArray array];

        [_configList addObject:[self getConfigDataByStatus:-1 title:TNLocalizedString(@"tn_title_all", @"全部")]];
        [_configList addObject:[self getConfigDataByStatus:4 title:TNLocalizedString(@"tn_pending_payment", @"待付款")]];
        [_configList addObject:[self getConfigDataByStatus:TNSellerOrderStatusPaid title:TNLocalizedString(@"E1I6ZUG5", @"已付款")]];
        TNSellerOrderStatus status;
        if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
            //回退旧版本
            status = TNSellerOrderStatusFinish;
        } else {
            //新版本
            status = TNSellerOrderStatusDrawCash;
        }
        [_configList addObject:[self getConfigDataByStatus:status title:TNLocalizedString(@"pkjnFFIN", @"已结算")]];
        [_configList addObject:[self getConfigDataByStatus:TNSellerOrderStatusExpired title:TNLocalizedString(@"hTFG1UDO", @"已失效")]];
    }
    return _configList;
}

- (TNSellerOrderConfig *)getConfigDataByStatus:(TNSellerOrderStatus)status title:(NSString *)title {
    TNSellerOrderConfig *config = [TNSellerOrderConfig configWithTitle:title status:status];
    return config;
}
@end

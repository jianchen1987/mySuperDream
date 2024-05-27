//
//  PNNewInterTransferReciverInfoViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNNewInterTransferReciverInfoViewController.h"
#import "PNInterTransferReciverInfoViewController.h"


@interface PNNewInterTransferReciverInfoViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 标题数组
@property (strong, nonatomic) NSArray<NSString *> *titleArr;

@end


@implementation PNNewInterTransferReciverInfoViewController

- (void)hd_setupViews {
    self.titleArr = @[PNLocalizedString(@"pn_transfer_to_wechat", @"微信收款人"), PNLocalizedString(@"pn_transfer_to_alipay", @"支付宝收款人")];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"mKw25x8s", @"收款人信息");
}

- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        PNInterTransferReciverInfoViewController *fvc = [[PNInterTransferReciverInfoViewController alloc] initWithRouteParameters:@{
            @"channel": @(PNInterTransferThunesChannel_Wechat),
            @"more": @(1),
        }];
        return fvc;
    } else {
        PNInterTransferReciverInfoViewController *fvc = [[PNInterTransferReciverInfoViewController alloc] initWithRouteParameters:@{
            @"channel": @(PNInterTransferThunesChannel_Alipay),
            @"more": @(1),
        }];
        return fvc;
    }
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.titleArr.count;
}

- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
}

- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleView.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: titleView.titleSelectedFont}
                                              context:nil]
                              .size.width);
    return MIN(width, kScreenWidth - kRealWidth(30));
}

- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[HDCategoryTitleView alloc] init];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.titles = self.titleArr;
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDAppTheme.PayNowColor.mainThemeColor;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.PayNowFont fontRegular:15];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.PayNowFont fontSemibold:15];
        _categoryTitleView.titleSelectedColor = HDAppTheme.PayNowColor.c333333;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        _categoryTitleView.averageCellSpacingEnabled = YES;
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}
@end

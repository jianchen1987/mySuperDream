//
//  PNLuckPacketRecordsRootViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLuckyPacketRecordsRootViewController.h"
#import "PNLuckyPacketListViewController.h"


@interface PNLuckyPacketRecordsRootViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 标题数组
@property (strong, nonatomic) NSArray<NSString *> *titleArr;

@property (nonatomic, strong) UIImageView *imageBgView;
@end


@implementation PNLuckyPacketRecordsRootViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupViews {
    self.titleArr = @[PNLocalizedString(@"pn_i_received", @"收到的红包"), PNLocalizedString(@"pn_i_send", @"发出的红包")];
    [self.view addSubview:self.imageBgView];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_packet_message_record", @"红包记录");
}

- (void)updateViewConstraints {
    [self.imageBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.size.mas_equalTo(self.imageBgView.image.size);
    }];

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

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

#pragma mark - delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        PNLuckyPacketListViewController *fvc = [[PNLuckyPacketListViewController alloc] initWithRouteParameters:@{
            @"viewType": @"reciver",
        }];
        return fvc;
    } else {
        PNLuckyPacketListViewController *fvc = [[PNLuckyPacketListViewController alloc] initWithRouteParameters:@{
            @"viewType": @"send",
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
        lineView.indicatorColor = HDAppTheme.PayNowColor.cFFFFFF;
        lineView.indicatorWidth = kRealWidth(20);
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor clearColor];
        _categoryTitleView.titleFont = [HDAppTheme.PayNowFont fontRegular:15];
        _categoryTitleView.titleColor = HDAppTheme.PayNowColor.cFFFFFF;
        _categoryTitleView.titleSelectedFont = [HDAppTheme.PayNowFont fontSemibold:15];
        _categoryTitleView.titleSelectedColor = HDAppTheme.PayNowColor.cFFFFFF;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        _categoryTitleView.averageCellSpacingEnabled = YES;

        _categoryTitleView.defaultSelectedIndex = [[self.parameters objectForKey:@"index"] integerValue];
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}

- (UIImageView *)imageBgView {
    if (!_imageBgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_packet_records_bg"];
        _imageBgView = imageView;
    }
    return _imageBgView;
}

@end

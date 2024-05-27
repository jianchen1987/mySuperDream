//
//  TNActivityCarouselView.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCarouselView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInfoView.h"
#import "SASingleImageCollectionViewCell.h"
#import "SAWindowManager.h"
#import "TNActivityRuleView.h"
#import "TNSpeciaActivityDetailModel.h"
static CGFloat const kPageControlDotSize = 6;

#define sideWidth 0
#define cellMargin kRealWidth(0)


@interface TNActivityCarouselView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
@property (nonatomic, strong) HDCyclePagerView *bannerView; ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;   ///< pageControl
@property (nonatomic, strong) HDUIButton *ruleButton;
@property (nonatomic, strong) NSMutableArray<SASingleImageCollectionViewCellModel *> *dataSource; ///< 数据源
/// 切换地址
@property (strong, nonatomic) HDUIButton *changeAdressBtn;
/// 收货标志图标
@property (strong, nonatomic) UIImageView *expressImageView;
///
@property (strong, nonatomic) UIImageView *arrowImageView;
/// TG群优惠
@property (strong, nonatomic) SAInfoView *telegramInfoView;
@end


@implementation TNActivityCarouselView
- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bannerView];
    [self addSubview:self.pageControl];
    [self addSubview:self.ruleButton];
    [self addSubview:self.changeAdressBtn];
    [self.changeAdressBtn addSubview:self.expressImageView];
    [self.changeAdressBtn addSubview:self.arrowImageView];
    [self addSubview:self.telegramInfoView];
}
- (void)updateBannerViewConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(236));
        make.left.right.top.equalTo(self);
        if (self.changeAdressBtn.isHidden && self.telegramInfoView.isHidden) {
            make.bottom.equalTo(self);
        }
    }];
}
- (void)updateConstraints {
    [self updateBannerViewConstraints];
    [self.ruleButton sizeToFit];
    [self.ruleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.mas_top).offset(kRealWidth(10));
    }];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bannerView);
        make.centerX.equalTo(self.bannerView);
        make.bottom.equalTo(self.bannerView).offset(-kRealWidth(10));
        make.height.mas_equalTo(kPageControlDotSize);
    }];
    if (!self.changeAdressBtn.isHidden) {
        [self.changeAdressBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
            make.top.equalTo(self.bannerView.mas_bottom).offset(kRealWidth(10));
            make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(10));
            make.height.mas_equalTo(kRealWidth(30));
        }];
        [self.expressImageView sizeToFit];
        [self.expressImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.changeAdressBtn.mas_centerY);
            make.left.equalTo(self.changeAdressBtn.mas_left).offset(kRealWidth(10));
        }];
        [self.arrowImageView sizeToFit];
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.changeAdressBtn.mas_centerY);
            make.right.equalTo(self.changeAdressBtn.mas_right).offset(-kRealWidth(10));
        }];
    }
    if (!self.telegramInfoView.isHidden) {
        [self.telegramInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.bannerView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }

    [super updateConstraints];
}
// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SASingleImageCollectionViewCell *cell = [SASingleImageCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    SASingleImageCollectionViewCellModel *model = self.dataSource[index];
    model.placholderImage = [HDHelper placeholderImageWithCornerRadius:10 size:CGSizeMake(kScreenWidth, kScreenWidth * 236 / 375.0) logoWidth:100];
    model.cornerRadius = 0;
    cell.model = model;
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index >= self.model.productSpecialAdvs.count) {
        return;
    }
    TNSpeciaActivityAdModel *adModel = self.model.productSpecialAdvs[index];
    if (HDIsStringNotEmpty(adModel.appLink)) {
        [SAWindowManager openUrl:adModel.appLink withParameters:nil];
    }
    [SATalkingData trackEvent:[NSString stringWithFormat:@"%@%@", self.speciaTrackPrefixName, @"商品专题_点击顶部banner"] label:@"" parameters:@{}];
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;

    const CGFloat width = kScreenWidth;
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(width, height);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

#pragma mark - getters and setters
- (void)setShowChangeAdressBtn:(BOOL)showChangeAdressBtn {
    _showChangeAdressBtn = showChangeAdressBtn;
}
- (void)setModel:(TNSpeciaActivityDetailModel *)model {
    _model = model;
    self.ruleButton.hidden = HDIsStringEmpty(model.content);
    [self.dataSource removeAllObjects];
    for (TNSpeciaActivityAdModel *adModel in model.productSpecialAdvs) {
        SASingleImageCollectionViewCellModel *iModel = [[SASingleImageCollectionViewCellModel alloc] init];
        iModel.url = adModel.adv;
        [self.dataSource addObject:iModel];
    }
    self.bannerView.isInfiniteLoop = self.dataSource.count > 1;
    self.pageControl.numberOfPages = self.dataSource.count;
    [self.bannerView reloadData];
    self.changeAdressBtn.hidden = !self.showChangeAdressBtn;
    ///只在海外购的专题展示TG群
    self.telegramInfoView.hidden = model.businessLine == TNSpeciaActivityBusinessLineFastConsume;
    [self setNeedsUpdateConstraints];
}
- (void)updateAdressText:(NSString *)adress {
    if (HDIsStringNotEmpty(adress)) {
        [self.changeAdressBtn setTitle:adress forState:UIControlStateNormal];
    }
}
#pragma mark - 活动规则点击
- (void)ruleBtnClick:(HDUIButton *)btn {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
    config.buttonTitle = TNLocalizedString(@"tn_close", @"close");
    config.buttonBgColor = HDAppTheme.TinhNowColor.G5;
    config.buttonTitleFont = HDAppTheme.TinhNowFont.standard17B;
    config.buttonTitleColor = HDAppTheme.TinhNowColor.G2;
    config.iPhoneXFillViewBgColor = HDAppTheme.TinhNowColor.G5;

    TNActivityRuleView *view = [[TNActivityRuleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - kRealWidth(30), 10) content:self.model.content];
    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
    [actionView show];
}
#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 5.0;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        _bannerView.backgroundColor = HDAppTheme.TinhNowColor.G7;
        [_bannerView registerClass:SASingleImageCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SASingleImageCollectionViewCell.class)];
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(10, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.TinhNowColor.C1;
        _pageControl.pageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}
- (HDUIButton *)ruleButton {
    if (!_ruleButton) {
        _ruleButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        [_ruleButton setBackgroundImage:[UIImage imageNamed:@"tinhnow_rule_bg_k"] forState:UIControlStateNormal];
        //        [_ruleButton setImage:[UIImage imageNamed:@"tinhnow_white_back_arrow"] forState:UIControlStateNormal];
        [_ruleButton setTitle:TNLocalizedString(@"tn_activity_rules", @"活动规则") forState:UIControlStateNormal];
        [_ruleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ruleButton.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _ruleButton.titleEdgeInsets = UIEdgeInsetsMake(3, 10, 3, 10);
        _ruleButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_ruleButton addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _ruleButton.hidden = YES;
        _ruleButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _ruleButton;
}
/** @lazy changeAdressBtn  切换地址*/
- (HDUIButton *)changeAdressBtn {
    if (!_changeAdressBtn) {
        _changeAdressBtn = [[HDUIButton alloc] init];
        _changeAdressBtn.hidden = YES;
        [_changeAdressBtn setTitle:TNLocalizedString(@"FyEfaUt8", @"切换收货地址") forState:UIControlStateNormal];
        _changeAdressBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [_changeAdressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeAdressBtn.titleLabel.font = HDAppTheme.font.standard4;
        _changeAdressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(30), 0, kRealWidth(30));
        _changeAdressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _changeAdressBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4.0];
        };
        @HDWeakify(self);
        [_changeAdressBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback": self.chooseAdressCallback}];
        }];
    }
    return _changeAdressBtn;
}
/** @lazy expressImageView */
- (UIImageView *)expressImageView {
    if (!_expressImageView) {
        self.expressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_topic_express"]];
    }
    return _expressImageView;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_white_back_arrow"]];
    }
    return _arrowImageView;
}
- (NSMutableArray<SASingleImageCollectionViewCellModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/** @lazy telegramInfoView */
- (SAInfoView *)telegramInfoView {
    if (!_telegramInfoView) {
        _telegramInfoView = [[SAInfoView alloc] init];
        SAInfoViewModel *tgModel = [[SAInfoViewModel alloc] init];
        tgModel.leftImage = [UIImage imageNamed:@"tn_telegram_k"];
        tgModel.keyFont = [HDAppTheme.TinhNowFont fontMedium:12];
        tgModel.keyColor = HDAppTheme.TinhNowColor.G1;
        tgModel.keyText = TNLocalizedString(@"tn_jion_telegram", @"加入Telegram群获取更多优惠");
        tgModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
        tgModel.enableTapRecognizer = YES;
        tgModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        tgModel.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveTinhNowTelegramGroupViewController:@{}];
        };
        tgModel.lineWidth = 0;
        _telegramInfoView.model = tgModel;
        _telegramInfoView.hidden = YES;
    }
    return _telegramInfoView;
}
@end

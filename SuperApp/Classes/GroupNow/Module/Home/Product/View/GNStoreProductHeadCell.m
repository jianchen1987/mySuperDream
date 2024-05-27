//
//  GNStoreProductHeadCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreProductHeadCell.h"
#import "GNStringUntils.h"


@interface GNStoreProductHeadCell () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
/// 已售
@property (nonatomic, strong) HDLabel *soldLB;
/// 轮播
@property (nonatomic, strong) HDCyclePagerView *bannerView;
/// pageLabel
@property (nonatomic, strong) HDLabel *pageLabel;

@property (nonatomic, strong) HDFloatLayoutView *flowView;

@end


@implementation GNStoreProductHeadCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.soldLB];
    [self.contentView addSubview:self.pageLabel];
    [self.contentView addSubview:self.flowView];
}

- (void)updateConstraints {
    BOOL product = [self.model.type.codeId isEqualToString:GNProductTypeP1];
    [self.soldLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom).offset(kRealWidth(product ? 8 : 5));
        make.left.mas_offset(kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        if (product) {
            make.left.right.mas_offset(0);
        } else {
            make.left.mas_offset(kRealWidth(12));
            make.right.mas_offset(-kRealWidth(12));
        }
        make.height.mas_equalTo(!product ? kRealWidth(123) : kScreenWidth);
    }];

    [self.pageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bannerView.mas_bottom).offset(-kRealWidth(16));
        make.right.equalTo(self.bannerView.mas_right).offset(-kRealWidth(16));
    }];

    [self.flowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGSize size = [self.flowView sizeThatFits:CGSizeMake(kScreenWidth - kRealWidth(24), CGFLOAT_MAX)];
        make.size.mas_equalTo(size);
        make.left.mas_offset(kRealWidth(12));
        make.right.mas_offset(-kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        make.top.equalTo(self.soldLB.mas_bottom).offset(kRealWidth(12));
        make.height.mas_equalTo(size.height);
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNProductModel *)data {
    self.model = data;
    self.soldLB.text = [NSString stringWithFormat:@"%@ %ld", GNLocalizedString(@"gn_store_sold", @"已售"), data.consumptionOrderCodeNum];
    [self.bannerView reloadData];
    self.bannerView.isInfiniteLoop = self.model.imagePathArr.count > 1;
    self.pageLabel.hidden = [self.model.type.codeId isEqualToString:GNProductTypeP2];
    [self.flowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.flowView addSubview:[self createBtnWithTitle:data.whetherRefund == 1 ? GNLocalizedString(@"gn_product_refund", @"过期自动退") : GNLocalizedString(@"gn_expire_not_refund", @"过期不退款")]];
    if (data.whetherHomePurchaseRestrictions == GNHomePurchaseRestrictionsTypeCan) {
        [self.flowView addSubview:[self createBtnWithTitle:[NSString stringWithFormat:GNLocalizedString(@"gn_store_limited", @"每单限购%ld份"), data.homePurchaseRestrictions]]];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.model.imagePathArr.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    GNProductBannerItem *cell = [GNProductBannerItem cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    NSString *pathModel = self.model.imagePathArr[index];
    if ([self.model.type.codeId isEqualToString:GNProductTypeP2]) {
        cell.iconIV.couponLB.text = GNFillEmpty(self.model.name.desc);
        cell.iconIV.couponLB.textColor = HDAppTheme.color.gn_mainColor;
        cell.iconIV.couponLB.font = [HDAppTheme.font gn_ForSize:20 weight:UIFontWeightHeavy];
        cell.iconIV.image = [UIImage imageNamed:pathModel];
        cell.iconIV.rightOffset = kRealWidth(120);
        cell.iconIV.leftOffset = kRealWidth(32);
        cell.iconIV.couponLB.hidden = NO;
    } else {
        cell.iconIV.couponLB.text = @"";
        [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:pathModel] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(355), kRealWidth(150)) logoWidth:kRealWidth(64)]];
        cell.iconIV.couponLB.hidden = YES;
        cell.iconIV.layer.cornerRadius = 0;
    }
    return cell;
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = CGRectGetWidth(pageView.frame);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (fromIndex < self.model.imagePathArr.count) {
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", toIndex + 1, self.model.imagePathArr.count];
    }
}

- (HDUIButton *)createBtnWithTitle:(NSString *)title {
    HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:HDAppTheme.color.gn_666Color forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [HDAppTheme.font gn_ForSize:12];
    button.layer.cornerRadius = kRealWidth(2);
    button.layer.backgroundColor = HDAppTheme.color.gn_lineColor.CGColor;
    button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
    return button;
}

- (HDLabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = HDLabel.new;
        _pageLabel.layer.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.6].CGColor;
        _pageLabel.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(8.5), kRealWidth(3), kRealWidth(8.5));
        _pageLabel.textColor = HDAppTheme.color.gn_whiteColor;
        _pageLabel.font = [HDAppTheme.font gn_ForSize:10];
        _pageLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
        };
    }
    return _pageLabel;
}

- (HDLabel *)soldLB {
    if (!_soldLB) {
        _soldLB = HDLabel.new;
        _soldLB.numberOfLines = 1;
        _soldLB.textAlignment = NSTextAlignmentRight;
        _soldLB.font = [HDAppTheme.font gn_ForSize:13];
    }
    return _soldLB;
}

- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 5.0;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:GNProductBannerItem.class forCellWithReuseIdentifier:NSStringFromClass(GNProductBannerItem.class)];
    }
    return _bannerView;
}

- (HDFloatLayoutView *)flowView {
    if (!_flowView) {
        _flowView = HDFloatLayoutView.new;
        _flowView.itemMargins = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(6), kRealWidth(4), kRealWidth(6));
    }
    return _flowView;
}

@end


@implementation GNProductBannerItem

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (GNCouPonImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = GNCouPonImageView.new;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconIV;
}

@end

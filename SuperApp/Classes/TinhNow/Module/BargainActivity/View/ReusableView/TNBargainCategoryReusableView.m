//
//  TNBargainActivityHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainCategoryReusableView.h"
#import "NSString+HD_Size.h"
#import "TNActivityRuleView.h"
#import "TNBargainRuleViewController.h"
#import <HDCommonDefines.h>
#import <HDHelper.h>
#import <HDUIKit/HDUIKit.h>
#import <HDVendorKit.h>
#import <Masonry.h>


@interface TNBargainCategoryReusableView () <HDCategoryViewDelegate, HDCategoryTitleViewDataSource>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
@end


@implementation TNBargainCategoryReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hd_setupView];
    }
    return self;
}
- (void)hd_setupView {
    [self addSubview:self.categoryTitleView];
}
- (void)setList:(NSArray<TNHomeCategoryModel *> *)list {
    _list = list;
    self.categoryTitleView.titles = [list mapObjectsUsingBlock:^id _Nonnull(TNHomeCategoryModel *_Nonnull obj, NSUInteger idx) {
        return obj.name;
    }];
    [self.categoryTitleView reloadDataWithoutListContainer];
}
- (void)updateConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (self.categoryClickCallBack) {
        self.categoryClickCallBack(index);
    }
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
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 10;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        lineView.verticalMargin = 4;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:16];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        _categoryTitleView.contentEdgeInsetLeft = kRealWidth(15);
        _categoryTitleView.contentEdgeInsetRight = kRealWidth(15);
        _categoryTitleView.cellSpacing = kRealWidth(20);
        _categoryTitleView.averageCellSpacingEnabled = NO;
    }
    return _categoryTitleView;
}
@end

//
//  SACMSWaterfallCategoryCollectionReusableView.m
//  SuperApp
//
//  Created by seeu on 2022/2/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallCategoryCollectionReusableView.h"
#import "SACMSWaterfallCategoryTitleRspModel.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry/Masonry.h>


@interface SACMSWaterfallCategoryCollectionReusableView () <HDCategoryViewDelegate>
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView; ///<
@end


@implementation SACMSWaterfallCategoryCollectionReusableView
#pragma mark - life cycle
- (void)commonInit {
    [self hd_setupViews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.categoryTitleView];
}

#pragma mark - setter
- (void)setModel:(SACMSWaterfallCategoryCollectionReusableViewModel *)model {
    _model = model;
    self.categoryTitleView.titleFont = [UIFont systemFontOfSize:model.fontSize weight:UIFontWeightRegular];
    self.categoryTitleView.titleColor = [UIColor hd_colorWithHexString:@"#999999"];

    self.categoryTitleView.titleSelectedColor = HDIsStringNotEmpty(model.tintColor) ? [UIColor hd_colorWithHexString:model.tintColor] : HDAppTheme.color.C1;
    self.categoryTitleView.titleSelectedFont = [UIFont systemFontOfSize:model.fontSize weight:UIFontWeightBold];
    self.categoryTitleView.titles = [model.titles mapObjectsUsingBlock:^id _Nonnull(SACMSCategoryTitleModel *_Nonnull obj, NSUInteger idx) {
        return obj.title.desc;
    }];

    HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
    lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
    lineView.indicatorColor = HDIsStringNotEmpty(model.tintColor) ? [UIColor hd_colorWithHexString:model.tintColor] : HDAppTheme.color.C1;
    self.categoryTitleView.indicators = @[lineView];

    [self.categoryTitleView reloadDataWithoutListContainer];
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(42);
    }];
    [super updateConstraints];
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    SACMSCategoryTitleModel *associatedModel = self.model.titles[index];
    if (self.clickedOnCategory) {
        self.clickedOnCategory(associatedModel, self);
    }
}

#pragma mark - lazy load
- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryTitleView.new;
        _categoryTitleView.delegate = self;
        _categoryTitleView.backgroundColor = UIColor.whiteColor;
        _categoryTitleView.cellSpacing = kRealWidth(30);
        _categoryTitleView.contentEdgeInsetLeft = kRealWidth(15);
    }
    return _categoryTitleView;
}

@end


@implementation SACMSWaterfallCategoryCollectionReusableViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tintColor = @"#F83E00";
        self.fontSize = 15;
    }
    return self;
}

@end

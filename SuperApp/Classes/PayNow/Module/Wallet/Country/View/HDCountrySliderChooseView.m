//
//  HDCountrySliderChooseView.m
//  ViPay
//
//  Created by VanJay on 2019/7/20.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCountrySliderChooseView.h"
#import "CountryModel.h"
#import "CountryUnitView.h"
#import "Masonry.h"


@interface HDCountrySliderChooseView ()
@property (nonatomic, strong) UIScrollView *containerScrollView;        ///< 容器
@property (nonatomic, strong) NSMutableArray<CountryUnitView *> *views; ///< 所有 View
@property (nonatomic, strong) CountryUnitView *selectedUnitView;        ///< 当前选中
@end


@implementation HDCountrySliderChooseView

#pragma mark - life cycle
- (void)commonInit {
    self.containerScrollView = [[UIScrollView alloc] init];
    [self addSubview:self.containerScrollView];
    self.containerScrollView.showsVerticalScrollIndicator = false;
    self.containerScrollView.showsHorizontalScrollIndicator = false;

    self.containerScrollView.backgroundColor = [UIColor hd_colorWithHexString:@"#F1F2F3"];
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

- (void)updateConstraints {
    [super updateConstraints];

    [self.containerScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UIView *lastView;
    const CGFloat hMargin = kRealWidth(10), vMargin = kRealWidth(8);
    for (UIView *view in self.views) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.left.equalTo(self.containerScrollView).offset(hMargin);
            } else {
                make.left.equalTo(lastView.mas_right).offset(hMargin);
            }
            make.centerY.equalTo(self.containerScrollView);
            make.top.equalTo(self.containerScrollView).offset(vMargin);
            if (view == self.views.lastObject) {
                make.right.equalTo(self.containerScrollView).offset(-hMargin);
            }
        }];
        lastView = view;
    }
}

#pragma mark - getters and setters
- (void)setDataSource:(NSArray<CountryModel *> *)dataSource {
    _dataSource = dataSource;

    [self.views makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.views removeAllObjects];

    for (CountryModel *model in dataSource) {
        CountryUnitView *view = [[CountryUnitView alloc] init];
        view.model = model;

        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosedUnitView:)]];

        [self.containerScrollView addSubview:view];
        [self.views addObject:view];
    }

    [self setNeedsUpdateConstraints];
}

- (void)setSelectModel:(CountryModel *)selectModel {
    _selectModel = selectModel;

    for (CountryUnitView *view in self.views) {
        if ([view.model.countryCode isEqualToString:selectModel.countryCode]) {
            view.isSelected = true;
            self.selectedUnitView = view;
        } else {
            view.isSelected = false;
        }
    }
}

#pragma mark - event response
- (void)choosedUnitView:(UITapGestureRecognizer *)recognizer {
    CountryUnitView *view = (CountryUnitView *)recognizer.view;

    self.selectedUnitView.isSelected = false;
    view.isSelected = true;
    self.selectedUnitView = view;

    !self.selectCountryUnitViewHandler ?: self.selectCountryUnitViewHandler(view.model);
}

#pragma mark - lazy load
- (NSMutableArray *)views {
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}
@end

//
//  WMNewSpecialActivesProductCategoryView.m
//  SuperApp
//
//  Created by Tia on 2023/7/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewSpecialActivesProductCategoryView.h"
#import "SACollectionViewCell.h"
#import "UICollectionViewLeftAlignLayout.h"
#import "SATableView.h"
#import "SATableViewCell.h"


@interface WMNewSpecialActivesProductCategoryViewCollectionViewCell : SACollectionViewCell
/// 显示名字
@property (nonatomic, strong) WMSpecialPromotionCategoryModel *model;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIButton *button;

@end


@implementation WMNewSpecialActivesProductCategoryViewCollectionViewCell


- (void)hd_setupViews {
    [self.contentView addSubview:self.button];
}

- (void)updateConstraints {
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark setter
- (void)setModel:(WMSpecialPromotionCategoryModel *)model {
    _model = model;
    [self.button setTitle:model.nameZh forState:UIControlStateNormal];
    [self setNeedsUpdateConstraints];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.button.backgroundColor = [HDAppTheme.color.sa_C1 colorWithAlphaComponent:0.1];
        self.button.layer.borderWidth = 1;
        self.button.layer.borderColor = UIColor.sa_C1.CGColor;
        [self.button setTitleColor:[UIColor sa_C1] forState:UIControlStateNormal];
    } else {
        self.button.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];
        self.button.layer.borderWidth = 0;
        [self.button setTitleColor:[UIColor sa_C666] forState:UIControlStateNormal];
    }
}

#pragma mark lazy
- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = HDAppTheme.font.sa_standard12;
        [button setTitleColor:[UIColor sa_C666] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];
        button.userInteractionEnabled = NO;
        button.layer.cornerRadius = 2;
        _button = button;
    }
    return _button;
}

@end


@interface WMNewSpecialActivesProductCategoryViewTableViewCell : SATableViewCell
/// 显示名字
@property (nonatomic, strong) WMSpecialPromotionCategoryModel *model;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *button;

@end


@implementation WMNewSpecialActivesProductCategoryViewTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.button];
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
    }];

    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.label);
        make.right.mas_equalTo(-12);
    }];
    [super updateConstraints];
}

#pragma mark setter
- (void)setModel:(WMSpecialPromotionCategoryModel *)model {
    _model = model;
    if (SAMultiLanguageManager.isCurrentLanguageEN) {
        self.label.text = model.name;
    } else {
        self.label.text = model.nameKm;
        self.label.font = HDAppTheme.font.sa_standard14H;
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.button.selected = isSelected;
    [self setNeedsUpdateConstraints];
}

- (UILabel *)label {
    if (!_label) {
        _label = UILabel.new;
        _label.font = HDAppTheme.font.sa_standard14;
        _label.textColor = UIColor.sa_C333;
    }
    return _label;
}

- (UIButton *)button {
    if (!_button) {
        _button = UIButton.new;
        [_button setImage:[UIImage imageNamed:@"icon_special_actives_radio_nor"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"icon_special_actives_radio_sel"] forState:UIControlStateSelected];
        _button.userInteractionEnabled = NO;
    }
    return _button;
}

@end


@interface WMNewSpecialActivesProductCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SATableView *tableView;
/// Container
@property (nonatomic, strong) UIView *containerView;
/// 相对视图
@property (nonatomic, assign) CGFloat startY;

@end


@implementation WMNewSpecialActivesProductCategoryView

- (instancetype)initWithStartOffsetY:(CGFloat)offset {
    self.startY = offset;
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    return self;
}

- (void)hd_setupViews {
    self.shadowBackgroundView.frame = CGRectMake(0, self.startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.startY);
    self.containerView.frame = CGRectMake(0, self.startY, CGRectGetWidth(self.frame), CGFLOAT_MIN);

    self.containerView.backgroundColor = UIColor.whiteColor;

    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.tableView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.shadowBackgroundView addGestureRecognizer:tap];

    if (!SAMultiLanguageManager.isCurrentLanguageCN) {
        self.collectionView.hidden = YES;
    } else {
        self.tableView.hidden = YES;
    }
    @HDWeakify(self);
    if (!self.collectionView.hidden) {
        [self.KVOController hd_observe:self.collectionView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.containerView).insets(UIEdgeInsetsMake(12, 12, 12, 12));
                    make.height.mas_equalTo(self.collectionView.contentSize.height);
                }];
            });
        }];
    }

    if (!self.tableView.hidden) {
        [self.KVOController hd_observe:self.tableView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                HDLog(@"%f", self.tableView.contentSize.height);
                [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.containerView);
                    make.height.mas_equalTo(self.tableView.contentSize.height > SCREEN_HEIGHT * 0.7 ? SCREEN_HEIGHT * 0.7 : self.tableView.contentSize.height);
                }];
            });
        }];
    }
}

- (void)updateConstraints {
    [self updateContainerConstraints];
    [super updateConstraints];
}

- (void)updateContainerConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.startY);
    }];

    if (!self.collectionView.hidden) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containerView).insets(UIEdgeInsetsMake(12, 12, 12, 12));
            make.height.mas_equalTo(200);
        }];
    }

    if (!self.tableView.hidden) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containerView);
            make.height.mas_equalTo(200);
        }];
    }
}

- (void)setCategoryList:(NSArray<WMSpecialPromotionCategoryModel *> *)categoryList {
    _categoryList = categoryList;
    if (!self.collectionView.hidden) {
        [self.collectionView reloadData];
    }
    if (!self.tableView.hidden) {
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }
}

#pragma mark - public methods
- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.showing = YES;
    [self.containerView setNeedsUpdateConstraints];
    self.shadowBackgroundView.alpha = 0.7;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.shadowBackgroundView.alpha = 0.7;
        [self updateContainerConstraints];
    } completion:^(BOOL finished){
    }];
}

- (void)dismiss {
    [self dismissCompleted:nil];
}

- (void)dismissCompleted:(void (^__nullable)(void))completed {
    //    !self.slideDownViewWillDisappear ?: self.slideDownViewWillDisappear(self);
    self.showing = NO;
    [self.containerView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.1 animations:^{
        self.shadowBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self updateContainerConstraints];
        if (completed) {
            completed();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            !self.dismissBlock ?: self.dismissBlock();
        });
    }];
}

#pragma mark - override system methods
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.showing) { // 展开
        if (!CGRectContainsPoint(self.containerView.frame, point)) {
            dispatch_async(dispatch_get_main_queue(), ^{ //点击非内容页面，隐藏view
                [self dismiss];
            });
        }
        return CGRectContainsPoint(self.containerView.frame, point) || CGRectContainsPoint(self.shadowBackgroundView.frame, point);
    }
    // 收起
    return [super pointInside:point withEvent:event];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMNewSpecialActivesProductCategoryViewCollectionViewCell *cell =
        [WMNewSpecialActivesProductCategoryViewCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                              identifier:NSStringFromClass(WMNewSpecialActivesProductCategoryViewCollectionViewCell.class)];
    WMSpecialPromotionCategoryModel *model = self.categoryList[indexPath.row];
    cell.model = model;
    cell.isSelected = model.isSelected;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.collectionView.hd_width - 10 * 3) / 4, 32);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMSpecialPromotionCategoryModel *m = self.categoryList[indexPath.row];
    if (m.isSelected)
        return;
    for (WMSpecialPromotionCategoryModel *m1 in self.categoryList) {
        if (m1 != m && m1.isSelected) {
            m1.isSelected = NO;
        } else if (m1 == m) {
            m1.isSelected = YES;
        }
    }
    if (self.selectedBlock) {
        self.selectedBlock(m);
    }
    [self dismiss];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMNewSpecialActivesProductCategoryViewTableViewCell *cell = [WMNewSpecialActivesProductCategoryViewTableViewCell cellWithTableView:tableView];
    WMSpecialPromotionCategoryModel *model = self.categoryList[indexPath.row];
    cell.model = model;
    cell.isSelected = model.isSelected;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WMSpecialPromotionCategoryModel *m = self.categoryList[indexPath.row];
    if (m.isSelected)
        return;
    for (WMSpecialPromotionCategoryModel *m1 in self.categoryList) {
        if (m1 != m && m1.isSelected) {
            m1.isSelected = NO;
        } else if (m1 == m) {
            m1.isSelected = YES;
        }
    }
    if (self.selectedBlock) {
        self.selectedBlock(m);
    }
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - lazy load
/** @lazy shadowbackgroundView */
- (UIView *)shadowBackgroundView {
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = UIColor.blackColor;
        _shadowBackgroundView.alpha = 0;
        _shadowBackgroundView.userInteractionEnabled = YES;
    }
    return _shadowBackgroundView;
}

/** @lazy filterbackgroundcontainer */
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
        _containerView.backgroundColor = UIColor.whiteColor;
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8];
        };
    }
    return _containerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right, 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (SATableView *)tableView {
    if (!_tableView) {
        SATableView *tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.needRefreshHeader = false;
        _tableView = tableView;
    }
    return _tableView;
}


@end

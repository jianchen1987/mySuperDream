//
//  SAOrderListFilterDownView.m
//  SuperApp
//
//  Created by Tia on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderListFilterDownView.h"
#import "NSDate+SAExtension.h"
#import "SAAppSwitchManager.h"
#import "SADatePickerViewController.h"
#import "SAInternationalizationModel.h"
#import "SAOrderListFilterCollectionReusableView.h"
#import "SAOrderListFilterCollectionTimeRangeReusableView.h"
#import "SAOrderListFilterCollectionViewCell.h"
#import "UICollectionViewLeftAlignLayout.h"


@interface SAOrderListFilterSectionModel : NSObject
/// section名称
@property (nonatomic, strong) SAInternationalizationModel *title;
/// 选项数组
@property (nonatomic, strong) NSArray *option;

@end


@implementation SAOrderListFilterSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"option": @"SAOrderListFilterOptionModel"};
}

@end


@interface SAOrderListFilterOptionModel : NSObject
/// 选项名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 选择状态
@property (nonatomic) BOOL isSelected;
///// 文本宽度
//@property (nonatomic) NSInteger width;

@property (nonatomic) NSString *timeRange;

/// YumNow-外卖, TinhNow-电商, PhoneTopUp-话费充值 GameChannel-游戏频道, HotelChannel-酒店频道
@property (nonatomic, copy) SAClientType businessLine;

@end


@implementation SAOrderListFilterOptionModel

@end


@interface SAOrderListFilterModel : NSObject

@property (nonatomic, strong) SAOrderListFilterSectionModel *businessLine;

@property (nonatomic, strong) SAOrderListFilterSectionModel *timeRange;

@end


@implementation SAOrderListFilterModel

@end


@interface SAOrderListFilterDownView () <UICollectionViewDelegate, UICollectionViewDataSource>
/// 相对视图
@property (nonatomic, assign) CGFloat startY;

@property (nonatomic, strong) UICollectionView *collectionView;
/// 初始数据
@property (nonatomic, strong) NSArray *defaultDataArr;
/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;
/// Container
@property (nonatomic, strong) UIView *containerView;
/// 是否展开
@property (nonatomic, assign) BOOL showing;

/// 重置按钮
@property (nonatomic, strong) UIButton *resetBTN;
/// 确定按钮
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, copy) NSString *filterStartDate;
@property (nonatomic, copy) NSString *filterEndDate;

@end


@implementation SAOrderListFilterDownView

- (instancetype)initWithStartOffsetY:(CGFloat)offset {
    self.startY = offset;
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    return self;
}

- (void)hd_setupViews {
    self.shadowBackgroundView.frame = CGRectMake(0, self.startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.startY);
    self.containerView.frame = CGRectMake(0, self.startY, CGRectGetWidth(self.frame), CGFLOAT_MIN);

    self.containerView.backgroundColor = HDAppTheme.color.sa_backgroundColor;

    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.resetBTN];
    [self.containerView addSubview:self.submitBtn];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.shadowBackgroundView addGestureRecognizer:tap];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.collectionView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.containerView);
                make.height.mas_equalTo(self.collectionView.contentSize.height);
            }];
        });
    }];
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

    [self.resetBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(kRealWidth(8));
        make.left.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(48));
        make.width.equalTo(self.containerView).multipliedBy(0.5);
    }];

    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.resetBTN);
        make.right.equalTo(self.containerView);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        make.height.mas_equalTo(200);
    }];
}

- (void)hd_languageDidChanged {
    [self.submitBtn setTitle:SALocalizedString(@"oc_btn_confirm", @"确认") forState:UIControlStateNormal];
    [self.resetBTN setTitle:SALocalizedStringFromTable(@"reset", @"重置", @"Buttons") forState:UIControlStateNormal];
    [self.collectionView reloadData];
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

- (void)updateDate:(NSString *)date isEndDate:(BOOL)isEndDate {
    if (isEndDate) {
        self.filterEndDate = date;
    } else {
        self.filterStartDate = date;
    }

    if (self.defaultDataArr.count > 1) {
        SAOrderListFilterSectionModel *model = self.defaultDataArr[1];
        for (SAOrderListFilterOptionModel *m1 in model.option) {
            m1.isSelected = NO;
        }
    }
    [self.collectionView reloadData];
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
        ;
    }
    // 收起
    return [super pointInside:point withEvent:event];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.defaultDataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    if(section == 0){
    SAOrderListFilterSectionModel *model = self.defaultDataArr[section];
    return model.option.count;
    //    }
    //    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAOrderListFilterCollectionViewCell *cell = [SAOrderListFilterCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                 identifier:NSStringFromClass(SAOrderListFilterCollectionViewCell.class)];
    SAOrderListFilterSectionModel *model = self.defaultDataArr[indexPath.section];
    SAOrderListFilterOptionModel *m = model.option[indexPath.row];
    cell.text = m.name.desc;
    cell.isSelected = m.isSelected;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SAOrderListFilterCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                 withReuseIdentifier:NSStringFromClass(SAOrderListFilterCollectionReusableView.class)
                                                                                                        forIndexPath:indexPath];
        SAOrderListFilterSectionModel *model = self.defaultDataArr[indexPath.section];
        headerView.text = model.title.desc;
        return headerView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section == 1) {
        SAOrderListFilterCollectionTimeRangeReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                                          withReuseIdentifier:NSStringFromClass(SAOrderListFilterCollectionTimeRangeReusableView.class)
                                                                                                                 forIndexPath:indexPath];
        @HDWeakify(self);
        footerView.chooseDateBlock = ^(BOOL isEndDate) {
            @HDStrongify(self);
            !self.chooseDateBlock ?: self.chooseDateBlock(isEndDate);
        };
        [footerView updateStartDate:self.filterStartDate endDate:self.filterEndDate];
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.hd_width, kRealWidth(40));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(self.collectionView.hd_width, kRealWidth(44));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.collectionView.hd_width - 12 * 4) / 3, kRealWidth(32));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SAOrderListFilterSectionModel *model = self.defaultDataArr[indexPath.section];
    SAOrderListFilterOptionModel *m = model.option[indexPath.row];
    if (m.isSelected)
        return;
    if (indexPath.section == 1) {
        self.filterStartDate = nil;
        self.filterEndDate = nil;
    }
    for (SAOrderListFilterOptionModel *m1 in model.option) {
        if (m1 != m && m1.isSelected) {
            m1.isSelected = NO;
        } else if (m1 == m) {
            m1.isSelected = YES;
        }
    }
    [self.collectionView reloadData];
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
        flowLayout.minimumInteritemSpacing = 11.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right, 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:SAOrderListFilterCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(SAOrderListFilterCollectionReusableView.class)];

        [_collectionView registerClass:SAOrderListFilterCollectionTimeRangeReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:NSStringFromClass(SAOrderListFilterCollectionTimeRangeReusableView.class)];

        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)resetBTN {
    if (!_resetBTN) {
        _resetBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBTN setTitle:SALocalizedStringFromTable(@"reset", @"重置", @"Buttons") forState:UIControlStateNormal];
        [_resetBTN setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        _resetBTN.backgroundColor = UIColor.whiteColor;
        _resetBTN.titleLabel.font = [HDAppTheme.font boldForSize:14];
        _resetBTN.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(2), kRealWidth(5), kRealHeight(2), kRealWidth(5));
        @HDWeakify(self);
        [_resetBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.defaultDataArr = nil;
            self.filterStartDate = nil;
            self.filterEndDate = nil;
            [self.collectionView reloadData];
        }];
    }
    return _resetBTN;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:SALocalizedString(@"oc_btn_confirm", @"确认") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [HDAppTheme.font boldForSize:14];
        _submitBtn.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(2), kRealWidth(5), kRealHeight(2), kRealWidth(5));
        _submitBtn.backgroundColor = HDAppTheme.color.sa_C1;
        @HDWeakify(self);
        [_submitBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.submitBlock) {
                SAClientType businessLine;
                SAOrderListFilterSectionModel *m = self.defaultDataArr[0];
                for (SAOrderListFilterOptionModel *m1 in m.option) {
                    if (m1.isSelected) {
                        businessLine = m1.businessLine;
                        break;
                    }
                }

                NSString *fmt = @"dd/MM/yyyy";
                if (self.filterStartDate && !self.filterEndDate) { //有起始时间
                    self.submitBlock(businessLine, self.filterStartDate, [NSDate getDate:NSDate.date day:0 formatter:fmt]);

                } else if (!self.filterStartDate && self.filterEndDate) { //有结束时间
                    self.submitBlock(businessLine, [NSDate getDate:NSDate.date day:-20 * 365 formatter:fmt], self.filterEndDate);

                } else if (self.filterStartDate && self.filterEndDate) { //有起始时间和结束时间
                    self.submitBlock(businessLine, self.filterStartDate, self.filterEndDate);

                } else { //其他情况
                    NSString *timeRange = nil;
                    m = self.defaultDataArr[1];
                    for (SAOrderListFilterOptionModel *m1 in m.option) {
                        if (m1.isSelected) {
                            timeRange = m1.timeRange;
                            break;
                        }
                    }
                    NSInteger day = timeRange.integerValue;
                    if (day > 0) {
                        self.submitBlock(businessLine, [NSDate getDate:NSDate.date day:-day formatter:fmt], [NSDate getDate:NSDate.date day:0 formatter:fmt]);
                    } else {
                        self.submitBlock(businessLine, [NSDate getDate:NSDate.date day:-20 * 365 formatter:fmt], [NSDate getDate:NSDate.date day:0 formatter:fmt]);
                    }
                }
            }
            [self dismiss];
        }];
    }
    return _submitBtn;
}

- (NSArray *)defaultDataArr {
    if (!_defaultDataArr) {
        //根据后台配置控制获取筛选数据，默认显示
        NSString *jsonStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchOrderListFilterOption];
        SAOrderListFilterModel *model = [SAOrderListFilterModel yy_modelWithJSON:jsonStr];
        _defaultDataArr = @[model.businessLine, model.timeRange];
    }
    return _defaultDataArr;
}

@end

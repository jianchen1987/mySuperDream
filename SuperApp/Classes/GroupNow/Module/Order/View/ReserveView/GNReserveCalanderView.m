//
//  GNReserveCalanderView.m
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveCalanderView.h"
#import "GNReserveViewModel.h"
#import "SAInternationalizationModel.h"

#define NumberMounthes 4
#define allCount 42


@interface GNReserveCalanderView () <UICollectionViewDelegate, UICollectionViewDataSource>
///标题
@property (nonatomic, strong) HDLabel *titleLB;
/// left
@property (nonatomic, strong) HDUIButton *leftBTN;
/// right
@property (nonatomic, strong) HDUIButton *rightBTN;
///内容视图
@property (nonatomic, strong) UIView *containView;
/// headView
@property (nonatomic, strong) UIView *headView;
/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
/// currentYear
@property (nonatomic, assign) NSInteger currentYear;
/// currentMonth
@property (nonatomic, assign) NSInteger currentMonth;
/// currentDay
@property (nonatomic, assign) NSInteger currentDay;
/// today
@property (nonatomic, copy) NSString *today;
///日历数组
@property (nonatomic, strong) NSMutableArray<NSMutableArray<GNReserveCalanderModel *> *> *dataArr;
/// currentIndex
@property (nonatomic, assign) NSInteger currentIndex;
/// monthArr
@property (nonatomic, copy) NSArray<SAInternationalizationModel *> *monthArr;
/// viewModel
@property (nonatomic, strong) GNReserveViewModel *viewModel;

@end


@implementation GNReserveCalanderView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    self.monthArr = @[
        [SAInternationalizationModel modelWithCN:@"1月" en:@"January" kh:@"January"],
        [SAInternationalizationModel modelWithCN:@"2月" en:@"February" kh:@"February"],
        [SAInternationalizationModel modelWithCN:@"3月" en:@"March" kh:@"March"],
        [SAInternationalizationModel modelWithCN:@"4月" en:@"April" kh:@"April"],
        [SAInternationalizationModel modelWithCN:@"5月" en:@"May" kh:@"May"],
        [SAInternationalizationModel modelWithCN:@"6月" en:@"June" kh:@"June"],
        [SAInternationalizationModel modelWithCN:@"7月" en:@"July" kh:@"July"],
        [SAInternationalizationModel modelWithCN:@"8月" en:@"August" kh:@"August"],
        [SAInternationalizationModel modelWithCN:@"9月" en:@"September" kh:@"September"],
        [SAInternationalizationModel modelWithCN:@"10月" en:@"October" kh:@"October"],
        [SAInternationalizationModel modelWithCN:@"11月" en:@"November" kh:@"November"],
        [SAInternationalizationModel modelWithCN:@"12月" en:@"December" kh:@"December"]
    ];
    [self addSubview:self.titleLB];
    [self addSubview:self.leftBTN];
    [self addSubview:self.rightBTN];
    [self addSubview:self.containView];
    [self.containView addSubview:self.headView];
    [self.containView addSubview:self.collectionView];

    NSArray *dayArr = @[
        [SAInternationalizationModel modelWithCN:@"日" en:@"Sun" kh:@"Sun"],
        [SAInternationalizationModel modelWithCN:@"一" en:@"Mon" kh:@"Mon"],
        [SAInternationalizationModel modelWithCN:@"二" en:@"Tue" kh:@"Tue"],
        [SAInternationalizationModel modelWithCN:@"三" en:@"Wed" kh:@"Wed"],
        [SAInternationalizationModel modelWithCN:@"四" en:@"Thu" kh:@"Thu"],
        [SAInternationalizationModel modelWithCN:@"五" en:@"Fri" kh:@"Fri"],
        [SAInternationalizationModel modelWithCN:@"六" en:@"Sat" kh:@"Sat"]
    ];
    HDLabel *currentLB = nil;
    CGSize size = CGSizeMake((kScreenWidth - kRealWidth(10)) / 7.0, kRealWidth(52));
    for (SAInternationalizationModel *str in dayArr) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.color.gn_333Color;
        label.font = [HDAppTheme.font gn_boldForSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = str.desc;
        [self.headView addSubview:label];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kRealWidth(8));
            if (!currentLB) {
                make.left.mas_equalTo(0);
            } else {
                make.left.equalTo(currentLB.mas_right);
            }
            make.size.mas_equalTo(size);
        }];
        currentLB = label;
    }
}

- (void)hd_bindViewModel {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = NSDate.date;
    self.currentYear = [NSDate year:currentDate];
    self.currentMonth = [NSDate month:currentDate];
    self.currentDay = [NSDate day:currentDate];
    self.today = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)self.currentYear, (long)self.currentMonth, (long)self.currentDay];

    self.dataArr = [NSMutableArray new];
    for (int i = 0; i < NumberMounthes; i++) {
        NSMutableArray *array = [NSMutableArray new];
        [self.dataArr addObject:array];
        [self updateDateYear:self.currentYear Month:self.currentMonth - i - 1 index:i];
    }
    [self.dataArr sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return NSOrderedDescending;
    }];

    NSMutableArray *array = [NSMutableArray new];
    [self.dataArr addObject:array];
    [self updateDateYear:self.currentYear Month:self.currentMonth index:NumberMounthes];

    for (int i = 0; i < NumberMounthes; i++) {
        NSMutableArray *array = [NSMutableArray new];
        [self.dataArr addObject:array];
        [self updateDateYear:self.currentYear Month:self.currentMonth + i + 1 index:i + NumberMounthes + 1];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        self.currentIndex = NumberMounthes;
        [self scrollIndexPath:self.currentIndex shouldReloadData:YES animal:NO first:YES];
    });
}

- (void)setBusinessDay:(NSArray<NSString *> *)businessDay {
    _businessDay = businessDay;
    [self.collectionView reloadData];
}

/// 刷新后滚动
- (void)scrollIndexPath:(NSInteger)section shouldReloadData:(BOOL)reloadData animal:(BOOL)animal first:(BOOL)first {
    if (reloadData) {
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
    }
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.hd_width * section, 0) animated:animal];
}

/// lastValue
- (void)lastValue {
    self.currentIndex -= 1;
    if (self.currentIndex < 0) {
        self.currentIndex = 0;
    }
    [self scrollIndexPath:self.currentIndex shouldReloadData:NO animal:YES first:NO];
}

/// nextValue
- (void)nextValue {
    self.currentIndex += 1;
    if (self.currentIndex >= self.dataArr.count) {
        self.currentIndex = self.dataArr.count - 1;
    }
    [self scrollIndexPath:self.currentIndex shouldReloadData:NO animal:YES first:NO];
}

/// 更新数据
- (void)updateDateYear:(NSInteger)year Month:(NSInteger)month index:(NSInteger)index {
    if (self.dataArr.count <= index)
        return;
    [[self.dataArr objectAtIndex:index] removeAllObjects];
    if (month > 12) {
        int num = (month / 12.0);
        month = month - (num + 1) * 12;
        year += (num + 1);
    }
    if (month < 1) {
        int num = (month / -12);
        month = month + (num + 1) * 12;
        year -= (num + 1);
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];

    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = month;
    components.year = year;
    components.day = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowDate = [calendar dateFromComponents:components];

    nowDate = [nowDate dateByAddingTimeInterval:[zone secondsFromGMTForDate:nowDate]];
    if (components.month <= 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    NSDate *nextDate = [calendar dateFromComponents:components];
    nextDate = [nextDate dateByAddingTimeInterval:[zone secondsFromGMTForDate:nextDate]];
    NSInteger DaysInNextMonth = [NSDate totaldaysInMonth:nextDate];

    NSInteger firstDayInThisMounth = [NSDate firstWeekdayInThisMonth:nowDate];
    NSInteger daysInThisMounth = [NSDate totaldaysInMonth:nowDate];
    NSInteger tmpDay = 0;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]]; //解决8小时时间差问题

    for (int j = 0; j < allCount; j++) {
        NSInteger tmpYear = year;
        NSInteger tmpMonth = month;
        GNReserveCalanderModel *model = [GNReserveCalanderModel new];
        if (j < firstDayInThisMounth) {
            if (tmpMonth <= 1) {
                tmpMonth = 12;
                tmpYear -= 1;
            } else {
                tmpMonth -= 1;
            }
            tmpDay = DaysInNextMonth - firstDayInThisMounth + j + 1;
            model.wLastMonth = YES;
        } else if (j > daysInThisMounth + firstDayInThisMounth - 1) {
            if (tmpMonth >= 12) {
                tmpMonth = 1;
                tmpYear += 1;
            } else {
                tmpMonth += 1;
            }
            tmpDay = j - (daysInThisMounth + firstDayInThisMounth - 1);
            model.wNextMonth = YES;
        } else {
            tmpDay = j - firstDayInThisMounth + 1;
        }
        NSString *detaMonth = tmpMonth < 10 ? [NSString stringWithFormat:@"0%ld", (long)tmpMonth] : [NSString stringWithFormat:@"%ld", (long)tmpMonth];
        NSString *detaDay = tmpDay < 10 ? [NSString stringWithFormat:@"0%ld", (long)tmpDay] : [NSString stringWithFormat:@"%ld", (long)tmpDay];
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%@-%@", (long)tmpYear, detaMonth, detaDay];
        NSDate *myDate = [dateFormatter dateFromString:dateStr];
        model.wYear = tmpYear;
        model.wMonth = tmpMonth;
        model.wDay = tmpDay;
        model.wDate = myDate;
        model.wWeek = [NSDate weekdayStringWithDate:myDate];
        model.wIndex = j % 7 * 6 + j / 7;
        if ([NSDate compareOneDay:NSDate.date withAnotherDay:model.wDate] == 1 || [NSDate getDifferenceByDate:model.wDate] >= 30) {
            model.wInRange = NO;
        } else {
            model.wInRange = YES;
        }
        ///今天
        if ([[NSString stringWithFormat:@"%ld-%ld-%ld", (long)model.wYear, (long)model.wMonth, (long)model.wDay] isEqualToString:self.today]) {
            model.wToday = YES;
        }
        if (!self.viewModel.reserveModel) {
            ///默认今天
            if (!self.selectModel && model.wToday) {
                model.wSelected = YES;
                self.selectModel = model;
            }
        } else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.viewModel.reserveModel.reservationTime.doubleValue / 1000];
            NSInteger currentYear = [NSDate year:date];
            NSInteger currentMonth = [NSDate month:date];
            NSInteger currentDay = [NSDate day:date];
            if (tmpYear == currentYear && tmpMonth == currentMonth && tmpDay == currentDay && !self.selectModel) {
                model.wSelected = YES;
                self.selectModel = model;
            }
        }
        [[self.dataArr objectAtIndex:index] insertObject:model atIndex:j];
    }

    NSMutableArray *arr = [self.dataArr objectAtIndex:index];
    [arr sortUsingComparator:^NSComparisonResult(GNReserveCalanderModel *_Nonnull obj1, GNReserveCalanderModel *obj2) {
        return obj1.wIndex > obj2.wIndex;
    }];
}

- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(16));
        make.centerX.mas_equalTo(0);
    }];

    [self.leftBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLB.mas_left).offset(-kRealWidth(48));
        make.centerY.equalTo(self.titleLB);
    }];

    [self.rightBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right).offset(kRealWidth(48));
        make.centerY.equalTo(self.titleLB);
    }];

    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(16));
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(5));
        make.right.mas_equalTo(kRealWidth(-5));
        make.height.mas_equalTo(kRealWidth(60));
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.mas_equalTo(kRealWidth(5));
        make.right.mas_equalTo(kRealWidth(-5));
        make.height.mas_equalTo(kRealWidth(44) * 6);
        make.bottom.mas_equalTo(0);
    }];

    [super updateConstraints];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.itemSize = CGSizeMake((kScreenWidth - kRealWidth(10)) / 7.0, kRealWidth(44));
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.contentInsetAdjustmentBehavior = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:GNReserveCalanderCell.class forCellWithReuseIdentifier:@"GNReserveCalanderCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr[section].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNReserveCalanderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GNReserveCalanderCell" forIndexPath:indexPath];
    GNReserveCalanderModel *model = self.dataArr[indexPath.section][indexPath.row];
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)model.wDay];
    cell.bgView.hidden = true;
    cell.circleView.hidden = true;
    cell.label.textColor = HDAppTheme.color.gn_333Color;
    NSInteger index = [self.businessDay indexOfObject:model.wWeek];
    model.wUnEnable = NO;
    BOOL gray = !model.wInRange;
    if (index == NSNotFound && !model.wLastMonth && !model.wNextMonth && [NSDate compareOneDay:NSDate.date withAnotherDay:model.wDate] != 1 && [NSDate getDifferenceByDate:model.wDate] < 30) {
        model.wUnEnable = YES;
    }
    if (model.wUnEnable && model.wSelected) {
        model.wSelected = NO;
        self.selectModel = nil;
    }
    if (model.wLastMonth || model.wNextMonth) {
        cell.label.textColor = HDAppTheme.color.gn_999Color;
    }
    if (model.wSelected || model.wUnEnable) {
        cell.bgView.hidden = NO;
        cell.label.textColor = UIColor.whiteColor;
        if (model.wSelected) {
            cell.bgView.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
        } else {
            cell.bgView.layer.backgroundColor = HDAppTheme.color.gn_cccccc.CGColor;
        }
    }
    if (gray) {
        cell.bgView.hidden = YES;
        cell.label.textColor = HDAppTheme.color.gn_999Color;
    }
    if ([[NSString stringWithFormat:@"%ld-%ld-%ld", (long)model.wYear, (long)model.wMonth, (long)model.wDay] isEqualToString:self.today] && !model.wLastMonth && !model.wNextMonth) {
        cell.circleView.hidden = false;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GNReserveCalanderModel *model = self.dataArr[indexPath.section][indexPath.row];
    if (model.wLastMonth || model.wNextMonth || model.wUnEnable || [NSDate compareOneDay:NSDate.date withAnotherDay:model.wDate] == 1 || [NSDate getDifferenceByDate:model.wDate] >= 30)
        return;
    if (self.selectModel) {
        self.selectModel.wSelected = false;
    }
    model.wSelected = YES;
    self.selectModel = model;
    [collectionView reloadData];
}

/// 手动拖动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadDataScrollView:scrollView];
}

/// 点击上下月
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self loadDataScrollView:scrollView];
}

/// 预加载
- (void)loadDataScrollView:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView)
        return;
    int index = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (index < 0 || index > self.dataArr.count - 1)
        return;
    NSMutableArray *arr = self.dataArr[index];
    self.currentIndex = index;
    for (GNReserveCalanderModel *model in arr) {
        if (!model.wLastMonth && !model.wNextMonth) {
            self.currentYear = model.wYear;
            self.currentMonth = model.wMonth;
            self.currentDay = model.wDay;
        }
    }
    /// 首个或者最后一个 预加载上个和下个
    if (self.currentIndex == 0 || self.currentIndex == self.dataArr.count - 1) {
        NSMutableArray *arr = [NSMutableArray new];
        if (self.currentIndex == 0) {
            [self.dataArr insertObject:arr atIndex:0];
        } else {
            [self.dataArr addObject:arr];
        }
        [self updateDateYear:self.currentYear Month:self.currentIndex == 0 ? (self.currentMonth - 1) : (self.currentMonth + 1) index:(self.currentIndex == 0) ? 0 : (self.dataArr.count - 1)];

        if (self.currentIndex == 0) {
            [self scrollIndexPath:1 shouldReloadData:NO animal:NO first:NO];
        }
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadData];
        }];
    }
}

- (void)setCurrentYear:(NSInteger)currentYear {
    _currentYear = currentYear;
    if (self.currentMonth) {
        self.titleLB.text = [NSString stringWithFormat:@"%@ %ld", self.monthArr[self.currentMonth - 1].desc, (long)currentYear];
    } else {
        self.titleLB.text = [NSString stringWithFormat:@"%ld", (long)currentYear];
    }
}

- (void)setCurrentMonth:(NSInteger)currentMonth {
    _currentMonth = currentMonth;
    self.titleLB.text = [NSString stringWithFormat:@"%@ %ld", self.monthArr[currentMonth - 1].desc, (long)self.currentYear];
}

- (UIView *)containView {
    if (!_containView) {
        _containView = UIView.new;
        _containView.layer.backgroundColor = UIColor.whiteColor.CGColor;
        [_containView setHd_frameDidChangeBlock:^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kRealWidth(20), kRealWidth(20))];
        }];
    }
    return _containView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = UIView.new;
    }
    return _headView;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:20 fontName:@"DIN-Bold"];
        label.textColor = HDAppTheme.color.gn_333Color;
        _titleLB = label;
    }
    return _titleLB;
}

- (HDUIButton *)leftBTN {
    if (!_leftBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_reserve_left"] forState:UIControlStateNormal];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self lastValue];
        }];
        _leftBTN = btn;
    }
    return _leftBTN;
}

- (HDUIButton *)rightBTN {
    if (!_rightBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_reserve_right"] forState:UIControlStateNormal];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self nextValue];
        }];
        _rightBTN = btn;
    }
    return _rightBTN;
}

- (NSMutableArray<NSMutableArray<GNReserveCalanderModel *> *> *)dataArr {
    if (!_dataArr) {
        _dataArr = NSMutableArray.new;
    }
    return _dataArr;
}

@end


@implementation GNReserveCalanderCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.circleView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(((36) * (kWidthCoefficientTo6S)), ((36) * (kWidthCoefficientTo6S))));
    }];

    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(kRealWidth(20));
    }];

    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.label.mas_bottom).offset(kRealWidth(2));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(4), kRealWidth(4)));
    }];
    [super updateConstraints];
}

- (HDLabel *)label {
    if (!_label) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DIN-Medium"];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.textAlignment = NSTextAlignmentCenter;
        _label = label;
    }
    return _label;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = UIView.new;
        _circleView.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
        _circleView.layer.cornerRadius = kRealWidth(2);
    }
    return _circleView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.layer.backgroundColor = HDAppTheme.color.gn_cccccc.CGColor;
        _bgView.layer.cornerRadius = ((18) * (kWidthCoefficientTo6S));
    }
    return _bgView;
}

@end


@implementation GNReserveCalanderModel

@end

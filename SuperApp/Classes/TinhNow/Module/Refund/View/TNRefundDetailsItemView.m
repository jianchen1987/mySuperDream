//
//  TNRefundDetailsItemView.m
//  SuperApp
//
//  Created by xixi on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundDetailsItemView.h"
#import "HDWebImageManager.h"
#import "TNTakePhotoItemCell.h"


@interface TNRefundDetailsItemView () <UICollectionViewDelegate, UICollectionViewDataSource>
///
@property (nonatomic, strong) UILabel *refundTypeLabel;
///
@property (nonatomic, strong) UILabel *refundMoneyLabel;
///
@property (nonatomic, strong) UILabel *resonLabel;
///
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat collectionViewHeight;
@property (nonatomic, assign) CGFloat sectionInsetTop;
@property (nonatomic, assign) CGFloat sectionInsetLeft;
@property (nonatomic, assign) CGFloat sectionInsetBottom;
@property (nonatomic, assign) CGFloat sectionInsetRight;
@property (nonatomic, assign) CGFloat minimumLineSpacingUpDown;
@property (nonatomic, assign) CGFloat minimumInteritemSpacingLeftRight;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
///
@property (nonatomic, assign) NSInteger rowCount;

@end


@implementation TNRefundDetailsItemView

- (void)hd_setupViews {
    [self addSubview:self.refundTypeLabel];
    [self addSubview:self.refundMoneyLabel];
    [self addSubview:self.resonLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.refundTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(44.f);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.mas_top);
    }];

    [self.refundMoneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.refundTypeLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.refundTypeLabel.mas_bottom).offset(15.f);
    }];

    [self.resonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.refundTypeLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.refundMoneyLabel.mas_bottom).offset(15.f);
    }];

    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.refundTypeLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.resonLabel.mas_bottom).offset(15.f);
        //        make.bottom.mas_equalTo(self.mas_bottom).offset(-15.f);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(44.f);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15.f);
        make.height.equalTo(@(self.collectionViewHeight));
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(10.f);
    }];

    [super updateConstraints];
}

- (void)setModel:(TNRefundDetailsItemsModel *)model {
    _model = model;
    self.refundTypeLabel.text = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"tn_refund_type", @"退款类型"), self.model.refundType];
    self.refundMoneyLabel.text = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"tn_refund_money", @"申请退款金额($)"), self.model.refundAmountMoney.thousandSeparatorAmountNoCurrencySymbol];
    self.resonLabel.text = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"tn_reason", @"原因"), HDIsStringNotEmpty(self.model.refundReason) ? self.model.refundReason : @""];
    self.descLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"tn_remark", @"说明"), HDIsStringNotEmpty(self.model.remarks) ? self.model.remarks : @""];

    if (model.images.count > 0) {
        self.collectionView.hidden = NO;
        self.collectionViewHeight = (self.itemWidth * [self getRow]) + (([self getRow] - 1) * self.minimumLineSpacingUpDown);
        [self.collectionView reloadData];
    } else {
        self.collectionView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

- (CGFloat)getRow {
    NSInteger a = self.model.images.count % self.column;
    NSInteger rowCount;
    if (a == 0) {
        rowCount = self.model.images.count / self.column;
    } else {
        rowCount = (self.model.images.count / self.column) + 1;
    }
    return rowCount;
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNTakePhotoItemCell *cell = [TNTakePhotoItemCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.imgURL = [self.model.images objectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TNTakePhotoItemCell *cell = (TNTakePhotoItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self showBigImage:indexPath.item projectiveView:cell];
}

- (void)showBigImage:(NSInteger)currentIndex projectiveView:(UIView *)projectiveView {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];
    for (NSString *url in self.model.images) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:url];
        // 这里固定只是从此处开始投影，滑动时会更新投影控件
        data.projectiveView = projectiveView;
        [datas addObject:data];
    }

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = currentIndex;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);
    [browser show];
}

#pragma mark -
- (UILabel *)refundTypeLabel {
    if (!_refundTypeLabel) {
        _refundTypeLabel = [[UILabel alloc] init];
        _refundTypeLabel.textColor = HDAppTheme.TinhNowColor.c666666;
        _refundTypeLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
        _refundTypeLabel.numberOfLines = 0;
    }
    return _refundTypeLabel;
}

- (UILabel *)refundMoneyLabel {
    if (!_refundMoneyLabel) {
        _refundMoneyLabel = [[UILabel alloc] init];
        _refundMoneyLabel.textColor = HDAppTheme.TinhNowColor.c666666;
        _refundMoneyLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
        _refundMoneyLabel.numberOfLines = 0;
    }
    return _refundMoneyLabel;
}

- (UILabel *)resonLabel {
    if (!_resonLabel) {
        _resonLabel = [[UILabel alloc] init];
        _resonLabel.textColor = HDAppTheme.TinhNowColor.c666666;
        _resonLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
        _resonLabel.numberOfLines = 0;
    }
    return _resonLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = HDAppTheme.TinhNowColor.c666666;
        _descLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.sectionInsetTop = self.sectionInsetBottom = self.sectionInsetLeft = self.sectionInsetRight = 0;
        self.minimumLineSpacingUpDown = 10.f;
        self.minimumInteritemSpacingLeftRight = 5.f;
        self.column = 4;

        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.sectionInset = UIEdgeInsetsMake(self.sectionInsetTop, self.sectionInsetLeft, self.sectionInsetBottom, self.sectionInsetRight);
        self.flowLayout.minimumLineSpacing = self.minimumLineSpacingUpDown;
        self.flowLayout.minimumInteritemSpacing = self.minimumInteritemSpacingLeftRight;
        self.collectionViewHeight = self.itemWidth = ((kScreenWidth - 44 - 15 - ((self.column - 1) * self.minimumInteritemSpacingLeftRight)) / self.column);
        self.flowLayout.itemSize = CGSizeMake(self.itemWidth, self.itemWidth);

        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.backgroundColor;
        [_collectionView registerClass:TNTakePhotoItemCell.class forCellWithReuseIdentifier:TNTakePhotoItemCell.description];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

@end

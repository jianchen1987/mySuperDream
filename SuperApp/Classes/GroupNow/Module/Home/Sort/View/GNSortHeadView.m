//
//  GNSortHeadView.m
//  SuperApp
//
//  Created by wmz on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNSortHeadView.h"


@interface GNSortHeadView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/// lineView
@property (nonatomic, strong) UIView *leftLine;
/// rightBTN
@property (nonatomic, strong) HDUIButton *rightBTN;

@end


@implementation GNSortHeadView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<GNClassificationModel *> *)dataSource {
    if (self = [super initWithFrame:frame]) {
        if (!HDIsArrayEmpty(dataSource)) {
            self.dataSource = dataSource;
        }
    }
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = self.collectionView.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self addSubview:self.collectionView];
    [self addSubview:self.leftLine];
    [self addSubview:self.rightBTN];
    [self.collectionView addSubview:self.bottomLine];
    [self.collectionView registerClass:GNClassCodeItemCell.class forCellWithReuseIdentifier:@"GNClassCodeItemCell"];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView updateUI];
}

- (void)updateConstraints {
    [self.rightBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kRealWidth(43));
        make.height.equalTo(self);
    }];

    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightBTN.mas_left);
        make.width.mas_equalTo(1);
        make.top.bottom.mas_equalTo(0);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.rightBTN.mas_left);
        make.height.mas_equalTo(kRealWidth(94));
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionView.mas_left);
        make.top.mas_equalTo(kRealWidth(87));
        make.height.mas_equalTo(kRealWidth(2));
        make.width.mas_equalTo(kRealWidth(20));
    }];
    [self.rightBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNClassCodeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GNClassCodeItemCell" forIndexPath:indexPath];
    [cell setGNModel:self.dataSource[indexPath.row]];

    NSArray *arr = [self.dataSource hd_filterWithBlock:^BOOL(GNClassificationModel *_Nonnull item) {
        return item.isSelect;
    }];
    if (!HDIsArrayEmpty(arr)) {
        UICollectionViewLayoutAttributes *atts = [collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.dataSource indexOfObject:arr.firstObject] inSection:0]];
        [UIView animateWithDuration:0.2 animations:^{
            [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                CGFloat left = atts.frame.origin.x + (atts.frame.size.width - kRealWidth(20)) / 2.0;
                make.left.equalTo(self.collectionView.mas_left).offset(left);
            }];
            [self.bottomLine setNeedsUpdateConstraints];
        }];
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(floor((kScreenWidth - kRealWidth(15)) / 5.0), self.collectionView.hd_height);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __block BOOL stopClick = NO;
    [self.dataSource enumerateObjectsUsingBlock:^(GNClassificationModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.select && (idx == indexPath.row)) {
            stopClick = YES;
            *stop = YES;
            return;
        }
        obj.select = (idx == indexPath.row);
    }];
    if (stopClick)
        return;
    [self.collectionView updateUI];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickItem:)]) {
        [self.delegate clickItem:self.dataSource[indexPath.row]];
    }
    [self scrollAction:[collectionView layoutAttributesForItemAtIndexPath:indexPath]];
}

/// 滚动到中间
- (void)scrollAction:(UICollectionViewLayoutAttributes *)itemView {
    if ([self.collectionView isScrollEnabled]) {
        CGFloat centerX = self.hd_width / 2;
        CGRect indexFrame = itemView.frame;
        CGFloat contenSize = self.collectionView.contentSize.width;
        CGPoint point = CGPointZero;
        if (indexFrame.origin.x <= centerX) {
            point = CGPointMake(0, 0);
        } else if (CGRectGetMaxX(indexFrame) > (contenSize - centerX)) {
            point = CGPointMake(self.collectionView.contentSize.width - self.collectionView.size.width, 0);
        } else {
            point = CGPointMake(CGRectGetMaxX(indexFrame) - centerX - indexFrame.size.width / 2, 0);
        }
        [self.collectionView setContentOffset:point animated:YES];
    }
}

- (void)setTopOffset:(CGFloat)topOffset {
    _topOffset = topOffset;
    CGFloat alpah = topOffset / self.maxOffset;
    [self.dataSource enumerateObjectsUsingBlock:^(GNClassificationModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.alpah = alpah;
    }];
    self.bottomLine.alpha = alpah;
    [self.rightBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (alpah > 0.5) {
            make.bottom.mas_equalTo(-kRealWidth(25));
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(kRealWidth(43));
        } else {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(kRealWidth(43));
            make.height.equalTo(self);
        }
    }];
    [self.rightBTN setNeedsFocusUpdate];
    [self.collectionView updateUI];
}

- (GNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[GNCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = UIView.new;
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0, kRealWidth(32), 1, kRealWidth(66));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.0].CGColor,
            (__bridge id)[UIColor colorWithRed:225 / 255.0 green:226 / 255.0 blue:230 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.0].CGColor
        ];
        gl.locations = @[@(0), @(0.5f), @(1.0f)];
        [_leftLine.layer addSublayer:gl];
    }
    return _leftLine;
}

- (HDUIButton *)rightBTN {
    if (!_rightBTN) {
        _rightBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_rightBTN setImage:[UIImage imageNamed:@"gn_storeinfo_expand"] forState:UIControlStateNormal];
        _rightBTN.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _rightBTN.imageEdgeInsets = UIEdgeInsetsMake(kRealWidth(27), 0, 0, 0);
        @HDWeakify(self)[_rightBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"openAction"];
        }];
    }
    return _rightBTN;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.alpha = 0;
        _bottomLine.layer.cornerRadius = (1.0 * (kWidthCoefficientTo6S));
        _bottomLine.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
    }
    return _bottomLine;
}

@end


@interface GNClassCodeItemCell ()
/// name
@property (nonatomic, strong) HDLabel *nameLB;

@end


@implementation GNClassCodeItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.nameLB];
}

- (void)setGNModel:(GNClassificationModel *)data {
    if ([data isKindOfClass:GNClassificationModel.class]) {
        self.nameLB.text = WMFillEmptySpace(data.classificationName.desc);
        if ([data.photo hasPrefix:@"http"]) {
            [self.imageIV sd_setImageWithURL:[NSURL URLWithString:data.photo]
                            placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(12) size:CGSizeMake(kRealWidth(54), kRealWidth(54))]];
        } else {
            self.imageIV.image = [UIImage imageNamed:data.photo];
        }
        self.nameLB.textColor = data.isSelect ? HDAppTheme.color.gn_mainColor : HDAppTheme.color.gn_333Color;
        self.imageIV.layer.borderColor = data.isSelect ? HDAppTheme.color.gn_mainColor.CGColor : UIColor.clearColor.CGColor;
        self.imageIV.layer.borderWidth = 1;
        self.imageIV.alpha = 1 - data.alpah;
    }
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(16));
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(kRealWidth(-16));
        make.height.equalTo(self.imageIV.mas_width).multipliedBy(1);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageIV.mas_bottom).offset(kRealWidth(4));
        make.left.mas_equalTo(kRealWidth(2));
        make.right.mas_equalTo(kRealWidth(-2));
    }];

    [super updateConstraints];
}

- (UIImageView *)imageIV {
    if (!_imageIV) {
        _imageIV = UIImageView.new;
        _imageIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(12);
            view.layer.masksToBounds = YES;
            view.clipsToBounds = YES;
        };
    }
    return _imageIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HDAppTheme.color.gn_333Color;
        label.font = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightMedium];
        _nameLB = label;
    }
    return _nameLB;
}

@end

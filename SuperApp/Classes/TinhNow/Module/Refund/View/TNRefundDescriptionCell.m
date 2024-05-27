//
//  TNRefundDescriptionCell.m
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundDescriptionCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAPhotoView.h"
#import "TNApplyRefundModel.h"
#import "TNTakePhotoItemCell.h"


@interface TNRefundDescriptionCell () <HDTextViewDelegate, HXPhotoViewDelegate>
///
@property (nonatomic, strong) UILabel *titleLabel;
///
@property (nonatomic, strong) HDTextView *textView;
///
@property (nonatomic, strong) UIView *line;
///
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) SAPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
///
@property (nonatomic, assign) CGFloat cHeight;
/*
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
*/

@end


@implementation TNRefundDescriptionCell

- (void)hd_setupViews {
    self.dataArray = [NSMutableArray arrayWithObjects:@"", nil];

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.photoView];
    //    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.height.equalTo(@(150.f));
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.bottom.mas_equalTo(self.line.mas_top).offset(-15.f);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(15.f);
        make.height.equalTo(@(self.cHeight));
    }];

    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.scrollView.mas_right);
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
        make.height.equalTo(@(self.cHeight));
        make.width.equalTo(@(kScreenWidth - 30.f));
    }];

    /*
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.bottom.mas_equalTo(self.line.mas_top).offset(-15.f);
        make.height.equalTo(@(self.collectionViewHeight));
        make.top.mas_equalTo(self.textView.mas_bottom).offset(15.f);
    }];
     */

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.height.equalTo(@(PixelOne));
        //        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(20.f);
        make.top.mas_equalTo(self.scrollView.mas_bottom).offset(20.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark -
- (void)setModel:(TNApplyRefundModel *)model {
    _model = model;
    [self.dataArray addObject:[self daultAddItem]];
    //    [self.collectionView reloadData];
    //    [_photoView refreshView];
    [self setNeedsUpdateConstraints];
    //    [self.contentView layoutIfNeeded];
}

- (TNTakePhotoItemCellModel *)daultAddItem {
    TNTakePhotoItemCellModel *addModel = [[TNTakePhotoItemCellModel alloc] init];
    addModel.type = @"add";
    return addModel;
}

/*
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNTakePhotoItemCell *cell = [TNTakePhotoItemCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TNTakePhotoItemCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.item];
    if ([cellModel.type isEqualToString:@"add"]) {

    } else {
        [self.dataArray addObject:@""];
        [self updateCollectionViewHeight];
    }
}
 */
- (void)updateCollectionViewHeight {
    //    [self.collectionView reloadData];
    //    self.cHeight = ceilf(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
    if (self.reloadHander) {
        self.reloadHander();
    }
}

#pragma mark - photo delegate
- (void)photoView:(HXPhotoView *)photoView
    changeComplete:(NSArray<HXPhotoModel *> *)allList
            photos:(NSArray<HXPhotoModel *> *)photos
            videos:(NSArray<HXPhotoModel *> *)videos
          original:(BOOL)isOriginal {
    NSArray *selectPhtotArray = photos;
    [selectPhtotArray enumerateObjectsUsingBlock:^(HXPhotoModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        CGSize size;
        if (isOriginal) {
            size = PHImageManagerMaximumSize;
        } else {
            size = CGSizeMake(model.imageSize.width * 0.8, model.imageSize.height * 0.8);
        }
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil success:nil failed:nil];
    }];

    if (self.selectImageHander) {
        self.selectImageHander(selectPhtotArray);
    }
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame));
    self.cHeight = frame.size.height;
    [self updateCollectionViewHeight];
}

#pragma mark -
- (void)textView:(HDTextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [HDTips showError:[NSString stringWithFormat:SALocalizedString(@"text_not_longer_than", @"文字不能超过 %@ 个字符"), @(textView.maximumTextLength)] inView:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.endInputHander) {
        self.endInputHander(textView.text);
    }
}

#pragma mark -
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = TNLocalizedString(@"tn_refund_desc", @"补充描述和凭证");
        _titleLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15.f];
    }
    return _titleLabel;
}

- (HDTextView *)textView {
    if (!_textView) {
        _textView = HDTextView.new;
        _textView.placeholder = TNLocalizedString(@"tn_refund_desc_detail", @" 请详细填写说明");
        _textView.placeholderColor = HDAppTheme.color.G3;
        _textView.font = HDAppTheme.font.standard3;
        _textView.textColor = HDAppTheme.color.G1;
        _textView.delegate = self;
        _textView.maximumTextLength = 500;
        _textView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
        _textView.layer.cornerRadius = 4.f;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.contentInset = UIEdgeInsetsMake(10.f, 10.f, 0, 0);
    }
    return _textView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.TinhNowColor.lineColor;
    }
    return _line;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15.f, self.textView.hd_bottom, kScreenWidth - 30.f, 100.f)];
    }
    return _scrollView;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoMaxNum = 5;
        _manager.configuration.maxNum = 5;
    }
    return _manager;
}

- (SAPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [SAPhotoView photoManager:self.manager];
        _photoView.delegate = self;
        _photoView.width = kScreenWidth - 30.f;
    }
    return _photoView;
}

/*
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.sectionInsetTop = self.sectionInsetBottom = self.sectionInsetLeft = self.sectionInsetRight = 0;
        self.minimumLineSpacingUpDown = self.minimumInteritemSpacingLeftRight = 5.f;
        self.column = 5;

        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.sectionInset = UIEdgeInsetsMake(self.sectionInsetTop, self.sectionInsetLeft, self.sectionInsetBottom, self.sectionInsetRight);
        self.flowLayout.minimumLineSpacing = self.minimumLineSpacingUpDown;
        self.flowLayout.minimumInteritemSpacing = self.minimumInteritemSpacingLeftRight;
        self.collectionViewHeight = self.itemWidth = ((kScreenWidth - 30 - ((self.column - 1) * self.minimumInteritemSpacingLeftRight)) / self.column);
        self.flowLayout.itemSize = CGSizeMake(self.itemWidth, self.itemWidth);

        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.contentView.backgroundColor;
        [_collectionView registerClass:TNTakePhotoItemCell.class forCellWithReuseIdentifier:TNTakePhotoItemCell.description];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}
 */

@end


@implementation TNRefundDescriptionCellModel

@end

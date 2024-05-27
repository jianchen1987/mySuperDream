//
//  TNTransferTakePhotoView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTransferTakePhotoView.h"
#import "TNAddImageView.h"
#import "TNTransferInputView.h"


@interface TNTransferTakePhotoView () <HXPhotoViewDelegate, HXPhotoViewCellCustomProtocol>
/// 上部分
@property (strong, nonatomic) TNTransferInputView *topView;
///相处选择器
@property (strong, nonatomic) SAPhotoManager *manager;
///图片展示
@property (strong, nonatomic) HXPhotoView *photoView;
/// 底部分割线
@property (strong, nonatomic) UIView *lineView;
/// 选择的照片
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos;
@end


@implementation TNTransferTakePhotoView
- (void)hd_setupViews {
    [self addSubview:self.topView];
    [self addSubview:self.lineView];
    [self addSubview:self.photoView];

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(45));
    }];

    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(kRealWidth(3));
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self).offset(-kRealWidth(15));
        make.width.mas_equalTo(kScreenWidth - kRealWidth(30));
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(PixelOne);
    }];
}
#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView
    changeComplete:(NSArray<HXPhotoModel *> *)allList
            photos:(NSArray<HXPhotoModel *> *)photos
            videos:(NSArray<HXPhotoModel *> *)videos
          original:(BOOL)isOriginal {
    self.selectedPhotos = photos;
    [self.selectedPhotos enumerateObjectsUsingBlock:^(HXPhotoModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        CGSize size;
        if (isOriginal) {
            size = PHImageManagerMaximumSize;
        } else {
            size = CGSizeMake(model.imageSize.width * 0.5, model.imageSize.height * 0.5);
        }
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil success:nil failed:nil];
    }];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    [UIView animateWithDuration:0.25 animations:^{
        [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(frame.size.height);
        }];
        [self layoutIfNeeded];
    }];
}
- (UIView *)customView:(HXPhotoSubViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 4;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = HDAppTheme.TinhNowColor.G4.CGColor;
    UIView *cornerView = [[UIView alloc] init];
    return cornerView;
}
- (CGRect)customViewFrame:(HXPhotoSubViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    return CGRectZero;
}
- (CGRect)customDeleteButtonFrame:(HXPhotoSubViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    CGFloat wh = kRealWidth(15);
    return CGRectMake(cell.width - wh, 0, wh, wh);
}
#pragma mark - setter
- (void)setImageURLs:(NSArray<NSString *> *)imageURLs {
    _imageURLs = imageURLs;
    if (!HDIsArrayEmpty(imageURLs)) {
        // 图片
        NSArray<HXCustomAssetModel *> *images = [imageURLs mapObjectsUsingBlock:^id _Nonnull(NSString *_Nonnull obj, NSUInteger idx) {
            return [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:obj] selected:true];
        }];

        [self.manager addCustomAssetModel:images];
        [self.photoView refreshView];
    }
}
- (void)setHiddenAddAndDeleteBtn:(BOOL)hiddenAddAndDeleteBtn {
    _hiddenAddAndDeleteBtn = hiddenAddAndDeleteBtn;
    self.photoView.hideDeleteButton = hiddenAddAndDeleteBtn;
    self.photoView.showAddCell = !hiddenAddAndDeleteBtn;
    [self.photoView refreshView];
}
/** @lazy topView */
- (TNTransferInputView *)topView {
    if (!_topView) {
        _topView = [[TNTransferInputView alloc] init];
        _topView.leftText = TNLocalizedString(@"tn_tf_voucher", @"转账凭证");
        _topView.hiddenRightView = YES;
        _topView.hiddenBottomLineView = YES;
    }
    return _topView;
}
- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 5;
        _manager.configuration.themeColor = HDAppTheme.TinhNowColor.C1;
    }
    return _manager;
}

- (HXPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [HXPhotoView photoManager:self.manager];
        _photoView.delegate = self;
        _photoView.lineCount = 5;
        _photoView.spacing = 5;
        _photoView.cellCustomProtocol = self;
        _photoView.deleteImageName = @"tn_photo_delete";
        _photoView.addImageName = @"";
        BeginIgnoreClangWarning(-Wundeclared - selector);
        if ([_photoView respondsToSelector:@selector(addModel)]) {
            EndIgnoreClangWarning;
            // clang-format on
            HXPhotoModel *addModel = [_photoView valueForKey:@"addModel"];
            if ([addModel isKindOfClass:HXPhotoModel.class]) {
                TNAddImageView *addImageView = [[TNAddImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
                addImageView.backgroundColor = UIColor.whiteColor;
                [addImageView setNeedsLayout];
                [addImageView layoutIfNeeded];
                UIImage *addImage = [addImageView snapshotImage];
                addModel.thumbPhoto = addImage;
            }
        }
    }
    return _photoView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}

@end

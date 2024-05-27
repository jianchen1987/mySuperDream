//
//  TNTakePhotoView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNTakePhotoView.h"
#import "TNAddImageView.h"


@interface TNTakePhotoView () <HXPhotoViewDelegate, HXPhotoViewCellCustomProtocol>
///相处选择器
@property (strong, nonatomic) SAPhotoManager *manager;
///图片展示
@property (strong, nonatomic) HXPhotoView *photoView;
///
@property (strong, nonatomic) UILabel *titleLabel;
///
@property (strong, nonatomic) TNTakePhotoConfig *config;
/// 选择的照片
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos;
@end


@implementation TNTakePhotoView
- (instancetype)initWithConfig:(TNTakePhotoConfig *)config {
    self.config = config;
    return [super init];
}
- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.photoView];

    if (!self.titleLabel.isHidden) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(self.config.contentInset.left);
            make.right.equalTo(self.mas_right).offset(-self.config.contentInset.right);
            make.top.equalTo(self.mas_top).offset(self.config.contentInset.top);
        }];
    }

    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLabel.isHidden) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(self.config.titleAndImagesSpace);
        } else {
            make.top.equalTo(self.mas_top).offset(self.config.contentInset.top);
        }
        make.left.equalTo(self.mas_left).offset(self.config.contentInset.left);
        make.right.equalTo(self.mas_right).offset(-self.config.contentInset.right);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self).offset(-self.config.contentInset.bottom);
        make.width.mas_equalTo(kScreenWidth - (self.config.contentInset.left + self.config.contentInset.right));
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
- (void)setOnlyRead:(BOOL)onlyRead {
    _onlyRead = onlyRead;
    self.photoView.hideDeleteButton = onlyRead;
    self.photoView.showAddCell = !onlyRead;
    [self.photoView refreshView];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = self.config.desFont;
        _titleLabel.textColor = self.config.desColor;
        if (self.config.desAttr != nil) {
            _titleLabel.attributedText = self.config.desAttr;
        } else {
            if (HDIsStringNotEmpty(self.config.desText)) {
                _titleLabel.text = self.config.desText;
            } else {
                _titleLabel.hidden = YES;
            }
        }
    }
    return _titleLabel;
}
- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = self.config.maxPhotoNum;
        _manager.configuration.themeColor = self.config.themeColor;
    }
    return _manager;
}

- (HXPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [HXPhotoView photoManager:self.manager];
        _photoView.delegate = self;
        _photoView.lineCount = self.config.lineCount;
        _photoView.spacing = self.config.lineSpace;
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
@end

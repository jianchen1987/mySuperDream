//
//  TNAdaptHeightImagesView.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  自适应高度图片

#import "TNAdaptHeightImagesView.h"
#import <HDKitCore.h>
#import <HDUIKit.h>
#import <Masonry/Masonry.h>
#import <SDWebImage.h>


@interface TNAdaptHeightImagesView ()
/// 图片数组
@property (strong, nonatomic) NSArray<TNAdaptImageModel *> *oldImages;
@end


@implementation TNAdaptHeightImagesView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.vMargin = 0;
    }
    return self;
}
- (void)setVMargin:(CGFloat)vMargin {
    _vMargin = vMargin;
}
- (void)setImages:(NSArray<TNAdaptImageModel *> *)images {
    _images = images;
    if (HDIsArrayEmpty(self.oldImages) || ![self.oldImages isEqualToArray:images]) {
        [self createContainerView:images];
        self.oldImages = images;
    }
}
- (void)createContainerView:(NSArray<TNAdaptImageModel *> *)images {
    if (HDIsArrayEmpty(images)) {
        return;
    }
    [self hd_removeAllSubviews];
    UIView *lastView = nil;
    CGFloat width = kScreenWidth - kRealWidth(30);
    @HDWeakify(self);
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        TNAdaptImageModel *picModel = images[i];
        NSString *imgStr = picModel.imgUrl;
        [self addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
        [imageView addGestureRecognizer:tap];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            if (picModel.imageHeight > 0) {
                make.height.mas_equalTo(picModel.imageHeight);
            } else {
                make.height.mas_equalTo(kScreenWidth - kRealWidth(30));
            }
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(self.vMargin);
            } else {
                make.top.equalTo(self);
            }
            if (i == images.count - 1) {
                make.bottom.equalTo(self.mas_bottom);
            }
        }];
        lastView = imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(width, width)]
                            completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                @HDStrongify(self);
                                if (picModel.imageHeight <= 0 && image != nil) {
                                    CGFloat height = image.size.height / image.size.width * width;
                                    picModel.imageHeight = height;
                                    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                                        make.height.mas_equalTo(height > 0 ? height : width);
                                    }];
                                    @HDWeakify(self);
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        @HDStrongify(self);
                                        if (self.getRealImageSizeCallBack) {
                                            self.getRealImageSizeCallBack();
                                        }
                                        if (self.getRealImageSizeAndIndexCallBack) {
                                            self.getRealImageSizeAndIndexCallBack(i, height);
                                        }
                                    });
                                }
                            }];
    }
}
- (void)imageViewClick:(UITapGestureRecognizer *)tap {
    if (self.imageViewClickCallBack) {
        UIImageView *imageView = (UIImageView *)tap.view;
        NSInteger index = imageView.tag;
        TNAdaptImageModel *model = self.images[index];
        self.imageViewClickCallBack(index, model.imgUrl, imageView);
    }
}
@end

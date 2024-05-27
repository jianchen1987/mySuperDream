//
//  TNProductDetailPublicImgCell.m
//  SuperApp
//
//  Created by xixi_wen on 2021/11/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDetailPublicImgCell.h"
#import "HDWebImageManager.h"


@interface TNProductDetailPublicImgCell ()
@property (nonatomic, strong) UIImageView *imgView;
///
@property (strong, nonatomic) TNProductDetailPublicImgCellModel *oldModel;
@end


@implementation TNProductDetailPublicImgCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    if (!self.model.notSetCellInset) {
        newFrame.origin.x = kRealWidth(8);
        newFrame.size.width = kScreenWidth - kRealWidth(16);
    }
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.imgView];
}

- (void)updateConstraints {
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(self.model.imageHeight > 0 ? self.model.imageHeight : 0);
    }];
    [super updateConstraints];
}

- (void)setModel:(TNProductDetailPublicImgCellModel *)model {
    _model = model;
    if (HDIsObjectNil(self.oldModel) || ![model.publicDetailImgUrl isEqualToString:self.oldModel.publicDetailImgUrl]) {
        [HDWebImageManager setImageWithURL:_model.publicDetailImgUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, 200)] imageView:self.imgView
                                 completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                     //按照比例 计算出imgView高度
                                     // 有数据就不用 刷新了
                                     if (image != nil && self.model.imageHeight <= 0) {
                                         self.model.imageHeight = kScreenWidth * image.size.height / image.size.width;
                                         [self setNeedsUpdateConstraints];
                                         if (self.getImageViewHeightCallBack) {
                                             self.getImageViewHeightCallBack();
                                         }
                                     }
                                 }];
        self.oldModel = model;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor redColor];
    }
    return _imgView;
}
@end


@implementation TNProductDetailPublicImgCellModel

@end

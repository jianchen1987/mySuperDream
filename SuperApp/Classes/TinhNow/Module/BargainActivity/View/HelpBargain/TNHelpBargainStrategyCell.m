//
//  TNHelpBargainStrategyCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHelpBargainStrategyCell.h"
#import "TNAdaptHeightImagesView.h"


@interface TNHelpBargainStrategyCell ()
/// 圆角背景
@property (strong, nonatomic) TNAdaptHeightImagesView *bgView;
@end


@implementation TNHelpBargainStrategyCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
    [self.contentView addSubview:self.bgView];
}
- (void)setModel:(TNBargainDetailModel *)model {
    _model = model;
    if (!HDIsArrayEmpty(model.rulePics)) {
        self.bgView.images = model.rulePics;
        @HDWeakify(self);
        self.bgView.getRealImageSizeCallBack = ^{
            @HDStrongify(self);
            if (self.getRealImageSizeCallBack) {
                self.getRealImageSizeCallBack();
            }
        };
    }
    //砍价攻略
    //    [self.bgView hd_removeAllSubviews];
    //    UIView *lastView = nil;
    //    CGFloat width = kScreenWidth - kRealWidth(30);
    //    @HDWeakify(self);
    //    for (int i = 0; i < model.rulePics.count; i++) {
    //        UIImageView *imageView = [[UIImageView alloc] init];
    //        TNAdaptPicModel *picModel = model.rulePics[i];
    //        NSString *imgStr = picModel.pic;
    //        [self.bgView addSubview:imageView];
    //        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.right.equalTo(self.bgView);
    //            if (picModel.picHeight > 0) {
    //                make.height.mas_equalTo(picModel.picHeight);
    //            } else {
    //                make.height.mas_equalTo(width);
    //            }
    //            if (lastView) {
    //                make.top.equalTo(lastView.mas_bottom);
    //            } else {
    //                make.top.equalTo(self.bgView);
    //            }
    //            if (i == model.rulePics.count - 1) {
    //                make.bottom.equalTo(self.bgView.mas_bottom);
    //            }
    //        }];
    //        lastView = imageView;
    //        [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr]
    //                     placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(width, width)]
    //                            completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
    //                                @HDStrongify(self);
    //                                if (picModel.picHeight <= 0 && image != nil) {
    //                                    CGFloat height = image.size.height / image.size.width * width;
    //                                    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
    //                                        make.height.mas_equalTo(height);
    //                                    }];
    //                                    picModel.picHeight = height;
    //                                    @HDWeakify(self);
    //                                    dispatch_async(dispatch_get_main_queue(), ^{
    //                                        @HDStrongify(self);
    //                                        if (self.getRealImageSizeCallBack) {
    //                                            self.getRealImageSizeCallBack();
    //                                        }
    //                                    });
    //                                }
    //                            }];
    //    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    [super updateConstraints];
}
/** @lazy bgView */
- (TNAdaptHeightImagesView *)bgView {
    if (!_bgView) {
        _bgView = [[TNAdaptHeightImagesView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _bgView;
}
@end

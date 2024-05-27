//
//  TNAdaptImagesCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNAdaptImagesCell.h"
#import "TNAdaptHeightImagesView.h"


@interface TNAdaptImagesCell ()
/// 图片背景视图
@property (strong, nonatomic) TNAdaptHeightImagesView *imgsBgView;
@end


@implementation TNAdaptImagesCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.imgsBgView];
}
- (void)updateConstraints {
    [self.imgsBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
- (void)setImages:(NSArray<TNAdaptImageModel *> *)images {
    if (HDIsArrayEmpty(images)) {
        return;
    }
    self.imgsBgView.images = images;
}
/** @lazy imgsBgView */
- (TNAdaptHeightImagesView *)imgsBgView {
    if (!_imgsBgView) {
        _imgsBgView = [[TNAdaptHeightImagesView alloc] init];
        @HDWeakify(self);
        _imgsBgView.getRealImageSizeCallBack = ^{
            @HDStrongify(self);
            if (self.getRealImageSizeCallBack) {
                self.getRealImageSizeCallBack();
            }
        };
    }
    return _imgsBgView;
}
@end

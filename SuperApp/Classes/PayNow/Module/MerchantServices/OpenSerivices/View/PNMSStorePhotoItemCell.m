//
//  PNMSStorePhotoItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStorePhotoItemCell.h"
#import "PNUtilMacro.h"


@interface PNMSStorePhotoItemCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) HDUIButton *btn;
@property (nonatomic, strong) HDUIButton *deleteBtn;

@end


@implementation PNMSStorePhotoItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.deleteBtn];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(kRealWidth(80), kRealWidth(80))));
        make.top.left.bottom.equalTo(self.contentView);
    }];

    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.deleteBtn.imageView.image.size);
        make.top.mas_equalTo(self.imageView.mas_top);
        make.right.mas_equalTo(self.imageView.mas_right);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark
- (void)setModel:(PNMSStorePhotoItemModel *)model {
    _model = model;
    if ([self.model.url.lowercaseString hasPrefix:@"http"]) {
        [HDWebImageManager setImageWithURL:self.model.url size:CGSizeMake(kRealWidth(80), kRealWidth(80)) placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_square"] imageView:self.imageView];
        self.deleteBtn.hidden = NO;
    } else {
        if (WJIsStringEmpty(self.model.url)) {
            self.imageView.image = [UIImage imageNamed:@"pn_ms_add_photo"];
        } else {
            self.imageView.image = [UIImage imageNamed:self.model.url];
        }
        self.deleteBtn.hidden = YES;
    }
}

#pragma mark
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //        imageView.image = [UIImage imageNamed:@"pn_ms_add_photo"];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = kRealWidth(4);
        _imageView = imageView;
    }
    return _imageView;
}

- (HDUIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"pn_photo_delete_icon"] forState:0];
        @HDWeakify(self);
        [_deleteBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            !self.deleteBlock ?: self.deleteBlock();
        }];
    }
    return _deleteBtn;
}

@end

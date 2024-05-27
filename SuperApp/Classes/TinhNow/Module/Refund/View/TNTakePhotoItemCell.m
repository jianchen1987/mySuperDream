//
//  TNTakePhotoItemCell.m
//  SuperApp
//
//  Created by xixi on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTakePhotoItemCell.h"


@interface TNTakePhotoItemCell ()
///
@property (nonatomic, strong) UIImageView *showImgView;
///
@property (nonatomic, strong) UIButton *deleteBtn;
///
@property (nonatomic, strong) UIImageView *iconCameraImgView;
@end


@implementation TNTakePhotoItemCell

- (void)hd_setupViews {
    //    self.contentView.layer.cornerRadius = 4.;
    //    self.contentView.layer.borderWidth = 1;
    //    self.contentView.layer.borderColor = HexColor(0xE4E5EA).CGColor;

    [self.contentView addSubview:self.showImgView];
    [self.contentView addSubview:self.iconCameraImgView];
    [self.contentView addSubview:self.deleteBtn];
}

- (void)updateConstraints {
    [self.showImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.deleteBtn.imageView.image.size);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];

    [self.iconCameraImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconCameraImgView.image.size);
        make.center.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

//- (void)setModel:(TNTakePhotoItemCellModel *)model {
//    if ([model.type isEqualToString:@"add"]) {
//        self.deleteBtn.hidden = YES;
//        self.iconCameraImgView.hidden = NO;
//    } else {
//        self.deleteBtn.hidden = NO;
//        self.iconCameraImgView.hidden = YES;
//        self.showImgView.image = model.imageData;
//    }
//}

- (void)setImgURL:(NSString *)imgURL {
    _imgURL = imgURL;
    [HDWebImageManager setImageWithURL:imgURL placeholderImage:nil imageView:self.showImgView];
    self.showImgView.hidden = NO;
    self.deleteBtn.hidden = YES;
    self.iconCameraImgView.hidden = YES;

    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (UIImageView *)showImgView {
    if (!_showImgView) {
        _showImgView = [[UIImageView alloc] init];
        _showImgView.backgroundColor = [UIColor whiteColor];
        _showImgView.contentMode = UIViewContentModeScaleAspectFill;
        _showImgView.clipsToBounds = YES;
        _showImgView.layer.cornerRadius = 4.f;
    }
    return _showImgView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"tn_refund_small_close"] forState:0];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

- (UIImageView *)iconCameraImgView {
    if (!_iconCameraImgView) {
        _iconCameraImgView = [[UIImageView alloc] init];
        _iconCameraImgView.image = [UIImage imageNamed:@"tn_icon_refund_camera"];
        _iconCameraImgView.hidden = YES;
    }
    return _iconCameraImgView;
}

@end


@implementation TNTakePhotoItemCellModel

@end

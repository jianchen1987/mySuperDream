//
//  SAAddOrModifyAddressDemoView.m
//  SuperApp
//
//  Created by seeu on 2020/8/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressDemoView.h"


@interface SAAddOrModifyAddressDemoView ()
/// 提示框
@property (nonatomic, strong) UILabel *tipsLabel;
/// 图片1
@property (nonatomic, strong) UIImageView *image1;
/// text1
@property (nonatomic, strong) UILabel *title1;
/// 图片2
@property (nonatomic, strong) UIImageView *image2;
/// text2
@property (nonatomic, strong) UILabel *title2;
@end


@implementation SAAddOrModifyAddressDemoView

- (void)hd_setupViews {
    [self addSubview:self.tipsLabel];
    [self addSubview:self.image1];
    [self addSubview:self.title1];
    [self addSubview:self.image2];
    [self addSubview:self.title2];

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView:)];
    [self.image1 addGestureRecognizer:tap1];
    [self.image2 addGestureRecognizer:tap2];
    self.image1.userInteractionEnabled = YES;
    self.image2.userInteractionEnabled = YES;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsLabel.mas_left);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(kRealHeight(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(108), kRealWidth(108)));
    }];

    [self.title1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image1.mas_left);
        make.right.equalTo(self.image1.mas_right);
        make.top.equalTo(self.image1.mas_bottom).offset(kRealWidth(7));
        make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-15);
    }];

    [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image1.mas_right).offset(kRealWidth(10));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(kRealHeight(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(108), kRealWidth(108)));
    }];

    [self.title2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image2.mas_left);
        make.right.equalTo(self.image2.mas_right);
        make.top.equalTo(self.image2.mas_bottom).offset(kRealWidth(7));
        make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-15);
    }];

    [super updateConstraints];
}

#pragma mark - private methods
- (void)clickOnImageView:(UITapGestureRecognizer *)recognizer {
    __block UIImageView *imageView = (UIImageView *)recognizer.view;

    YBIBImageData *data = [YBIBImageData new];
    data.projectiveView = imageView;
    data.image = ^UIImage *_Nullable {
        return imageView.image;
    };

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = @[data];
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);

    //    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    //    toolViewHandler.sourceView = self.bannerView;
    //    toolViewHandler.saveImageResultBlock = ^(UIImage *_Nonnull image, NSError *_Nullable error) {
    //        if (error != NULL) {
    //            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_failed", @"图片保存失败") type:HDTopToastTypeError];
    //        } else {
    //            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_success", @"图片保存成功") type:HDTopToastTypeSuccess];
    //        }
    //    };
    //    //    toolViewHandler.updateProjectiveViewBlock = ^UIView *_Nonnull(NSUInteger index) {
    //    //        return index < self.model.images.count ? self.model.subviews[index] : self.imageContainer.subviews.lastObject;
    //    //    };
    //    browser.toolViewHandlers = @[toolViewHandler];

    [browser show];
}

#pragma mark - lazy load
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = HDAppTheme.font.standard4;
        _tipsLabel.textColor = HDAppTheme.color.G3;
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = SALocalizedString(@"upload_house_number_delivery_address",
                                            @"Upload the house number of the delivery address, the street view of the door or the surrounding area can help the delivery man find you faster and avoid "
                                            @"delaying your item.");
    }
    return _tipsLabel;
}

- (UIImageView *)image1 {
    if (!_image1) {
        _image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo1"]];
    }
    return _image1;
}

- (UILabel *)title1 {
    if (!_title1) {
        _title1 = [[UILabel alloc] init];
        _title1.font = HDAppTheme.font.standard4;
        _title1.textColor = HDAppTheme.color.G1;
        _title1.textAlignment = NSTextAlignmentCenter;
        _title1.numberOfLines = 0;
        _title1.text = SALocalizedString(@"doorway_photo", @"Doorway Photo");
    }
    return _title1;
}

- (UIImageView *)image2 {
    if (!_image2) {
        _image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo2"]];
    }
    return _image2;
}

- (UILabel *)title2 {
    if (!_title2) {
        _title2 = [[UILabel alloc] init];
        _title2.font = HDAppTheme.font.standard4;
        _title2.textColor = HDAppTheme.color.G1;
        _title2.textAlignment = NSTextAlignmentCenter;
        _title2.numberOfLines = 0;
        _title2.text = SALocalizedString(@"house_number", @"House Number");
    }
    return _title2;
}
@end

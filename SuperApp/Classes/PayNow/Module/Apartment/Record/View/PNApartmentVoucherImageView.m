//
//  PNApartmentVoucherImageView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/3.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNApartmentVoucherImageView.h"


@interface PNApartmentVoucherImageView ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) SALabel *countLabel;
@property (nonatomic, strong) HDUIButton *btn;
@end


@implementation PNApartmentVoucherImageView

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.imgView];
    [self addSubview:self.countLabel];
    [self addSubview:self.btn];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(12));
    }];

    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(58), kRealWidth(58)));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(12));
    }];

    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.imgView);
    }];

    [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imgView);
    }];

    [super updateConstraints];
}

- (void)setImagesURL:(NSArray *)imagesURL {
    _imagesURL = imagesURL;

    self.countLabel.text = [NSString stringWithFormat:@"%zd", imagesURL.count];

    NSString *url = @"";
    if (imagesURL.count > 0) {
        url = imagesURL.firstObject;
    }

    [HDWebImageManager setImageWithURL:url placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(58), kRealWidth(58))] imageView:self.imgView];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];

    for (NSString *url in self.imagesURL) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:url];
        // 这里固定只是从此处开始投影，滑动时会更新投影控件
        data.projectiveView = projectiveView;
        [datas addObject:data];
    }

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = 0;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);

    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self.imgView;
    toolViewHandler.saveImageResultBlock = ^(UIImage *_Nonnull image, NSError *_Nullable error) {
        if (error != NULL) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_failed", @"图片保存失败") type:HDTopToastTypeError];
        } else {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_success", @"图片保存成功") type:HDTopToastTypeSuccess];
        }
    };

    browser.toolViewHandlers = @[toolViewHandler];

    [browser show];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.text = PNLocalizedString(@"pn_Payment_voucher", @"缴费凭证");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = kRealWidth(4);
        _imgView.layer.masksToBounds = YES;
        _imgView = imageView;
    }
    return _imgView;
}

- (SALabel *)countLabel {
    if (!_countLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.backgroundColor = HDAppTheme.PayNowColor.c333333;
        label.hd_edgeInsets = UIEdgeInsetsMake(2, 4, 2, 4);
        label.textAlignment = NSTextAlignmentCenter;

        label.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomLeft radius:kRealWidth(4)];
        };
        _countLabel = label;
    }
    return _countLabel;
}

- (HDUIButton *)btn {
    if (!_btn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self showImageBrowserWithInitialProjectiveView:self.imgView];
        }];

        _btn = button;
    }
    return _btn;
}
@end

//
//  PNGuarateenDetailAttachmentView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/12.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenDetailAttachmentView.h"


@interface PNGuarateenDetailAttachmentView ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIImageView *valueImgView;
@property (nonatomic, strong) SALabel *countLabel;
@property (nonatomic, strong) HDUIButton *clickBtn;
@end


@implementation PNGuarateenDetailAttachmentView

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.valueImgView];
    [self.valueImgView addSubview:self.countLabel];
    [self addSubview:self.clickBtn];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    [self.valueImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(4));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(12));
    }];

    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.valueImgView);
    }];

    [self.clickBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.left.mas_equalTo(self.valueImgView.mas_left).offset(-kRealWidth(12));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setImages:(NSArray *)images {
    _images = images;

    if (!WJIsArrayEmpty(images)) {
        [HDWebImageManager setImageWithURL:self.images.firstObject size:CGSizeMake(kRealWidth(32), kRealWidth(32))
                          placeholderImage:[HDHelper placeholderImageWithCornerRadius:22 size:CGSizeMake(kRealWidth(32), kRealWidth(32))]
                                 imageView:self.valueImgView];
        self.countLabel.text = [NSString stringWithFormat:@"+%zd", images.count];
    }

    [self setNeedsUpdateConstraints];
}

- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];

    for (NSString *url in self.images) {
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
    toolViewHandler.sourceView = self.valueImgView;
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
        label.text = PNLocalizedString(@"iU6StRW0", @"附件");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)valueImgView {
    if (!_valueImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _valueImgView = imageView;

        _valueImgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(2)];
        };
    }
    return _valueImgView;
}

- (SALabel *)countLabel {
    if (!_countLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textAlignment = NSTextAlignmentCenter;
        _countLabel = label;
    }
    return _countLabel;
}

- (HDUIButton *)clickBtn {
    if (!_clickBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self showImageBrowserWithInitialProjectiveView:self.valueImgView];
        }];

        _clickBtn = button;
    }
    return _clickBtn;
}
@end

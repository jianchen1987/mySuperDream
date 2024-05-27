//
//  TNWithDrawDetailCertificateCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithDrawDetailCertificateCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"


@interface TNWithDrawDetailCertificateCell ()
@property (strong, nonatomic) UILabel *titleLabel;       ///< 标题
@property (strong, nonatomic) UIImageView *payImageView; ///<付款凭证图片
@property (strong, nonatomic) UIView *lineView;          ///< 分割线
@end


@implementation TNWithDrawDetailCertificateCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.payImageView];
    [self.contentView addSubview:self.lineView];
}
- (void)setModel:(TNWithDrawDetailCertificateCellModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.voucher placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(90, 90)] imageView:self.payImageView];
}
- (void)imageClick {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];
    YBIBImageData *data = [YBIBImageData new];
    data.imageURL = [NSURL URLWithString:self.model.voucher];
    // 这里固定只是从此处开始投影，滑动时会更新投影控件
    data.projectiveView = self.payImageView;
    [datas addObject:data];

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = 0;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);

    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self.payImageView;
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

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(18));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.payImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(90), kRealWidth(90)));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payImageView.mas_bottom).offset(kRealWidth(20));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _titleLabel.text = TNLocalizedString(@"7BN04Y3L", @"付款凭证");
    }
    return _titleLabel;
}
/** @lazy payImageView */
- (UIImageView *)payImageView {
    if (!_payImageView) {
        _payImageView = [[UIImageView alloc] init];
        _payImageView.contentMode = UIViewContentModeScaleAspectFill;
        _payImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
        [_payImageView addGestureRecognizer:tap];
    }
    return _payImageView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(0xD6DBE8);
    }
    return _lineView;
}
@end


@implementation TNWithDrawDetailCertificateCellModel

@end

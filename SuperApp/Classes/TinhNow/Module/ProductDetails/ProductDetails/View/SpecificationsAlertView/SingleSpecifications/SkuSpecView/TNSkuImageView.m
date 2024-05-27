//
//  TNSkuImageView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSkuImageView.h"


@interface TNSkuImageView ()
/// 商品图片
@property (nonatomic, strong) UIImageView *imageView;
/// 放大提示按钮图片
@property (strong, nonatomic) HDUIButton *promptBtn;
@end


@implementation TNSkuImageView
- (void)hd_setupViews {
    [self addSubview:self.imageView];
    [self.imageView addSubview:self.promptBtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageHandler:)];
    [self.imageView addGestureRecognizer:tap];
}
#pragma mark - 查看大图
- (void)clickedImageHandler:(UITapGestureRecognizer *)recognizer {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];
    YBIBImageData *data = [YBIBImageData new];
    data.imageURL = [NSURL URLWithString:self.largeImageUrl];
    // 这里固定只是从此处开始投影，滑动时会更新投影控件
    data.projectiveView = self.imageView;
    [datas addObject:data];


    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = 0;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);

    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self;
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
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.promptBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.imageView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [super updateConstraints];
}
- (void)setThumbnail:(NSString *)thumbnail {
    _thumbnail = thumbnail;
    [HDWebImageManager setImageWithURL:thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(100, 100)] imageView:self.imageView];
}
- (void)setLargeImageUrl:(NSString *)largeImageUrl {
    _largeImageUrl = largeImageUrl;
}
/** @lazy productImageView */
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _imageView;
}
/** @lazy promptBtn */
- (HDUIButton *)promptBtn {
    if (!_promptBtn) {
        _promptBtn = [[HDUIButton alloc] init];
        [_promptBtn setImage:[UIImage imageNamed:@"tn_big_photo_prompt"] forState:UIControlStateNormal];
        _promptBtn.userInteractionEnabled = NO;
        _promptBtn.backgroundColor = [UIColor colorWithRed:52 / 255.0 green:59 / 255.0 blue:77 / 255.0 alpha:0.50];
        _promptBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:8];
        };
    }
    return _promptBtn;
}
@end

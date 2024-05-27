//
//  TNReviewImageView.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNReviewImageView.h"
#define imageSpace kRealWidth(10)
#define imageWH (kScreenWidth - kRealWidth(80) - imageSpace * 2) / 3


@interface TNReviewImageView ()
/// 标签数量
@property (strong, nonatomic) HDLabel *numTagLabel;
/// 图片数组
@property (strong, nonatomic) NSMutableArray *imgViewArr;
@end


@implementation TNReviewImageView
- (void)hd_setupViews {
    //最多三张图片
    [self.imgViewArr removeAllObjects];
    UIView *lastView = nil;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [self.imgViewArr addObject:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.hd_associatedObject = [NSNumber numberWithInteger:i];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageHandler:)];
        [imageView addGestureRecognizer:recognizer];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.height.mas_equalTo(imageWH);
            if (lastView == nil) {
                make.left.equalTo(self);
            } else {
                make.left.equalTo(lastView.mas_right).offset(imageSpace);
            }
        }];
        lastView = imageView;
        imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    [self addSubview:self.numTagLabel];
}
- (void)setImages:(NSArray *)images {
    _images = images;
    if (images.count > 3) {
        self.numTagLabel.hidden = NO;
        NSString *showTxt = [NSString stringWithFormat:@"3/%ld", images.count];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:showTxt];
        [attr addAttribute:NSFontAttributeName value:HDAppTheme.TinhNowFont.standard15 range:[showTxt rangeOfString:@"3"]];
        self.numTagLabel.attributedText = attr;
    } else {
        self.numTagLabel.hidden = YES;
    }
    for (UIImageView *imgView in self.imgViewArr) {
        imgView.hidden = YES;
    }
    for (int i = 0; i < images.count; i++) {
        if (i == self.imgViewArr.count) {
            break;
        }
        UIImageView *imgView = self.imgViewArr[i];
        imgView.hidden = NO;
        NSString *imgUrl = images[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(90), kRealWidth(90))]];
    }
}
#pragma mark - event response
- (void)clickedImageHandler:(UITapGestureRecognizer *)recognizer {
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (imageView && [imageView isKindOfClass:UIImageView.class]) {
        NSInteger index = ((NSNumber *)(imageView.hd_associatedObject)).integerValue;
        [self showImageBrowserWithInitialProjectiveView:imageView index:index];
    }
}
#pragma mark - private methods
/// 展示图片浏览器
- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView index:(NSUInteger)index {
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
    browser.currentPage = index;
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
    toolViewHandler.updateProjectiveViewBlock = ^UIView *_Nonnull(NSUInteger index) {
        return index < self.subviews.count ? self.subviews[index] : self.subviews.lastObject;
    };
    browser.toolViewHandlers = @[toolViewHandler];
    [browser show];
}
- (void)updateConstraints {
    [self.numTagLabel sizeToFit];
    [self.numTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kRealWidth(5));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(5));
    }];
    [super updateConstraints];
}
/** @lazy numTagLabel */
- (HDLabel *)numTagLabel {
    if (!_numTagLabel) {
        _numTagLabel = [[HDLabel alloc] init];
        _numTagLabel.textColor = [UIColor whiteColor];
        _numTagLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.50];
        _numTagLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 9, 2, 9);
        _numTagLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _numTagLabel.hidden = YES;
        _numTagLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:15];
        };
    }
    return _numTagLabel;
}
/** @lazy imgArr */
- (NSMutableArray *)imgViewArr {
    if (!_imgViewArr) {
        _imgViewArr = [NSMutableArray array];
    }
    return _imgViewArr;
}
@end

//
//  TNStoreSceneCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreSceneCell.h"
#import "TNAdaptHeightImagesView.h"


@interface TNStoreSceneCell ()
/// 文本
@property (strong, nonatomic) UILabel *nameLabel;
/// 更多按钮
@property (strong, nonatomic) UIButton *moreBtn;
/// 图片容器
@property (strong, nonatomic) TNAdaptHeightImagesView *imageContainer;
///底部分割线
@property (strong, nonatomic) UIView *sectionView;

@end


@implementation TNStoreSceneCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.imageContainer];
    [self.contentView addSubview:self.sectionView];
    self.backgroundColor = [UIColor whiteColor];
}
- (void)setModel:(TNStoreSceneModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.moreBtn.hidden = !model.isNeedShowMoreBtn;
    self.moreBtn.selected = model.showAllText;
    if (model.showAllText) {
        self.nameLabel.numberOfLines = 0;
    } else {
        self.nameLabel.numberOfLines = 3;
    }
    if (!HDIsArrayEmpty(model.storeLiveImageModels)) {
        self.imageContainer.images = model.storeLiveImageModels;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    if (!self.moreBtn.isHidden) {
        [self.moreBtn sizeToFit];
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(5));
            make.height.mas_equalTo(kRealWidth(21));
        }];
    }
    [self.imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.moreBtn.isHidden) {
            make.top.equalTo(self.moreBtn.mas_bottom).offset(kRealWidth(5));
        } else {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(5));
        }
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(self.model.imagesHeight);
    }];
    [self.sectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(10));
    }];

    [super updateConstraints];
}
- (void)moreClick {
    self.moreBtn.selected = !self.moreBtn.selected;
    self.model.showAllText = self.moreBtn.selected;
    if (self.moreClickCallBack) {
        self.moreClickCallBack(self.model.showAllText);
    }
}
- (void)imageClick:(UITapGestureRecognizer *)tap {
    [self showImageBrowserWithInitialProjectiveView:tap.view index:tap.view.tag];
}
/// 展示图片浏览器
/// @param projectiveView 默认投影 View
/// @param index 默认起始索引
- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView index:(NSUInteger)index {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];
    for (NSString *imageStr in self.model.storeLiveImage) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:imageStr];
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
    toolViewHandler.sourceView = projectiveView;
    toolViewHandler.saveImageResultBlock = ^(UIImage *_Nonnull image, NSError *_Nullable error) {
        if (error != NULL) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_failed", @"图片保存失败") type:HDTopToastTypeError];
        } else {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_success", @"图片保存成功") type:HDTopToastTypeSuccess];
        }
    };
    browser.toolViewHandlers = @[toolViewHandler];
    toolViewHandler.updateProjectiveViewBlock = ^UIView *_Nonnull(NSUInteger index) {
        return index < self.imageContainer.subviews.count ? self.imageContainer.subviews[index] : self.imageContainer.subviews.lastObject;
    };
    [browser show];
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15M;
        _nameLabel.numberOfLines = 3;
    }
    return _nameLabel;
}
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        //        _moreBtn.hd_eventTimeInterval = 0.01;
        [_moreBtn setTitleColor:[UIColor hd_colorWithHexString:@"#FD9626"] forState:UIControlStateNormal];
        [_moreBtn setTitle:TNLocalizedString(@"tn_store_more", @"更多") forState:UIControlStateNormal];
        [_moreBtn setTitle:TNLocalizedString(@"tn_store_less", @"收起") forState:UIControlStateSelected];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
- (TNAdaptHeightImagesView *)imageContainer {
    if (!_imageContainer) {
        _imageContainer = [[TNAdaptHeightImagesView alloc] init];
        _imageContainer.vMargin = kRealWidth(5);
        @HDWeakify(self);
        _imageContainer.getRealImageSizeAndIndexCallBack = ^(NSInteger index, CGFloat imageHeight) {
            @HDStrongify(self);
            if (self.getRealImageSizeCallBack) {
                self.getRealImageSizeCallBack();
            }
        };
        _imageContainer.imageViewClickCallBack = ^(NSInteger index, NSString *_Nonnull imgUrl, UIImageView *_Nonnull imageView) {
            @HDStrongify(self);
            [self showImageBrowserWithInitialProjectiveView:imageView index:index];
        };
    }
    return _imageContainer;
}
- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return _sectionView;
}
@end

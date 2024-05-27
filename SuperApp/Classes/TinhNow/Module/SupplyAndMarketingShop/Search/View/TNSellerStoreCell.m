//
//  TNSellerStoreCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerStoreCell.h"
#import "TNGlobalData.h"


@interface TNSellerStoreCell ()
@property (strong, nonatomic) UIImageView *storeImageView; ///< 店铺图片
@property (strong, nonatomic) UILabel *storeNameLabel;     ///<店铺名称
@property (strong, nonatomic) UILabel *productNumLabel;    ///<商品数量
@property (strong, nonatomic) HDUIButton *storeBtn;        ///< 进入店铺
@end


@implementation TNSellerStoreCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.storeImageView];
    [self.contentView addSubview:self.storeNameLabel];
    [self.contentView addSubview:self.productNumLabel];
    [self.contentView addSubview:self.storeBtn];
}
- (void)setModel:(TNSellerStoreModel *)model {
    _model = model;
    [self setStoreNameLabelText];
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(60, 60)] imageView:self.storeImageView];
    self.productNumLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"Number of commodities", @"商品数"), model.productNum];
}
- (void)setStoreNameLabelText {
    if ([self.model.storeTypeName isEqualToString:TNStoreTypeOverseasShopping]) {
        UIImage *globalImage = [UIImage imageNamed:@"tn_global_k"];
        NSString *name = [NSString stringWithFormat:@"%@ ", self.model.storeName];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
        NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
        imageMent.image = globalImage;
        UIFont *font = [HDAppTheme.TinhNowFont fontSemibold:15];
        CGFloat paddingTop = font.lineHeight - font.pointSize;
        imageMent.bounds = CGRectMake(0, -paddingTop, globalImage.size.width, globalImage.size.height);
        NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:imageMent];
        [text appendAttributedString:attachment];
        [text addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, name.length)];
        self.storeNameLabel.attributedText = text;
    } else {
        self.storeNameLabel.text = self.model.storeName;
    }
}
- (void)updateConstraints {
    [self.storeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(60), kRealWidth(60)));
    }];
    [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeImageView.mas_top);
        make.left.equalTo(self.storeImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.productNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.storeImageView.mas_bottom);
        make.leading.equalTo(self.storeNameLabel.mas_leading);
        make.right.lessThanOrEqualTo(self.storeBtn.mas_left).offset(-kRealWidth(15));
    }];
    [self.storeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.storeImageView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(110), kRealWidth(25)));
    }];
    [super updateConstraints];
}
/** @lazy storeImageView */
- (UIImageView *)storeImageView {
    if (!_storeImageView) {
        _storeImageView = [[UIImageView alloc] init];
        _storeImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _storeImageView;
}
/** @lazy storeNameLabel */
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _storeNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _storeNameLabel.numberOfLines = 1;
    }
    return _storeNameLabel;
}
/** @lazy productNumLabel */
- (UILabel *)productNumLabel {
    if (!_productNumLabel) {
        _productNumLabel = [[UILabel alloc] init];
        _productNumLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        _productNumLabel.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _productNumLabel;
}
/** @lazy storeBtn */
- (HDUIButton *)storeBtn {
    if (!_storeBtn) {
        _storeBtn = [[HDUIButton alloc] init];
        _storeBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _storeBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        _storeBtn.titleEdgeInsets = UIEdgeInsetsMake(4, 20, 4, 20);
        [_storeBtn setTitle:TNLocalizedString(@"IvMdlQpA", @"进入店铺") forState:UIControlStateNormal];
        _storeBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        @HDWeakify(self);
        [_storeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"isFromProductCenter": @"1", @"sp": [TNGlobalData shared].seller.supplierId, @"storeNo": self.model.storeNo}];
        }];
    }
    return _storeBtn;
}
@end

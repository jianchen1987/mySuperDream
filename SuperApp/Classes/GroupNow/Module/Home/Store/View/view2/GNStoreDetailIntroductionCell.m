//
//  GNStoreDetailIntroductionCell.m
//  SuperApp
//
//  Created by wmz on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStoreDetailIntroductionCell.h"
#import "GNImageTableViewCell.h"
#import "GNStringUntils.h"


@interface GNStoreDetailIntroductionCell ()
///图标
@property (nonatomic, strong) UIImageView *iconIV;
/// name
@property (nonatomic, strong) YYLabel *nameLB;

@end


@implementation GNStoreDetailIntroductionCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.iconIV];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            make.top.mas_equalTo(kRealWidth(8));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(120));
        }
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            make.left.right.equalTo(self.iconIV);
            make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(8));
        } else {
            make.top.mas_equalTo(kRealWidth(8));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
        }
        make.bottom.mas_equalTo(-kRealWidth(16));
    }];
    [super updateConstraints];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
            view.clipsToBounds = YES;
        };
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction)];
        _iconIV.userInteractionEnabled = YES;
        [_iconIV addGestureRecognizer:ta];
    }
    return _iconIV;
}

- (void)tapImageAction {
    if (HDIsArrayEmpty(self.model.dataSource))
        return;
    NSMutableArray<YBIBImageData *> *marr = [NSMutableArray new];
    for (NSString *model in self.model.dataSource) {
        YBIBImageData *data = [YBIBImageData new];
        if ([model isKindOfClass:NSString.class]) {
            NSString *modelStr = (NSString *)model;
            data.imageURL = [NSURL URLWithString:modelStr];
        }
        [marr addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    GNImageHandle *handle = GNImageHandle.new;
    handle.sourceView = self;
    browser.toolViewHandlers = @[handle];
    browser.dataSourceArray = marr;
    browser.autoHideProjectiveView = false;
    [browser.defaultToolViewHandler yb_hide:YES];
    browser.currentPage = 0;
    [browser show];
}

- (YYLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = YYLabel.new;
        _nameLB.numberOfLines = 3;
        _nameLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(24);
        _nameLB.textVerticalAlignment = YYTextVerticalAlignmentTop;
        @HDWeakify(self)[GNStringUntils addSeeMoreButton:_nameLB more:GNLocalizedString(@"gn_view_more", @"Read more") moreColor:HDAppTheme.color.gn_mainColor before:@"...   "
                                               tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                                   @HDStrongify(self) self.model.select = YES;
                                                   [GNEvent eventResponder:self target:self.nameLB key:@"reloadAction" indexPath:self.model.indexPath];
                                               }];
    }
    return _nameLB;
}

- (void)setGNModel:(GNCellModel *)data {
    if ([data isKindOfClass:GNCellModel.class]) {
        data.notCacheHeight = YES;
        self.model = data;
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:GNFillEmpty(data.title)];
        mstr.yy_font = [HDAppTheme.font gn_ForSize:14];
        mstr.yy_color = HDAppTheme.color.gn_333Color;
        mstr.yy_lineSpacing = kRealWidth(5);
        self.nameLB.numberOfLines = self.model.isSelected ? 0 : 3;
        self.nameLB.attributedText = mstr;
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.imageTitle]
                       placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(347), kRealWidth(120)) logoWidth:kRealWidth(60)]];
        self.iconIV.hidden = !GNStringNotEmpty(data.imageTitle);
        [self setNeedsUpdateConstraints];
    }
}

@end

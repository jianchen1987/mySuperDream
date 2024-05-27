//
//  TNGoodsSortFilterReusableView.m
//  SuperApp
//
//  Created by seeu on 2020/7/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNGoodsSortFilterReusableView.h"
#import "TNNotificationConst.h"
#import "TNSearchViewModel.h"
#import "TNSpecialProductTagView.h"


@interface TNGoodsSortFilterReusableView ()
/// 分类下的描述文本
@property (strong, nonatomic) HDLabel *desLabel;
/// 改变商品展示样式按钮
@property (strong, nonatomic) HDUIButton *changeStyleBtn;
/// 显示横向商品样式
@property (nonatomic, assign) BOOL showHorizontalStyle;
///
@property (strong, nonatomic) TNSpecialProductTagView *tagView;
@end


@implementation TNGoodsSortFilterReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self hd_setupView];
    }
    return self;
}
- (void)hd_setupView {
    self.sortFilterBar = TNSearchSortFilterBar.new;
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.tagView];
    [self addSubview:self.sortFilterBar];
    [self addSubview:self.desLabel];
    [self addSubview:self.changeStyleBtn];
}
- (void)setShowChangeProductDisplayStyleBtn:(BOOL)showChangeProductDisplayStyleBtn {
    _showChangeProductDisplayStyleBtn = showChangeProductDisplayStyleBtn;
    self.changeStyleBtn.hidden = !showChangeProductDisplayStyleBtn;
    if (!showChangeProductDisplayStyleBtn) {
        return;
    }
    NSString *imageName;
    if (self.showHorizontalStyle) {
        imageName = @"tn_waterflow_item_two";
    } else {
        imageName = @"tn_waterflow_item_one";
    }
    [self.changeStyleBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
- (void)setContentWidth:(CGFloat)contentWidth {
    _contentWidth = contentWidth;
    self.tagView.contentWidth = contentWidth;
}
- (void)setTagArr:(NSArray *)tagArr {
    _tagArr = tagArr;
    self.tagView.itemArray = tagArr;
    self.tagView.hidden = HDIsArrayEmpty(tagArr);
    [self setNeedsUpdateConstraints];
}
- (void)setDesText:(NSString *)desText {
    _desText = desText;
    if (HDIsStringNotEmpty(desText)) {
        self.desLabel.hidden = NO;
        self.desLabel.text = desText;
    } else {
        self.desLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.sortFilterBar.backgroundColor = backgroundColor;
    [super setBackgroundColor:backgroundColor];
}
- (void)setViewModel:(TNSearchBaseViewModel *)viewModel {
    _viewModel = viewModel;
    self.sortFilterBar.viewModel = _viewModel;
}

- (void)updateConstraints {
    if (!self.tagView.isHidden) {
        [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(kRealWidth(80));
        }];
    }
    if (!self.changeStyleBtn.isHidden) {
        [self.changeStyleBtn sizeToFit];
        [self.changeStyleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.sortFilterBar.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        }];
    }
    [self.sortFilterBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.tagView.isHidden) {
            make.top.equalTo(self.mas_top);
        } else {
            make.top.equalTo(self.tagView.mas_bottom);
        }
        make.left.equalTo(self);
        if (!self.changeStyleBtn.isHidden) {
            make.right.equalTo(self.changeStyleBtn.mas_left);
        } else {
            make.right.equalTo(self);
        }
        if (self.desLabel.isHidden) {
            make.bottom.equalTo(self);
        }
        make.height.mas_equalTo(45);
    }];
    if (!self.desLabel.isHidden) {
        [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(50);
            make.top.equalTo(self.sortFilterBar.mas_bottom);
        }];
    }
    [super updateConstraints];
}
/** @lazy desLabel */
- (HDLabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[HDLabel alloc] init];
        _desLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _desLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _desLabel.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _desLabel.hd_edgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
        _desLabel.hidden = YES;
    }
    return _desLabel;
}
/** @lazy changeStyleBtn */
- (HDUIButton *)changeStyleBtn {
    if (!_changeStyleBtn) {
        _changeStyleBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _changeStyleBtn.hidden = YES;
        @HDWeakify(self);
        [_changeStyleBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [[NSUserDefaults standardUserDefaults] setBool:!self.showHorizontalStyle forKey:kNSUserDefaultsKeyShowHorizontalProductsStyle];
            //发送更改通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kTNNotificationNameChangedSpecialProductsListDispalyStyle object:nil];
            !self.changeProductDisplayStyleCallBack ?: self.changeProductDisplayStyleCallBack();
        }];
    }
    return _changeStyleBtn;
}
- (BOOL)showHorizontalStyle {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsKeyShowHorizontalProductsStyle];
}
/** @lazy tagView */
- (TNSpecialProductTagView *)tagView {
    if (!_tagView) {
        _tagView = [[TNSpecialProductTagView alloc] init];
        _tagView.hidden = YES;
        @HDWeakify(self);
        _tagView.tagClickCallBack = ^(TNGoodsTagModel *_Nonnull model) {
            @HDStrongify(self);
            !self.tagClickCallBack ?: self.tagClickCallBack(model);
        };
        _tagView.dropSpecialProductTagClickCallBack = ^{
            @HDStrongify(self);
            !self.dropSpecialProductTagClickCallBack ?: self.dropSpecialProductTagClickCallBack();
        };
    }
    return _tagView;
}
@end

//
//  TNSpecialProductTagView.m
//  SuperApp
//
//  Created by 张杰 on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpecialProductTagView.h"
#import "TNGoodsTagModel.h"
#import "TNProductTagButton.h"
#import "TNSpecialProductTagPopView.h"


@interface TNSpecialProductTagView ()
///
@property (strong, nonatomic) HDFloatLayoutView *floatLayoutView;
///
@property (strong, nonatomic) HDUIButton *dropBtn;
///
@property (strong, nonatomic) UIImageView *shadowImageView;

@end


@implementation TNSpecialProductTagView
- (void)hd_setupViews {
    [self addSubview:self.floatLayoutView];
    [self addSubview:self.shadowImageView];
    [self addSubview:self.dropBtn];
}
- (void)setContentWidth:(CGFloat)contentWidth {
    _contentWidth = contentWidth;
}
- (void)setItemArray:(NSArray<TNGoodsTagModel *> *)itemArray {
    _itemArray = itemArray;
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (TNGoodsTagModel *tagModel in itemArray) {
        TNProductTagButton *btn = [[TNProductTagButton alloc] init];
        [btn setTitle:tagModel.tagName forState:UIControlStateNormal];
        btn.tagSize = tagModel.itemSize;
        btn.selected = tagModel.isSelected;
        @HDWeakify(self);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self processSelectedTag:tagModel];
        }];
        [self.floatLayoutView addSubview:btn];
    }
    NSInteger count = [self.floatLayoutView fowardingTotalRowCountWithMaxSize:CGSizeMake(self.superview.bounds.size.width - kRealWidth(20), CGFLOAT_MAX)];
    if (count > 2) {
        self.dropBtn.hidden = NO;
        self.shadowImageView.hidden = NO;
    } else {
        self.dropBtn.hidden = YES;
        self.shadowImageView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)processSelectedTag:(TNGoodsTagModel *)tagModel {
    [self.itemArray enumerateObjectsUsingBlock:^(TNGoodsTagModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.isSelected = NO;
    }];
    tagModel.isSelected = !tagModel.isSelected;
    !self.tagClickCallBack ?: self.tagClickCallBack(tagModel);
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(10));
        make.top.equalTo(self.mas_top).offset(kRealWidth(10));
        //        make.width.mas_equalTo(self.superview.bounds.size.width - kRealWidth(20));
        make.size.mas_equalTo(CGSizeMake(self.contentWidth - kRealWidth(20), MAXFLOAT));
        make.bottom.equalTo(self.mas_bottom);
    }];
    if (!self.dropBtn.isHidden) {
        [self.dropBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.width.mas_equalTo(kRealWidth(30));
        }];
        [self.shadowImageView sizeToFit];
        [self.shadowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            CGSize size = self.shadowImageView.image.size;
            make.size.mas_equalTo(size);
            make.right.equalTo(self.dropBtn.mas_right).offset(-size.width / 2 - 5);
        }];
    }
}
#pragma mark - lazy load
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 15);
        _floatLayoutView.maxRowCount = 2;
        _floatLayoutView.minimumItemSize = CGSizeMake(kRealWidth(40), kRealWidth(25));
    }
    return _floatLayoutView;
}
/** @lazy dropControl */
- (HDUIButton *)dropBtn {
    if (!_dropBtn) {
        _dropBtn = [[HDUIButton alloc] init];
        [_dropBtn setImage:[UIImage imageNamed:@"tn_direction_down"] forState:UIControlStateNormal];
        _dropBtn.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        [_dropBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.dropSpecialProductTagClickCallBack ?: self.dropSpecialProductTagClickCallBack();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                TNSpecialProductTagPopView *popView = [[TNSpecialProductTagPopView alloc] initWithView:self tagArr:self.itemArray width:self.bounds.size.width];
                @HDWeakify(self);
                popView.tagClickCallBack = ^(TNGoodsTagModel *_Nonnull model) {
                    @HDStrongify(self);
                    [self processSelectedTag:model];
                };
                [popView show];
            });
        }];
    }
    return _dropBtn;
}
/** @lazy shadowImageView */
- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_speacial_shadow"]];
    }
    return _shadowImageView;
}
@end

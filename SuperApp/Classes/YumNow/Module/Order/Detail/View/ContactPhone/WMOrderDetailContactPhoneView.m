//
//  WMOrderDetailContactPhoneView.m
//  SuperApp
//
//  Created by Chaos on 2021/2/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderDetailContactPhoneView.h"
#import "SAContactPhoneModel.h"
#import "SAImageLeftFillButton.h"
#import "NSString+SA_Extension.h"

#define kLineViewTag 99


@interface WMOrderDetailContactPhoneView ()

@property (nonatomic, strong) NSArray<UIView *> *phoneViews;

@end


@implementation WMOrderDetailContactPhoneView

#pragma mark - setter
- (void)setPhoneList:(NSArray *)phoneList {
    _phoneList = phoneList;

    self.phoneViews = [self.phoneList mapObjectsUsingBlock:^id _Nonnull(id _Nonnull obj, NSUInteger idx) {
        return [self createContactPhoneViewWithPhone:obj index:idx];
    }];
    for (UIView *view in self.phoneViews) {
        [self addSubview:view];
        NSUInteger index = [self.phoneViews indexOfObject:view];
        // 最后一个不添加分割线，但是只有一条数据时需要添加分割线
        if (index < self.phoneViews.count - 1 || self.phoneViews.count == 1) {
            [self addSubview:[self createLineView]];
        }
    }
}

#pragma mark - private methods
- (UIView *)createContactPhoneViewWithPhone:(id)phone index:(NSUInteger)index {
    UIView *view = UIView.new;
    view.tag = index + 1;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedPhoneViewHandler:)]];
    // 电话号码
    UILabel *phoneLB = UILabel.new;
    phoneLB.font = [UIFont systemFontOfSize:20];
    phoneLB.textColor = HDAppTheme.color.G2;
    // 电话icon
    UIImageView *phoneIV = UIImageView.new;
    phoneIV.image = [UIImage imageNamed:@"ic_phone_round"];

    if ([phone isKindOfClass:SAContactPhoneModel.class]) {
        SAContactPhoneModel *model = (SAContactPhoneModel *)phone;
        // 运营商图标
        UIImageView *operatorIV = UIImageView.new;
        [HDWebImageManager setImageWithURL:model.picture placeholderImage:nil imageView:operatorIV];
        [view addSubview:operatorIV];
        [operatorIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.width.mas_equalTo(52);
            make.height.mas_equalTo(24);
            make.centerY.equalTo(view);
        }];
        // 电话号码
        phoneLB.text = [model.num sa_855PhoneFormat];
        [view addSubview:phoneLB];
        const CGFloat defaultPhoneWitdth = [@"000 000 0000" boundingAllRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:phoneLB.font].width;
        [phoneLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(operatorIV.mas_right).offset(kRealWidth(10));
            make.width.mas_equalTo(defaultPhoneWitdth);
        }];
        // icon
        [view addSubview:phoneIV];
        [phoneIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view);
            make.left.equalTo(phoneLB.mas_right).offset(kRealWidth(20));
        }];
    } else {
        // 电话号码
        phoneLB.text = [phone sa_855PhoneFormat];
        [view addSubview:phoneLB];
        [phoneLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view);
        }];
        // icon
        [view addSubview:phoneIV];
        [phoneIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view);
            make.left.equalTo(phoneLB.mas_right).offset(kRealWidth(15));
        }];
    }

    return view;
}

- (UIView *)createLineView {
    UIView *line = UIView.new;
    line.tag = kLineViewTag;
    line.backgroundColor = HDAppTheme.color.G4;
    return line;
}

#pragma mark - event response
- (void)clickedPhoneViewHandler:(UITapGestureRecognizer *)tap {
    id phone = self.phoneList[tap.view.tag - 1];
    if ([phone isKindOfClass:SAContactPhoneModel.class]) {
        phone = ((SAContactPhoneModel *)phone).num;
    }
    !self.clickedPhoneNumberBlock ?: self.clickedPhoneNumberBlock(phone);
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    [self updateLayout];
    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = (CGRect){0, 0, CGRectGetWidth(self.frame), size.height};
}


#pragma mark - layout
- (void)updateLayout {
    NSArray<UIView *> *showViews = [self.subviews hd_filterWithBlock:^BOOL(__kindof UIView *_Nonnull item) {
        return !item.hidden;
    }];
    UIView *lastView;
    for (UIView *view in showViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (view.tag != kLineViewTag) {
                make.centerX.equalTo(self);
                make.height.mas_equalTo(70);
                if (!lastView) {
                    make.top.equalTo(self);
                } else {
                    make.top.equalTo(lastView.mas_bottom);
                }
            } else {
                make.left.right.equalTo(self);
                make.top.equalTo(lastView.mas_bottom);
                make.height.mas_equalTo(PixelOne);
            }
            if (view == showViews.lastObject) {
                make.bottom.equalTo(self).offset(-kRealWidth(35));
            }
        }];
        lastView = view;
    }
}

@end

//
//  WMStoreFilterTableViewCellBaseModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFilterTableViewCellBaseModel.h"
#import "WMAppTheme.h"


@implementation WMStoreFilterTableViewCellBaseModel
+ (instancetype)modelWithTitle:(NSString *)title associatedParamsModel:(id __nullable)associatedParamsModel {
    return [[self alloc] initWithTitle:title associatedParamsModel:associatedParamsModel];
}

+ (instancetype)modelWithAttributedTitle:(NSAttributedString *)title associatedParamsModel:(id)associatedParamsModel {
    return [[self alloc] initWithAttributedTitle:title selectedAttributedTitle:nil associatedParamsModel:associatedParamsModel];
}

+ (instancetype)modelWithAttributedTitle:(NSAttributedString *)title selectedAttributedTitle:(NSAttributedString *_Nullable)selectTitle associatedParamsModel:(id __nullable)associatedParamsModel {
    return [[self alloc] initWithAttributedTitle:title selectedAttributedTitle:selectTitle associatedParamsModel:associatedParamsModel];
}

- (instancetype)initWithAttributedTitle:(NSAttributedString *)title selectedAttributedTitle:(NSAttributedString *)selectTitle associatedParamsModel:(id)associatedParamsModel {
    if (self = [super init]) {
        self.title = title.string;
        self.attributedTitle = title;
        self.selectedAttributedTitle = selectTitle;
        self.associatedParamsModel = associatedParamsModel;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title associatedParamsModel:(id __nullable)associatedParamsModel {
    self = [super init];
    if (self) {
        self.title = title;
        self.associatedParamsModel = associatedParamsModel;
    }
    return self;
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = HDAppTheme.font.standard3;
    }
    return _titleFont;
}

- (UIFont *)titleSelectFont {
    if (!_titleSelectFont) {
        _titleSelectFont = HDAppTheme.font.standard3Bold;
    }
    return _titleSelectFont;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = HDAppTheme.color.G1;
    }
    return _titleColor;
}

- (UIColor *)titleSelectColor {
    if (!_titleSelectColor) {
        _titleSelectColor = HDAppTheme.color.mainColor;
    }
    return _titleSelectColor;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
}

@end

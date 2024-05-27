//
//  GNCellModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNTheme.h"


@implementation GNCellModel
@synthesize hidden = _hidden;
@synthesize cellHeight = _cellHeight;
@synthesize cellClass = _cellClass;
@synthesize xib = _xib;
@synthesize select = _select;
@synthesize dataSource = _dataSource;
@synthesize backgroundColor = _backgroundColor;
@synthesize indexPath = _indexPath;
@synthesize notCacheHeight = _notCacheHeight;
@synthesize selectionStyle = _selectionStyle;
@synthesize accessoryType = _accessoryType;
@synthesize businessData = _businessData;
@synthesize estimatedHeight = _estimatedHeight;

+ (GNCellModel *)createClass:(NSString *)classStr {
    GNCellModel *model = GNCellModel.new;
    model.cellClass = NSClassFromString(classStr);
    return model;
}

- (instancetype)initTitle:(nullable NSString *)title image:(nullable UIImage *)image {
    return [self initTitle:title image:image detail:nil];
}

- (instancetype)initTitle:(nullable NSString *)title detail:(nullable NSString *)detail {
    return [self initTitle:title image:nil detail:nil];
}

- (instancetype)initTitle:(nullable NSString *)title image:(nullable UIImage *)image detail:(nullable NSString *)detail {
    if (self = [super init]) {
        self.title = title;
        self.image = image;
        self.detail = detail;
        self.imageSize = CGSizeMake(kRealWidth(12), kRealWidth(12));
        self.numOfLines = 1;
        self.num = 1;
        self.offset = HDAppTheme.value.gn_marginT;
        self.titleFont = [HDAppTheme.font gn_ForSize:13];
        self.detailFont = [HDAppTheme.font gn_ForSize:13];
        self.bottomOffset = HDAppTheme.value.gn_marginT;
        self.titleColor = HDAppTheme.color.gn_333Color;
        self.detailColor = HDAppTheme.color.gn_333Color;
        self.cellClickEnable = YES;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.imageSize = CGSizeMake(kRealWidth(12), kRealWidth(12));
        self.numOfLines = 1;
        self.num = 1;
        self.offset = HDAppTheme.value.gn_marginT;
        self.titleFont = [HDAppTheme.font gn_ForSize:13];
        self.detailFont = [HDAppTheme.font gn_ForSize:13];
        self.cellClickEnable = YES;
        self.titleColor = HDAppTheme.color.gn_333Color;
        self.detailColor = HDAppTheme.color.gn_333Color;
    }
    return self;
}

@end

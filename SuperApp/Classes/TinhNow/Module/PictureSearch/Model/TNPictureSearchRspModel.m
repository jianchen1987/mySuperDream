//
//  TNPictureSearchRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/1/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNPictureSearchRspModel.h"
#import "HDAppTheme+TinhNow.h"
#import "TNSellerProductModel.h"
#import <HDKitCore/HDKitCore.h>


@implementation TNPictureSearchModel

- (void)configCellHeight {
    if (self.cellHeight > 0) {
        return;
    }
    CGFloat maxLabelWidth = self.preferredWidth - kRealWidth(16);
    CGFloat height = 0;
    // 图片长宽1：1
    height += self.preferredWidth;
    // 图片到商品名
    height += kRealHeight(10);
    if (HDIsStringNotEmpty(self.title)) {
        NSString *sizeName = [@" Global " stringByAppendingString:self.title];
        CGSize size = [sizeName boundingAllRectWithSize:CGSizeMake(maxLabelWidth + kRealWidth(1), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15 lineSpacing:0];
        CGSize towRowsSize = [@"一\n二" boundingAllRectWithSize:CGSizeMake(maxLabelWidth + kRealWidth(1), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15 lineSpacing:0];
        height += size.height < towRowsSize.height ? size.height : towRowsSize.height;

        //到店铺
        height += kRealWidth(25);
    } else {
        height += kRealWidth(5);
    }

    CGSize storeNameSize = [self.storeName boundingAllRectWithSize:CGSizeMake(maxLabelWidth - kRealWidth(15), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:0];
    CGSize towRowsSize = [@"一\n二" boundingAllRectWithSize:CGSizeMake(maxLabelWidth - kRealWidth(15), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:0];
    height += storeNameSize.height < towRowsSize.height ? storeNameSize.height : towRowsSize.height;

    //上下间距
    height += kRealWidth(10);
    self.cellHeight = height;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (HDIsStringNotEmpty(title)) {
        UIImage *globalImage = [UIImage imageNamed:@"tn_global_k"];
        NSString *name = [NSString stringWithFormat:@" %@", title];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
        NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
        imageMent.image = globalImage;
        UIFont *font = HDAppTheme.TinhNowFont.standard15;
        CGFloat paddingTop = font.lineHeight - font.pointSize;
        imageMent.bounds = CGRectMake(0, -paddingTop, globalImage.size.width, globalImage.size.height);
        NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:imageMent];
        [text insertAttributedString:attachment atIndex:0];
        [text addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, name.length)];
        self.nameAttr = text;
    }
}
- (CGFloat)preferredWidth {
    return (kScreenWidth - kRealWidth(40)) / 2;
}
@end


@implementation TNPictureSearchRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items": [TNPictureSearchModel class]};
}
@end

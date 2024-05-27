//
//  SACMSWaterfallDataSourceRspModel.m
//  SuperApp
//
//  Created by seeu on 2022/2/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallDataSourceRspModel.h"
#import "NSDate+SAExtension.h"
#import "SALabel.h"
#import <HDKitCore/HDKitCore.h>
#import <YYText/NSAttributedString+YYText.h>
#import <YYText/YYLabel.h>
#import "SAOperationButton.h"


@implementation SACMSWaterfallDataSourceRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": SACMSWaterfallCellModel.class};
}

@end


@implementation SACMSWaterfallCellModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellType = SACMSWaterfallCellTypeDiscovery;
        self.bizType = @"discovery";
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"contentTags": NSString.class, @"tags": NSString.class};
}

- (CGFloat)heightWithWidth:(CGFloat)width {
    __block CGFloat cellHeight = 0;

    if (self.cellType == SACMSWaterfallCellTypeHomeRecommand) {
        cellHeight += (width * self.coverHeight) / self.coverWidth;
        cellHeight += kRealHeight(8);

        NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] init];
        if (HDIsStringNotEmpty(self.bizLine) && [self.showBizLine isEqualToString:@"Y"]) {
            SALabel *bizTagLabel = SALabel.new;
            bizTagLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
            bizTagLabel.textColor = [UIColor whiteColor];
            bizTagLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#FC2040"];
            bizTagLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 4, 2, 4);
            bizTagLabel.text = self.bizLine;
            [bizTagLabel sizeToFit];
            [bizTagLabel setRoundedCorners:UIRectCornerAllCorners radius:4.0f];
            [titleAttStr appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:bizTagLabel contentMode:UIViewContentModeCenter attachmentSize:bizTagLabel.frame.size
                                                                                              alignToFont:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]
                                                                                                alignment:YYTextVerticalAlignmentCenter]];
            [titleAttStr yy_appendString:@" "];
        }

        if (HDIsStringNotEmpty(self.price)) {
            SALabel *bizTagLabel = SALabel.new;
            bizTagLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightHeavy];
            bizTagLabel.hd_edgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
            bizTagLabel.text = self.price;
            [bizTagLabel sizeToFit];
            [titleAttStr appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:bizTagLabel contentMode:UIViewContentModeCenter attachmentSize:bizTagLabel.frame.size
                                                                                              alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightHeavy]
                                                                                                alignment:YYTextVerticalAlignmentCenter]];
            [titleAttStr yy_appendString:@" "];
        }

        [titleAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:self.contentTitle attributes:@{
                         NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                         NSForegroundColorAttributeName: [UIColor hd_colorWithHexString:@"#333333"]
                     }]];
        if ([SAMultiLanguageManager isCurrentLanguageCN]) {
            [titleAttStr yy_setLineSpacing:8 range:NSMakeRange(0, titleAttStr.string.length)];
        } else if ([SAMultiLanguageManager isCurrentLanguageKH]) {
            [titleAttStr yy_setLineSpacing:0 range:NSMakeRange(0, titleAttStr.string.length)];
        } else {
            [titleAttStr yy_setLineSpacing:4 range:NSMakeRange(0, titleAttStr.string.length)];
        }

        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width - kRealWidth(16), CGFLOAT_MAX)];
        container.maximumNumberOfRows = 2;
        container.truncationType = YYTextTruncationTypeEnd;
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:titleAttStr];

        CGFloat maxWidth = width - (kRealWidth(8) * 2);
        cellHeight += layout.textBoundingSize.height;

        NSArray<NSString *> *tags = [self.tags hd_filterWithBlock:^BOOL(NSString *_Nonnull item) {
            return HDIsStringNotEmpty(item);
        }];
        if (tags.count) {
            cellHeight += kRealHeight(8); // 标签到标题的间距
            __block CGFloat lineWidth = 0;
            CGFloat oneLineHeight = [@"哈" boundingAllRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) font:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]].height + 4 + 4; //字高 + 背景间距
            cellHeight += oneLineHeight;

            [tags enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                CGSize tagSize = [obj boundingAllRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) font:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]];
                if ((tagSize.width + 4 + 4 + 4) + lineWidth > maxWidth && idx != 0) {
                    // 满一行了，要换行
                    cellHeight += oneLineHeight + 4;
                    lineWidth = tagSize.width + 4 + 4 + 4;
                } else {
                    // 没满，可以继续放
                    lineWidth += tagSize.width + 4 + 4 + 4; // 字宽 + 左右背景间距 + tag间距
                }
            }];
        }
        cellHeight += kRealHeight(8);

    } else {
        cellHeight += (width * self.coverHeight) / self.coverWidth;
        cellHeight += kRealHeight(8);

        NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] init];
        if (!HDIsArrayEmpty(self.contentTags)) {
            SAOperationButton *tb = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
            [tb applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#FC2040"]];
            [tb setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            tb.titleLabel.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
            [tb setImage:[UIImage imageNamed:@"discover_tag_hot"] forState:UIControlStateNormal];
            [tb setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 0)];
            [tb setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 4)];
            tb.cornerRadius = 4.0f;
            tb.userInteractionEnabled = NO;
            [tb setTitle:self.contentTags.firstObject forState:UIControlStateNormal];
            [tb sizeToFit];
            [titleAttStr appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:tb contentMode:UIViewContentModeCenter attachmentSize:tb.frame.size
                                                                                              alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]
                                                                                                alignment:YYTextVerticalAlignmentCenter]];
            [titleAttStr yy_appendString:@" "];
        }


        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.maximumLineHeight = 20;
        paragraphStyle.minimumLineHeight = 20;

        [titleAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:self.contentTitle attributes:@{
                         NSFontAttributeName: [UIFont systemFontOfSize:14],
                         NSForegroundColorAttributeName: [UIColor hd_colorWithHexString:@"#333333"],
                         NSParagraphStyleAttributeName: paragraphStyle
                     }]];

        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.cellWidth - kRealWidth(16), CGFLOAT_MAX)];
        container.maximumNumberOfRows = 3;
        container.truncationType = YYTextTruncationTypeEnd;
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:titleAttStr];

        CGFloat maxWidth = width - (kRealWidth(8) * 2);
        cellHeight += layout.textBoundingSize.height;

        cellHeight += kRealHeight(8);

        CGSize dateSize = [[[NSDate dateWithTimeIntervalSince1970:self.publishTime / 1000.0f] stringWithFormatStr:@"dd/MM/yyyy HH:mm"] boundingAllRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                                                                                                                          font:[UIFont systemFontOfSize:12]];
        CGSize tmpSize = [@"2012" boundingAllRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) font:[UIFont systemFontOfSize:12]];
        cellHeight += dateSize.height > tmpSize.height ? ceil(tmpSize.height) : ceil(dateSize.height);
        cellHeight += kRealHeight(8);
    }

    return cellHeight;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *coverUrlStr = [dic valueForKey:@"cover"];

    if (HDIsStringNotEmpty(coverUrlStr)) {
        NSURL *coverUrl = [NSURL URLWithString:coverUrlStr];
        NSURLComponents *components = [NSURLComponents componentsWithURL:coverUrl resolvingAgainstBaseURL:YES];
        NSArray<NSURLQueryItem *> *bingo = [components.queryItems hd_filterWithBlock:^BOOL(NSURLQueryItem *_Nonnull item) {
            return [item.name isEqualToString:@"WxH"];
        }];
        if (bingo.count) {
            NSArray<NSString *> *WxH = [bingo.firstObject.value componentsSeparatedByString:@"x"];
            self.coverWidth = [WxH.firstObject floatValue];
            self.coverHeight = [WxH.lastObject floatValue];
        } else {
            self.coverWidth = 1.0f;
            self.coverHeight = 1.0f;
        }
    } else {
        self.coverWidth = 1.0f;
        self.coverHeight = 1.0f;
    }
    return YES;
}

@end


@implementation SADiscoveryStatisticsModel

@end

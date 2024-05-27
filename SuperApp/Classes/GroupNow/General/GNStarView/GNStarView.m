//
//  GNStarView.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStarView.h"
#import "GNModel.h"


@implementation GNStarView

- (void)setScore:(NSInteger)score {
    _score = score;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    @HDWeakify(self) UIImage *image = [UIImage imageNamed:self.defaultImage];
    CGSize size = image.size;
    if (!CGSizeIsEmpty(self.iconSize))
        size = self.iconSize;
    size.width += self.space;
    for (int i = 0; i < self.maxValue; i++) {
        image = [UIImage imageNamed:i < score ? self.selectImage : self.defaultImage];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeLeft attachmentSize:size alignToFont:self.font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
        if (self.canTap) {
            [attachText yy_setTextHighlightRange:NSMakeRange(0, 1) color:nil backgroundColor:nil tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                @HDStrongify(self) if (self.delegate && [self.delegate respondsToSelector:@selector(gn_starView:star:)])[self.delegate gn_starView:self star:i];
            }];
        }
        [text appendAttributedString:attachText];
    }
    self.attributedText = text;
}

@end

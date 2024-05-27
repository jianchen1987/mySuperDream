//
//  PNInputTextView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^TextViewDidChangeBlock)(NSString *inputText);


@interface PNInputTextView : PNView

@property (nonatomic, copy) NSString *currentText;

@property (nonatomic, copy) TextViewDidChangeBlock textViewDidChangeBlock;
@end

NS_ASSUME_NONNULL_END

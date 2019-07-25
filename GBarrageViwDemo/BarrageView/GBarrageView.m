//
//  GBarrageView.m
//  GClassroomFramework
//
//  Created by Caoguo on 2019/7/24.
//  Copyright © 2019 Namegold. All rights reserved.
//

#import "GBarrageView.h"
#import "GBarrageItemView.h"
#import "GRichTextAttributedTextLayout.h"

#define KBarrageItemMinHeight 24
#define KBarrageItemSpace 8

@interface GBarrageView ()

@property (nonatomic, strong) NSMutableArray *reusedViewArray;       // 未展示区
@property (nonatomic, strong) NSMutableArray *displayViewArray;      // 已展示区
@property (nonatomic, assign) NSInteger totalCount;                  // 总数量
@property (nonatomic, strong) CAGradientLayer  *maskLayer;
@property (nonatomic, strong) GBarrageItemView *willDisplayItemView; // 将要展示的item
@property (nonatomic, strong) NSMutableArray *waitDealDataArray;     // 等待处理区
@property (nonatomic, strong) NSMutableArray *dealingDataArray;      // 正在处理区

@end

@implementation GBarrageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self _setUpCommon];
        self.layer.mask = self.maskLayer;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void) _setUpCommon {
    self.dealingDataArray = [NSMutableArray array];
    self.waitDealDataArray = [NSMutableArray array];
    self.reusedViewArray = [NSMutableArray array];
    self.displayViewArray = [NSMutableArray array];
    self.totalCount = (CGRectGetHeight(self.frame) / KBarrageItemMinHeight + 2);
    [self setUpUnDisplayView];
}

- (void)setUpUnDisplayView {
    CGFloat _originY = CGRectGetHeight(self.frame);
    CGFloat _space = KBarrageItemSpace;
    for (int i = 0; i < self.totalCount; i ++) {
        GBarrageItemView *itemView = [self itemView];
        itemView.frame = CGRectMake(0, _originY + (_space), CGRectGetWidth(self.frame), KBarrageItemMinHeight);
        itemView.barrageBoundHeight = CGRectGetHeight(self.frame);
        [self.reusedViewArray addObject:itemView];
        [self addSubview:itemView];
    }
    
}

- (void)appendNewBarrageText: (GClassroomMessageItem *)message {
    if (!message.fullText.length) {
        return;
    }
    if (self.dealingDataArray.count) { // 当前有正在绘制的, 先加到等待区
        [self.waitDealDataArray addObject:message];
        return;
    }
    [self.dealingDataArray addObject:message];
    [self appendNewData];
}

- (void)appendNewData {
    // 布局
    [self _setUpWiddDisplayItem:self.dealingDataArray.firstObject];
    // 动画
    [self showWithAnimation:CGRectGetHeight(self.willDisplayItemView.frame) + KBarrageItemSpace];
    // 更新分区数据
}

- (void)showWithAnimation:(CGFloat )offsetHeight {
    // 先处理已展示区
    if (self.displayViewArray.count) {
        for (GBarrageItemView *itemView in self.displayViewArray) {
            itemView.upOffsetHeight = offsetHeight;
            [self showAnimationWithItemView:itemView];
        }
    }
    // 处理展示区
    [self showAnimationWithItemView:self.willDisplayItemView];
}

- (void)showAnimationWithItemView: (GBarrageItemView *)itemView {
    __weak __typeof__(self) weakSelf = self;
    if (itemView != self.willDisplayItemView) {
        [itemView doBarrageAnimation:^{
            [weakSelf recallItemViewIfNeed:itemView];
        }];
    }else {
        [itemView doBarrageAnimation:^{
            [weakSelf.displayViewArray addObject:itemView];
            [weakSelf contiuneDealWaitData];
        }];
    }
}

- (void)contiuneDealWaitData {
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    self.dealingDataArray = [NSMutableArray array];
    if (self.waitDealDataArray) {
        id data = [self.waitDealDataArray firstObject];
        [self.dealingDataArray addObject:data];
        [self.waitDealDataArray removeObject:data];
    }
    [lock unlock];
    if (self.dealingDataArray.count) {
        [self appendNewData];
    }
}

- (void)recallItemViewIfNeed: (GBarrageItemView *)itemView {
    if (CGRectGetMaxY(itemView.frame) < 0) {
        itemView.alpha = 1.f;
        itemView.frame = CGRectMake(0, CGRectGetHeight(self.frame) + KBarrageItemSpace, CGRectGetWidth(self.frame), KBarrageItemMinHeight);
        if ([self.displayViewArray containsObject:itemView]) {
            [self.displayViewArray removeObject:itemView];
        }
        if (![self.reusedViewArray containsObject:itemView]) {
            [self.reusedViewArray addObject:itemView];
        }
    }
    
}

- (void)_setUpWiddDisplayItem: (GClassroomMessageItem *)message {
    CGSize resultSize = [self sizeForText:message.fullText];
    self.willDisplayItemView = [self nextReuseItemView];
    CGRect rect = self.willDisplayItemView.frame;
    rect.size.height = resultSize.height + 10;
    self.willDisplayItemView.frame = rect;
//    [self.willDisplayItemView setViewFrameHeight:resultSize.height + 10];
    self.willDisplayItemView.upOffsetHeight = CGRectGetHeight(self.willDisplayItemView.frame) + KBarrageItemSpace * 2;
    if (self.willDisplayItemView) {
        [self.willDisplayItemView setBarrageText:message.fullText
                                        imageUrl:@""
                                            sign:NO
                                            size:resultSize];
        [self.reusedViewArray removeObject:self.willDisplayItemView];
    }
}

- (GBarrageItemView *)nextReuseItemView {
    if (self.reusedViewArray.count) {
        GBarrageItemView *itemView = [self.reusedViewArray firstObject];
        return itemView;
    }else {
        return nil;
    }
}

- (CGSize )sizeForText: (NSString *)text {
    GRichTextAttributedTextContainer *container = [[GRichTextAttributedTextContainer alloc] init];
    container.width = CGRectGetWidth(self.frame) - 53;
    container.font = [UIFont systemFontOfSize:11.f];
    container.textAlignment = NSTextAlignmentLeft;
    container.lineSpacing = 2;
    container.numberOfLines = 3;
    GRichTextAttributedTextLayout *result = [GRichTextAttributedTextLayout layoutWithContainer:container
                                                                                          text:text];
    return result.size;
}


#pragma mark - Private

- (CAGradientLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAGradientLayer layer];
        _maskLayer.colors     = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor];
        _maskLayer.frame      = self.bounds;
        _maskLayer.locations  = @[@(0),@(0.15), @(1.0)];
    }
    return _maskLayer;
}

- (GBarrageItemView *)itemView {
    GBarrageItemView *itemView = [[GBarrageItemView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 20)];
    
    return itemView;
}

#pragma mark - Gesture

- (void)tapGestureHandle: (UITapGestureRecognizer *)tapGesture {
    !self.tapHandle?:self.tapHandle();
}



@end

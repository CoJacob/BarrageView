//
//  GBarrageItemView.m
//  GClassroomFramework
//
//  Created by Caoguo on 2019/7/24.
//  Copyright © 2019 Namegold. All rights reserved.
//

#import "GBarrageItemView.h"

@interface GBarrageItemView ()

@property (nonatomic, strong) UIView      *contentBgView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *authorVerifyImageView;

@end

@implementation GBarrageItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentBgView];
        [self.contentBgView addSubview:self.titleLabel];
        [self addSubview:self.coverImageView];
        [self addSubview:self.authorVerifyImageView];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setBarrageText: (NSString *)text
              imageUrl: (NSString *)imageUrl
                  sign: (BOOL )sign
                  size: (CGSize )size {
//    [self.coverImageView qn_setClipSizedImageWithUrl:imageUrl placeholder:[UIImage imageNamed:@"default"]];
    [self.authorVerifyImageView setHidden:!sign];
    CGRect rect = self.contentBgView.frame;
    rect.size.width = size.width;
    rect.size.height = size.height;
    rect.origin.x = CGRectGetMinX(self.coverImageView.frame) - (size.width) - 16 - 5;
    self.contentBgView.frame = rect;
    
//    [self.contentBgView setViewFrameSize:CGSizeMake(size.width + 16, size.height + 10)];
//    [self.contentBgView setViewFrameX:CGRectGetMinX(self.coverImageView.frame) - (size.width) - 16 - 5];
    self.titleLabel.text = text;
//    [self.titleLabel setViewFrameSize:size];
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect.size.width = size.width;
    titleRect.size.height = size.height;
    self.titleLabel.frame = titleRect;
}

- (void)doBarrageAnimation: (void(^)(void))complected {
    CGFloat _targetFrameY = self.frame.origin.y - self.upOffsetHeight;
    if (!self.isDisplay) {
        self.alpha = 0.4f;
    }
    [UIView animateWithDuration:0.35
                          delay:0.05
         usingSpringWithDamping:1.0f
          initialSpringVelocity:15
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if (!self.isDisplay) {
                             self.alpha = 1;
                         }
                         CGRect rect = self.frame;
                         rect.origin.y = _targetFrameY;
                         self.frame = rect;
//                         [self setViewFrameY:_targetFrameY];
                     } completion:^(BOOL finished) {
                         self.isDisplay = YES;
                         !complected?:complected();
                     }];
}

#pragma mark - Getter

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 8 - 24, 0, 24, 24)];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 12.f;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _coverImageView;
}

- (UIImageView *)authorVerifyImageView {
    if (!_authorVerifyImageView) {
        _authorVerifyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame) - 11, CGRectGetMaxY(self.coverImageView.frame)-11, 11, 11)];
        _authorVerifyImageView.clipsToBounds = YES;
        _authorVerifyImageView.contentMode = UIViewContentModeScaleAspectFill;
        _authorVerifyImageView.image = [UIImage imageNamed:@"author_v"];
        _authorVerifyImageView.hidden = YES;
    }
    return _authorVerifyImageView;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - 38, 0)];
        _contentBgView.clipsToBounds = YES;
        _contentBgView.layer.cornerRadius = 4.f;
        _contentBgView.backgroundColor = [UIColor clearColor];
        _contentBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _contentBgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, CGRectGetWidth(self.frame) - 53, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:11.f];
        _titleLabel.numberOfLines = 3;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
    }
    return _titleLabel;
}


@end

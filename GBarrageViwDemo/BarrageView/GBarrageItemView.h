//
//  GBarrageItemView.h
//  GClassroomFramework
//
//  Created by Caoguo on 2019/7/24.
//  Copyright © 2019 Namegold. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBarrageItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL    isDisplay;
@property (nonatomic, assign) CGFloat upOffsetHeight;
@property (nonatomic, assign) CGFloat barrageBoundHeight;

- (void)setBarrageText: (NSString *)text
              imageUrl: (NSString *)imageUrl
                  sign: (BOOL )sign
                  size: (CGSize )size;

- (void)doBarrageAnimation: (void(^)(void))complected;

@end

NS_ASSUME_NONNULL_END

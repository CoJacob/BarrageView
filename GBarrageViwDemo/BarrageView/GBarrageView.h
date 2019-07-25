//
//  GBarrageView.h
//  GClassroomFramework
//
//  Created by Caoguo on 2019/7/24.
//  Copyright © 2019 Namegold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GClassroomMessageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GBarrageView : UIView

@property (nonatomic, copy) void(^tapHandle)(void);

- (void)appendNewBarrageText: (GClassroomMessageItem *)message;


@end





NS_ASSUME_NONNULL_END

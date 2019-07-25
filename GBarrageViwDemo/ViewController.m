//
//  ViewController.m
//  GBarrageViwDemo
//
//  Created by Caoguo on 2019/7/25.
//  Copyright © 2019 Namegold. All rights reserved.
//

#import "ViewController.h"
#import "GBarrageView.h"
#import "GClassroomMessageItem.h"

@interface ViewController ()

@property (nonatomic, strong) GBarrageView *barrageTipView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.barrageTipView];
    for (int i = 0; i < 500; i ++) {
        GClassroomMessageItem *item = [[GClassroomMessageItem alloc] init];
        NSString *emoj = @"😏😏😝😝🙃😄🐮🐽🐽🐽🍈🍈🍑🍑🍑🥔🥔🌽🌽🍠🍠😏😏😝😝🙃😄🐮🐽🐽🐽🍈🍈🍑🍑🍑🥔🥔🌽🌽🍠🍠😏😏😝😝🙃😄🐮🐽🐽🐽🍈🍈🍑🍑🍑🥔🥔🌽🌽🍠🍠😏😏😝😝🙃😄🐮🐽🐽🐽🍈🍈🍑🍑🍑🥔🥔🌽🌽🍠🍠";
        NSInteger index = (arc4random() % 30);
        NSString *targetEmoj = [emoj substringWithRange:NSMakeRange(index, (arc4random() % 40))];
        item.fullText = [NSString stringWithFormat:@"%@ %ld",targetEmoj,(long)(arc4random() % 999)];
        [self.barrageTipView appendNewBarrageText:item];
    }
}

#pragma mark - Getter

- (GBarrageView *)barrageTipView {
    if (!_barrageTipView) {
        _barrageTipView = [[GBarrageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 153, [UIScreen mainScreen].bounds.size.height - 49 - 143, 153, 143)];
//        __weak __typeof__(self) weakSelf = self;
        _barrageTipView.tapHandle = ^{
            
        };
    }
    return _barrageTipView;
}


@end

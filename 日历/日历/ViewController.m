//
//  ViewController.m
//  日历
//
//  Created by zhiqing on 16/7/21.
//  Copyright © 2016年 asdfghj. All rights reserved.
//

#import "ViewController.h"
#import "ZQCalendarView.h"
#import "PureLayout.h"
@interface ViewController ()
@property(nonatomic,strong)ZQCalendarView * calender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calender = [[ZQCalendarView alloc]initWithFrame:CGRectZero];
    self.calender.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.calender];
    [self.calender autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [self.calender autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.calender autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.calender autoSetDimension:ALDimensionHeight toSize:60];
}



@end

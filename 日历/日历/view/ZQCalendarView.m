//
//  CalendarView.m
//  日历
//
//  Created by zhiqing on 16/7/21.
//  Copyright © 2016年 asdfghj. All rights reserved.
//

#import "ZQCalendarView.h"
#import "PureLayout.h"
#import "ZQCalendarModel.h"
#import "ZQCollectionViewCell.h"
#import "ZQSelectTimeView.h"
@interface ZQCalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZQSelectTimeViewDelegate>

@property(nonatomic,strong)NSCalendar * calendar;
@property(nonatomic,strong) ZQSelectTimeView *mounthBtn; // 选择月份的
@property(nonatomic,strong) UIButton *leftBtn;   // 上一周
@property(nonatomic,strong) UIButton *rightBtn;  // 下一周
@property(nonatomic,strong) UICollectionView *midCollectionView; // 中间显示周日到周六的视图
@property(nonatomic,strong) NSArray *weekArray;
@property(nonatomic,strong) NSArray *weekDataArray; // 每次装的7个数据模型
@property(nonatomic,strong) NSDate *currentDate;

@end

@implementation ZQCalendarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{
    self.weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    self.mounthBtn = [[ZQSelectTimeView alloc]init];
    self.mounthBtn.selectTime = date;
    self.mounthBtn.delegate = self;
    [self addSubview:self.mounthBtn];
    [self.mounthBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
    [self.mounthBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.mounthBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.2];
    [self.mounthBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.backgroundColor = [UIColor redColor];
    [self.leftBtn setTitle:@"上周" forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(getlastWeekData) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    
    [self.leftBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.mounthBtn withOffset:10];
    [self.leftBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.05];
    [self.leftBtn autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.mounthBtn withMultiplier:1];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.midCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    self.midCollectionView.backgroundColor =  [UIColor orangeColor];
    
    
    [self addSubview:self.midCollectionView];
    [self.midCollectionView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.leftBtn];
    [self.midCollectionView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.65];
    [self.midCollectionView registerClass:[ZQCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.midCollectionView.delegate = self;
    self.midCollectionView.dataSource = self;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.backgroundColor = [UIColor redColor];
    [self.rightBtn setTitle:@"下周" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBtn addTarget:self action:@selector(getNextWeekData) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self addSubview:self.rightBtn];
    [self.rightBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.midCollectionView];
    [self.rightBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.05];
    [@[self.mounthBtn,self.leftBtn,self.midCollectionView,self.rightBtn] autoAlignViewsToAxis:ALAxisHorizontal];
    [@[self.mounthBtn,self.leftBtn,self.midCollectionView,self.rightBtn] autoMatchViewsDimension:ALDimensionHeight];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self.calendar setLocale:[NSLocale currentLocale]];
    [self.calendar setFirstWeekday:1];
    
    [self getDataWith:date];

}

-(void)getDataWith:(NSDate *)date{

    self.currentDate = date;
    self.weekDataArray =  [self getWeekOfFirstDayWithDate:date];
     [self.midCollectionView reloadData];
}
 // 获取传入日期当前周的数组
-(NSArray *)getWeekOfFirstDayWithDate:(NSDate *)date{

    NSInteger dateWeekNum = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    NSTimeInterval nowTime = [date timeIntervalSince1970]; // date的时间戳
    NSDate *needTimeDate = [NSDate dateWithTimeIntervalSince1970:nowTime - (dateWeekNum - 1)* 24*60*60]; // 根据传入的时间 该周 计算周日的时间

 
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:7];
    for (NSInteger i = 0; i < 7; i++) {
        ZQCalendarModel * model = [[ZQCalendarModel alloc]init];
        NSDate * tempDate = [needTimeDate dateByAddingTimeInterval:i * 24 * 60 * 60];
        if ([self.currentDate.description isEqualToString:tempDate.description]) {
            model.isSelected = YES;
        }
        model.week = self.weekArray[i];
        model.day = tempDate;
        [tempArray addObject:model];
    }
    return tempArray;
}

// 获取下周的数据
-(void)getNextWeekData{
    ZQCalendarModel * model =  self.weekDataArray[6];
    NSDate * lastDate = model.day;
    self.weekDataArray = [self getWeekOfFirstDayWithDate:[lastDate dateByAddingTimeInterval:24 *60*60]];
    
    [self.midCollectionView reloadData];
}
// 获取上周的数据
-(void)getlastWeekData{
    ZQCalendarModel * model =  self.weekDataArray[0];
    NSDate * lastDate = model.day;
    self.weekDataArray = [self getWeekOfFirstDayWithDate:[lastDate dateByAddingTimeInterval:-24 *60*60]];
    
    [self.midCollectionView reloadData];
}

#pragma -mark WSSelectTimeViewDelegate
-(void)selectTimeViewValueChanged:(NSDate *)date{
    
    [self getDataWith:date];
    // 这里可以加一个代理事件(可以做你选中日期之后需要做的事情:例如 筛选等)
}

#pragma -mark   delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.weekDataArray.count;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     static NSString * reuserId = @"UICollectionViewCell";
    ZQCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserId forIndexPath:indexPath];
    ZQCalendarModel * model = self.weekDataArray[indexPath.row];
   
    cell.dateModel = model;
    
    return cell;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(60, 40);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i< self.weekDataArray.count; i++) {
        ZQCalendarModel *model = self.weekDataArray[i];
        if (i == indexPath.row) {
            model.isSelected = YES;
            self.mounthBtn.selectTime = model.day;
            // 这里可以加一个代理事件(可以做你选中日期之后需要做的事情:例如 筛选等)
        }else{
            model.isSelected = NO;
        }
    }
    [collectionView reloadData];
    
}
@end

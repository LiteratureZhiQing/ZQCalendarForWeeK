//
//  WSSelectTimeView.m
//  WinSFA
//
//  Created by zhiqing on 16/7/25.
//  Copyright © 2016年 WinChannel. All rights reserved.
//

#import "ZQSelectTimeView.h"
#import "PureLayout.h"
#import "DatePickerSheet.h"
@interface ZQSelectTimeView ()<DatePickerSheetDelegate>
{
    UIImageView * icon ;
    UIButton * timeButton;
    NSDate * currentDate;

}
@end

@implementation ZQSelectTimeView
-(instancetype)init{
    if (self = [super init]) {
        icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_gridDate"]];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [timeButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        [self addSubview:timeButton];
        [icon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [icon autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
        [icon autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
        [icon autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.2];
        
        [timeButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [timeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [timeButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:icon withOffset:10];
        [timeButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.65];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void)setSelectTime:(NSDate *)selectTime{
    _selectTime = selectTime;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
     [timeButton setTitle:[formatter stringFromDate:selectTime] forState:UIControlStateNormal];
}

- (void)handleTap{
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                                   currentDate:_selectTime
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    [datePickerSheet showDatePickerSheet];
}

-(void)datePickerSheet:(DatePickerSheet *)datePickerSheet chosenDate:(NSDate *)date
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [timeButton setTitle:[dateFormat stringFromDate:date] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(selectTimeViewValueChanged:)]) {
        [self.delegate selectTimeViewValueChanged:date];
    }
    
}
@end

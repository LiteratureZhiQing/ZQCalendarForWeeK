//
//  CollectionViewCell.m
//  日历
//
//  Created by zhiqing on 16/7/21.
//  Copyright © 2016年 asdfghj. All rights reserved.
//

#import "ZQCollectionViewCell.h"
#import "PureLayout.h"
@interface ZQCollectionViewCell ()
{
    UILabel * week;
    UILabel * day;
    UIImageView * imgView;

}

@end

@implementation ZQCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews{
    
    week = [[UILabel alloc]init];
    week.font = [UIFont systemFontOfSize:15];
    day = [[UILabel alloc]init];
    day.font = [UIFont systemFontOfSize:15];
    imgView = [[UIImageView alloc]init];
    [self.contentView addSubview:week];
    [self.contentView addSubview:day];
    [self.contentView addSubview:imgView];
    week.text = @"周一";
    day.text = @"28";
    [week autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5,5,5,0) excludingEdge:ALEdgeTrailing];
    [week autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self
              withMultiplier:0.5];
    [day autoAlignAxis:ALAxisHorizontal toSameAxisOfView:week];
    
    [day autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self
              withMultiplier:0.3];
    [day autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:week];
    
    [day autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:week withMultiplier:1];
    
    [imgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:day];
    [imgView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:day];
    [imgView autoSetDimension:ALDimensionWidth toSize:10];
    [imgView autoSetDimension:ALDimensionHeight toSize:10];
    
}

-(void)setDateModel:(ZQCalendarModel *)dateModel{
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"yyyy-MM-dd"];
    NSString * tempDateString = [formatDate stringFromDate:dateModel.day ];
    week.text = dateModel.week;
    day.text = [NSString stringWithFormat:@"%.ld",[[tempDateString componentsSeparatedByString:@"-"] lastObject].integerValue];;
    if (dateModel.isSelected) {
        self.backgroundColor = [UIColor greenColor];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}


@end

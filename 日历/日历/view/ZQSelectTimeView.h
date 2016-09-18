//
//  WSSelectTimeView.h
//  WinSFA
//
//  Created by zhiqing on 16/7/25.
//  Copyright © 2016年 WinChannel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQSelectTimeViewDelegate <NSObject>

-(void)selectTimeViewValueChanged:(NSDate *)date;

@end

@interface ZQSelectTimeView : UIView
@property(nonatomic,strong)NSDate * selectTime;
@property(nonatomic,weak) id <ZQSelectTimeViewDelegate> delegate;
@end

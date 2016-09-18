

#import "ZQYMPickView.h"

static const CGFloat YEAR_WIDTH = 100.0f;

static const CGFloat MONTH_WIDTH = 100.0f;

static const NSInteger YM_RANGE = 25;



@implementation ZQYMPickView

- (id)initWithFrame:(CGRect)frame withNowDateStr:(NSString *)nowDateStr{
    if (self = [super initWithFrame:frame]) {
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:frame];
        // 显示选中框
        pickerView.showsSelectionIndicator=YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:
                                            NSYearCalendarUnit|
                                            NSMonthCalendarUnit|
                                            NSDayCalendarUnit|
                                            NSWeekdayCalendarUnit fromDate:[NSDate date]];;
        _months = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
        _years = [NSMutableArray array];
        for (NSInteger i = dateComponents.year -YM_RANGE;i < dateComponents.year + YM_RANGE; i++) {
            [_years addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        
        if (nowDateStr) {
            NSArray *YMTimeArray =[nowDateStr componentsSeparatedByString:@"-"];
            _currentYear = [YMTimeArray objectAtIndex:0];
            _currentMonth =[YMTimeArray objectAtIndex:1];
        }
        else{
            _currentYear = [NSString stringWithFormat:@"%ld",dateComponents.year];
            _currentMonth = [NSString stringWithFormat:@"%ld",dateComponents.month];
            if (dateComponents.month < 10) {
                _currentMonth = [NSString stringWithFormat:@"0%ld",dateComponents.month];
            }
            
        }
        
        NSInteger yearIndex = [_years indexOfObject:_currentYear];
        NSInteger monthIndex = [_months indexOfObject:_currentMonth];
        [pickerView  selectRow:yearIndex inComponent:0 animated:YES];
        [pickerView selectRow:monthIndex inComponent:1 animated:YES];
        [self  addSubview:pickerView];
        

        NSString *date = [NSString stringWithFormat:@"%@-%@",_currentYear,_currentMonth];
        _selecteDate = date;
        return self;
    }
    return nil;
    
}
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_years count];
    }
    return [_months count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 0) {
        return YEAR_WIDTH;
    }
    return MONTH_WIDTH;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _currentYear = [_years objectAtIndex:row];
    } else {
        _currentMonth = [_months objectAtIndex:row];
    }
    NSString *date = [NSString stringWithFormat:@"%@-%@",_currentYear,_currentMonth];
    _selecteDate = date;
    NSLog(@"selectedDate--%@",date);
    if ([_delegate respondsToSelector:@selector(pickView:selectedDate:)]) {
        [_delegate pickView:self selectedDate:date];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
        return [_years objectAtIndex:row];
    }
    return [_months objectAtIndex:row];
}

@end

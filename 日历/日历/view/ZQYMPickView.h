

#import <UIKit/UIKit.h>

@protocol ZQYMPickerViewDelegate;

@interface ZQYMPickView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)NSMutableArray *years;
@property (nonatomic,strong)NSArray *months;
@property (nonatomic,strong)NSString *currentYear;
@property (nonatomic,strong)NSString *currentMonth;
@property (nonatomic,strong)NSString *selecteDate;

@property (nonatomic, weak) id <ZQYMPickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withNowDateStr:(NSString *)nowDateStr;

@end


@protocol ZQYMPickerViewDelegate <NSObject>

- (void)pickView:(ZQYMPickView *)pickView selectedDate:(NSString *)date;

@end
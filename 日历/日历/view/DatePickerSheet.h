

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>

#import "ZQYMPickView.h"

typedef enum {
    WSDatePickerSheetModeDate,
    WSDatePickerSheetModeYM,
    WSDatePickerSheetModeTime
}WSDatePickerSheetMode;


@protocol DatePickerSheetDelegate;

@interface DatePickerSheet : NSObject
@property (nonatomic, strong) UIDatePicker      *curDatePicker;
@property (nonatomic, strong) ZQYMPickView *currentYMPickView;
@property (nonatomic ,assign) WSDatePickerSheetMode datePickerSheetMode;

+ (DatePickerSheet*) getInstance;

- (void) initializationYMPickViewWithNowDateStr:(NSString *)nowDateStr
                                 WithMaxDate:(NSDate*)maxDate
                                 withMinDate:(NSDate*)minDate
                      withDatePickeSheetMode:(WSDatePickerSheetMode)mode
                                withDelegate:(id <DatePickerSheetDelegate>)delegate;

- (void) initializationWithNowDate:(NSDate *)nowDate
                       WithMaxDate:(NSDate*)maxDate
                       withMinDate:(NSDate*)minDate
                withDatePickerMode:(UIDatePickerMode)mode
                      withDelegate:(id <DatePickerSheetDelegate>)delegate;

- (void) initializationWithMaxDate:(NSDate*)maxDate
                       withMinDate:(NSDate*)minDate
                       currentDate:(NSDate *)date
                withDatePickerMode:(UIDatePickerMode)mode
                      withDelegate:(id <DatePickerSheetDelegate>)delegate;

- (void) initializationWithDatePicker:(UIDatePicker*)datePicker
                       withDelegate:(id <DatePickerSheetDelegate>)delegate;

- (void) showDatePickerSheet;

@end


@protocol DatePickerSheetDelegate <NSObject>

-(void) datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date;
@optional
-(void) datePickerSheet:(DatePickerSheet*)datePickerSheet isCancel:(BOOL)cancel;

@end

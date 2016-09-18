

#import "DatePickerSheet.h"
#import "UIView+ViewController.h"
#import "PureLayout.h"
#define parserLuaScriptParam(title, ...) [NSString stringWithFormat: title, ##__VA_ARGS__]

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

@interface DatePickerSheet() <UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheet     *curActionSheet;
#ifdef __IPHONE_8_0
@property (nonatomic, strong) UIAlertController *curAlertController;
#endif
@property (nonatomic, assign) id <DatePickerSheetDelegate> curDelegate;

@end

@implementation DatePickerSheet

+ (DatePickerSheet*) getInstance
{
    static DatePickerSheet *instance = nil;
    @synchronized(self){
        if (instance == nil) {
            instance = [[DatePickerSheet alloc] init];
        }
        
        return instance;
    }
}

- (void)initializationYMPickViewWithNowDateStr:(NSString *)nowDateStr
                                   WithMaxDate:(NSDate *)maxDate
                                   withMinDate:(NSDate *)minDate
                        withDatePickeSheetMode:(WSDatePickerSheetMode)mode
                                  withDelegate:(id<DatePickerSheetDelegate>)delegate{
    
//    _currentYMPickView = [[WSYMPickView alloc]initWithFrame:CGRectMake(20, 2, 280, 216) withNowDateStr:nowDateStr];
    _currentYMPickView = [[ZQYMPickView alloc]initWithFrame:CGRectZero withNowDateStr:nowDateStr];
    
    self.curDelegate = delegate;
    self.datePickerSheetMode = mode;
#ifdef __IPHONE_8_0
    if ([self systemVersionLowerThan:@"8.0"])
    {
#endif
        NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
        self.curActionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"确定", @"确定"), nil];
        [self.curActionSheet addSubview:_currentYMPickView];
        [_currentYMPickView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_currentYMPickView autoPinEdgeToSuperviewEdge:ALEdgeBottom];

        [_currentYMPickView autoPinEdgeToSuperviewEdge:ALEdgeLeading];

        [_currentYMPickView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];

#ifdef __IPHONE_8_0
    }else {
        NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
        UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"iPad Simulator"]) {
            title = @"\n\n\n\n\n\n\n\n\n";
            style = UIAlertControllerStyleAlert;
            
//            CGRect rect = _currentYMPickView.bounds;
//            rect.origin.x = 28;
//            [_currentYMPickView setBounds:rect];
        }
        self.curAlertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:style];
        
        [self.curAlertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self clickedOkActionButton];
        }]];
        
        [self.curAlertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self clickedCancelActionButton];
        }]];
        
        [self.curAlertController.view addSubview:_currentYMPickView];
        [_currentYMPickView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_currentYMPickView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [_currentYMPickView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        
        [_currentYMPickView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    }
#endif
  
}

- (void) initializationWithNowDate:(NSDate *)nowDate
                       WithMaxDate:(NSDate*)maxDate
                       withMinDate:(NSDate*)minDate
                withDatePickerMode:(UIDatePickerMode)mode
                      withDelegate:(id <DatePickerSheetDelegate>)delegate{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = mode;
    [datePicker setDate:nowDate animated:YES];
    datePicker.maximumDate = maxDate;
    datePicker.minimumDate = minDate;
    [self initializationWithDatePicker:datePicker withDelegate:delegate];
    
}
- (void) initializationWithMaxDate:(NSDate*)maxDate
                       withMinDate:(NSDate*)minDate
                       currentDate:(NSDate *)date
                        withDatePickerMode:(UIDatePickerMode)mode
                        withDelegate:(id<DatePickerSheetDelegate>)delegate{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = mode;
    datePicker.maximumDate = maxDate;
    datePicker.minimumDate = minDate;
    
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    
    if (mode == UIDatePickerModeDate) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else if (mode == UIDatePickerModeDateAndTime) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (date) {
        [datePicker setDate:date animated:YES];
    }
    
//    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier: [UIDevice sysLanguage]];
    [self initializationWithDatePicker:datePicker withDelegate:delegate];
}
- (void) initializationWithDatePicker:(UIDatePicker*)datePicker
                       withDelegate:(id <DatePickerSheetDelegate>)delegate
{
    self.curDatePicker = datePicker;
    self.curDelegate = delegate;
    
#ifdef __IPHONE_8_0
    if ([self systemVersionLowerThan:@"8.0"])
    {
#endif
        NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
        self.curActionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"确定", @"确定"), nil];
        [self.curActionSheet addSubview:self.curDatePicker];
#ifdef __IPHONE_8_0
    }else {
        NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
        UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"iPad Simulator"]) {
            title = @"\n\n\n\n\n\n\n\n\n";
            style = UIAlertControllerStyleAlert;
            
//            CGRect rect = self.curDatePicker.bounds;
//            rect.origin.x = 28;
//            [self.curDatePicker setBounds:rect];
        }
        self.curAlertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:style];
        [self.curAlertController.view addSubview:self.curDatePicker];
        [self.curDatePicker autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.curDatePicker autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:80];

        [self.curDatePicker autoPinEdgeToSuperviewEdge:ALEdgeLeading];

        [self.curDatePicker autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.curAlertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self clickedOkActionButton];
        }]];
//        [self.curAlertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"消除", @"消除") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            [self clickedClearActionButton];
//        }]];
        [self.curAlertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self clickedCancelActionButton];
        }]];
        

    }
#endif
}

- (void) showDatePickerSheet
{
#ifdef __IPHONE_8_0
    if ([self systemVersionLowerThan:@"8.0"]) {
#endif
        [self.curActionSheet showInView:[[UIApplication sharedApplication].delegate window]];
#ifdef __IPHONE_8_0
    }else {
        if (self.curDelegate) {
            UIViewController *parentVC = nil;
            if ([self.curDelegate isKindOfClass:[UIViewController class]]) {
                 parentVC = (UIViewController*)self.curDelegate;
            }else if ([self.curDelegate isKindOfClass:[UIView class]]) {
                UIView *tmpView = (UIView*)self.curDelegate;
                parentVC = [tmpView viewController];
            }else {
                parentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            }
            
            if (parentVC) {
                [parentVC presentViewController:self.curAlertController
                                       animated:YES
                                     completion:^{
                                     }];
            }
        }
    }
#endif
}


#pragma mark - private method
- (BOOL)systemVersionLowerThan:(NSString*)version
{
    if (version == nil || version.length == 0) {
        NSLog(@"### Error Version");
        return NO;
    }
    
    if ([[UIDevice currentDevice].systemVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void) clickedOkActionButton
{
    NSDate *selecteDate = nil;
    if (self.datePickerSheetMode == WSDatePickerSheetModeYM) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
        selecteDate = [formatter  dateFromString:_currentYMPickView.selecteDate];
    } else {
        selecteDate = self.curDatePicker.date;
    }
    if (self.curDelegate && [self.curDelegate respondsToSelector:@selector(datePickerSheet:chosenDate:)]) {
        [self.curDelegate datePickerSheet:self chosenDate:selecteDate];
    }
    
}
- (void) clickedCancelActionButton
{
    if (self.curDelegate && [self.curDelegate respondsToSelector:@selector(datePickerSheet:isCancel:)]) {
        [self.curDelegate datePickerSheet:self isCancel:YES];
    }
}
- (void) clickedClearActionButton
{

    if (self.curDelegate && [self.curDelegate respondsToSelector:@selector(datePickerSheet:chosenDate:)]) {
        [self.curDelegate datePickerSheet:self chosenDate:nil];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self clickedOkActionButton];
}

@end

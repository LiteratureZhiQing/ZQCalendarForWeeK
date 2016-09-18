

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

//@interface UIColor(category)
//
//+(UIColor *)colorWithHexString:(NSString *)stringToConvert;
//
//@end
//
//
//
//@implementation UIColor(category)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    
    if ([stringToConvert isEqualToString:@""]) {
        return [UIColor colorWithWhite:(float)(0/255.0f) alpha:0.0f];
    }
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor colorWithRed:(float)(255/255.0f)green:(float)(255/255.0f)blue:(float)(255/255.0f)alpha:1.0f];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] == 6 ||  [cString length] == 8){
        // Separate into r, g, b substrings
        NSRange range;
        range.length = 2;
        range.location = 0;
        // Scan values
        NSString *aString = nil;
        if ([cString length] == 8 ) {
            aString = [cString substringWithRange:range];
            range.location += 2;
        }
        NSString *rString = [cString substringWithRange:range];
        range.location += 2;
        
        NSString *gString = [cString substringWithRange:range];
        range.location += 2;
        
        
        NSString *bString = [cString substringWithRange:range];
        
        unsigned int r, g, b ,a;
        if (aString) {
            [[NSScanner scannerWithString:aString] scanHexInt:&a];
        }else{
            a = 255;
        }
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
         return [UIColor colorWithRed:(float)(r/255.0f)green:(float)(g/255.0f)blue:(float)(b/255.0f)alpha:(float)(a/255.0f)];
    }else{
    
         return [UIColor colorWithRed:(float)(255/255.0f)green:(float)(255/255.0f)blue:(float)(255/255.0f)alpha:1.0f];
    }
}

@end

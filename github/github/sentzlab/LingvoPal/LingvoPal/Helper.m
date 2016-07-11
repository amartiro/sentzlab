//
//  Helper.m
//  LingovoPal
//
//  Created by Artak Martirosyan on 4/8/15.
//  Copyright (c) 2015 SentzLab. All rights reserved.
//

#import "Helper.h"
#import <UIKit/UIKit.h>
//#import "VideoCallViewController.h"
//#import "GustConferenceViewController.h"
//#import "ChatManager.h"
//#import "Settings.h"


typedef enum {
    szInvalidDevice = -1,
    sziPhone4 = 0,
    sziPhone5 = 1,
    sziPhone6 = 2,
    sziPhone6Plus = 3
    
} SzDeviceModel;


static SzDeviceModel deviceModel = -1;
static NSDictionary * langDict;

@implementation Helper

+(BOOL) isIOS7{
    return ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0);
}

+(BOOL) isIPAD{
    return ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad);
}

+ (NSString *)GetUUID {
    
    UIDevice *myDevice=[UIDevice currentDevice];
    NSString *UUID = [[myDevice identifierForVendor] UUIDString];
    return UUID;
}

+(UIFont *) fontWithSize:(NSInteger ) size{
//        for (NSString *familyName in [UIFont familyNames]) {
//            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//                NSLog(@"%@", fontName);
//            }
//        }

    
    return [UIFont fontWithName:@"MyriadPro-Regular" size:[Helper getValue:size]];
}

//+(UIFont *) boldFontWithSize:(NSInteger ) size{
//    return [UIFont fontWithName:@"CaviarDreams-Bold" size:[Helper getValue:size]];
//
//}

+(SzDeviceModel) getDeviceModel{
    if (deviceModel == -1) {
        CGSize boundSize = [UIScreen mainScreen].bounds.size;
        NSInteger maxSize = MAX(boundSize.width, boundSize.height);
        NSInteger minSize = MIN(boundSize.width, boundSize.height);
        
        if (minSize == 320) {
            if (maxSize == 480) {
                deviceModel = sziPhone4;
            } else if (maxSize == 568){
                deviceModel = sziPhone5;
            }
        } else if ((minSize == 375) && (maxSize == 667)){
            deviceModel = sziPhone6;
        } else if ((minSize == 414) && (maxSize == 736)){
            deviceModel = sziPhone6Plus;
        }
    }
  
    return deviceModel;
}

+(BOOL) isiPhone4{
    return [Helper getDeviceModel] == sziPhone4;
}

+(BOOL) isiPhone5{
    return [Helper getDeviceModel] == sziPhone5;
}

+(BOOL) isiPhone6{
    return [Helper getDeviceModel] == sziPhone6;
}

+(BOOL) isiPhone6Plus{
    return [Helper getDeviceModel] == sziPhone4;
}

+(UIView *) getWhiteViewWithLength:(NSInteger) length{
    UIView *view = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, length, 2)]];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

//+(UIView *) getHalfWhiteView{
//    UIView *view = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 126, 2)]];
//    view.backgroundColor = [UIColor whiteColor];
//    return view;
//}

+(UIImage *) getImageByImageName:(NSString *) imageName{
    NSString *realImageName = nil;
    UIImage * image = nil;
    
    SzDeviceModel deviceModel = [Helper getDeviceModel];
  
    switch (deviceModel) {
        case sziPhone4:{
            realImageName = [NSString stringWithFormat:@"%@.png", imageName];
            image = [UIImage imageNamed:realImageName];
            if (image == nil) {
                realImageName = [NSString stringWithFormat:@"%@_iphone5.png", imageName];
                image = [UIImage imageNamed:realImageName];
            }
        }
            break;
        case sziPhone5:{
            realImageName = [NSString stringWithFormat:@"%@_iphone5.png", imageName];
            image = [UIImage imageNamed:realImageName];
        }
            break;
        case sziPhone6:{
            realImageName = [NSString stringWithFormat:@"%@_iphone6.png", imageName];
            image = [UIImage imageNamed:realImageName];
        }
            break;
        case sziPhone6Plus:{
            realImageName = [NSString stringWithFormat:@"%@_iphone6+.png", imageName];
            image = [UIImage imageNamed:realImageName];
        }
            break;
        default:
            break;
    }

    return image;
}

+(UIImage *) getJpegImageByImageName:(NSString *) imageName{
    NSString *realImageName = nil;
    UIImage * image = nil;
    
    SzDeviceModel deviceModel = [Helper getDeviceModel];
    
    switch (deviceModel) {
        case sziPhone4:{
            realImageName = [NSString stringWithFormat:@"%@.jpg", imageName];
            image = [UIImage imageNamed:realImageName];
            if (image == nil) {
                realImageName = [NSString stringWithFormat:@"%@_iphone5.jpg", imageName];
                image = [UIImage imageNamed:realImageName];
            }
        }
            break;
        case sziPhone5:{
            realImageName = [NSString stringWithFormat:@"%@_iphone5.jpg", imageName];
            image = [UIImage imageNamed:realImageName];
        }
            break;
        case sziPhone6:{
            realImageName = [NSString stringWithFormat:@"%@_iphone6.jpg", imageName];
            image = [UIImage imageNamed:realImageName];
        }
            break;
        case sziPhone6Plus:{
            realImageName = [NSString stringWithFormat:@"%@_iphone6+.jpg", imageName];
            image = [UIImage imageNamed:realImageName];
        }
            break;
        default:
            break;
    }
    
    return image;
}

+(BOOL) isValidNickName:(NSString*) name{
    if (name == nil) {
        return NO;
    }
    if ([name length] == 0) {
        return NO;
    }
    
    return YES;
}


+(BOOL) isValidEmail:(NSString*) email{
    if (email == nil) {
        return NO;
    }
    if ([email length] == 0) {
        return NO;
    }
    
    NSString *regExPattern = @"^[A-Z0-9._-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    //   NSLog(@"%i", regExMatches);
    
    return (regExMatches != 0);
}

+(BOOL) isValidPassword:(NSString *) pass{
    return [pass length] > 5;
}

+(CGFloat) getValue:(CGFloat) value{
    SzDeviceModel deviceModel = [Helper getDeviceModel];
    
    switch (deviceModel) {
        case sziPhone6Plus:
            return (414.0f * value)/320.0f;
            break;
        case sziPhone6:
            return (375.0f*value)/320.0f;
            break;
        default:
            return value;
            break;
    }
}

+(CGPoint) getPointValue:(CGPoint) point{
    CGFloat coeficent = [Helper getValue:1];
    
    return CGPointMake(coeficent * point.x, coeficent * point.y);
}


+(CGRect) getRectValue:(CGRect) rect{
    
    CGFloat coeficent = [Helper getValue:1];
    
    return CGRectMake(coeficent * rect.origin.x, coeficent * rect.origin.y, coeficent * rect.size.width, coeficent * rect.size.height);
}

+(void) showAlertViewWithText:(NSString *) text delegate:(id /*<UIAlertViewDelegate>*/)delegate {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:delegate cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [alertView show];
}

+(NSString *) getVisibleValue:(NSString *) value{
//    if ([value length] == 6) {
//        return [NSString stringWithFormat:@"%@,%@", [value substringToIndex:4], [value substringFromIndex:4]];
//    }
    return value;
}

+(CGPoint) parsePoint:(NSString *) pointStr{
    NSRange range = [pointStr rangeOfString:@"_"];
    if (range.location != NSNotFound) {
        NSString *xStr = [pointStr substringToIndex:range.location];
        NSString *yStr = [pointStr substringFromIndex:(range.location + 1)];
        
        return CGPointMake([xStr integerValue], [yStr integerValue]);
    }
    
    return CGPointMake(0, 0);
}

//+(NSString *) polishNumber:(NSString *) number{
//    NSMutableString *result = [NSMutableString stringWithString:number];
//    [result replaceOccurrencesOfString:@"_" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, result.length)];
//    [result replaceOccurrencesOfString:@"/" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, result.length)];
//    return [NSString stringWithString:result];
//}

+(NSString *) getTimeString:(NSInteger) time{
    NSString *resultString = [NSString string];
    
    NSInteger hour = time/3600;
    time %= 3600;
    NSInteger minute = time/60;
    NSInteger second = time%60;
    
    
    if (hour > 0) {
        resultString = [NSString stringWithFormat:@"%ld:%ld:%ld", (long) hour, (long) minute, (long) second];
    } else {
        if (minute > 0) {
            resultString = [NSString stringWithFormat:@"%ld:%ld", (long) minute, (long) second];
        } else {
            resultString = [NSString stringWithFormat:@"%ld", (long) second];
        }
    }
    
    return resultString;
}

+(NSString *) getMinutesString:(NSInteger) time{
    return [NSString stringWithFormat:@"%ld min", (long) round((double)time/ 60) ];
}



+(UIColor *) getGameCellColor:(NSInteger) index{
    switch (index) {
        case 1:
            return [UIColor colorWithRed:(67.0f/255.0f) green:(106.0f/255.0f) blue:(155.0f/255.0f) alpha:1.0f];
            break;
        case 2:
            return [UIColor colorWithRed:(67.0f/255.0f) green:(124.0f/255.0f) blue:(154.0f/255.0f) alpha:1.0f];
            break;
        case 3:
            return [UIColor colorWithRed:(67.0f/255.0f) green:(138.0f/255.0f) blue:(153.0f/255.0f) alpha:1.0f];
            break;
        case 4:
            return [UIColor colorWithRed:(67.0f/255.0f) green:(153.0f/255.0f) blue:(148.0f/255.0f) alpha:1.0f];
            break;
        case 5:
            return [UIColor colorWithRed:(67.0f/255.0f) green:(152.0f/255.0f) blue:(129.0f/255.0f) alpha:1.0f];
            break;
        case 6:
            return [UIColor colorWithRed:(67.0f/255.0f) green:(151.0f/255.0f) blue:(106.0f/255.0f) alpha:1.0f];
            break;
        default:
            return [UIColor clearColor];
            break;
    }
}

+(NSDictionary *) getLangDict {
    if (langDict == nil) {
        langDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Abkhazian",@"ab",
                    @"Afar",@"aa",
                    @"Afrikaans",@"af",
                    @"Albanian",@"sq",
                    @"Amharic",@"am",
                    @"Arabic",@"ar",
                    @"Armenian",@"hy",
                    @"Assamese",@"as",
                    @"Aymara",@"ay",
                    @"Azerbaijani",@"az",
                    @"Bashkir",@"ba",
                    @"Basque",@"eu",
                    @"Bengali (Bangla)",@"bn",
                    @"Bhutani",@"dz",
                    @"Bihari",@"bh",
                    @"Bislama",@"bi",
                    @"Breton",@"br",
                    @"Bulgarian",@"bg",
                    @"Burmese",@"my",
                    @"Byelorussian (Belarusian)",@"be",
                    @"Cambodian",@"km",
                    @"Catalan",@"ca",
                    @"Chinese",@"zh",
                    @"Corsican",@"co",
                    @"Croatian",@"hr",
                    @"Czech",@"cs",
                    @"Danish",@"da",
                    @"Dutch",@"nl",
                    @"English",@"en",
                    @"Esperanto",@"eo",
                    @"Estonian",@"et",
                    @"Faeroese",@"fo",
                    @"Farsi",@"fa",
                    @"Fiji",@"fj",
                    @"Finnish",@"fi",
                    @"French",@"fr",
                    @"Frisian",@"fy",
                    @"Gaelic (Manx)",@"gv",
                    @"Gaelic (Scottish)",@"gd",
                    @"Galician",@"gl",
                    @"Georgian",@"ka",
                    @"German",@"de",
                    @"Greek",@"el",
                    @"Greenlandic",@"kl",
                    @"Guarani",@"gn",
                    @"Gujarati",@"gu",
                    @"Hausa",@"ha",
                    @"Hebrew",@"he",
                    @"Hindi",@"hi",
                    @"Hungarian",@"hu",
                    @"Icelandic",@"is",
                    @"Indonesian",@"id",
                    @"Interlingua",@"ia",
                    @"Interlingue",@"ie",
                    @"Inuktitut",@"iu",
                    @"Inupiak",@"ik",
                    @"Irish",@"ga",
                    @"Italian",@"it",
                    @"Japanese",@"ja",
                    @"Javanese",@"jv",
                    @"Kannada",@"kn",
                    @"Kashmiri",@"ks",
                    @"Kazakh",@"kk",
                    @"Kinyarwanda (Ruanda)",@"rw",
                    @"Kirghiz",@"ky",
                    @"Kirundi (Rundi)",@"rn",
                    @"Korean",@"ko",
                    @"Kurdish",@"ku",
                    @"Laothian",@"lo",
                    @"Latin",@"la",
                    @"Latvian (Lettish)",@"lv",
                    @"Limburgish ( Limburger)",@"li",
                    @"Lingala",@"ln",
                    @"Lithuanian",@"lt",
                    @"Macedonian",@"mk",
                    @"Malagasy",@"mg",
                    @"Malay",@"ms",
                    @"Malayalam",@"ml",
                    @"Maltese",@"mt",
                    @"Maori",@"mi",
                    @"Marathi",@"mr",
                    @"Moldavian",@"mo",
                    @"Mongolian",@"mn",
                    @"Nauru",@"na",
                    @"Nepali",@"ne",
                    @"Norwegian",@"no",
                    @"Occitan",@"oc",
                    @"Oriya",@"or",
                    @"Oromo (Afan, Galla)",@"om",
                    @"Pashto (Pushto)",@"ps",
                    @"Polish",@"pl",
                    @"Portuguese",@"pt",
                    @"Punjabi",@"pa",
                    @"Quechua",@"qu",
                    @"Rhaeto-Romance",@"rm",
                    @"Romanian",@"ro",
                    @"Russian",@"ru",
                    @"Samoan",@"sm",
                    @"Sangro",@"sg",
                    @"Sanskrit",@"sa",
                    @"Serbian",@"sr",
                    @"Serbo-Croatian",@"sh",
                    @"Sesotho",@"st",
                    @"Setswana",@"tn",
                    @"Shona",@"sn",
                    @"Sindhi",@"sd",
                    @"Sinhalese",@"si",
                    @"Siswati",@"ss",
                    @"Slovak",@"sk",
                    @"Slovenian",@"sl",
                    @"Somali",@"so",
                    @"Spanish",@"es",
                    @"Sundanese",@"su",
                    @"Swahili (Kiswahili)",@"sw",
                    @"Swedish",@"sv",
                    @"Tagalog",@"tl",
                    @"Tajik",@"tg",
                    @"Tamil",@"ta",
                    @"Tatar",@"tt",
                    @"Telugu",@"te",
                    @"Thai",@"th",
                    @"Tibetan",@"bo",
                    @"Tigrinya",@"ti",
                    @"Tonga",@"to",
                    @"Tsonga",@"ts",
                    @"Turkish",@"tr",
                    @"Turkmen",@"tk",
                    @"Twi",@"tw",
                    @"Uighur",@"ug",
                    @"Ukrainian",@"uk",
                    @"Urdu",@"ur",
                    @"Uzbek",@"uz",
                    @"Vietnamese",@"vi",
                    @"Volapük",@"vo",
                    @"Welsh",@"cy",
                    @"Wolof",@"wo",
                    @"Xhosa",@"xh",
                    @"Yiddish",@"yi",
                    @"Yoruba",@"yo",
                    @"Zulu",@"zu", nil];
    }
    
    return langDict;
}

+(NSString *) getLanguageFromABRV:(NSString *) lang{
    NSDictionary *langDict = [Helper getLangDict];
    
    NSString *valueStr = langDict[lang];
    
    return valueStr ? valueStr : @"";
}

+(NSString *) getCallType:(CallType) type{
    switch (type) {
        case sntzPhoneCall:
            return @"Phone Call";
            break;
        case sntzVideoCall:
            return @"Video Call";
            break;
            
        case sntzConfVideoCall:
            return @"Conference Video Call";
            break;
            
        case sntzConfPhoneCall:
            return @"Conference Phone Call";
            break;
            
        default:
            break;
    }
    
    return @"";
}

+(UIView *) getRateView:(NSInteger) rate{
    UIView *view  = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 80, 16)]];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *starView1 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:((rate >= 1) ? @"full_star" : @"empty_star")]];
    UIImageView *starView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:((rate >= 2) ? @"full_star" : @"empty_star")]];
    UIImageView *starView3 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:((rate >= 3) ? @"full_star" : @"empty_star")]];
    UIImageView *starView4 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:((rate >= 4) ? @"full_star" : @"empty_star")]];
    UIImageView *starView5 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:((rate == 5) ? @"full_star" : @"empty_star")]];
    
    starView1.center = [Helper getPointValue:CGPointMake(8, 8)];
    starView2.center = [Helper getPointValue:CGPointMake(24, 8)];
    starView3.center = [Helper getPointValue:CGPointMake(40, 8)];
    starView4.center = [Helper getPointValue:CGPointMake(56, 8)];
    starView5.center = [Helper getPointValue:CGPointMake(72, 8)];
    
    [view addSubview:starView1];
    [view addSubview:starView2];
    [view addSubview:starView3];
    [view addSubview:starView4];
    [view addSubview:starView5];
    
    return view;
}

+(NSArray *) getLangsArray{
    NSArray *keyArray =  [[Helper getLangDict] allKeys];
    
    keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(NSString* a, NSString* b) {
        
        return [[Helper getLanguageFromABRV:a] compare:[Helper getLanguageFromABRV:b]];
    }];
    
    return keyArray;
}

+(void)deinitializeTimer:(NSTimer *) timer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

+(BOOL) isConnected{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com/m"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        return YES;
        NSLog(@"Device is connected to the Internet");
    } else{
        return NO;
        NSLog(@"Device is not connected to the Internet");
    }
    return YES;
}

+(CGSize) getTextHeight:(NSString *) text withFont:(UIFont *) font andWidth:(CGFloat) width{
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil];
    
    return rect.size;
}

@end

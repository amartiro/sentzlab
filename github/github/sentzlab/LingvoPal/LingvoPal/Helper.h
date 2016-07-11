//
//  Helper.h
//  SentzBet
//
//  Created by Artak Martirosyan on 4/8/14.
//  Copyright (c) 2015 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    sntzInvalidCall = -1,
    sntzVideoCall = 0,
    sntzConfVideoCall = 1,
    sntzPhoneCall = 2,
    sntzConfPhoneCall = 3,


} CallType;

@interface Helper : NSObject

+ (NSString *)GetUUID;

+(BOOL) isIOS7;
+(BOOL) isIPAD;

+(BOOL) isiPhone4;
+(BOOL) isiPhone5;
+(BOOL) isiPhone6;
+(BOOL) isiPhone6Plus;

+(UIFont *) fontWithSize:(NSInteger ) size;
//+(UIFont *) boldFontWithSize:(NSInteger ) size;

//+(NSString *) polishNumber:(NSString *) number;

+(UIView *) getWhiteViewWithLength:(NSInteger) length;
//+(UIView *) getHalfWhiteView;


+(UIImage *) getImageByImageName:(NSString *) imageName;
+(UIImage *) getJpegImageByImageName:(NSString *) imageName;

+(BOOL) isValidNickName:(NSString*) name;
+(BOOL) isValidEmail:(NSString*) email;
+(BOOL) isValidPassword:(NSString *) pass;

+(CGFloat) getValue:(CGFloat) value;

+(CGPoint) getPointValue:(CGPoint) point;

+(CGRect) getRectValue:(CGRect) rect;

+(void) showAlertViewWithText:(NSString *) text delegate:(id /*<UIAlertViewDelegate>*/)delegate;

+(NSString *) getVisibleValue:(NSString *) value;

+(CGPoint) parsePoint:(NSString *) pointStr;

//+(NSString *) polishNumber:(NSString *) number;

+(NSString *) getMinutesString:(NSInteger) time;

+(NSString *) getTimeString:(NSInteger) time;

+(UIColor *) getGameCellColor:(NSInteger) index;

+(NSString *) getLanguageFromABRV:(NSString *) lang;

+(NSString *) getCallType:(CallType) type;

+(UIView *) getRateView:(NSInteger) rate;

+(NSArray *) getLangsArray;

+(void)deinitializeTimer:(NSTimer *) timer;

+(BOOL) isConnected;

+(CGSize) getTextHeight:(NSString *) text withFont:(UIFont *) font andWidth:(CGFloat) size;

@end

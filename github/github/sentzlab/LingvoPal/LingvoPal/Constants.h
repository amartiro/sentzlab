//
//  Constants.h
//  SentzBet
//
//  Created by Artak on 10/8/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString * const restfullPath;

extern NSString *const kAccessId;
extern NSString *const kAccessToken;
extern NSString *const kTranslatorId;
extern NSString *const kEmail;
extern NSString *const kPassword;
extern NSString *const kNickName;
extern NSString *const kName;
extern NSString *const kSurname;

extern NSString *const kQBId;
extern NSString *const kQBPassword;

extern NSString *const koVoId;
extern NSString *const kStreamId;

extern NSString *const kPreferedLang1;
extern NSString *const kPreferedLang2;

extern NSString *const kDeviceToken;

extern NSString *const kInvalidIdTokenNotification;
extern NSString *const kIndexNotification;

extern NSString *const kNewOrderNotification;
extern NSString *const kOpenOrdersNotification;
extern NSString *const kAcceptOrderNotification;
extern NSString *const kAcceptTranslatorNotification;



#define LOGIN @"login"
#define SOCIAL_LOGIN @"soc_login"
#define REGISTER @"register"
#define FORGOT_PASSWORD @"forgot_password"

#define GET_TRANS @"get_trans"
#define GET_LANGS @"get_langs"
#define HISTORY @"history"
#define GET_TRANS_INFO @"trans_info"

#define MAKE_REVIEW @"set_rate"
#define USER_INFO @"user_info"
#define CHANGE_ACCOUNT @"change_account"
#define LOGOUT @"logout"
#define GET_ORDERS @"get_orders"
#define GET_REVIEWS @"get_reviews"
#define BECOME_TRANSLATOR @"become_trans"
#define GET_TRANSLATOR_ORDERS @"tr_order"

#define ACCEPT_TRANSLATOR @"accept_translator"
#define ACCEPT_ORDER @"accept_order"
#define DECLINE_ORDER @"decline_order"
#define CANCEL_ORDER @"cancel_order"

#define SET_RESERVE @"set_reserve"
#define SET_PUSH @"set_push"
#define SET_LANGS @"set_lang"
#define SET_IMAGE @"set_image"
#define GET_STREAM @"get_stream"

#define SET_HISTORY @"set_history"
#define STREAM_INFO @"stream_info"
#define CALL_USER @"call_user"

#define START_TIME @"time_start"
#define STOP_TIME @"time_stop"
#define CHECK_STREAM @"check_stream"
#define CANCEL_STREAM @"cancel_stream"
#define STREAM_TRANS @"stream_trans"
#define SET_ONLINE @"set_online"
#define CHECK_PASSWORD @"check_password"


@interface Constants : NSObject

@end

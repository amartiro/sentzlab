//
//  PortalSession.h
//  LingvoPal
//
//  Created by Artak on 12/2/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Helper.h"

@protocol PortalSessionDelegate <NSObject>
@optional

-(void) registerWithNickResponse:(NSDictionary *) dict;
-(void) failedToRegisterWithNick:(NSDictionary *) dict;
-(void) timeoutToRegisterWithNick:(NSError *) error;

-(void) loginWithEmailResponse:(NSDictionary *) dict;
-(void) failedToLoginWithEmail:(NSDictionary *) dict;
-(void) timeoutToLoginWithEmail:(NSError *) error;

-(void) loginWithUUIDResponse:(NSDictionary *) dict;
-(void) failedToLoginWithUUID:(NSDictionary *) dict;
-(void) timeoutToLoginWithUUID:(NSError *) error;

-(void) socialLoginResponse:(NSDictionary *) dict;
-(void) failedToSocialLogin:(NSDictionary *) dict;
-(void) timeoutToSocialLogin:(NSError *) error;

-(void) resetPasswordResponse:(NSDictionary *) dict;
-(void) failedToResetPassword:(NSDictionary *) dict;
-(void) timeoutToResetPassword:(NSError *) error;


-(void) getTranslatorResponse:(NSDictionary *) dict;
-(void) failedToGetTranslator:(NSDictionary *) dict;
-(void) timeoutToGetTranslator:(NSError *) error;

-(void) getLangsResponse:(NSDictionary *) dict;
-(void) failedToGetLangs:(NSDictionary *) dict;
-(void) timeoutToGetLangs:(NSError *) error;

-(void) getHistoryResponse:(NSDictionary *) dict;
-(void) failedToGetHistory:(NSDictionary *) dict;
-(void) timeoutToGetHistory:(NSError *) error;

-(void) getTransInfoResponse:(NSDictionary *) dict;
-(void) failedToGetTransInfo:(NSDictionary *) dict;
-(void) timeoutToGetTransInfo:(NSError *) error;

-(void) makeReviewResponse:(NSDictionary *) dict;
-(void) failedToMakeReview:(NSDictionary *) dict;
-(void) timeoutToMakeReview:(NSError *) error;

-(void) getProfileResponse:(NSDictionary *) dict;
-(void) failedToGetProfile:(NSDictionary *) dict;
-(void) timeoutToGetProfile:(NSError *) error;

-(void) changeUserNameResponse:(NSDictionary *) dict;
-(void) failedToChangeUserName:(NSDictionary *) dict;
-(void) timeoutToChangeUserName:(NSError *) error;

-(void) logoutResponse:(NSDictionary *) dict;
-(void) failedToLogout:(NSDictionary *) dict;
-(void) timeoutToLogout:(NSError *) error;

-(void) getOrdersResponse:(NSDictionary *) dict;
-(void) failedToGetOrders:(NSDictionary *) dict;
-(void) timeoutToGetOrders:(NSError *) error;

-(void) getReviewsResponse:(NSDictionary *) dict;
-(void) failedToGetReviews:(NSDictionary *) dict;
-(void) timeoutToGetReviews:(NSError *) error;

-(void) becomeTranslatorResponse:(NSDictionary *) dict;
-(void) failedToBecomeTranslator:(NSDictionary *) dict;
-(void) timeoutToBecomeTranslator:(NSError *) error;


-(void) getTranslatorOrdersResponse:(NSDictionary *) dict;
-(void) failedToGetTranslatorOrders:(NSDictionary *) dict;
-(void) timeoutToGetTranslatorOrders:(NSError *) error;

-(void) acceptOrderResponse:(NSDictionary *) dict;
-(void) failedToAcceptOrder:(NSDictionary *) dict;
-(void) timeoutToAcceptOrder:(NSError *) error;

-(void) declineOrderResponse:(NSDictionary *) dict;
-(void) failedToDeclineOrder:(NSDictionary *) dict;
-(void) timeoutToDeclineOrder:(NSError *) error;


-(void) acceptTransatorResponse:(NSDictionary *) dict;
-(void) failedToAcceptTransator:(NSDictionary *) dict;
-(void) timeoutToAcceptTransator:(NSError *) error;

-(void) setReserveResponse:(NSDictionary *) dict;
-(void) failedToSetReserve:(NSDictionary *) dict;
-(void) timeoutToSetReserve:(NSError *) error;

-(void) setPushResponse:(NSDictionary *) dict;
-(void) failedToSetPush:(NSDictionary *) dict;
-(void) timeoutToSetPush:(NSError *) error;

-(void) setLanguageResponse:(NSDictionary *) dict;
-(void) failedToSetLanguage:(NSDictionary *) dict;
-(void) timeoutToSetLanguage:(NSError *) error;

-(void) setImageResponse:(NSDictionary *) dict;
-(void) failedToSetImage:(NSDictionary *) dict;
-(void) timeoutToSetImage:(NSError *) error;

-(void) cancelOrderResponse:(NSDictionary *) dict;
-(void) failedToCancelOrder:(NSDictionary *) dict;
-(void) timeoutToCancelOrder:(NSError *) error;

-(void) getStreamResponse:(NSDictionary *) dict;
-(void) failedToGetStream:(NSDictionary *) dict;
-(void) timeoutToGetStream:(NSError *) error;

-(void) setHistoryResponse:(NSDictionary *) dict;
-(void) failedToSetHistory:(NSDictionary *) dict;
-(void) timeoutToSetHistory:(NSError *) error;

-(void) getStreamInfoResponse:(NSDictionary *) dict;
-(void) failedToGetStreamInfo:(NSDictionary *) dict;
-(void) timeoutToGetStreamInfo:(NSError *) error;

-(void) callUserResponse:(NSDictionary *) dict;
-(void) failedToCallUser:(NSDictionary *) dict;
-(void) timeoutToCallUser:(NSError *) error;

-(void) startTimeResponse:(NSDictionary *) dict;
-(void) failedToStartTime:(NSDictionary *) dict;
-(void) timeoutToStartTime:(NSError *) error;

-(void) stopTimeResponse:(NSDictionary *) dict;
-(void) failedToStopTime:(NSDictionary *) dict;
-(void) timeoutToStopTime:(NSError *) error;

-(void) checkStreamResponse:(NSDictionary *) dict;
-(void) failedToCheckStream:(NSDictionary *) dict;
-(void) timeoutToCheckStream:(NSError *) error;

-(void) cancelStreamResponse:(NSDictionary *) dict;
-(void) failedToCancelStream:(NSDictionary *) dict;
-(void) timeoutToCancelStream:(NSError *) error;

-(void) getStreamTranslatorResponse:(NSDictionary *) dict;
-(void) failedToGetStreamTranslator:(NSDictionary *) dict;
-(void) timeoutToGetStreamTranslator:(NSError *) error;

-(void) setOnlineResponse:(NSDictionary *) dict;
-(void) failedToSetOnline:(NSDictionary *) dict;
-(void) timeoutToSetOnline:(NSError *) error;

-(void) checkPasswordResponse:(NSDictionary *) dict;
-(void) failedToCheckPassword:(NSDictionary *) dict;
-(void) timeoutToCheckPassword:(NSError *) error;

@end


@interface PortalSession : NSObject<NSURLSessionDataDelegate>{
    NSURLSession *session_;
    
}

+ (PortalSession*)sharedInstance;

@property(nonatomic,weak)id<PortalSessionDelegate> delegate;


- (void) registerWithName:(NSString *) name withSurname:(NSString *)surname withEmail:(NSString *)email withPassword:(NSString *)password withUUID:(NSString *) uuid andRegId:(NSString *) regId;

-(void) loginWithUUID:(NSString *) uuid andRegId:(NSString *) regId andStreamId:(NSString *) streamId;

-(void) loginWithEmail:(NSString *) email andPassword:(NSString *) pass andUUID:(NSString *) uuid andRegId:(NSString *) regId andStreamId:(NSString *) streamId;

-(void) socialLoginWitName:(NSString *) name withSurname:(NSString *)surname withEmail:(NSString *)email withFacbookId:(NSString *)fbId andGoogleId:(NSString *)gId  withUUID:(NSString *) uuid andRegId:(NSString *) regId;

-(void) resetPassword:(NSString *) email;


-(void) getTranslatorForOrderId:(NSString *) orderId declineTransId:(NSString *) trId;

-(void) getLangs;

-(void) getHistoryForTransId:(NSString *) transId withPage:(NSInteger) page;

-(void) getTransInfo:(NSString *) transId;

-(void) makeReview:(NSString *) review withRate:(NSInteger ) rate forTransId:(NSString *) transId;

-(void) getProfile;

-(void) changeUserName:(NSString *) name andSurname:(NSString *) surname andEmail:(NSString *) email;

-(void) logout;

-(void) getOrders;

-(void) getReviewsForTransId:(NSString *) transId;

-(void) becomeTranslator:(NSString *) nativeLang withLang1:(NSString *) lang1 withLang2:(NSString *) lang2;

-(void) getTranslatorOrdersForTransId:(NSString *) transId;

-(void) acceptOrderFromTransId:(NSString *) transId withOrderId:(NSString *) orderId;

-(void) declineOrderFromTransId:(NSString *) transId withOrderId:(NSString *) orderId;

-(void) acceptTransatorWithId:(NSString *) transId withOrderId:(NSString *) orderId;

-(void) setReserveOfTranslatorFromLanguage:(NSString *) fromLang toLanguage:(NSString *) toLang withIsPro:(BOOL) isPro withPhoneNumber1:(NSString *)number1 withPhoneNumber2:(NSString *)number2 andTime:(NSUInteger) time andCallType:(CallType) callType;

-(void) setPushForTransId:(NSString *) transId andEnable:(BOOL) enable;

-(void) setLanguage:(NSString *) lang1 andLang2:(NSString *) lang2 forTransId:(NSString *) transId;

-(void) setImage:(UIImage *) image;

-(void) cancelOrderWithOrderId:(NSString *) orderId;

-(void) getStreamWithTransId:(NSString *) transId withOrderId:(NSString *) orderId;

-(void) setHistoryWithStreamId:(NSString *) streamId;

-(void) getStreamInfo:(NSString *) streamId;

-(void) callUserWithTransId:(NSString *) transId withStreamId:(NSString *) streamId;

-(void) startTimeWithStreamId:(NSString *) streamId;

-(void) stopTimeWithStreamId:(NSString *) streamId;

-(void) checkStreamWithTransId:(NSString *) transId withUUID:(NSString *) uuid;

-(void) cancelStreamWithStreamId:(NSString *) streamId andTransId:(NSString *) transId;

-(void) getStreamTranslatorWithStreamId:(NSString *) streamId andTransId:(NSString *) transId;

-(void) setOnline;

-(void) checkPassword:(NSString *) password;

@end

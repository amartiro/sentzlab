//
//  PortalSession.m
//  LingvoPal
//
//  Created by Artak on 12/2/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "PortalSession.h"
#import "Constants.h"

#define timeOutDeley 15.0f

@implementation PortalSession

+ (PortalSession*)sharedInstance
{
    static PortalSession *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PortalSession alloc] init];
    });
    return _sharedInstance;
}

-(NSMutableDictionary *) getIdTokenDict {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kAccessToken];
    NSString *Id = [defaults objectForKey:kAccessId];
    
    
    [dict setObject:token forKey:@"token"];
    [dict setObject:Id forKey:@"id"];
    
    return dict;
}

-(NSMutableURLRequest*) getRequest{
    NSURL *url = [NSURL URLWithString:restfullPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:5.0];
    
    [request setHTTPMethod:@"POST"];
    
    return request;
}

-(instancetype) init{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        
        session_ = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
        
    }
    
    return self;
}

-(NSString *) convertToString:(NSDictionary *) dict{
    NSMutableString * str = [NSMutableString string];
    
    for (NSString *key in [dict allKeys]) {
        [str appendString:[NSString stringWithFormat:@"%@=%@&", key, [dict objectForKey:key]]];
    }
    
    [str deleteCharactersInRange:NSMakeRange([str length] - 1, 1)];
    
    return [NSString stringWithString:str];
}

-(void) requestWithData:(NSData *) data withSuccessSelector:(SEL) successSelector withFailSelector:(SEL) failSelector withTimoutSelector:(SEL) timoutSelector withTimeout:(NSInteger) timeout isUpload:(BOOL) isUpload{
    NSMutableURLRequest * request = [self getRequest];
    
    [request setHTTPBody:data];
    [request setTimeoutInterval:timeout];
    
    if (isUpload) {
        NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    }
    
    __weak id blockDelegate = self.delegate;
    
    NSURLSessionDataTask *postDataTask = [session_ dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (!error && httpResp.statusCode == 200) {
            
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&error];
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([[jsonDictionary objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInteger:200]]){
                        if([blockDelegate respondsToSelector:successSelector]){
                            [blockDelegate performSelector:successSelector withObject:jsonDictionary];
                        }
                    } else {
                        if([blockDelegate respondsToSelector:failSelector]){
                            [blockDelegate performSelector:failSelector  withObject:jsonDictionary];
                        }
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([blockDelegate respondsToSelector:failSelector]){
                        [blockDelegate performSelector:failSelector  withObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld", (long)error.code] forKey:@"status"]];
                    }
                });
            }
            
            //  [self.delegate noteDetailsViewControllerDoneWithDetails:self];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([blockDelegate respondsToSelector:timoutSelector]){
                    [blockDelegate performSelector:timoutSelector  withObject:error afterDelay:timeOutDeley];
                }
            });
            // alert for error saving / updating note
        }
    }];
    
    [postDataTask resume];
}



-(void) requestWithDict:(NSMutableDictionary *) dict withSuccessSelector:(SEL) successSelector withFailSelector:(SEL) failSelector withTimoutSelector:(SEL) timoutSelector withTimeout:(NSInteger) timeout{
    
    
    NSString *strDict = [self convertToString:dict];
    
    NSData *strDictData = [strDict dataUsingEncoding:NSUTF8StringEncoding];
    
    [self requestWithData:strDictData withSuccessSelector:successSelector withFailSelector:failSelector withTimoutSelector:timoutSelector withTimeout:timeout isUpload:NO];
}

-(void) requestWithDict:(NSMutableDictionary *) dict withSuccessSelector:(SEL) successSelector withFailSelector:(SEL) failSelector withTimoutSelector:(SEL) timoutSelector{
    NSLog(@"request dict : %@", dict);
    
    [self requestWithDict:dict withSuccessSelector:successSelector withFailSelector:failSelector withTimoutSelector:timoutSelector withTimeout:5.0];
}

- (void) registerWithName:(NSString *) name withSurname:(NSString *)surname withEmail:(NSString *)email withPassword:(NSString *)password withUUID:(NSString *) uuid andRegId:(NSString *) regId{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    [dict setObject:REGISTER forKey:@"action"];
    [dict setObject:name forKey:kName];
    [dict setObject:surname forKey:kSurname];

    [dict setObject:email forKey:kEmail];
    [dict setObject:password forKey:kPassword];
    [dict setObject:uuid forKey:@"device"];
    
    if (regId != nil) [dict setObject:regId forKey:@"reg_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(registerWithNickResponse:) withFailSelector:@selector(failedToRegisterWithNick:) withTimoutSelector:@selector(timeoutToRegisterWithNick:)];
}

- (void) loginWithEmail:(NSString *) email andPassword:(NSString *) pass andUUID:(NSString *) uuid andRegId:(NSString *) regId andStreamId:(NSString *) streamId{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    
    [dict setObject:LOGIN forKey:@"action"];
    [dict setObject:uuid forKey:@"device"];
    [dict setObject:email forKey:@"email"];
    [dict setObject:pass forKey:kPassword];
    
    if (regId != nil) [dict setObject:regId forKey:@"reg_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(loginWithEmailResponse:) withFailSelector:@selector(failedToLoginWithEmail:) withTimoutSelector:@selector(timeoutToLoginWithEmail:)];
}

-(void) socialLoginWitName:(NSString *) name withSurname:(NSString *)surname withEmail:(NSString *)email withFacbookId:(NSString *)fbId andGoogleId:(NSString *)gId  withUUID:(NSString *) uuid andRegId:(NSString *) regId{

    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    
    [dict setObject:SOCIAL_LOGIN forKey:@"action"];
    [dict setObject:uuid forKey:@"device"];
    [dict setObject:email forKey:kEmail];
    [dict setObject:name forKey:kName];
    [dict setObject:surname forKey:kSurname];


    if (regId != nil) [dict setObject:regId forKey:@"reg_id"];
    if (gId != nil) [dict setObject:gId forKey:@"gp_id"];
    if (fbId != nil) [dict setObject:fbId forKey:@"fb_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(socialLoginResponse:) withFailSelector:@selector(failedToSocialLogin:) withTimoutSelector:@selector(timeoutToSocialLogin:)];
}

- (void) loginWithUUID:(NSString *) uuid andRegId:(NSString *) regId andStreamId:(NSString *) streamId{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    
    [dict setObject:LOGIN forKey:@"action"];
    [dict setObject:uuid forKey:@"device"];
    
    if (regId != nil) [dict setObject:regId forKey:@"reg_id"];
    if (streamId != nil) [dict setObject:streamId forKey:@"stream_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(loginWithUUIDResponse:) withFailSelector:@selector(failedToLoginWithUUID:) withTimoutSelector:@selector(timeoutToLoginWithUUID:)];
}

-(void) resetPassword:(NSString *) email{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    
    [dict setObject:FORGOT_PASSWORD forKey:@"action"];
    [dict setObject:email forKey:@"email"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(resetPasswordResponse:) withFailSelector:@selector(failedToResetPassword:) withTimoutSelector:@selector(timeoutToResetPassword:)];
}

-(void) getTranslatorForOrderId:(NSString *) orderId declineTransId:(NSString *) trId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:GET_TRANS forKey:@"action"];
    [dict setObject:orderId forKey:@"ord_id"];
  
    if (trId != nil) {
        [dict setObject:trId forKey:@"decline_tr"];
    }
    
    [self requestWithDict:dict withSuccessSelector:@selector(getTranslatorResponse:) withFailSelector:@selector(failedToGetTranslator:) withTimoutSelector:@selector(timeoutToGetTranslator:)];
}

-(void) getLangs{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:GET_LANGS forKey:@"action"];
    
      [self requestWithDict:dict withSuccessSelector:@selector(getLangsResponse:) withFailSelector:@selector(failedToGetLangs:) withTimoutSelector:@selector(timeoutToGetLangs:)];
    
}

-(void) getHistoryForTransId:(NSString *) transId withPage:(NSInteger) page{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:HISTORY forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)page]  forKey:@"page"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(getHistoryResponse:) withFailSelector:@selector(failedToGetHistory:) withTimoutSelector:@selector(timeoutToGetHistory:)];
    
}

-(void) getTransInfo:(NSString *) transId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:GET_TRANS_INFO forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [self requestWithDict:dict withSuccessSelector:@selector(getTransInfoResponse:) withFailSelector:@selector(failedToGetTransInfo:) withTimoutSelector:@selector(timeoutToGetTransInfo:)];
}

-(void) makeReview:(NSString *) review withRate:(NSInteger ) rate forTransId:(NSString *) transId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:MAKE_REVIEW forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    
    [dict setObject:review forKey:@"review"];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)rate] forKey:@"rating"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(makeReviewResponse:) withFailSelector:@selector(failedToMakeReview:) withTimoutSelector:@selector(timeoutToMakeReview:)];
}

-(void) getProfile{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kAccessToken];
    NSString *Id = [defaults objectForKey:kAccessId];
    
    
    [dict setObject:token forKey:@"token"];
    [dict setObject:Id forKey:@"id"];
    [dict setObject:Id forKey:@"user_id"];
    
    
    [dict setObject:USER_INFO forKey:@"action"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(getProfileResponse:) withFailSelector:@selector(failedToGetProfile:) withTimoutSelector:@selector(timeoutToGetProfile:)];
}

-(void) changeUserName:(NSString *) name andSurname:(NSString *) surname andEmail:(NSString *) email{
    
    NSMutableDictionary * dict = [self getIdTokenDict];
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:kAccessToken];
//    NSString *Id = [defaults objectForKey:kAccessId];
    
 //   NSString *password = [defaults objectForKey:kPassword];

//    [dict setObject:token forKey:@"token"];
//    [dict setObject:Id forKey:@"id"];
    [dict setObject:CHANGE_ACCOUNT forKey:@"action"];
    [dict setObject:name forKey:kName];
    [dict setObject:surname forKey:kSurname];
    
    [dict setObject:email forKey:kEmail];
    
  //  [dict setObject:password forKey:@"old_pass"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(changeUserNameResponse:) withFailSelector:@selector(failedToChangeUserName:) withTimoutSelector:@selector(timeoutToChangeUserName:)];
}

-(void) logout{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:LOGOUT forKey:@"action"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(logoutResponse:) withFailSelector:@selector(failedToLogout:) withTimoutSelector:@selector(timeoutToLogout:)];
}

-(void) getOrders{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:GET_ORDERS forKey:@"action"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(getOrdersResponse:) withFailSelector:@selector(failedToGetOrders:) withTimoutSelector:@selector(timeoutToLogout:)];
}

-(void) getReviewsForTransId:(NSString *) transId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:GET_REVIEWS forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [self requestWithDict:dict withSuccessSelector:@selector(getReviewsResponse:) withFailSelector:@selector(failedToGetReviews:) withTimoutSelector:@selector(timeoutToGetReviews:)];
}

-(void) becomeTranslator:(NSString *) nativeLang withLang1:(NSString *) lang1 withLang2:(NSString *) lang2{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:BECOME_TRANSLATOR forKey:@"action"];
    [dict setObject:nativeLang forKey:@"native_lang"];
    [dict setObject:lang1 forKey:@"lang1"];
    [dict setObject:lang2 forKey:@"lang2"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(becomeTranslatorResponse:) withFailSelector:@selector(failedToBecomeTranslator:) withTimoutSelector:@selector(timeoutToBecomeTranslator:)];
}

-(void) getTranslatorOrdersForTransId:(NSString *) transId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:GET_TRANSLATOR_ORDERS forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    
    [self requestWithDict:dict withSuccessSelector:@selector(getTranslatorOrdersResponse:) withFailSelector:@selector(failedToGetTranslatorOrders:) withTimoutSelector:@selector(timeoutToGetTranslatorOrders:)];
}

-(void) acceptTransatorWithId:(NSString *) transId withOrderId:(NSString *) orderId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:ACCEPT_TRANSLATOR forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    
    [dict setObject:orderId forKey:@"ord_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(acceptTransatorResponse:) withFailSelector:@selector(failedToAcceptTransator:) withTimoutSelector:@selector(timeoutToAcceptTransator:)];
}



-(void) acceptOrderFromTransId:(NSString *) transId withOrderId:(NSString *) orderId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:ACCEPT_ORDER forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [dict setObject:orderId forKey:@"ord_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(acceptOrderResponse:) withFailSelector:@selector(failedToAcceptOrder:) withTimoutSelector:@selector(timeoutToAcceptOrder:)];

}

-(void) declineOrderFromTransId:(NSString *) transId withOrderId:(NSString *) orderId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:DECLINE_ORDER forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [dict setObject:orderId forKey:@"ord_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(declineOrderResponse:) withFailSelector:@selector(failedToDeclineOrder:) withTimoutSelector:@selector(timeoutToDeclineOrder:)];
    
}


-(void) setReserveOfTranslatorFromLanguage:(NSString *) fromLang toLanguage:(NSString *) toLang withIsPro:(BOOL) isPro withPhoneNumber1:(NSString *)number1 withPhoneNumber2:(NSString *)number2 andTime:(NSUInteger) time andCallType:(CallType) callType{
    
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:SET_RESERVE forKey:@"action"];
    [dict setObject:fromLang forKey:@"lang1"];
    [dict setObject:toLang forKey:@"lang2"];
    [dict setObject:(isPro ? @"1" : @"0") forKey:@"pro"];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long) time] forKey:@"time"];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long) callType] forKey:@"call_type"];
    if (number1 != nil && [number1 length]) {
        [dict setObject:number1 forKey:@"number"];
    }
    
    if (number2 != nil && [number2 length]) {
        [dict setObject:number2 forKey:@"number"];
    }
    
    [self requestWithDict:dict withSuccessSelector:@selector(setReserveResponse:) withFailSelector:@selector(failedToSetReserve:) withTimoutSelector:@selector(timeoutToSetReserve:)];
}

-(void) setPushForTransId:(NSString *) transId andEnable:(BOOL) enable{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:SET_PUSH forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [dict setObject:(enable ? @"1" : @"0") forKey:@"send"];
    
     [self requestWithDict:dict withSuccessSelector:@selector(setPushResponse:) withFailSelector:@selector(failedToSetPush:) withTimoutSelector:@selector(timeoutToSetPush:)];
}

-(void) setLanguage:(NSString *) lang1 andLang2:(NSString *) lang2 forTransId:(NSString *) transId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:SET_LANGS forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [dict setObject:lang1 forKey:@"lang1"];
    [dict setObject:lang2 forKey:@"lang2"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(setLanguageResponse:) withFailSelector:@selector(failedToSetLanguage:) withTimoutSelector:@selector(timeoutToSetLanguage:)];

}

-(void) setImage:(UIImage *) image{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:SET_IMAGE forKey:@"action"];

    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    
    
    // add params (all params are strings)
    for (NSString *param in [dict allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    if (imageData){
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"img"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Close off the request with the boundary
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
     [self requestWithData:body withSuccessSelector:@selector(setImageResponse:) withFailSelector:@selector(failedToSetImage:) withTimoutSelector:@selector(timeoutToSetImage:) withTimeout:5.0f isUpload:YES];
    
}

-(void) cancelOrderWithOrderId:(NSString *) orderId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:CANCEL_ORDER forKey:@"action"];
    [dict setObject:orderId forKey:@"ord_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(cancelOrderResponse:) withFailSelector:@selector(failedToCancelOrder:) withTimoutSelector:@selector(timeoutToCancelOrder:)];

}

-(void) getStreamWithTransId:(NSString *) transId withOrderId:(NSString *) orderId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:GET_STREAM forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [dict setObject:orderId forKey:@"ord_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(getStreamResponse:) withFailSelector:@selector(failedToGetStream:) withTimoutSelector:@selector(timeoutToGetStream:)];
}

-(void) setHistoryWithStreamId:(NSString *) streamId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:SET_HISTORY forKey:@"action"];
    [dict setObject:streamId forKey:@"stream_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(setHistoryResponse:) withFailSelector:@selector(failedToSetHistory:) withTimoutSelector:@selector(timeoutToSetHistory:)];
}

-(void) getStreamInfo:(NSString *) streamId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:STREAM_INFO forKey:@"action"];
    [dict setObject:streamId forKey:@"stream_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(getStreamInfoResponse:) withFailSelector:@selector(failedToGetStreamInfo:) withTimoutSelector:@selector(timeoutToGetStreamInfo:)];
}

-(void) callUserWithTransId:(NSString *) transId withStreamId:(NSString *) streamId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:CALL_USER forKey:@"action"];
    [dict setObject:streamId forKey:@"stream_id"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    
    [self requestWithDict:dict withSuccessSelector:@selector(callUserResponse:) withFailSelector:@selector(failedToCallUser:) withTimoutSelector:@selector(timeoutToCallUser:)];
}

-(void) startTimeWithStreamId:(NSString *) streamId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:START_TIME forKey:@"action"];
    [dict setObject:streamId forKey:@"stream_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(startTimeResponse:) withFailSelector:@selector(failedToStartTime:) withTimoutSelector:@selector(timeoutToStartTime:)];
}

-(void) stopTimeWithStreamId:(NSString *) streamId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:STOP_TIME forKey:@"action"];
    [dict setObject:streamId forKey:@"stream_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(stopTimeResponse:) withFailSelector:@selector(failedToStopTime:) withTimoutSelector:@selector(timeoutToStopTime:)];
}

-(void) checkStreamWithTransId:(NSString *) transId withUUID:(NSString *) uuid{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:CHECK_STREAM forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [dict setObject:uuid forKey:@"device"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(checkStreamResponse:) withFailSelector:@selector(failedToCheckStream:) withTimoutSelector:@selector(timeoutToCheckStream:)];
}

-(void) cancelStreamWithStreamId:(NSString *) streamId andTransId:(NSString *) transId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:CANCEL_STREAM forKey:@"action"];
    if (transId != nil) {
        [dict setObject:transId forKey:@"tr_id"];
    }
    [dict setObject:streamId forKey:@"stream_id"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(cancelStreamResponse:) withFailSelector:@selector(failedToCancelStream:) withTimoutSelector:@selector(timeoutToCancelStream:)];
}

-(void) getStreamTranslatorWithStreamId:(NSString *) streamId andTransId:(NSString *) transId{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:STREAM_TRANS forKey:@"action"];
    [dict setObject:streamId forKey:@"stream_id"];
    if ( transId != nil && [transId length]) {
         [dict setObject:transId forKey:@"tr_id"];
    }
   
    [self requestWithDict:dict withSuccessSelector:@selector(getStreamTranslatorResponse:) withFailSelector:@selector(failedToGetStreamTranslator:) withTimoutSelector:@selector(timeoutToGetStreamTranslator:)];
}

-(void) setOnline{
    NSMutableDictionary * dict = [self getIdTokenDict];
    [dict setObject:SET_ONLINE forKey:@"action"];
    
    [self requestWithDict:dict withSuccessSelector:@selector(setOnlineResponse:) withFailSelector:@selector(failedToSetOnline:) withTimoutSelector:@selector(timeoutToSetOnline:)];
}

-(void) checkPassword:(NSString *) password{
    NSMutableDictionary * dict = [self getIdTokenDict];
    
    [dict setObject:CHECK_PASSWORD forKey:@"action"];
    [dict setObject:password forKey:kPassword];
       
    [self requestWithDict:dict withSuccessSelector:@selector(checkPasswordResponse:) withFailSelector:@selector(failedToCheckPassword:) withTimoutSelector:@selector(timeoutToCheckPassword:)];
}


@end

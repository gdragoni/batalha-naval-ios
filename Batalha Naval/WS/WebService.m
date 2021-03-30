//
//  ChamadasRestKit.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/12/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "WebService.h"
#import <RestKit/RestKit.h>
#import "RestKitCallBack.h"
#import "Alert.h"

id<RestKitCallBack> delegate_;

@implementation WebService

-(instancetype)initWithDelegate:(UIViewController <RestKitCallBack>*)delegate{
    if (![self connected]) {
        [delegate.navigationController popToRootViewControllerAnimated:YES];
        [Alert alertWithTitle:@"Sem conexão" msg:nil viewController:delegate.navigationController.viewControllers[0] completion:nil];
        return nil;
    }
    if (self = [super init]) {
        delegate_ = delegate;
    }
    return self;
}

-(void)requestType:(CallType)type withMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://iisprod.luxfacta.com.br/BNServer/"]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:method
                                                            path:path
                                                      parameters:parameters];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error: &error];
        [self processDataType:type withData:responseDict];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processDataType:type withData:nil];
        NSLog(@"Erro: %@", error);
    }];
    [operation start];
}

-(void)processDataType:(CallType)typeData withData:(NSDictionary *)data {
    if (![data[KEY_STATUS] boolValue] || data[KEY_RESPONSEDATA] == (id)[NSNull null]) {
        [delegate_ callBackType:typeData withdata:nil];
        return;
    }
    if (typeData == GET_PLAYERFIELD_PLAYERONEID_GAMEID || typeData == GET_PLAYERFIELD_PLAYERTWOID_GAMEID) {
        PlayerField *playerField = [PlayerField new];
        [playerField playerFieldWithDict:data[KEY_RESPONSEDATA]];
        [delegate_ callBackType:typeData withdata:playerField];
    }else if (typeData == GET_PLAYER){
        [delegate_  callBackType:typeData withdata:[Player arrayPlayersWithDict:data]];
    }else if (typeData == GET_PLAYER_ID){
    }else if (typeData == POST_PLAYER){
        Player *player = [Player new];
        [player playerWithDict:data[KEY_RESPONSEDATA]];
        [delegate_ callBackType:typeData withdata:player];
    }else if (typeData == POST_GAMESHIP){
        [delegate_ callBackType:typeData withdata:data];
    }else if (typeData == GET_GAME_ID){
        Game *game = [Game new];
        [game gameWithDict:data[KEY_RESPONSEDATA]];
        [delegate_ callBackType:typeData withdata:game];
    }else if (typeData == POST_GAME){
        Game *game = [[Game alloc]gameWithDict:data[KEY_RESPONSEDATA]];
        [delegate_ callBackType:typeData withdata:game];
    }else if (typeData == PUT_GAME){
        Game *game = [[Game alloc]gameWithDict:data[KEY_RESPONSEDATA]];
        [delegate_ callBackType:typeData withdata:game];
    }else if (typeData == GET_LISTPLAYERGAMES_ID){
        [delegate_ callBackType:typeData withdata:[Game arrayGamesWithDict:data]];
    }else if (typeData == POST_FIRE){
        Fire *fire = [Fire new];
        [fire fireWithDict:data[KEY_RESPONSEDATA]];
        [delegate_ callBackType:typeData withdata:fire];
    }
}

-(BOOL)connected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end

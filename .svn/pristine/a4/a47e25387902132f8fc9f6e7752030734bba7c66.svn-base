//
//  ChamadasRestKit.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/12/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKitCallBack.h"
#import "ModelosOnline.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface WebService : NSObject

-(instancetype)initWithDelegate:(id<RestKitCallBack>)delegate;
-(void)requestType:(CallType)type withMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;
-(BOOL)connected;

@end

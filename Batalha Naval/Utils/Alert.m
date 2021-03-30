//
//  Alerta.m
//  Carros
//
//  Created by Gabriel A. Dragoni on 3/29/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "Alert.h"

@implementation Alert

+(void)alertWithTitle:(NSString *)title msg:(NSString *)msg viewController:(UIViewController *)viewController completion:(void (^)())comp{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:alert animated:YES completion:comp];
}

@end

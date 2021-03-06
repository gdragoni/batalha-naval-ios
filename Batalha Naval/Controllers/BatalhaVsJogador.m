//
//  OnlinePagInicial.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/11/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "BatalhaVsJogador.h"
#import "Player.h"
#import "PlayerList.h"
#import "WebService.h"
#import "Sound.h"
#import "LoadingView.h"
#import "CreatePlayer.h"
#import "UserDefault.h"
#import "Alert.h"

@implementation BatalhaVsJogador{
    UIBarButtonItem *barbutton;
    WebService *ws;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    Player *player = [UserDefault getActivePlayer];
    if (player != nil)  self.labelActivePlayer.text = [NSString stringWithFormat:@"%@", player.playerName];
    else {
        ws = !ws ? [[WebService alloc]initWithDelegate:nil] : ws;
        if (![ws connected]){
            [Alert alertWithTitle:@"Sem conexão" msg:nil viewController:self completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        CreatePlayer *cp = [CreatePlayer new];
        cp.sender = self;
        [self presentViewController:cp animated:YES completion:nil];
    }
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    barbutton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Botoes_5112_user_48.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tapButton)];
    self.navigationItem.rightBarButtonItem = barbutton;
    self.navigationItem.backBarButtonItem.enabled = YES;
    self.navigationController.navigationBarHidden = NO;

}

#pragma mark - Action button

-(void)tapButton{
    ws = !ws ? [[WebService alloc]initWithDelegate:nil] : ws;
    if (![ws connected]){
        [Alert alertWithTitle:@"Sem conexão" msg:nil viewController:self completion:nil];
        return;
    }
    PlayerList *lp = [PlayerList new];
    lp.sender = self;
    lp.preferredContentSize = CGSizeMake(200, [[UIScreen mainScreen] bounds].size.height/1.5);
    lp.modalPresentationStyle = UIModalPresentationPopover;
    lp.popoverPresentationController.delegate = self;
    [self presentViewController:lp animated:YES completion:nil];
}

#pragma mark - Popover

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController{
    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popoverPresentationController.barButtonItem = barbutton;
}

#pragma mark - Alert view

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 76) [self.navigationController popViewControllerAnimated:YES];
}

@end

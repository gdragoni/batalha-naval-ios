//
//  CriarPlayer.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/11/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "CreatePlayer.h"
#import "WebService.h"
#import "RKUtil.h"
#import "ValidatePlayerName.h"
#import "LoadingView.h"
#import "UserDefault.h"
#import "PlayerList.h"
#import "BatalhaVsJogador.h"

@implementation CreatePlayer{
    WebService *rk;
    LoadingView *loading;
    NSArray *arrayPlayers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldName.delegate = self;
    self.view.frame = CGRectMake(self.view.superview.center.x, self.view.superview.center.y, 400, 200);
    loading = [[LoadingView alloc]initWithController:self];
    [loading show];
    rk = [[WebService alloc]initWithDelegate:self];
    [rk requestType:GET_PLAYER withMethod:@"GET" path:[RKUtil pathForGetPlayer] parameters:nil];
    [self.textFieldName becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldName) [self actionButtonCreate];
    return YES;
}

#pragma mark - Action dos botões

-(IBAction)actionButtonCreate{
    NSString *playerName = self.textFieldName.text.capitalizedString;
    if ([ValidatePlayerName nameWithInvalidCharacters:playerName]) self.labelMsg.text = @"Caracter inválido:\nNome não deve conter caracteres especiais.";
    else if ([ValidatePlayerName nameWithInvalidSize:playerName]) self.labelMsg.text = @"Tamanho inválido:\nNome deve ter mais de 3 e menos de 25 caracteres.";
    else if ([ValidatePlayerName repeatedName:playerName playerClass:[Player class] withArrayPlayers:arrayPlayers]){
        for (Player *player in arrayPlayers) {
            if ([player.playerName isEqualToString:playerName]) {
                [UserDefault setActivePlayer:player];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.sender class] == [PlayerList class]) {
                        [((PlayerList *)self.sender).sender viewWillAppear:YES];
                        [self.sender dismissViewControllerAnimated:YES completion:nil ];
                    }else if ([self.sender class] == [BatalhaVsJogador class]){
                        [self.sender viewWillAppear:YES];
                    }
                }];
                break;
            }
        }
    }else{
        [rk requestType:POST_PLAYER withMethod:@"POST" path:[RKUtil pathForPostPlayer] parameters:[RKUtil parameterForPostPlayer:playerName]];
        [loading setNewTitle:@"Criando Player"];
        [loading show];
    }
}

-(IBAction)actionButtonCancel{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([UserDefault getActivePlayer]) {
            [self.sender dismissViewControllerAnimated:YES completion:nil];
        }
        else [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - Retorno do chamado

-(void)callBackType:(CallType)type withdata:(id)data{
    [loading hide];
    if (type == GET_PLAYER && data != nil) {
        arrayPlayers = data;
    }else if (type == POST_PLAYER){
        Player *player = data;
        [UserDefault setActivePlayer:player];
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.sender class] == [PlayerList class]) {
                [((PlayerList *)self.sender).sender viewWillAppear:YES];
                [self.sender dismissViewControllerAnimated:YES completion:nil ];
            }else if ([self.sender class] == [BatalhaVsJogador class]){
                [self.sender viewWillAppear:YES];
            }
        }];
    }
}

@end

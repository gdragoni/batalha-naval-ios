//
//  ListaDeJogadoresController.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/8/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "PlayerCompList.h"
#import "PlayerCompDAO.h"
#import "PlayerComp.h"
#import "ValidatePlayerName.h"
#import "UserDefault.h"
#import "SortArray.h"
#import "ImageUtil.h"

@implementation PlayerCompList{
    PlayerComp *activePlayer;
    NSMutableArray *arrayPlayers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![UserDefault getActivePlayerComp]) [self actionButtonAddPlayer];
    activePlayer = [UserDefault getActivePlayerComp];
    PlayerCompDAO *pDAO = [PlayerCompDAO new];
    arrayPlayers = [[NSMutableArray alloc]initWithArray:[pDAO getPlayersOnDataBase]];
    [SortArray sortArray:arrayPlayers byKey:@"name" ascending:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView setBackgroundView:[ImageUtil imageViewWithImageNamed:@"Ocean.jpg" size:self.tableView.frame.size isHorizontal:YES]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
}

-(void)onKeyboardHide:(NSNotification *)notification{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayPlayers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.tag = indexPath.row+1;
    if ([activePlayer.name isEqualToString: [arrayPlayers[indexPath.row]name]]) {
        [cell.textLabel setTextColor:[UIColor yellowColor]];
    }else{
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    cell.textLabel.text = [arrayPlayers[indexPath.row]name];
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([activePlayer.name isEqualToString:[arrayPlayers[indexPath.row]name]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erro" message:@"Este jogador est?? ativo no momento" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        PlayerCompDAO *pDAO = [PlayerCompDAO new];
        [pDAO deletePlayer:arrayPlayers[indexPath.row]];
        [arrayPlayers removeObjectAtIndex:indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Deletado" message:@"Jogador deletado" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UserDefault setActivePlayerComp:arrayPlayers[indexPath.row]];
    [self backToRootViewController];
}

#pragma mark - Action de botoes

- (IBAction)actionButtonAddPlayer {
    if ([self.buttonDeletePlayer.titleLabel.text isEqualToString:@"Pronto"]) [self actionButtonDeletePlayer];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Novo Jogador" message:@"Digite o nome do jogador" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 2;
    [alertView show];
}

- (IBAction)actionButtonDeletePlayer{
    if ([self.buttonDeletePlayer.titleLabel.text isEqualToString:@"Deletar"]) {
        [self.tableView setEditing:YES animated:YES];
        [self.buttonDeletePlayer setTitle:@"Pronto" forState:UIControlStateNormal];
    }else{
        [self.tableView setEditing:NO animated:YES];
        [self.buttonDeletePlayer setTitle:@"Deletar" forState:UIControlStateNormal];
    }
}

-(void)addPlayer:(NSString *)playerName{
    playerName = playerName.capitalizedString;
    UIAlertView *alert;
    PlayerCompDAO *pDAO = [PlayerCompDAO new];
    if ([ValidatePlayerName nameWithInvalidCharacters:playerName]) {
        alert = [[UIAlertView alloc]initWithTitle:@"Caracter inv??lido" message:@"Nome n??o deve conter caracteres especiais." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    }else if ([ValidatePlayerName nameWithInvalidSize:playerName]){
        alert = [[UIAlertView alloc]initWithTitle:@"Tamanho inv??lido" message:@"Nome deve ter mais de 3 cacteres e menos de 25." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    }else if ([ValidatePlayerName repeatedName:playerName playerClass:[PlayerComp class] withArrayPlayers:arrayPlayers]){
        alert = [[UIAlertView alloc]initWithTitle:@"Nome repetido" message:@"Nome j?? existente, escolha outro." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    }else{
        [pDAO createNewPlayer:playerName];
        activePlayer = [UserDefault getActivePlayerComp];
        arrayPlayers = [[NSMutableArray alloc]initWithArray:[pDAO getPlayersOnDataBase]];
        [SortArray sortArray:arrayPlayers byKey:@"name" ascending:YES];
        [self.tableView reloadData];
    }
    if (alert != nil) {
        alert.tag = 3;
        [alert show];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 50)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor colorWithRed:(CGFloat)12/255 green:(CGFloat)14/255 blue:(CGFloat)139/255 alpha:1]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.text = @"Escolha seu jogador";
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 0) {
        [self.tableView reloadData];
        [self actionButtonDeletePlayer];
    }else if (alertView.tag == 2) {
        if (buttonIndex==1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [self addPlayer:textField.text];
        }else{
            [self.tableView resignFirstResponder];
        }
    }else if (alertView.tag == 3 && buttonIndex == 0){
        [self actionButtonAddPlayer];
    }
}

-(void)backToRootViewController{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end

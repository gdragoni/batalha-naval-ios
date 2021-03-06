//
//  HistoricoDeJogos.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/15/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "GameHistory.h"
#import "WebService.h"
#import "RKUtil.h"
#import "LoadingView.h"
#import "Game.h"
#import "Player.h"
#import "GameDetail.h"
#import "UserDefault.h"
#import "SortArray.h"

@implementation GameHistory{
    IBOutlet UITableView *tableView_;
    IBOutlet UISegmentedControl *segment;
    Player *player;
    LoadingView *loading;
    WebService *rk;
    NSMutableArray *arrayCompletedGames, *arrayProgressGames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    loading = [[LoadingView alloc]initWithController:self];
    player  = [UserDefault getActivePlayer];
    rk      = [[WebService alloc]initWithDelegate:self];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    [rk requestType:GET_LISTPLAYERGAMES_ID withMethod:@"GET" path:[RKUtil pathForGetListPlayerGamesWithPlayerId:player.playerID] parameters:nil];
    [loading show];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    tableView_.layer.masksToBounds = YES;
    tableView_.layer.cornerRadius = 8;
    tableView_.backgroundView.backgroundColor = [UIColor clearColor];
    tableView_.backgroundColor = [UIColor clearColor];
}

#pragma mark - Action do segment para changeState

-(IBAction)alterarTipo:(UISegmentedControl *)sender{
    [tableView_ reloadData];
    [tableView_ setContentOffset:tableView_.contentOffset animated:NO];
    tableView_.contentOffset = CGPointMake(0, 0 - tableView_.contentInset.top);
}

#pragma mark - Retorno da chamada

-(void)callBackType:(CallType)type withdata:(id)data{
    [loading hide];
    if (type == GET_LISTPLAYERGAMES_ID && data != nil) {
        NSArray *arrayResponse = data;
        if (arrayResponse.count == 0) return;
        arrayCompletedGames = [NSMutableArray new];
        arrayProgressGames = [NSMutableArray new];
        for (Game *game in arrayResponse) {
            if (game.gameWinner == 0) [arrayProgressGames addObject:game];
            else [arrayCompletedGames addObject:game];
        }
        [SortArray sortArray:arrayCompletedGames byKey:@"gamePlayerTwo.playerName" ascending:YES];
        [SortArray sortArray:arrayProgressGames byKey:@"gamePlayerTwo.playerName" ascending:YES];
        [self alterarTipo:segment];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return segment.selectedSegmentIndex == 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return segment.selectedSegmentIndex == 0 ? section == 0 ? arrayCompletedGames.count : arrayProgressGames.count : segment.selectedSegmentIndex == 1 ? arrayCompletedGames.count : arrayProgressGames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Game *game = segment.selectedSegmentIndex == 0 ? indexPath.section == 0 ? arrayCompletedGames[indexPath.row] : arrayProgressGames[indexPath.row] : segment.selectedSegmentIndex == 1 ? arrayCompletedGames[indexPath.row] : arrayProgressGames[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ Vs %@", game.gamePlayerOne.playerName, game.gamePlayerTwo.playerName];
    cell.detailTextLabel.text = game.gameWinner == game.gamePlayerOne.playerID ? [NSString stringWithFormat:@"Vencedor: %@", game.gamePlayerOne.playerName] : game.gameWinner == game.gamePlayerTwo.playerID ? [NSString stringWithFormat:@"Vencedor: %@", game.gamePlayerTwo.playerName] : @"Em andamento";
    cell.detailTextLabel.textColor = game.gameWinner == game.gamePlayerOne.playerID ? [UIColor greenColor] : game.gameWinner == game.gamePlayerTwo.playerID ? [UIColor redColor] : [UIColor yellowColor];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (segment.selectedSegmentIndex == 2) return nil;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor colorWithRed:(CGFloat)12/255 green:(CGFloat)14/255 blue:(CGFloat)139/255 alpha:1]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setTextColor:[UIColor whiteColor]];
    if (segment.selectedSegmentIndex == 1){
    NSInteger wins = 0, loses = 0;
    for (Game *game in arrayCompletedGames) {
        if (game.gameWinner == player.playerID) wins ++;
        else loses ++;
    }
    [label setText:[NSString stringWithFormat:@"Vit??rias: %li | Derrotas: %li", wins, loses]];
    }else if (segment.selectedSegmentIndex == 0) [label setText:section == 0 ? @"Conclu??dos" : @"Em andamento"];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return segment.selectedSegmentIndex == 2 ? 0 : 60;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GameDetail *dj = [GameDetail new];
    dj.game = segment.selectedSegmentIndex == 0 ? indexPath.section == 0 ? arrayCompletedGames[indexPath.row] : arrayProgressGames[indexPath.row] : segment.selectedSegmentIndex == 1 ? arrayCompletedGames[indexPath.row] : arrayProgressGames[indexPath.row];
    [self presentViewController:dj animated:YES completion:nil];
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 76) [self.navigationController popViewControllerAnimated:YES];
}

@end

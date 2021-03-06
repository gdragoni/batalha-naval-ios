//
//  JogosAtivos.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/16/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ActiveGames.h"
#import "WebService.h"
#import "LoadingView.h"
#import "Alert.h"
#import "ShipDistributor.h"
#import "UserDefault.h"
#import "BatalhaOnline.h"
#import "SortArray.h"
#import "ImageUtil.h"

@implementation ActiveGames{
    WebService *rk;
    LoadingView *loading;
    Player *player;
    Game *game;
    NSMutableArray *array, *arrayWithPlayerGames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    player = [UserDefault getActivePlayer];
    self.navigationItem.backBarButtonItem.enabled = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    loading = [[LoadingView alloc]initWithController:self];
    rk      = [[WebService alloc]initWithDelegate:self];
    [rk requestType:GET_LISTPLAYERGAMES_ID withMethod:@"GET" path:[RKUtil pathForGetListPlayerGamesWithPlayerId:player.playerID] parameters:nil];
    [loading show];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView setBackgroundView:(UIView *)[ImageUtil imageViewWithImageNamed:@"Ocean.jpg" size:self.view.frame.size isHorizontal:YES]];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Retorno chamado

-(void)callBackType:(CallType)type withdata:(id)data{
    [loading hide];
    if (type == GET_LISTPLAYERGAMES_ID && data != nil) {
        array = [NSMutableArray new];
        for (Game *game_ in data) {
            if (game_.gameWinner == 0) {
                [array addObject:game_];
            }
        }
        [SortArray sortArray:array byKey:@"gamePlayerTwo.playerName" ascending:YES];
        NSMutableArray *mutArray = [NSMutableArray new];
        arrayWithPlayerGames = [NSMutableArray new];
        for (int i = 0; i < array.count; i++) {
            Game *currentGame = array[i];
            Game *previousGame = currentGame != array.firstObject ? array[i-1] : nil;
            if (currentGame == array.firstObject) [mutArray addObject:currentGame];
            else if (currentGame.gamePlayerTwo.playerID == previousGame.gamePlayerTwo.playerID) [mutArray addObject:currentGame];
            else{
                [arrayWithPlayerGames addObject:mutArray];
                mutArray = [NSMutableArray new];
                [mutArray addObject:currentGame];
            }
            if (currentGame == array.lastObject) [arrayWithPlayerGames addObject:mutArray];
        }
        [self.tableView reloadData];
    }else if (type == GET_PLAYERFIELD_PLAYERONEID_GAMEID && data != nil){
        PlayerField *pf = data;
        if (pf.playerFieldShips.count == 0) {
            UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            ShipDistributor *dn = [ShipDistributor new];
            dn.game = game;
            dn.sender = self;
            [self presentViewController:dn animated:YES completion:nil];
        }else{
            if (game.gameTurnPlayerId == 0) [Alert alertWithTitle:@"Aguarde" msg:@"Aguarde advers??rio distribuir seus navios" viewController:self completion:nil];
            else{
                BatalhaOnline *bat = [BatalhaOnline new];
                bat.game = game;
                [self.navigationController pushViewController:bat animated:YES];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrayWithPlayerGames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayWithPlayerGames[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celulaJogosAtivos" forIndexPath:indexPath];
    cell.tag = indexPath.row+1;
    Game *game_ = arrayWithPlayerGames[indexPath.section][indexPath.row];
    Player *one = game_.gamePlayerOne;
    Player *two = game_.gamePlayerTwo;
    cell.textLabel.text         = [NSString stringWithFormat:@"%@ Vs %@", one.playerName, two.playerName];
    cell.textLabel.textColor    = [UIColor whiteColor];
    cell.detailTextLabel.text = game_.gameTurnPlayerId == one.playerID ? [NSString stringWithFormat:@"Turno: %@", one.playerName] : game_.gameTurnPlayerId == 0 ? @"Jogo n??o iniciado" : [NSString stringWithFormat:@"Turno: %@", two.playerName];
    cell.detailTextLabel.textColor = game_.gameTurnPlayerId == one.playerID ? [UIColor greenColor] : game_.gameTurnPlayerId == 0 ? [UIColor yellowColor] : [UIColor redColor];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor colorWithRed:(CGFloat)12/255 green:(CGFloat)14/255 blue:(CGFloat)139/255 alpha:0.8]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setTextColor:[UIColor whiteColor]];
    label.text = [NSString stringWithFormat:@"Vs %@", [[arrayWithPlayerGames[section] firstObject] gamePlayerTwo].playerName];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    game = arrayWithPlayerGames[indexPath.section][indexPath.row];
    [rk requestType:GET_PLAYERFIELD_PLAYERONEID_GAMEID withMethod:@"GET" path:[RKUtil pathForGetPlayerFieldWithPlayerId:player.playerID andGameID:game.gameId] parameters:nil];
    [loading show];
}

@end

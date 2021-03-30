//
//  ListaDePlayers.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/19/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "PlayerList.h"
#import "Player.h"
#import "WebService.h"
#import "RKUtil.h"
#import "ValidatePlayerName.h"
#import "CreatePlayer.h"
#import "Alert.h"
#import "UserDefault.h"
#import "SortArray.h"

@implementation PlayerList{
    NSMutableArray *arrayPlayer;
    WebService *rk;
    Player *activePlayer;
    IBOutlet UITableView *tableView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activePlayer = [UserDefault getActivePlayer];
    rk           = [[WebService alloc]initWithDelegate:self];
    [rk requestType:GET_PLAYER withMethod:@"GET" path:[RKUtil pathForGetPlayer] parameters:nil];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [tableView_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.backgroundView.frame = tableView_.bounds;
    tableView_.backgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Action button

-(IBAction)actionButtonCreate{
    CreatePlayer *cp = [CreatePlayer new];
    cp.sender = self;
    [self presentViewController:cp animated:YES completion:nil];
}

#pragma mark - Retorno chamado

-(void)callBackType:(CallType)type withdata:(id)data{
    if (type == GET_PLAYER && data != nil) {
        arrayPlayer = [[NSMutableArray alloc]initWithArray:(NSArray *)data];
        [SortArray sortArray:arrayPlayer byKey:@"playerName" ascending:YES];
        [tableView_ reloadData];
    }else if (type == POST_PLAYER && data != nil){
        Player *player = (Player *)data;
        [UserDefault setActivePlayer:player];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayPlayer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.tag = indexPath.row+1;
    cell.userInteractionEnabled = YES;
    BOOL teste = [activePlayer.playerName compare:[arrayPlayer[indexPath.row]playerName] options:NSCaseInsensitiveSearch];
    cell.textLabel.text = [arrayPlayer[indexPath.row]playerName];
    cell.textLabel.textColor = teste ? [UIColor whiteColor] : [UIColor yellowColor];
    cell.detailTextLabel.hidden = YES;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.layer.cornerRadius = 8;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView_.bounds.size.width, 40)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor colorWithRed:(CGFloat)12/255 green:(CGFloat)14/255 blue:(CGFloat)139/255 alpha:1]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView_.bounds.size.width, 40)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setTextColor:[UIColor whiteColor]];
    label.text = @"Escolha seu jogador";
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Player *player = arrayPlayer[indexPath.row];
    [UserDefault setActivePlayer:player];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.sender viewWillAppear:YES];
    }];
}

@end


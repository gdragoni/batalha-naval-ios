//
//  CriarJogo.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/16/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "CreateGame.h"
#import "WebService.h"
#import "RKUtil.h"
#import "Player.h"
#import "Game.h"
#import "LoadingView.h"
#import "Alert.h"
#import "ShipDistributor.h"
#import "UserDefault.h"
#import "ImageUtil.h"

@implementation CreateGame{
    WebService *rk;
    LoadingView *loading;
    Player *player;
    NSArray *arrayPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    player  = [UserDefault getActivePlayer];
    rk      = [[WebService alloc]initWithDelegate:self];
    loading = [[LoadingView alloc]initWithController:self];
    [rk requestType:GET_PLAYER withMethod:@"GET" path:[RKUtil pathForGetPlayer] parameters:nil];
    [loading show];
}

-(void)viewWillLayoutSubviews{
    self.navigationItem.backBarButtonItem.enabled = YES;
    [self.tableView setBackgroundView:[ImageUtil imageViewWithImageNamed:@"Ocean.jpg" size:self.tableView.frame.size isHorizontal:YES]];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
}

-(void)callBackType:(CallType)type withdata:(id)data{
    [loading hide];
    if (type == GET_PLAYER) {
        NSMutableArray *mutArray = [[NSMutableArray alloc]initWithArray: data];
        for (Player *play in mutArray) {
            if (play.playerID == player.playerID) {
                [mutArray removeObject:play];
                break;
            }
        }
        arrayPlayer = mutArray;
        arrayPlayer = [arrayPlayer sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"playerName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]]];
        [self.tableView reloadData];
    }else if (type == POST_GAME){
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        ShipDistributor *dn = [ShipDistributor new];
        dn.game = data;
        [self presentViewController:dn animated:YES completion:^{
            dn.sender = self;
        }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celulaCriarJogo" forIndexPath:indexPath];
    Player *player_ = arrayPlayer[indexPath.row];
    cell.textLabel.text             = player_.playerName;
    cell.textLabel.textColor        = [UIColor whiteColor];
    cell.textLabel.textAlignment    = NSTextAlignmentCenter;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setTextColor:[UIColor whiteColor]];
    label.text = @"Selecione o adversário";
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor colorWithRed:(CGFloat)12/255 green:(CGFloat)14/255 blue:(CGFloat)139/255 alpha:0.8]];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *playerTwo = arrayPlayer[indexPath.row];
    [loading  setNewTitle:@"Criando game"];
    [rk requestType:POST_GAME withMethod:@"POST" path:[RKUtil pathForPostGame] parameters:[RKUtil parameterForPostGameWithPlayerOne:player.playerID Player2:playerTwo.playerID]];
    [loading show];
}

@end

//
//  RankDeTemposController.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/11/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "RankingBestTime.h"
#import "PlayerCompDAO.h"
#import "UserDefault.h"

NSString* reuseIdentifier = @"MyCell";

@implementation RankingBestTime{
    PlayerComp *activePlayer;
    NSArray *arrayPlayers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    PlayerCompDAO *pDAO = [PlayerCompDAO new];
    arrayPlayers = [pDAO arrayPlayersOrganizedBy:@"bestTime"];
    activePlayer = [UserDefault getActivePlayerComp];
    self.navigationItem.backBarButtonItem.enabled = YES;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeClose)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizer];
}

-(void)swipeClose{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)amountOfPlayer{
    NSInteger amount = 0;
    for (PlayerComp* player in arrayPlayers) {
        if (player.bestTime.integerValue != 9999) {
            amount ++;
        }
    }
    return amount > 10 ? 10 : amount;
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = 10;
    float val = ((float)index / (float)itemCount);
    return [UIColor colorWithRed: val green:1-val blue: 0.0 alpha:0.5];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self amountOfPlayer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    PlayerComp *currentPlayer = arrayPlayers[row];
    if (currentPlayer.bestTime.integerValue != 9999) {
        if ([currentPlayer.name isEqualToString: activePlayer.name]) {
            [cell.textLabel setTextColor:[UIColor yellowColor]];
            [cell.detailTextLabel setTextColor:[UIColor yellowColor]];
        }else{
            [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
            [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        }
        NSInteger time = currentPlayer.bestTime.integerValue;
        cell.textLabel.text = [NSString stringWithFormat:@"%li?? %@", row+1, currentPlayer.name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",  time / 60 , time % 60];
    }
    cell.backgroundColor = [self colorForIndex:row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.frame.size.height/10-6.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    view.backgroundColor = [UIColor colorWithRed:(CGFloat)12/255 green:(CGFloat)14/255 blue:(CGFloat)139/255 alpha:1];
    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.text = @"Top 10 Tempos";
    [view addSubview:label];
    return view;
}

@end

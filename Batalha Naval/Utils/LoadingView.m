//
//  LoadingView.m
//  BradescoIntegrador
//
//  Created by Conrrado Camacho (6018) on 6/20/14.
//  Copyright (c) 2014 Bradesco. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()

@property (strong, nonatomic) UIView * view;
@property (nonatomic, strong) NSString *title;

@end

@implementation LoadingView

@synthesize view, title;

- (id)initWithController:(UIViewController*) controller
{
    if (title == nil || [title isEqualToString:@""]) {
        title = @"Aguarde";
    }
    
    view = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:controller options:nil] objectAtIndex:0];
    [controller.view addSubview:view];
    
    UILabel *labelLoading = (UILabel *)[view viewWithTag:101];
    labelLoading.text = title;
    
    view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 75, [UIScreen mainScreen].bounds.size.height / 2 - 45, 150, 90);
//    view.center = view.superview.center;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.hidden = YES;

    return self;
}

- (id)initWithController:(UIViewController*)controller andNewTitle:(NSString *)newTitle
{
    title = newTitle;
    return [self initWithController:controller];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:view];
    view.hidden = NO;
}

- (void)hide
{
    view.hidden = YES;
}

- (BOOL)isAnimating
{
    return !view.hidden;
}

- (void)setNewTitle:(NSString *)newTitle
{
    UILabel *labelLoading = (UILabel *)[view viewWithTag:101];
    labelLoading.text = newTitle;
}

@end

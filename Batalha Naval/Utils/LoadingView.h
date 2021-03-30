//
//  LoadingView.h
//  BradescoIntegrador
//
//  Created by Conrrado Camacho (6018) on 6/20/14.
//  Copyright (c) 2014 Bradesco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : NSObject

- (void)show;
- (void)hide;
- (BOOL)isAnimating;
- (id)initWithController:(UIViewController *) controller;
- (id)initWithController:(UIViewController *) controller andNewTitle:(NSString *)newTitle;
- (void)setNewTitle:(NSString *)newTitle;

@end

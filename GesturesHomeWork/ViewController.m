//
//  ViewController.m
//  GesturesHomeWork
//
//  Created by gressmc on 28/11/14.
//  Copyright (c) 2014 gressmc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CGPoint touchPoint;
    UIPanGestureRecognizer* panGesture;
    UISwipeGestureRecognizer* swipeGestureVertical;
    UITapGestureRecognizer* tapGesture;
    CGFloat tempY;
    BOOL stayBool;
}

@property(strong,nonatomic)NSArray* walk;
@property(strong,nonatomic)NSArray* stay;
@property(strong,nonatomic)NSArray* jumpUp;
@property(strong,nonatomic)NSArray* jumpDown;

@property(weak,nonatomic)UIImageView* viewDuck;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Создаем вью героя в разных положениях
    
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-150,
                                                                      CGRectGetMaxY(self.view.bounds)-300,
                                                                      300, 300)];
    
    UIImage* walk1 = [UIImage imageNamed:@"walk-1.png"];
    UIImage* walk2 = [UIImage imageNamed:@"walk-2.png"];
    UIImage* walk3 = [UIImage imageNamed:@"walk-3.png"];
    UIImage* walk4 = [UIImage imageNamed:@"walk-4.png"];
    UIImage* walk5 = [UIImage imageNamed:@"walk-5.png"];
    UIImage* walk6 = [UIImage imageNamed:@"walk-6.png"];
    self.walk = @[walk1,walk3,walk2,walk4,walk5,walk6,walk4,walk5,walk6,walk4,walk5,walk6];
    
    UIImage* stay1 = [UIImage imageNamed:@"Stay-1.png"];
    UIImage* stay2 = [UIImage imageNamed:@"Stay-2.png"];
    UIImage* stay3 = [UIImage imageNamed:@"Stay-3.png"];
    UIImage* stay4 = [UIImage imageNamed:@"Stay-4.png"];
    self.stay = @[stay1,stay1,stay3,stay1,stay1,stay2,stay1,stay4,stay3];
    
    view.animationImages = self.stay;
    view.animationDuration = 2.5f;
    [view startAnimating];
    
    [self.view addSubview:view];
    self.viewDuck = view;
    
    // Temp - обработка панарамирования
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(handePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    // Temp - обработка swipeVertical
    swipeGestureVertical = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(swipeVerticalPanGesture:)];
    swipeGestureVertical.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureVertical];
    
    [panGesture requireGestureRecognizerToFail:swipeGestureVertical];
    
    // Temp - обработка Тапа по экрану
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(handeTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    stayBool = YES;
}

-(void)handeTapGesture:(UITapGestureRecognizer*) tapRecognizer{
    
    [self.viewDuck stopAnimating];
    self.viewDuck.animationImages = self.walk;
    self.viewDuck.animationDuration = 2.5f;
    [self.viewDuck startAnimating];
    
    CGPoint pointOnView = [tapRecognizer locationInView:self.view];
    
    if (self.viewDuck.center.x < pointOnView.x) {
        self.viewDuck.transform = CGAffineTransformMakeScale(-1, 1);
    }
    
    if (self.viewDuck.center.x > pointOnView.x) {
        self.viewDuck.transform = CGAffineTransformMakeScale(1, 1);
    }
    
    [UIView animateWithDuration:2.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction //| UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.viewDuck.center =  CGPointMake(pointOnView.x,self.viewDuck.center.y);
                         stayBool = NO;
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"BU");
                         [self.viewDuck stopAnimating];
                         self.viewDuck.animationImages = self.stay;
                         self.viewDuck.animationDuration = 2.5f;
                         [self.viewDuck startAnimating];
                         stayBool = YES;
                     }];
    
}

-(void)handePanGesture:(UIPanGestureRecognizer*) panRecognizer{
    NSLog(@"handePanGesture %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    [self.viewDuck stopAnimating];
    self.viewDuck.image = [UIImage imageNamed:@"Dead.png"];
    
    if([(UIPanGestureRecognizer*)panRecognizer state] == UIGestureRecognizerStateBegan){
        tempY = self.viewDuck.center.y;
    }
    
    if([(UIPanGestureRecognizer*)panRecognizer state] == UIGestureRecognizerStateChanged){
        CGPoint pointOnView = [panRecognizer translationInView:self.view];
        self.viewDuck.center=CGPointMake(self.viewDuck.center.x+pointOnView.x, self.viewDuck.center.y+ pointOnView.y);
        [panRecognizer setTranslation:CGPointMake(0, 0) inView:self.viewDuck];
    }
    
    if([(UIPanGestureRecognizer*)panRecognizer state] == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        
        CGPoint pointOnView = [panRecognizer translationInView:self.view];
        [UIView animateWithDuration:0.6
                         animations:^{
                             self.viewDuck.center=CGPointMake(self.viewDuck.center.x+pointOnView.x, tempY);
                             [panRecognizer setTranslation:CGPointMake(0, 0) inView:self.viewDuck];
                         }];
        self.viewDuck.animationImages = self.stay;
        self.viewDuck.animationDuration = 2.5f;
        [self.viewDuck startAnimating];
        stayBool = YES;
    }
   
}

-(void)swipeVerticalPanGesture:(UISwipeGestureRecognizer*) swipeRecognizer{

    [self.viewDuck stopAnimating];
    self.viewDuck.image = [UIImage imageNamed:@"Jump-1.png"];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                          self.viewDuck.center =  CGPointMake(self.viewDuck.center.x, self.viewDuck.center.y - 250);
                      }
                     completion:^(BOOL finished) {
                      }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewDuck stopAnimating];
        self.viewDuck.image = [UIImage imageNamed:@"Jump-2.png"];
    });
    
    [UIView animateWithDuration:0.4
                          delay:0.6
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.viewDuck.center =  CGPointMake(self.viewDuck.center.x, self.viewDuck.center.y + 250);
                     }
                     completion:^(BOOL finished) {
                         if (stayBool) {
                             self.viewDuck.animationImages = self.stay;
                         }else{
                             self.viewDuck.animationImages = self.walk;
                         }
                         self.viewDuck.animationDuration = 2.5f;
                         [self.viewDuck startAnimating];
                     }];
}
@end
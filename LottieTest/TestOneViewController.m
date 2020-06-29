//
//  TestOneViewController.m
//  LottieTest
//
//  Created by phoenix on 2020/6/29.
//  Copyright © 2020 ymy. All rights reserved.
//

#import "TestOneViewController.h"
#import "LOTAnimationTransitionController.h"
#import "Test2ViewController.h"
@interface TestOneViewController ()<UIViewControllerTransitioningDelegate>
@property (nonnull, strong) UIButton *button1;
@property (nonnull, strong) UIButton *closeButton;


@end

@implementation TestOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor =[ UIColor greenColor];
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
     [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
     [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     self.closeButton.backgroundColor = [UIColor colorWithRed:50.f/255.f
                                                        green:207.f/255.f
                                                         blue:193.f/255.f
                                                        alpha:1.f];
     self.closeButton.layer.cornerRadius = 7;
     
     [self.closeButton addTarget:self action:@selector(_close) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:self.closeButton];
     
     
     self.button1 = [UIButton buttonWithType:UIButtonTypeSystem];
     [self.button1 setTitle:@"Show Transition A" forState:UIControlStateNormal];
     [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     self.button1.backgroundColor = [UIColor colorWithRed:50.f/255.f
                                                    green:207.f/255.f
                                                     blue:193.f/255.f
                                                    alpha:1.f];
     self.button1.layer.cornerRadius = 7;
     
     [self.button1 addTarget:self action:@selector(_showTransitionA) forControlEvents:UIControlEventTouchUpInside];
     self.view.backgroundColor = [UIColor colorWithRed:122.f/255.f
                                                 green:8.f/255.f
                                                  blue:81.f/255.f
                                                 alpha:1.f];
     [self.view addSubview:self.button1];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  CGRect b = self.view.bounds;
  CGSize buttonSize = [self.button1 sizeThatFits:b.size];
  buttonSize.width += 20;
  buttonSize.height += 20;
  self.button1.bounds = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
  self.button1.center = self.view.center;
  
  
  CGSize closeSize = [self.closeButton sizeThatFits:b.size];
  closeSize.width += 20;
  closeSize.height += 20;
  
  self.closeButton.bounds = CGRectMake(0, 0, closeSize.width, closeSize.height);
  self.closeButton.center = CGPointMake(self.button1.center.x, CGRectGetMaxY(b) - closeSize.height);
}

- (void)_close {
//    [self dismissViewControllerAnimated:YES completion:nil];
//  [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_showTransitionA {

      Test2ViewController *vc = [[Test2ViewController alloc] init];
      vc.transitioningDelegate = self;
      vc.modalPresentationStyle    = UIModalPresentationFullScreen;
      [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark -- View Controller Transitioning

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"transitions" fromLayerNamed:@"outLayer" toLayerNamed:@"inLayer" applyAnimationTransform:YES];
  return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"transitions2" fromLayerNamed:@"outLayer" toLayerNamed:@"inLayer" applyAnimationTransform:YES];
  return animationController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

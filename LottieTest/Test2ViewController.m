//
//  Test2ViewController.m
//  LottieTestDemo
//
//  Created by phoenix on 2020/6/29.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "Test2ViewController.h"
@interface Test2ViewController ()
@property (nonnull, strong) UIButton *button1;
@property (nonnull, strong) UIButton *closeButton;


@end
@implementation Test2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[ UIColor yellowColor];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_showTransitionA {
    
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

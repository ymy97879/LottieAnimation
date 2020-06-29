//
//  ViewController.m
//  LottieTest
//
//  Created by ymy on 2020/6/29.
//  Copyright © 2020 ymy. All rights reserved.
//

#import "ViewController.h"
#import "Lottie.h"
#import "LOTAnimationTransitionController.h"
#import "TestOneViewController.h"
@interface ViewController () <UIViewControllerTransitioningDelegate>{
    UILabel *_fileNameLabel;
    
    UIView *_detailView;
    
    NSInteger _fileIndex;
    
    UIButton *_fillBtn;
}

@property (nonatomic, strong) LOTAnimationView *animationView;
@property (nonatomic, strong) LOTAnimationView *animationURLView;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSArray *titles = @[@"下一个", @"背景色", @"全屏", @"播放/暂停",@"nextView"];
    int n = (int)titles.count;
    CGFloat itemWidth = (width - 10 * n - 10) / n;
    
    while (n > 0) {
        int i = n - 1;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + (itemWidth +10) * i, height - 60, itemWidth, 40);
        btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithDisplayP3Red:arc4random() % 150 + 100 / 255.f green:arc4random() % 100 / 255.f blue:arc4random() % 200 / 255.f alpha:1.f];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        if (i == 2) {
            _fillBtn = btn;
        }
        n --;
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 90, self.view.frame.size.width, 24)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        label.userInteractionEnabled = YES;
        _fileNameLabel = label;
    }
    

//    _animationURLView = [[LOTAnimationView alloc]init];
//    _animationURLView.frame=CGRectMake(([UIScreen mainScreen ].bounds.size.width-300)/2, 100, 300, 200);
//      _animationURLView.contentMode = UIViewContentModeScaleAspectFit;
//      _animationURLView.loopAnimation = YES;
//      _animationURLView.userInteractionEnabled = NO;
//      _animationURLView.backgroundColor=[UIColor clearColor];
//      _animationURLView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//      [self.view insertSubview:_animationURLView atIndex:0];
//    [_animationURLView  sd_setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/airbnb/lottie-web/master/demo/gatin/data.json"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//    }];
}

- (void)btnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 0:
        {
            _fileIndex++;
            [self playAnimation];
        }
            break;
        case 1:
        {
            if (sender.selected) {
                self.view.backgroundColor = [UIColor blackColor];
                _fileNameLabel.textColor = [UIColor whiteColor];
            } else {
                self.view.backgroundColor = [UIColor whiteColor];
                _fileNameLabel.textColor = [UIColor blackColor];
            }
        }
            break;
        case 2:
        {
            if (sender.selected) {
                _animationView.frame=CGRectMake(0, 0, [UIScreen mainScreen ].bounds.size.width, [ UIScreen mainScreen ].bounds.size.height-100);
            } else {
                _animationView.frame=CGRectMake(([UIScreen mainScreen ].bounds.size.width-300)/2, 100, 300, 200);
            }
        }
            break;
        case 3:
        {
            if (_animationView) {
                if (_animationView.isAnimationPlaying) {
                    [_animationView pause];
                } else {
                    [_animationView play];
                }
            } else {
                [self playAnimation];
            }
        }
            break;
        case 4:{
           
           TestOneViewController  *vc = [[TestOneViewController alloc] init];
            vc.modalPresentationStyle    = UIModalPresentationFullScreen;
            UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:NULL];

        }
            break;
        default:
            break;
    }
}

- (NSString *)filePath
{
    if (_fileIndex < 0) {
        _fileIndex = 0;
    }
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"animation"];
    static NSArray *contents = nil;
    if (!contents) {
        contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        contents = [contents sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
    }
    
    if (contents.count) {
        NSInteger i = _fileIndex % (contents.count);
        NSString *fileName = contents[i];
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        return filePath;
    }
    return nil;
}

- (void)playAnimation
{
    NSString *filePath = [self filePath];
    NSString *fileName = [filePath lastPathComponent];
    [self playAnimationWithPath:filePath];
    _fileNameLabel.text = fileName;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (point.y < 120) {
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: UIButton.class]) {
                obj.backgroundColor = [UIColor colorWithDisplayP3Red:arc4random() % 255 / 255.f green:arc4random() % 255 / 255.f blue:arc4random() % 255 / 255.f alpha:1.f];
            }
        }];
        return;
    }
    if (touch.view == _fileNameLabel) {
        NSString *filePath = [self filePath];
        NSString *fileName = [filePath lastPathComponent];
        _fileNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", fileName, [self.class fileSize:filePath]];
    } else {
        if (_animationView.isAnimationPlaying) {
            _fileIndex ++;
        }
        
        [self playAnimation];
    }
}

+ (NSString *)fileSize:(NSString *)path
{
    NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
    
    /*
     NSFileCreationDate = "2013-03-26 03:03:26 +0000";
         NSFileExtendedAttributes =     {
         "com.apple.TextEncoding" = <7574662d 383b3133 34323137 393834>;
         };
         NSFileExtensionHidden = 0;
         NSFileGroupOwnerAccountID = 20;
         NSFileGroupOwnerAccountName = staff;
         NSFileHFSCreatorCode = 0;
         NSFileHFSTypeCode = 0;
         NSFileModificationDate = "2013-03-26 03:03:58 +0000";
         NSFileOwnerAccountID = 501;
         NSFileOwnerAccountName = hehehe;
         NSFilePosixPermissions = 420;
         NSFileReferenceCount = 1;
         NSFileSize = 19;
     NSFileSystemFileNumber = 3145017;
     NSFileSystemNumber = 16777225;
     NSFileType = NSFileTypeRegular;
     */
    
    NSString *size = [info objectForKey:NSFileSize];
    
    NSInteger s = size.integerValue;
    if (s < 1024) {
        return [NSString stringWithFormat:@"%zd B", s];
    } else if (s < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2f KB", s/1024.f];
    } else {
        return [NSString stringWithFormat:@"%.2f MB", s/1024.f/1024.f];
    }
}

- (void)playAnimationWithPath:(NSString *)path
{
    if (!path) {
        return;
    }
    LOTComposition *sceneModel = [LOTComposition animationWithFilePath:path];
    if (!_animationView) {
        _animationView = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
       _animationView.frame=CGRectMake(([UIScreen mainScreen ].bounds.size.width-300)/2, 100, 300, 200);
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
        _animationView.loopAnimation = YES;
        _animationView.userInteractionEnabled = NO;
        _animationView.backgroundColor=[UIColor clearColor];
        _animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:_animationView atIndex:0];
    } else {
        [_animationView stop];
        
        _animationView.sceneModel = sceneModel;
        _animationView.loopAnimation = YES;
    }
    
    if ([path rangeOfString:@"adrock"].length || [path rangeOfString:@"Logo1"].length) {
        _animationView.contentMode = UIViewContentModeScaleAspectFill;
        _fillBtn.selected = YES;
    } else {
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
        _fillBtn.selected = NO;
    }
    
    [self showSwitchDetail:path];
    
    [_animationView playToProgress:1.0 withCompletion:^(BOOL animationFinished) {
        NSLog(@"###animationFinished");
    }];
}

- (void)showSwitchDetail:(NSString *)path
{
    if ([path rangeOfString:@"witch"].length) {
        LOTComposition *sceneModel = [LOTComposition animationWithFilePath:path];
        if (!_detailView) {
            _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 300, 100)];
            _detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _detailView.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:_detailView];
            
            int i = 0;
            {
                LOTAnimationView *view = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
                view.frame = CGRectMake(i%2 * 150, i/2 * 50, 150, 50);
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.loopAnimation = YES;
                view.userInteractionEnabled = NO;
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_detailView addSubview:view];
                
                [view setAnimationProgress:0];
                i++;
            }
            
            {
                LOTAnimationView *view = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
                view.frame = CGRectMake(i%2 * 150, i/2 * 50, 150, 50);
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.loopAnimation = YES;
                view.userInteractionEnabled = NO;
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_detailView addSubview:view];
                
                [view playFromProgress:0 toProgress:0.5 withCompletion:^(BOOL animationFinished) {
                    
                }];
                i++;
            }
            
            {
                LOTAnimationView *view = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
                view.frame = CGRectMake(i%2 * 150, i/2 * 50, 150, 50);
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.loopAnimation = YES;
                view.userInteractionEnabled = NO;
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_detailView addSubview:view];
                
                [view setAnimationProgress:0.5];
                
                i++;
            }
            
            {
                LOTAnimationView *view = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
                view.frame = CGRectMake(i%2 * 150, i/2 * 50, 150, 50);
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.loopAnimation = YES;
                view.userInteractionEnabled = NO;
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_detailView addSubview:view];
                
                [view playFromProgress:0.5 toProgress:1.f withCompletion:^(BOOL animationFinished) {
                    
                }];
                i++;
            }
        }
        _detailView.hidden = NO;
    } else {
        if (_detailView) {
            [_detailView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            _detailView.hidden = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

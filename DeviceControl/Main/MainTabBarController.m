//
//  MainTabBarController.m
//  OneBAuction
//
//  Created by 刘帅 on 2019/4/6.
//  Copyright © 2019 刘帅. All rights reserved.
//

#import "MainTabBarController.h"
#import "LSPaletteController.h"
#import "LSMicrophoneController.h"
#import "LSModelController.h"
#import "LSMusicController.h"
#import "LSOnlineMusicController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化所有控制器
    [self setUpChildVC];
   
}

#pragma mark -初始化所有控制器

- (void)setUpChildVC {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(0, 0, self.tabBar.bounds.size.width, self.tabBar.bounds.size.height+44);
    [[UITabBar appearance] insertSubview:view atIndex:0];
    LSPaletteController *palete = [[LSPaletteController alloc] init];
    [self setChildVC:palete title:NSLocalizedString(@"调色",nil) image:@"调色板" selectedImage:@"调色板-点击"];
    
    LSModelController *model = [[LSModelController alloc] init];
    [self setChildVC:model title:NSLocalizedString(@"模式",nil)  image:@"中图模式" selectedImage:@"中图模式-点击"];
    
//    LSMusicController *music = [[LSMusicController alloc] init];
//    [self setChildVC:music title:@"音乐" image:@"音乐" selectedImage:@"音乐点击"];
//    
//    LSOnlineMusicController *online = [[LSOnlineMusicController alloc] init];
//    [self setChildVC:online title:@"在线音乐" image:@"在线音乐" selectedImage:@"在线音乐-点击"];
//    LSMicrophoneController *microphone = [[LSMicrophoneController alloc] init];
//    [self setChildVC:microphone title:@"麦克风" image:@"麦克风" selectedImage:@"麦克风-点击"];
//    
}

- (void) setChildVC:(UIViewController *)childVC title:(NSString *) title image:(NSString *) image selectedImage:(NSString *) selectedImage {
    
    childVC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    dict[NSForegroundColorAttributeName] = Selected_Color;
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];

    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
  
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
}



@end

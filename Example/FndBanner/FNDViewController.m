//
//  FNDViewController.m
//  FndBanner
//
//  Created by lushaoxiong on 09/20/2019.
//  Copyright (c) 2019 lushaoxiong. All rights reserved.
//

#import "FNDViewController.h"
#import <FndBanner/FndBannerView.h>

@interface FNDViewController ()<FndBannerViewDelegate>

@property (strong, nonatomic) FndBannerView * loop;

@end

@implementation FNDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self style1];

    [self style2];

    [self style3];

    [self style4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)style1
{
    self.loop = [[FndBannerView alloc] initWithFrame:CGRectMake(0, 20, 320, 200)];
    self.loop.imageStringsGroup = @[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1568714172&di=ded2f6c8ae8d3063be0c875e3da4959d&src=http://pic.k73.com/up/soft/2016/0102/092635_44907394.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568724332681&di=adc889b4e6507271b5c608f2df9b676b&imgtype=0&src=http%3A%2F%2Fa3.att.hudong.com%2F28%2F22%2F20300000859973134180223918035.jpg"];
    self.loop.pageControlStyle = FndBannerViewPageContolStyleClassic;
    self.loop.currentPageDotColor =[UIColor redColor];
    self.loop.pageDotColor =[UIColor greenColor];
    self.loop.pageControlAliment = FndBannerViewPageContolAlimentRight;
    self.loop.titlesGroup =@[@"金九银十 是毕业生的",@"别想了洗洗吧别想了洗洗吧别想了洗洗吧别想了洗洗吧别想了洗洗吧别想了洗洗吧别想了洗洗吧别想了洗洗吧"];
    self.loop.titleLabelbgImg = [UIImage imageNamed:@"bg_jianbianlbt"];
    //    loop.onlyDisplayText = YES;
    self.loop.autoScrollTimeInterval = 2.0;
    //    loop.autoScroll = NO;
    self.loop.delegate = self;
    self.loop.pageControlRightOffset = -10;
    self.loop.titleLabelTextColor = [UIColor redColor];
    self.loop.titleLabelTextAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.loop];
}

-(void)style2
{
    FndBannerView *loop = [[FndBannerView alloc] initWithFrame:CGRectMake(0, 240, 320, 200)];
    loop.imageStringsGroup = @[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1568714172&di=ded2f6c8ae8d3063be0c875e3da4959d&src=http://pic.k73.com/up/soft/2016/0102/092635_44907394.jpg",@"banner1"];
    loop.pageControlStyle = FndBannerViewPageContolStyleAnimated;
    loop.currentPageDotColor =[UIColor redColor];
    loop.pageDotColor =[UIColor greenColor];
    loop.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    loop.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    loop.pageControlDotSize = CGSizeMake(8, 3);
    //loop.showPageControl = NO;
    loop.pageControlBottomOffset = 25;
    [self.view addSubview:loop];
}

-(void)style3
{

}

-(void)style4
{

}


#pragma mark FndBannerViewDelegate
/** 点击图片回调 */
- (void)fndBannerView:(FndBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击图片==>>(%ld)",(long)index);
}

/** 图片滚动回调 */
- (void)fndBannerView:(FndBannerView *)bannerView didScrollToIndex:(NSInteger)index
{
    NSArray * arr = @[@"30",@"50"];
    self.loop.titleLabelHeight = [arr[index] floatValue];
    //NSLog(@"图片滚动(%ld)",(long)index);
}

@end

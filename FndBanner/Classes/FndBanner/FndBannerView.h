//
//  FndBannerView.h
//  FndBanner
//
//  Created by Lsx on 2019/9/3.
//  Copyright © 2019年 Fnd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    FndBannerViewPageContolAlimentRight,
    FndBannerViewPageContolAlimentCenter
} FndBannerViewPageContolAliment;

typedef enum {
    FndBannerViewPageContolStyleClassic,        // 系统自带经典样式
    FndBannerViewPageContolStyleAnimated,       // 动画效果pagecontrol
    FndBannerViewPageContolStyleNone            // 不显示pagecontrol
} FndBannerViewPageContolStyle;

@class FndBannerView;

@protocol FndBannerViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)fndBannerView:(FndBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)fndBannerView:(FndBannerView *)bannerView didScrollToIndex:(NSInteger)index;

@end

@interface FndBannerView : UIView

//////////////////////  数据源API //////////////////////

/**图片 string 数组 可以是本地图片名字，也可以是网络图片Url  混合都可以*/
@property (nonatomic, strong) NSArray *imageStringsGroup;
/** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray *titlesGroup;






//////////////////////  滚动控制API //////////////////////

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, weak) id<FndBannerViewDelegate> delegate;

/** block方式监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/** block方式监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/** 可以调用此方法手动控制滚动到哪一个index */
- (void)makeScrollViewScrollToIndex:(NSInteger)index;


//////////////////////  自定义样式API  //////////////////////

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/** 只展示文字轮播 */
@property (nonatomic, assign) BOOL onlyDisplayText;

/** pagecontrol 样式，默认为动画样式 */
@property (nonatomic, assign) FndBannerViewPageContolStyle pageControlStyle;

/** 分页控件位置 */
@property (nonatomic, assign) FndBannerViewPageContolAliment pageControlAliment;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;

/** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/** 轮播文字label字体大小 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/** 轮播文字label背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/** 轮播文字label高度 */
@property (nonatomic, assign) CGFloat titleLabelHeight;

/** 轮播文字label对齐方式 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

/** 轮播文字label背景图 */
@property (nonatomic, strong) UIImage * titleLabelbgImg;

@end

NS_ASSUME_NONNULL_END

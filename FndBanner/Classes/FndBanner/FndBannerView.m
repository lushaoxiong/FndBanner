//
//  FndBannerView.m
//  FndBanner
//
//  Created by Lsx on 2019/9/3.
//  Copyright © 2019年 Fnd. All rights reserved.
//

#import "FndBannerView.h"
#import "TAPageControl.h"
#import <SDWebImage/SDWebImage.h>
#import "UIView+FndExtension.h"

#define kPageControlDotSize CGSizeMake(10, 10)

@interface FndBannerView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,   weak) UIControl *pageControl;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (strong, nonatomic) UILabel * titleLable;
@property (strong, nonatomic) UIImageView * titleBgImage;

@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic,   weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;

@end

@implementation FndBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configInitViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configInitViews];
}

- (void)configInitViews
{
    [self configAddViews];
    [self configConstraint];
    [self initialization];
    [self addObservers];
}

- (void)initialization
{
    self.pageControlAliment = FndBannerViewPageContolAlimentCenter;
    self.autoScrollTimeInterval = 2.0;
    self.titleLabelTextColor = [UIColor whiteColor];
    self.titleLabelTextFont= [UIFont systemFontOfSize:14];
    self.titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.titleLabelHeight = 30;
    self.titleLabelTextAlignment = NSTextAlignmentLeft;
    self.autoScroll = YES;
    self.infiniteLoop = YES;
    self.showPageControl = YES;
    self.pageControlDotSize = kPageControlDotSize;
    self.pageControlBottomOffset = 0;
    self.pageControlRightOffset = 0;
    self.pageControlStyle = FndBannerViewPageContolStyleClassic;
    self.hidesForSinglePage = YES;
    self.currentPageDotColor = [UIColor whiteColor];
    self.pageDotColor = [UIColor lightGrayColor];
    self.bannerImageViewContentMode = UIViewContentModeScaleToFill;
}

- (void)configAddViews
{
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    [self addSubview:self.scrollView];
    [self addSubview:self.titleLable];
    [self.titleLable addSubview:self.titleBgImage];
}

-(void)configConstraint
{
    self.scrollView.frame = self.bounds;
    
    CGFloat imageWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    self.leftImageView.frame    = CGRectMake(imageWidth * 0, 0, imageWidth, imageHeight);
    self.middleImageView.frame  = CGRectMake(imageWidth * 1, 0, imageWidth, imageHeight);
    self.rightImageView.frame   = CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight);
    self.scrollView.contentSize = CGSizeMake(imageWidth * 3, 0);
    
    [self setScrollViewContentOffsetCenter];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kPageControlDotSize, self.pageControlDotSize))) {
            pageControl.dotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.imageStringsGroup.count];
    } else {
        size = CGSizeMake(self.imageStringsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    }
   
    CGFloat x = (self.fnd_width - size.width) * 0.5;
    if (self.pageControlAliment == FndBannerViewPageContolAlimentRight) {
        x = self.fnd_width - size.width - 10;
    }
    CGFloat y = self.fnd_height - size.height - 10;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;

    
    if (self.onlyDisplayText) {
        self.titleLable.frame = self.bounds;
    } else {
        CGFloat titleLabelW = self.fnd_width;
        CGFloat titleLabelH = self.titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.fnd_height - titleLabelH;
        self.titleLable.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
    self.titleBgImage.frame = self.titleLable.bounds;
}

#pragma mark 设置scrollView的ContentOffset居中
- (void)setScrollViewContentOffsetCenter {
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
}

#pragma mark - kvo
- (void)addObservers {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self caculateCurIndex];
    }
}




#pragma mark getter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)middleImageView
{
    if (!_middleImageView) {
        _middleImageView = [UIImageView new];
        _middleImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [_middleImageView addGestureRecognizer:tap];
        _middleImageView.userInteractionEnabled = YES;
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

-(UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.hidden = NO;
        _titleLable.numberOfLines = 0;
    }
    return _titleLable;
}

-(UIImageView *)titleBgImage
{
    if (!_titleBgImage) {
         _titleBgImage = [UIImageView new];
    }
    return _titleBgImage;
}



#pragma mark setter

-(void)setDelegate:(id<FndBannerViewDelegate>)delegate
{
    _delegate = delegate;
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageContol = (TAPageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.dotColor = currentPageDotColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
    
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage
{
    _currentPageDotImage = currentPageDotImage;
    if (self.pageControlStyle != FndBannerViewPageContolStyleAnimated) {
        self.pageControlStyle = FndBannerViewPageContolStyleAnimated;
    }
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage
{
    _pageDotImage = pageDotImage;
    if (self.pageControlStyle != FndBannerViewPageContolStyleAnimated) {
        self.pageControlStyle = FndBannerViewPageContolStyleAnimated;
    }
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot
{
    if (!image || !self.pageControl) return;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage = image;
        }
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (void)setPageControlStyle:(FndBannerViewPageContolStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    
    [self setupPageControl];
}

-(void)setTitleLabelbgImg:(UIImage *)titleLabelbgImg
{
    _titleLabelbgImg = titleLabelbgImg;
    self.titleBgImage.image = titleLabelbgImg;
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    self.titleLable.textAlignment = titleLabelTextAlignment;
}

-(void)setTitleLabelHeight:(CGFloat)titleLabelHeight
{
    _titleLabelHeight = titleLabelHeight;
    self.titleLable.fnd_height = titleLabelHeight;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    self.titleLable.backgroundColor = titleLabelBackgroundColor;
}

-(void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    self.titleLable.font = titleLabelTextFont;
}

-(void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    self.titleLable.textColor = titleLabelTextColor;
}

-(void)setImageStringsGroup:(NSArray *)imageStringsGroup
{
    if(imageStringsGroup){
        _imageStringsGroup = imageStringsGroup;
        self.curIndex = 0;
    }
}

-(void)setTitlesGroup:(NSArray *)titlesGroup
{
    _titlesGroup = titlesGroup;
    self.curIndex = 0;
    if (self.onlyDisplayText) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < _titlesGroup.count; i++) {
            [temp addObject:@""];
        }
        self.backgroundColor = [UIColor clearColor];
        self.imageStringsGroup = [temp copy];
    }
}


-(void)setCurIndex:(NSInteger)curIndex
{
    if(_curIndex>=0){
         _curIndex = curIndex;
    }
    NSInteger imageCount = self.imageStringsGroup.count;
    NSInteger leftIndex = (curIndex + imageCount - 1) % imageCount;
    NSInteger rightIndex= (curIndex + 1) % imageCount;
    
    //
    if([self isHttpUrl:self.imageStringsGroup[leftIndex]]){
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageStringsGroup[leftIndex]] placeholderImage:_placeholderImage];
    }else{
        self.leftImageView.image = [UIImage imageNamed:self.imageStringsGroup[leftIndex]];
    }
    //
    if([self isHttpUrl:self.imageStringsGroup[curIndex]]){
        [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:self.imageStringsGroup[curIndex]] placeholderImage:_placeholderImage];
    }else{
       self.middleImageView.image = [UIImage imageNamed:self.imageStringsGroup[curIndex]];
    }
    //
    if([self isHttpUrl:self.imageStringsGroup[rightIndex]]){
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageStringsGroup[rightIndex]] placeholderImage:_placeholderImage];
    }else{
        self.rightImageView.image = [UIImage imageNamed:self.imageStringsGroup[rightIndex]];
    }
    
    [self setScrollViewContentOffsetCenter];
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.currentPage = curIndex;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = curIndex;
    }
    self.titleLable.text = self.titlesGroup[curIndex];
}

-(void)setOnlyDisplayText:(BOOL)onlyDisplayText
{
    _onlyDisplayText = onlyDisplayText;
    self.leftImageView.hidden = onlyDisplayText;
    self.middleImageView.hidden = onlyDisplayText;
    self.rightImageView.hidden = onlyDisplayText;
}

-(void)setContentMode:(UIViewContentMode)contentMode
{
    self.leftImageView.contentMode = contentMode;
    self.middleImageView.contentMode = contentMode;
    self.rightImageView.contentMode = contentMode;
}

#pragma mark action

- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    
    if (self.imageStringsGroup.count == 0 || self.onlyDisplayText) return;
    
    if ((self.imageStringsGroup.count == 1) && self.hidesForSinglePage) return;
    
    NSInteger indexOnPageControl = self.curIndex;
    
    switch (self.pageControlStyle) {
        case FndBannerViewPageContolStyleAnimated:
        {
            TAPageControl *pageControl = [[TAPageControl alloc] init];
            pageControl.numberOfPages = self.imageStringsGroup.count;
            pageControl.dotColor = self.currentPageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        case FndBannerViewPageContolStyleClassic:
        {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.imageStringsGroup.count;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        default:
            break;
    }
    
    // 重设pagecontroldot图片
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
}

- (void)automaticScroll
{
    CGFloat criticalValue = .2f;
    if (self.scrollView.contentOffset.x < CGRectGetWidth(self.scrollView.bounds) - criticalValue || self.scrollView.contentOffset.x > CGRectGetWidth(self.scrollView.bounds) + criticalValue) {
        [self setScrollViewContentOffsetCenter];
    }
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)caculateCurIndex {
    if (self.imageStringsGroup && self.imageStringsGroup.count > 0) {
        CGFloat pointX = self.scrollView.contentOffset.x;
        
        // 判断临界值,第一和第三imageView内容偏移
        CGFloat criticalValue = .2f;
        
        // 向右滚动，判断正确的临界值
        if (pointX > 2 * CGRectGetWidth(self.scrollView.bounds) - criticalValue) {
            self.curIndex = (self.curIndex + 1) % self.imageStringsGroup.count;
        } else if (pointX < criticalValue) {
            // 滚动,判断临界值
            self.curIndex = (self.curIndex + self.imageStringsGroup.count - 1) % self.imageStringsGroup.count;
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(fndBannerView:didScrollToIndex:)]) {
        [self.delegate fndBannerView:self didScrollToIndex:self.curIndex];
    }else if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(self.curIndex);
    }
}

#pragma mark - button actions
- (void)imageClicked:(UITapGestureRecognizer *)tap {
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock (self.curIndex);
    }
    if ([self.delegate respondsToSelector:@selector(fndBannerView:didSelectItemAtIndex:)]) {
        [self.delegate fndBannerView:self didSelectItemAtIndex:self.curIndex];
    }
}





- (BOOL)isHttpUrl:(NSString *)furl
{
    NSString *url = [furl lowercaseString];
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"] || [url hasPrefix:@"http%3A%2F%2F"] || [url hasPrefix:@"https%3A%2F%2F"]) {
        return YES;
    }
    return NO;
}

- (void)makeScrollViewScrollToIndex:(NSInteger)index{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    if (0 == self.imageStringsGroup.count) return;
    
    self.curIndex = index;
    
    if (self.autoScroll) {
        [self setupTimer];
    }
}
@end

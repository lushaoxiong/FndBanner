//
//  UIView+FndExtension.m
//  FndBanner
//
//  Created by Lsx on 2019/9/19.
//  Copyright © 2019年 Fnd. All rights reserved.
//

#import "UIView+FndExtension.h"

@implementation UIView (FndExtension)

- (CGFloat)fnd_height
{
    return self.frame.size.height;
}

- (void)setFnd_height:(CGFloat)fnd_height
{
    CGRect temp = self.frame;
    temp.size.height = fnd_height;
    self.frame = temp;
}

- (CGFloat)fnd_width
{
    return self.frame.size.width;
}

- (void)setFnd_width:(CGFloat)fnd_width
{
    CGRect temp = self.frame;
    temp.size.width = fnd_width;
    self.frame = temp;
}


- (CGFloat)fnd_y
{
    return self.frame.origin.y;
}

- (void)setFnd_y:(CGFloat)fnd_y
{
    CGRect temp = self.frame;
    temp.origin.y = fnd_y;
    self.frame = temp;
}

- (CGFloat)fnd_x
{
    return self.frame.origin.x;
}

- (void)setFnd_x:(CGFloat)fnd_x
{
    CGRect temp = self.frame;
    temp.origin.x = fnd_x;
    self.frame = temp;
}

@end

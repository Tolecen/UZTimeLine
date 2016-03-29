//
//  UIImageView+Animation.m
//  maguanjiaios
//
//  Created by xiefei on 16/1/23.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UIImageView+Animation.h"

@implementation UIImageView (HKImageViewAnimation)

- (void) doCartAnimationFrom:(CGPoint)fromPos toPos:(CGPoint)toPos
{
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration=0.5f;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeRemoved;
    animation.repeatCount=0;// repeat forever
    animation.calculationMode = kCAAnimationCubicPaced;
    animation.delegate = self;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, fromPos.x, fromPos.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 112, 184, toPos.x, toPos.y);
//    CGPathAddQuadCurveToPoint(curvedPath, NULL, 310, 584, 512, 584);
//    CGPathAddQuadCurveToPoint(curvedPath, NULL, 712, 584, 712, 384);
//    CGPathAddQuadCurveToPoint(curvedPath, NULL, 712, 184, 512, 184);
    
    animation.path=curvedPath;
    
    [self performSelector:@selector(animationDidStop:finished:) withObject:nil afterDelay:0.45];

    [self.layer addAnimation:animation forKey:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
}
@end
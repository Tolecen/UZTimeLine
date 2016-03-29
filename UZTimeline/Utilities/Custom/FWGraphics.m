//
//  FWGraphics.m
//  FWBaseAppCommonView
//
//  Created by 陈国双 on 4/16/15.
//  Copyright (c) 2015 freework. All rights reserved.
//

#import "FWGraphics.h"
#import <ImageIO/ImageIO.h>

@implementation FWGraphics


+ (void)drawCircleWithContext:(CGContextRef)context
                       radius:(CGFloat)radius
                       center:(CGPoint)center
                    fillColor:(CGColorRef)fillColor
                  borderColor:(CGColorRef)borderColor
                  borderWidth:(CGFloat)borderWidth
{
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, center.x - radius, center.y);
    CGContextAddArcToPoint(context, center.x - radius, center.y - radius, center.x, center.y - radius, radius);
    CGContextAddArcToPoint(context, center.x, center.y - radius, center.x + radius, center.y, radius);
    CGContextAddArcToPoint(context, center.x + radius, center.y + radius, center.x, center.y + radius, radius);
    CGContextAddArcToPoint(context, center.x - radius, center.y + radius, center.x - radius, center.y, radius);
    CGContextAddLineToPoint(context, center.x - radius, center.y);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextSetStrokeColorWithColor(context, borderColor);
    CGContextSetLineWidth(context, borderWidth);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}

+ (void)drawRectWithContext:(CGContextRef)context
                       rect:(CGRect)rect
                     radius:(CGFloat)radius
                  fillColor:(CGColorRef)fillColor
                   fragment:(FWCornerFragment)fragment
{
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    if (radius > 0 && (fragment & FWCornerFragment_LeftTop) == FWCornerFragment_LeftTop) {
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    } else {
        CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    }
    CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    if (radius > 0 && (fragment & FWCornerFragment_RigthTop) == FWCornerFragment_RigthTop) {
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
    } else {
        CGContextAddLineToPoint(context,  CGRectGetMaxX(rect), CGRectGetMinY(rect));
    }
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMidY(rect));
    
    if (radius > 0 && (fragment & FWCornerFragment_RightBottom) == FWCornerFragment_RightBottom) {
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
    } else {
        CGContextAddLineToPoint(context,  CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    }
    CGContextAddLineToPoint(context,  CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    if (radius > 0 && (fragment & FWCornerFragment_LeftBottom) == FWCornerFragment_LeftBottom) {
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    } else {
        CGContextAddLineToPoint(context,  CGRectGetMinX(rect), CGRectGetMaxY(rect));
    }
    CGContextAddLineToPoint(context,  CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}

+ (void)drawCardWithContext:(CGContextRef)context
                     radius:(CGFloat)radius
                       rect:(CGRect)rect
                   fragment:(FWCardFragment)fragment
                  fillColor:(CGColorRef)fillColor
                borderColor:(CGColorRef)borderColor
                borderWidth:(CGFloat)borderWidth
                   lineType:(drawLineDashBlock)lineType
{
    //STEP 1.填充
    FWCornerFragment cornerFragment;
    if (fragment == FWCardFragment_Top) {
        cornerFragment = (FWCornerFragment_LeftTop | FWCornerFragment_RigthTop);
    } else if (fragment == FWCardFragment_Middle) {
        cornerFragment = 0;
    } else if (fragment == FWCardFragment_Bottom) {
        cornerFragment = (FWCornerFragment_RightBottom | FWCornerFragment_LeftBottom);
    } else if (fragment == FWCardFragment_All) {
        cornerFragment = (FWCornerFragment_LeftTop | FWCornerFragment_RigthTop | FWCornerFragment_RightBottom | FWCornerFragment_LeftBottom);
    }
    [[self class] drawRectWithContext:context
                                 rect:rect
                               radius:radius
                            fillColor:fillColor
                             fragment:cornerFragment];
    
    //STEP 2.绘制线条
    if (fragment == FWCardFragment_Top) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        if (radius > 0) {
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
            CGContextAddArcToPoint(context, CGRectGetMinX(rect),
                                   CGRectGetMinY(rect),
                                   CGRectGetMidX(rect),
                                   CGRectGetMinY(rect),
                                   radius);
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect),
                                   CGRectGetMinY(rect),
                                   CGRectGetMaxX(rect),
                                   CGRectGetMidY(rect),
                                   radius);
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMidY(rect));
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        } else {
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        }
        CGContextSetLineWidth(context, borderWidth);
        if (lineType) {
            lineDashData dashData = lineType();
            CGContextSetLineDash(context,
                                 dashData.phase,
                                 dashData.lengths,
                                 dashData.count);
        }
        CGContextSetStrokeColorWithColor(context, borderColor);
        CGContextDrawPath(context, kCGPathStroke);
    } else if (fragment == FWCardFragment_Bottom) {
        CGContextMoveToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        if (radius > 0) {
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMidY(rect));
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
            CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        } else {
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        }
        CGContextSetLineWidth(context, borderWidth);
        if (lineType) {
            lineDashData dashData = lineType();
            CGContextSetLineDash(context,
                                 dashData.phase,
                                 dashData.lengths,
                                 dashData.count);
        }
        CGContextSetStrokeColorWithColor(context, borderColor);
        CGContextDrawPath(context, kCGPathStroke);
    } else if (fragment == FWCardFragment_Middle) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGContextSetLineWidth(context, borderWidth);
        if (lineType) {
            lineDashData dashData = lineType();
            CGContextSetLineDash(context,
                                 dashData.phase,
                                 dashData.lengths,
                                 dashData.count);
        }
        CGContextSetStrokeColorWithColor(context, borderColor);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextMoveToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        CGContextSetLineWidth(context, borderWidth);
        if (lineType) {
            lineDashData dashData = lineType();
            CGContextSetLineDash(context,
                                 dashData.phase,
                                 dashData.lengths,
                                 dashData.count);
        }
        CGContextSetStrokeColorWithColor(context, borderColor);
        CGContextDrawPath(context, kCGPathStroke);
    } else if (fragment == FWCardFragment_All) {
        if (radius > 0) {
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
            CGContextAddArcToPoint(context,
                                   CGRectGetMinX(rect),
                                   CGRectGetMinY(rect),
                                   CGRectGetMidX(rect),
                                   CGRectGetMinY(rect),
                                   radius);
            CGContextAddArcToPoint(context,
                                   CGRectGetMaxX(rect),
                                   CGRectGetMinY(rect),
                                   CGRectGetMaxX(rect),
                                   CGRectGetMidY(rect),
                                   radius);
            CGContextAddArcToPoint(context,
                                   CGRectGetMaxX(rect),
                                   CGRectGetMaxY(rect),
                                   CGRectGetMidX(rect),
                                   CGRectGetMaxY(rect),
                                   radius);
            CGContextAddArcToPoint(context,
                                   CGRectGetMinX(rect),
                                   CGRectGetMaxY(rect),
                                   CGRectGetMinX(rect),
                                   CGRectGetMidY(rect),
                                   radius);
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
            CGContextClosePath(context);
        } else {
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
            CGContextClosePath(context);
        }
        
        CGContextSetLineWidth(context, borderWidth);
        if (lineType) {
            lineDashData dashData = lineType();
            CGContextSetLineDash(context,
                                 dashData.phase,
                                 dashData.lengths,
                                 dashData.count);
        }
        CGContextSetStrokeColorWithColor(context, borderColor);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

+ (void)drawBackgroundWithContext:(CGContextRef)context
                             rect:(CGRect)rect
                        fillColor:(CGColorRef)fillColor
{
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}

+ (void)drawArrowWithContext:(CGContextRef)context
                        rect:(CGRect)rect
                   arrowType:(FWArrowType)arrowType
               arrowTopPoint:(CGPoint)arrowTopPoint
                   arrowSize:(CGSize)arrowSize
                   fillColor:(CGColorRef)fillColor
                 borderColor:(CGColorRef)borderColor
                 borderWidth:(CGFloat)borderWidth
                      radius:(CGFloat)radius
{
    
    CGPoint points[10] = {};
    BOOL canDraw = [self inner_DrawArrowPoints:points
                                          rect:rect
                                     arrwoType:arrowType
                                 arrowTopPoint:arrowTopPoint
                                     arrowSize:arrowSize];
    if (!canDraw) {
        return;
    }
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, points[0].x, points[0].y);
    CGContextAddLineToPoint(context, points[1].x, points[1].y);
    NSInteger pointIdx = 2;
    while (pointIdx < 10) {
        if (radius > 0) {
            CGPoint secondPoint = points[pointIdx];
            CGPoint thridPoint = points[pointIdx + 1];
            CGContextAddArcToPoint(context, secondPoint.x, secondPoint.y, thridPoint.x, thridPoint.y, radius);
            pointIdx += 2;
        } else {
            CGContextAddLineToPoint(context, points[pointIdx].x, points[pointIdx].y);
            pointIdx++;
        }
    }
    CGContextAddLineToPoint(context, points[0].x, points[0].y);
    CGContextClosePath(context);
    if (fillColor) CGContextSetFillColorWithColor(context, fillColor);
    if (borderColor) CGContextSetStrokeColorWithColor(context, borderColor);
    CGContextSetLineWidth(context, borderWidth);
    if (fillColor && borderWidth) {
        CGContextDrawPath(context, kCGPathFillStroke);
    } else if (fillColor) {
        CGContextDrawPath(context, kCGPathFill);
    } else if (borderColor) {
        CGContextDrawPath(context, kCGPathStroke);
    }
    CGContextRestoreGState(context);
}

+ (void)drawCricleAndCrossXWithContext:(CGContextRef)context
                                  rect:(CGRect)rect
                                radius:(CGFloat)radius
                             fillColor:(CGColorRef)fillColor
                           borderColor:(CGColorRef)borderColor
                           borderWidth:(CGFloat)borderWidth
                            crossColor:(CGColorRef)crossColor
                                offset:(CGFloat)offset
                             crossType:(FWCrossAngleType)crossType
{
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    [[self class] drawCircleWithContext:context
                                 radius:radius
                                 center:center
                              fillColor:fillColor
                            borderColor:borderColor
                            borderWidth:borderWidth];
    
    CGRect crossRect = CGRectMake(center.x - radius + offset,
                                  center.y - radius + offset,
                                  radius * 2.0f - offset * 2.0f,
                                  radius * 2.0f - offset * 2.0f);
    if (crossType == FWCrossAngleType_Zero) {
        [[self class] drawCrossXWithContext:context
                                       rect:crossRect
                                 crossColor:crossColor
                                 crossWidth:borderWidth
                                     angle1:M_PI_2
                                     angle2:0];
    } else if (crossType == FWCrossAngleType_PI_PER_4) {
        [[self class] drawCrossXWithContext:context
                                       rect:crossRect
                                 crossColor:crossColor
                                 crossWidth:borderWidth
                                     angle1:M_PI_4
                                     angle2:M_PI_4 * 3];
    }
}

+ (void)drawCrossXWithContext:(CGContextRef)context
                         rect:(CGRect)rect
                   crossColor:(CGColorRef)crossColor
                   crossWidth:(CGFloat)crossWidth
                       angle1:(CGFloat)angle1
                       angle2:(CGFloat)angle2
{
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    radius /= 2.0f;
    CGSize offset1 = CGSizeZero;
    CGSize offset2 = CGSizeZero;
    
    offset1.width = sin(angle1);
    offset1.height = cos(angle1);
    offset2.width = sin(angle2);
    offset2.height = cos(angle2);
    
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, center.x + offset1.width, center.y - offset1.height);
    CGContextAddLineToPoint(context, center.x - offset1.width, center.y + offset1.height);
    CGContextSetStrokeColorWithColor(context, crossColor);
    CGContextSetLineWidth(context, crossWidth);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextMoveToPoint(context, center.x + offset2.width, center.y - offset2.height);
    CGContextAddLineToPoint(context, center.x - offset2.width, center.y + offset2.height);
    CGContextSetStrokeColorWithColor(context, crossColor);
    CGContextSetLineWidth(context, crossWidth);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
}

#pragma mark - 私有方法
+ (BOOL)inner_DrawArrowPoints:(CGPoint *)points
                         rect:(CGRect)rect
                    arrwoType:(FWArrowType)arrwoType
                arrowTopPoint:(CGPoint)arrowTopPoint
                    arrowSize:(CGSize)arrowSize
{
    BOOL result = NO;
    CGFloat arrowSizeWidthHalf = arrowSize.width / 2.0f;
    if (arrwoType == FWArrowType_Top) {
        result = YES;
        CGRect rClient = CGRectMake(CGRectGetMinX(rect),
                                    CGRectGetMinY(rect) + arrowSize.height,
                                    CGRectGetWidth(rect),
                                    CGRectGetHeight(rect) - arrowSize.height);
        CGFloat arrowTopX = CGRectGetMinX(rect) + arrowTopPoint.x;
        
        points[0] = CGPointMake(arrowTopX, CGRectGetMinY(rect));
        points[1] = CGPointMake(arrowTopX + arrowSizeWidthHalf, CGRectGetMinY(rClient));
        points[2] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMinY(rClient));
        points[3] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMidY(rClient));
        points[4] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMaxY(rClient));
        points[5] = CGPointMake(CGRectGetMidX(rClient), CGRectGetMaxY(rClient));
        points[6] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMaxY(rClient));
        points[7] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMidY(rClient));
        points[8] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMinY(rClient));
        points[9] = CGPointMake(arrowTopX - arrowSizeWidthHalf, CGRectGetMinY(rClient));
    } else if (arrwoType == FWArrowType_Left) {
        result = YES;
        CGRect rClient = CGRectMake(CGRectGetMinX(rect) + arrowSize.height,
                                    CGRectGetMinY(rect),
                                    CGRectGetWidth(rect) - arrowSize.height,
                                    CGRectGetHeight(rect));
        CGFloat arrowTopY = CGRectGetMinY(rect) + arrowTopPoint.y;
        points[0] = CGPointMake(CGRectGetMinX(rect), arrowTopY);
        points[1] = CGPointMake(CGRectGetMinX(rClient), arrowTopY - arrowSizeWidthHalf);
        points[2] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMinY(rClient));
        points[3] = CGPointMake(CGRectGetMidX(rClient), CGRectGetMinY(rClient));
        points[4] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMinY(rClient));
        points[5] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMidY(rClient));
        points[6] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMaxY(rClient));
        points[7] = CGPointMake(CGRectGetMidX(rClient), CGRectGetMaxY(rClient));
        points[8] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMaxY(rClient));
        points[9] = CGPointMake(CGRectGetMinX(rClient), arrowTopY + arrowSizeWidthHalf);
    } else if (arrwoType == FWArrowType_Right) {
        result = YES;
        CGRect rClient = CGRectMake(CGRectGetMinX(rect),
                                    CGRectGetMinY(rect),
                                    CGRectGetWidth(rect) - arrowSize.height,
                                    CGRectGetHeight(rect));
        CGFloat arrowTopY = CGRectGetMinY(rect) + arrowTopPoint.y;
        points[0] = CGPointMake(CGRectGetMaxX(rect), arrowTopY);
        points[1] = CGPointMake(CGRectGetMaxX(rClient), arrowTopY + arrowSizeWidthHalf);
        points[2] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMaxY(rClient));
        points[3] = CGPointMake(CGRectGetMidX(rClient), CGRectGetMaxY(rClient));
        points[4] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMaxY(rClient));
        points[5] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMidY(rClient));
        points[6] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMinY(rClient));
        points[7] = CGPointMake(CGRectGetMidX(rClient), CGRectGetMinY(rClient));
        points[8] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMinY(rClient));
        points[9] = CGPointMake(CGRectGetMaxX(rClient), arrowTopY - arrowSizeWidthHalf);
    } else if (arrwoType == FWArrowType_Bottom) {
        result = YES;
        CGRect rClient = CGRectMake(CGRectGetMinX(rect),
                                    CGRectGetMinY(rect),
                                    CGRectGetWidth(rect),
                                    CGRectGetHeight(rect) - arrowSize.height);
        CGFloat arrowTopX = CGRectGetMinX(rect) + arrowTopPoint.x;
        points[0] = CGPointMake(arrowTopX, CGRectGetMaxY(rect));
        points[1] = CGPointMake(arrowTopX - arrowSizeWidthHalf, CGRectGetMaxY(rClient));
        points[2] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMaxY(rClient));
        points[3] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMidY(rClient));
        points[4] = CGPointMake(CGRectGetMinX(rClient), CGRectGetMinY(rClient));
        points[5] = CGPointMake(CGRectGetMidX(rClient), CGRectGetMinY(rClient));
        points[6] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMinY(rClient));
        points[7] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMidY(rClient));
        points[8] = CGPointMake(CGRectGetMaxX(rClient), CGRectGetMaxY(rClient));
        points[9] = CGPointMake(arrowTopX + arrowSizeWidthHalf, CGRectGetMaxY(rClient));
    }
    return result;
}

+ (NSArray *)imagesWithGIFFileName:(NSString *)fileName
{
    NSURL *fileURL = [NSURL fileURLWithPath:fileName];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)fileURL, NULL);
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSInteger imageCount = CGImageSourceGetCount(imageSource);
    for (NSInteger imageIdx = 0; imageIdx < imageCount; imageIdx++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, imageIdx, NULL);
        if (imageRef) {
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            if (image) {
                [images addObject:image];
            }
        }
        CGImageRelease(imageRef);
    }
    CFRelease(imageSource);
    return [images autorelease];
}

@end

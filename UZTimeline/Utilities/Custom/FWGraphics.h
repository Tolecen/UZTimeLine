//
//  FWGraphics.h
//  FWBaseAppCommonView
//
//  Created by 陈国双 on 4/16/15.
//  Copyright (c) 2015 freework. All rights reserved.
//  重新整理的绘图以及位图的处理
//*****************************************************************
//  version         author          date        status
//*****************************************************************
//  1.0.0           chen.gsh        2015-04-16  create
//*****************************************************************

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//卡片的圆角定义
typedef NS_ENUM(NSUInteger, FWCornerFragment)
{
    FWCornerFragment_LeftTop      = (1),          //左上角
    FWCornerFragment_RigthTop     = (1 << 1),     //右上角
    FWCornerFragment_RightBottom  = (1 << 2),     //右下角
    FWCornerFragment_LeftBottom   = (1 << 3),     //左下角
};

typedef NS_ENUM(NSUInteger, FWCardFragment)
{
    FWCardFragment_Top          = (0),          //卡片上部
    FWCardFragment_Middle       = (1),          //卡片中部
    FWCardFragment_Bottom       = (2),          //卡片底部
    FWCardFragment_All          = (3),          //单独卡片
};

//箭头填充
typedef NS_ENUM(NSUInteger, FWArrowType)
{
    FWArrowType_Top     = (0),  //上部
    FWArrowType_Left    = (1),  //左侧
    FWArrowType_Right   = (2),  //右侧
    FWArrowType_Bottom  = (3),  //底部
};

//交叉的角度
typedef NS_ENUM(NSUInteger, FWCrossAngleType)
{
    FWCrossAngleType_Zero       = (0),
    FWCrossAngleType_PI_PER_4   = (1),
};

//线的格式回调
typedef struct __lineDashData__
{
    CGFloat phase;
    CGFloat *lengths;
    size_t count;
} lineDashData;

typedef lineDashData (^drawLineDashBlock)();

@interface FWGraphics : NSObject

/*
 @brief:在指定的图形上下文中绘制一个实心的园
 @param context:绘制图形的上下文
 @param radius:绘制半径
 @param center:绘制中心点
 @param fillColor:填充颜色
 @param borderColor:边框颜色
 @param borderWidth:边框的宽度
 */
+ (void)drawCircleWithContext:(CGContextRef)context
                       radius:(CGFloat)radius
                       center:(CGPoint)center
                    fillColor:(CGColorRef)fillColor
                  borderColor:(CGColorRef)borderColor
                  borderWidth:(CGFloat)borderWidth;


/*
 @brief:在指定的图形上下文绘制一个带圆角的背景色
 @param context:绘制图形的上下文
 @param rect:绘制的区域
 @param radius:圆角
 @param fillColor:填充颜色
 @param fragment:卡片的绘制方式
 */
+ (void)drawRectWithContext:(CGContextRef)context
                       rect:(CGRect)rect
                     radius:(CGFloat)radius
                  fillColor:(CGColorRef)fillColor
                   fragment:(FWCornerFragment)fragment;

/*
 @brief:在指定的图形上下文绘制一个卡片背景色
 @param context:绘制图形的上下文
 @param radius:圆角
 @param rect:绘制的区域
 @param fragment:卡片的绘制方式
 @param fillColor:填充颜色
 @param borderColor:边框颜色
 @param borderWidth:边框的宽度
 @param lineType:线的类型.nil为实线,否则传入dash的格式
 */
+ (void)drawCardWithContext:(CGContextRef)context
                     radius:(CGFloat)radius
                       rect:(CGRect)rect
                   fragment:(FWCardFragment)fragment
                  fillColor:(CGColorRef)fillColor
                borderColor:(CGColorRef)borderColor
                borderWidth:(CGFloat)borderWidth
                   lineType:(drawLineDashBlock)lineType;


/*
 @brief:指定上下文填充一个矩形区域
 @param context:图形上下文
 @param rect:需要填充的矩形区域
 @param fillColor:填充的颜色
 */
+ (void)drawBackgroundWithContext:(CGContextRef)context
                             rect:(CGRect)rect
                        fillColor:(CGColorRef)fillColor;


/*
 @bireif:绘制一个带箭头的区域
 @param context:图形上下文
 @param rect:绘制图形的矩形区域
 @param arrowType:箭头的方向
 @param arrowTopPoint:箭头的顶点坐标
 @param arrowSize:箭头的宽度和高度的size
 @param fillColor:填充的颜色
 @param borderColor:边线的颜色
 @param borderWidth:边线的宽度
 @param radius:边线的矩形圆角
 */

+ (void)drawArrowWithContext:(CGContextRef)context
                        rect:(CGRect)rect
                   arrowType:(FWArrowType)arrowType
               arrowTopPoint:(CGPoint)arrowTopPoint
                   arrowSize:(CGSize)arrowSize
                   fillColor:(CGColorRef)fillColor
                 borderColor:(CGColorRef)borderColor
                 borderWidth:(CGFloat)borderWidth
                      radius:(CGFloat)radius;

/*
 @brief:绘制一个圆，内部有交叉线
 @param context:绘制图形的上下文
 @param rect:绘制的矩形区域
 @param radius:圆的半径
 @param fillColor:填充色
 @param borderColor:边线色
 @param borderWidth:边线宽度、交叉线宽度
 @param crossColor:交叉线色
 @param offset:在直径方向减少的值
 @param crossType:交叉方式、目前只有垂直、45度两种
 */
+ (void)drawCricleAndCrossXWithContext:(CGContextRef)context
                                  rect:(CGRect)rect
                                radius:(CGFloat)radius
                             fillColor:(CGColorRef)fillColor
                           borderColor:(CGColorRef)borderColor
                           borderWidth:(CGFloat)borderWidth
                            crossColor:(CGColorRef)crossColor
                                offset:(CGFloat)offset
                             crossType:(FWCrossAngleType)crossType;


/*
 @brief:以矩形中间为圆点,以最小矩形宽度的二分之一为半径。根据角度绘制交叉的双线
 @param context:绘制图形的上下文
 @param crossColor:绘制交叉线的颜色
 @param crossWidth:交叉线的宽度
 @param angle1:第一条线从0算起的角度
 @param angel2:第二条线从0算起的角度
 */
+ (void)drawCrossXWithContext:(CGContextRef)context
                         rect:(CGRect)rect
                   crossColor:(CGColorRef)crossColor
                   crossWidth:(CGFloat)crossWidth
                       angle1:(CGFloat)angle1
                       angle2:(CGFloat)angle2;

/*
 @brief:提取gif动画中的所有图片
 @param fileName:gif动画中的所有图片
 */
+ (NSArray *)imagesWithGIFFileName:(NSString *)fileName;

@end

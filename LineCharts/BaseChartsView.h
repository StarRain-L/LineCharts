//
//  BaseChartsView.h
//  LineCharts
//
//  Created by jr on 16/12/26.
//  Copyright © 2016年 jr. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreFoundation/CFBase.h>

@class BaseChartsView;

@protocol TouchBaseChartsViewGetValueDelagte <NSObject>

- (void)touchGetValue:(NSArray *)values;

@end

//画表基础页面
@interface BaseChartsView : UIView

@property (nonatomic, strong)NSArray   *xLableArray;              //横坐标的数
@property (nonatomic, strong)NSArray   *yLableArray;              //横坐标的数
@property (nonatomic, strong)NSArray   *dataArray;                //二维数组,放置每条线的值
@property (nonatomic, strong)NSArray   *lineColors;               //每条线的颜色
@property (nonatomic, strong)NSMutableArray   *pointArray;        //数值点的坐标
@property (nonatomic, strong)NSArray   *lineExplainArray;              //每条线的解释

@property (nonatomic, assign) CGFloat maxXValue;
@property (nonatomic, assign) CGFloat maxYValue;
/// X、Y分区数量
@property (nonatomic, assign) NSInteger xSectionNum;
@property (nonatomic, assign) NSInteger ySectionNum;
/// X、Y轴默认间隔
@property (nonatomic, assign) CGFloat xDistance;
@property (nonatomic, assign) CGFloat yDistance;
@property (nonatomic, assign) CGFloat marKWidth;
/// X、Y轴描述字体颜色
@property (nonatomic, strong) UIColor *xValueTextColor;
@property (nonatomic, strong) UIColor *yValueTextColor;
/// X、Y轴描述字体大小
@property (nonatomic, assign) CGFloat xValueFont;
@property (nonatomic, assign) CGFloat yValueFont;

/// 是否需要动画
@property (nonatomic, assign) BOOL animation;
/// 动画执行时间
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign)id<TouchBaseChartsViewGetValueDelagte> delegate;

// 坐标转换
- (CGFloat)getFrameX:(CGFloat)x;
- (CGFloat)getFrameY:(CGFloat)y;

@end

//根据数值画线
@interface HMBasicLayer : CAShapeLayer

/// 标示
@property (nonatomic, assign) NSInteger tag;
/// layer位置
@property (nonatomic, assign) NSInteger currenTIndex;
/// 所占百分比
@property (nonatomic, assign) CGFloat percent;
/// 显示text
@property (nonatomic, strong) NSString *text;
/// info
@property (nonatomic, strong) id userInfo;

/// Add Animation Method
- (void)addAnimationForKeypath:(NSString *)keyPath fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration delegate:(id)delegate;

@end
//记录数据点得坐标
@interface ValuePoint : NSObject

@property (nonatomic, assign)CGFloat  x;

@property (nonatomic, assign) CGFloat y;

@end


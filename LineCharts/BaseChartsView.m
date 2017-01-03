//
//  BaseChartsView.m
//  LineCharts
//
//  Created by jr on 16/12/26.
//  Copyright © 2016年 jr. All rights reserved.
//

#import "BaseChartsView.h"
#define FONT(x) [UIFont systemFontOfSize:x]
//#define MARGIN_TOP 50               // 统计图的顶部间隔
#define MARGIN_BETWEEN_X_POINT 50   // X轴的坐标点的间距
#define Y_SECTION 5                 // 纵坐标轴的区间数

static int ylableWidth = 50;        //y坐标的lable宽度
static int xlableHeight = 15;       //x坐标的lable高度
static int yDistanceNum = 1000.00;   //Y坐标增长值
static int marginX = 15;             //左右两边间距
static int marginY = 10;             //上下两边间距
static int starX = 0;                //X左边开始画线处
//static int starY = 0;                //Y左边开始画线处
static int chartWidth= 0;            //表的宽度
static int chartHeight= 0;            //表的高度
@interface BaseChartsView ()
@property (nonatomic, assign)CGContextRef currentPoint;
@property (nonatomic, strong)UILabel    *horizontalLine;              //触摸时横线
@property (nonatomic, strong)UILabel    *verticaLine;              //触摸时竖线
@end
@implementation BaseChartsView

- (void)drawRect:(CGRect)rect{
    
    CGContextRef lineContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(lineContext, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(lineContext, [UIColor brownColor].CGColor);
    CGContextSetLineCap(lineContext, kCGLineCapButt);
    CGContextSetLineJoin(lineContext, kCGLineJoinBevel);
    CGContextSetLineWidth(lineContext, 0.5f);
    self.xDistance = (self.frame.size.width-marginX*2-ylableWidth-15)/(self.xSectionNum-1);
    self.yDistance = (self.frame.size.height-marginY*2-xlableHeight-20)/(self.ySectionNum-1);
    chartWidth = self.xDistance*(self.xSectionNum-1);
    chartHeight = self.yDistance * (self.ySectionNum-1);
    CGFloat maxWidth = chartWidth  +50+15;
    CGFloat pointX = (self.frame.size.width - maxWidth)/2;
    /**
     * 折线图
     */
    // add xValue
    for (NSInteger i = 0; i < self.xSectionNum; i++) {
        NSString *xValue = self.xLableArray[i];
        UILabel *xLabel = [self addXValue:xValue frame:CGRectMake(pointX+50, 0, self.xDistance, xlableHeight)];
        xLabel.center = CGPointMake(pointX+50 + i * self.xDistance, marginY + 15 + self.yDistance * (self.ySectionNum-1));
//        xLabel.backgroundColor = [UIColor redColor];
        [self addSubview:xLabel];
    }
    // add yValue
    for (NSInteger i = 0; i < self.ySectionNum; i ++) {
        NSString *yValue = self.yLableArray[i];
        UILabel *yLabel = [self addYValue:yValue frame:CGRectMake(pointX, marginY + (self.ySectionNum - i-1) * self.yDistance,50, 20)];
        CGPoint center = yLabel.center;
        center = CGPointMake(center.x, marginY + (self.ySectionNum - i-1) * self.yDistance);
        yLabel.center = center;
        [self addSubview:yLabel];
    }
    pointX += 50;
    starX = pointX;
    // 绘制横线
    for (NSInteger i = 0; i < self.ySectionNum; i ++) {
        CGPoint startPoint = CGPointMake(pointX, marginY + i * self.yDistance);
        CGPoint endPoint = CGPointMake(pointX + self.xDistance * (self.xSectionNum-1), marginY + i * self.yDistance);
        [self horizontalAddLineStartPoint:startPoint endPoint:endPoint context:lineContext];
    }
    
    // 绘制竖线
    for (NSInteger i = 0; i < 2; i ++) {
        CGPoint startPoint = CGPointMake(pointX + i * self.xDistance * (self.xSectionNum-1 ), marginY);
        CGPoint endPoint = CGPointMake(pointX + i * self.xDistance * (self.xSectionNum-1 ), marginY + self.yDistance * (self.ySectionNum-1));
        [self verticalAddLineStartPoint:startPoint endPoint:endPoint context:lineContext];
    }
    
    [self addXSectionMark:lineContext startX:pointX];
    CGContextStrokePath(lineContext);
    
    CGFloat bottomViewX = starX;
    for (int i= 0; i < self.lineExplainArray.count; i++) {
        
        UIView *bottomView = [self bottomLineExplain:CGRectMake(bottomViewX, marginY +10 + self.yDistance * (self.ySectionNum-1)+xlableHeight, 0, 15) squareClolor:self.lineColors[i] explainStr:self.lineExplainArray[i]];
        [self addSubview:bottomView];
        
        bottomViewX = CGRectGetMaxX(bottomView.frame)+10;
    }
    
}

/**
 * 绘制坐标及分割线
 */
- (void)horizontalAddLineStartPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint
                            context:(CGContextRef)context {
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
}

- (void)verticalAddLineStartPoint:(CGPoint)startPoint
                         endPoint:(CGPoint)endPoint
                          context:(CGContextRef)context {
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
}

- (void)addXSectionMark:(CGContextRef)context startX:(CGFloat)startX{
    for (NSInteger i = 1; i < self.xSectionNum-1; i ++) {
//        CGContextMoveToPoint(context, startX + i * self.xDistance, MARGIN_TOP + self.ySectionNum * self.yDistance - self.marKWidth);
        CGContextMoveToPoint(context, startX + i * self.xDistance, marginY );
        CGContextAddLineToPoint(context, startX + i * self.xDistance, marginY + (self.ySectionNum-1) * self.yDistance);
    }
}

/**
 * x、y 坐标轴 label 添加
 */
- (UILabel *)addXValue:(NSString *)xValue frame:(CGRect)frame {
    UILabel *xLabel = [[UILabel alloc] initWithFrame:frame];
    xLabel.text = xValue;
    xLabel.textAlignment = NSTextAlignmentCenter;
    xLabel.backgroundColor = [UIColor clearColor];
    xLabel.font = FONT(self.xValueFont);
    xLabel.textColor = self.xValueTextColor;
    return xLabel;
}

- (UILabel *)addYValue:(NSString *)yValue frame:(CGRect)frame {
    UILabel *yLabel = [[UILabel alloc] initWithFrame:frame];
    yLabel.text = yValue;
    yLabel.textAlignment = NSTextAlignmentCenter;
    yLabel.backgroundColor = [UIColor clearColor];
    yLabel.font = FONT(self.yValueFont);
    yLabel.textColor = self.yValueTextColor;
    return yLabel;
}

// Value Convert To Frame
- (CGFloat)getFrameX:(CGFloat)x {
    CGFloat resultX = (starX + self.xDistance * x);
    return  resultX;
}

- (CGFloat)getFrameY:(CGFloat)y {
    ;
    CGFloat resultY = (marginY + self.yDistance * self.ySectionNum-self.yDistance / yDistanceNum *y) ;
    return resultY;
}

// Get Default Value
- (UIColor *)xValueTextColor {
    return _xValueTextColor ? _xValueTextColor : [UIColor whiteColor];
}

- (UIColor *)yValueTextColor {
    return _yValueTextColor ? _yValueTextColor : [UIColor whiteColor];
}

- (CGFloat)xValueFont {
    return (_xValueFont != 0) ? _xValueFont : 9;
}

- (CGFloat)yValueFont {
    return (_yValueFont != 0) ? _yValueFont : 9;
}

- (NSInteger)xSectionNum {
    
    return (_xSectionNum != 0) ? _xSectionNum : 4;
}

- (NSInteger)ySectionNum {
    return (_ySectionNum != 0) ? _ySectionNum : 5;
}

- (CGFloat)xDistance {
    return (_xDistance != 0) ? _xDistance : 35;
}

- (CGFloat)yDistance {
    return (_yDistance != 0) ? _yDistance : 30;
}

- (CGFloat)marKWidth {
    return (_marKWidth != 0) ? _marKWidth : 2;
}

- (CGFloat)duration {
    return (_duration != 0) ? _duration : 2;
}
- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}
//当有一个或多个手指触摸事件在当前视图或window窗体中响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    [self touchLine:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    [self touchLine:point];
}

- (void)touchLine:(CGPoint)point{
    int x = point.x;
    int y = point.y;
    if (self.pointArray.count > 0 && x > (starX-20) && x < (starX+_xDistance*(_xSectionNum-1)+20)&& y > (marginY-20) && y < (marginY+_yDistance*(_ySectionNum-1)+20)) {
        //    NSLog(@"touch (x, y) is (%d, %d)", x, y);
        ValuePoint *point;
        int pointNum = (x-starX)/_xDistance;
        //触摸点-
        if ((x-pointNum*_xDistance-starX)>_xDistance/2) {
            pointNum +=1 ;
        }
        point = self.pointArray[0][pointNum];
        if (self.pointArray.count == 1) {
            if (!self.horizontalLine) {
                self.horizontalLine = [[UILabel alloc]init];
                self.horizontalLine .backgroundColor = [UIColor greenColor];
                [self addSubview:self.horizontalLine ];
            }
            //设置x线的隐藏显示
            if (point.y == self.horizontalLine.frame.origin.y) {
                self.horizontalLine.hidden = YES;
                self.horizontalLine.frame = CGRectMake(0,0,0.5, chartHeight);
            } else {
                self.horizontalLine.hidden = NO;
                self.horizontalLine.frame = CGRectMake(starX, point.y,chartWidth, 0.5);
            }

        }
        
        if (!self.verticaLine) {
            self.verticaLine = [[UILabel alloc]init];
            self.verticaLine .backgroundColor = [UIColor greenColor];
            [self addSubview:self.verticaLine ];
        }
        //设置y线的隐藏显示
        if (point.x == self.verticaLine.frame.origin.x) {
            self.verticaLine.hidden = YES;
            self.verticaLine.frame = CGRectMake(0,marginY,0.5, chartHeight);
        } else {
            self.verticaLine.hidden = NO;
            self.verticaLine.frame = CGRectMake(point.x,marginY,0.5, chartHeight);
        }
        
        if ([self.delegate respondsToSelector:@selector(touchGetValue:)]) {
            NSMutableArray *touchValue = [[NSMutableArray alloc]initWithCapacity:1];
            for (int i = 0; i < self.dataArray.count; i++) {
                NSArray *lineData = self.dataArray[i];
                [touchValue addObject:lineData[pointNum]];
            }
            [self.delegate touchGetValue:touchValue];
        }
      
    }
   
}

//底部线条注释

- (UIView *)bottomLineExplain:(CGRect)frame squareClolor:(UIColor *)color explainStr:(NSString *)explain{
    CGFloat viewheight = frame.size.height;
    UIView *view = [[UIView alloc]initWithFrame:frame];
    //方框
    UIView *square = [[UIView alloc]initWithFrame:CGRectMake(0, (viewheight-5)/2, 5, 5)];
    square.backgroundColor = color;
    [view addSubview:square];
    //文字
    UILabel *explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(square.frame)+5, 0, 5, frame.size.height)];
    explainLabel.text = explain;
    explainLabel.font = [UIFont fontWithName:@"Arial" size:8];
    explainLabel.textColor = [UIColor whiteColor];
    CGSize constraintSize = CGSizeMake(0, MAXFLOAT);
    CGSize labelSize =[explainLabel.text boundingRectWithSize:constraintSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:8]}
                                                      context:nil].size;
    explainLabel.frame = CGRectMake(explainLabel.frame.origin.x,(viewheight-labelSize.height)/2 , labelSize.width, labelSize.height);
    [view addSubview:explainLabel];
    
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, CGRectGetMaxX(explainLabel.frame), view.frame.size.height);
    
    return view;
}

@end

@implementation HMBasicLayer

- (void)addAnimationForKeypath:(NSString *)keyPath
                     fromValue:(CGFloat)fromValue
                       toValue:(CGFloat)toValue
                      duration:(CGFloat)duration
                      delegate:(id)delegate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    animation.delegate = delegate;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [self addAnimation:animation forKey:keyPath];
}

- (NSString *)text {
    if (_text) { return _text; } else { return @""; }
}

@end

@implementation ValuePoint


@end
/*
 //绘线
 //- (void)drawRect:(CGRect)rect {
 //
 //    CGContextRef context = UIGraphicsGetCurrentContext();
 //    CGContextSetLineCap(context, kCGLineCapRound);
 //    CGContextSetLineWidth(context, 3);  //线宽
 //    CGContextSetAllowsAntialiasing(context, true);
 //    CGContextSetRGBStrokeColor(context, 70.0 / 255.0, 241.0 / 255.0, 241.0 / 255.0, 1.0);  //线的颜色
 //    CGContextBeginPath(context);
 //
 //    CGContextMoveToPoint(context, 0, 0);  //起点坐标
 //    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);   //终点坐标
 //
 //    CGContextStrokePath(context);
 //}
 */

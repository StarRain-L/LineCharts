//
//  LineChartsView.m
//  LineCharts
//
//  Created by jr on 16/12/26.
//  Copyright © 2016年 jr. All rights reserved.
//

#import "LineChartsView.h"

@interface LineChartsView ()
@property (nonatomic, assign)CGContextRef currentPoint;

@end
@implementation LineChartsView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    for (int i = 0; i<self.dataArray.count; i++) {
         [self drawRectLine:self.dataArray[i] lineColor:self.lineColors[i]];
    }
}

- (void)drawRectLine:(NSArray *)dataArray lineColor:(UIColor *)linecolor{
    HMBasicLayer *linelayer = [HMBasicLayer layer];
    linelayer.lineCap = kCALineCapRound;
    linelayer.lineJoin = kCALineJoinBevel;
    linelayer.lineWidth = 0.5f;
    linelayer.strokeColor = linecolor.CGColor; //self.lineColor.CGColor;
    linelayer.fillColor = [UIColor clearColor].CGColor;
    
    CGMutablePathRef linepath = CGPathCreateMutable();
    for (NSInteger i = 0; i < dataArray.count-1; i++) {
        CGPathMoveToPoint(linepath, &CGAffineTransformIdentity,[self getFrameX:i] , [self getFrameY:[dataArray[i] floatValue]]);
        CGPathAddLineToPoint(linepath, &CGAffineTransformIdentity, [self getFrameX:i+1], [self getFrameY:[dataArray[i+1] floatValue]]);
    }
    linelayer.path = linepath;
    [self.layer addSublayer:linelayer];
    CGPathRelease(linepath);
    
    if (self.animation) {
        [linelayer addAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:self.duration delegate:self];
    } else {
        [self setPoint:dataArray pointColor:linecolor];
    }
    

}


- (void)setPoint:(NSArray *)dataArray pointColor:(UIColor *)pointcolor{
    NSMutableArray *currentPoint = [[NSMutableArray alloc]initWithCapacity:5];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        ValuePoint *point = [[ValuePoint alloc]init];
        point.x = [self getFrameX:i];
        point.y =[self getFrameY:[dataArray[i] floatValue]];
        [currentPoint addObject:point];
        UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 6, 6)];
        pointView.center = CGPointMake([self getFrameX:i], [self getFrameY:[dataArray[i] floatValue]]);
        pointView.backgroundColor = pointcolor;
        pointView.layer.cornerRadius = 3.0;
        pointView.layer.masksToBounds = YES;
        pointView.alpha = 0.0;
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1];
         pointView.alpha = 1;
        [UIView commitAnimations];
        [self addSubview:pointView];
    }
    [self.pointArray addObject:currentPoint];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"--------动画结束-----");
    for (int i = 0; i<self.dataArray.count; i++) {
//        [self drawRectLine:self.dataArray[i] lineColor:self.lineColors[i]];
        [self setPoint:self.dataArray[i] pointColor:self.lineColors[i]];
    }

  
}




@end

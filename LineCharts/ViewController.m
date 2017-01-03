//
//  ViewController.m
//  LineCharts
//
//  Created by jr on 16/12/26.
//  Copyright © 2016年 jr. All rights reserved.
//

#import "ViewController.h"
#import "LineChartsView.h"
//获取设备的物理信息
#define screenHeight    [UIScreen mainScreen].bounds.size.height
#define screenWidth     [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<TouchBaseChartsViewGetValueDelagte>
@property (nonatomic, strong)UILabel    *touchValue;              //触摸显示当前值
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a
    _touchValue = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, screenWidth-20, 30)];
    _touchValue.textColor = [UIColor blackColor];
    _touchValue.textAlignment = 1;
    [self.view addSubview:_touchValue];
    LineChartsView *line = [[LineChartsView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_touchValue.frame)+10, screenWidth-20, 300)];
    line.delegate = self;
    line.xLableArray = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    line.yLableArray = @[@"1000.00",@"2000.00",@"3000.00",@"4000.00",@"5000.00",@"6000.00",@"7000.00"];
    line.xSectionNum =line.xLableArray.count;
    line.ySectionNum = line.yLableArray.count;
    line.dataArray = @[@[@"1300.0",@"2300.0",@"4300.0",@"3300.0",@"5000.0",@"2000.0",@"4000.0"],
                       @[@"4300.0",@"1300.0",@"2300.0",@"5300.0",@"2000.0",@"3000.0",@"5000.0"]];
    line.lineColors = @[[UIColor redColor],[UIColor blueColor]];
    line.lineExplainArray = @[@"第一条线哦哦哦",@"第二条"];
    line.animation = YES;
    [self.view addSubview:line];
}

- (void)touchGetValue:(NSArray *)value{
    NSLog(@"------%@--------",value);
    NSString *currentValue = @"";
    for (int i = 0; i < value.count; i++) {
        currentValue = [currentValue stringByAppendingString:[NSString stringWithFormat:@"%@  ",value[i]]];
    }
    _touchValue.text = currentValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

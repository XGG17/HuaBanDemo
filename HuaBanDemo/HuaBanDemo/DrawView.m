//
//  DrawView.m
//  HuaBanDemo
//
//  Created by TGT-Tech on 16/5/27.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        [self initGes];
    }
    return self;
}
- (NSMutableArray *)pathArr {
    if (_pathArr == nil) {
        _pathArr = [NSMutableArray array];
    }
    return _pathArr;
}
// 自定义初始化方法
- (void)initGes {
    
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    // 获取开始的触摸点
    CGPoint startP = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        // 创建贝塞尔路径
        _path = [[DrawPath alloc]init];
        _path.lineWidth = _lineWidth;
        _path.pathColor = _pathColor;
        // 不能在手指抬起时将路径添加到数组，因为在遍历数组画线时路径还没有被添加到数组里面
        [_pathArr addObject:_path];
        // 设置起点
        [_path moveToPoint:startP];
    }
    // 连线
    [_path addLineToPoint:startP];
    // 重绘，调用drawRect方法
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    // 把所有路径画出来
    for (DrawPath *path in self.pathArr) {
        
        if ([path isKindOfClass:[UIImage class]]) {
            // 画图
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        }else {
            // 画线
            [path.pathColor set];
            [path stroke];
        }
    }
}

- (void)clear {
    // 清除
    [self.pathArr removeAllObjects];
    [self setNeedsDisplay];
}

- (void)undo {
    // 撤销
    [self.pathArr removeLastObject];
    [self setNeedsDisplay];
}
@end

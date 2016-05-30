//
//  DrawView.h
//  HuaBanDemo
//
//  Created by TGT-Tech on 16/5/27.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawPath.h"

@interface DrawView : UIView

/** 线宽 */
@property (nonatomic, assign) NSInteger lineWidth;
/** 颜色 */
@property(nonatomic, strong) UIColor *pathColor;
/** 图片 */
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) DrawPath *path;
/** 保存所有路径的数组 */
@property(nonatomic, strong) NSMutableArray *pathArr;

- (void)clear;  // 清除
- (void)undo;   // 撤销

@end

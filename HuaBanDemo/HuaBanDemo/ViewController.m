//
//  ViewController.m
//  HuaBanDemo
//
//  Created by TGT-Tech on 16/5/27.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"

@interface ViewController ()
{
    DrawView *_drawView;
    UIButton *_clearButton;
    UIButton *_undoButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, self.view.bounds.size.height - 400)];
    _drawView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _drawView.pathColor = [UIColor blackColor];
    _drawView.lineWidth = 5;
    _drawView.alpha = 0;
    [self.view addSubview:_drawView];
    
    _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearButton.frame = CGRectMake(130, 110, 50, 30);
    _clearButton.backgroundColor = [UIColor orangeColor];
    [_clearButton setTitle:@"清除" forState:UIControlStateNormal];
    _clearButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_clearButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _clearButton.hidden = YES;
    [self.view addSubview:_clearButton];
    
    _undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _undoButton.frame = CGRectMake(210, 110, 50, 30);
    _undoButton.backgroundColor = [UIColor orangeColor];
    [_undoButton setTitle:@"撤回" forState:UIControlStateNormal];
    _undoButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_undoButton addTarget:self action:@selector(undoAction:) forControlEvents:UIControlEventTouchUpInside];
    _undoButton.hidden = YES;
    [self.view addSubview:_undoButton];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(50, 110, 50, 30);
    saveBtn.backgroundColor = [UIColor orangeColor];
    [saveBtn setTitle:@"签名" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)undoAction:(UIButton *)sender {

    [_drawView undo];
}
- (void)btnAction:(UIButton *)sender {

    [_drawView clear];
}
- (void)saveAction:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"签名"]) {
        
        // 签名
        [UIView animateWithDuration:0.15 animations:^{
            _drawView.alpha = 1;
        } completion:^(BOOL finished) {
            _clearButton.hidden = NO;
            _undoButton.hidden = NO;
        }];
        [sender setTitle:@"保存" forState:UIControlStateNormal];
    } else {
    
        // 保存
        if (_drawView.pathArr.count == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"画板为空，将不保存在相册中" delegate: nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [self save];
        [sender setTitle:@"签名" forState:UIControlStateNormal];
    }
}

- (void)save {

    [UIView animateWithDuration:0.15 animations:^{
       
        //保存当前画板上的内容
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
        //获取位图上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //把控件上的图层渲染到上下文
        [_drawView.layer renderInContext:ctx];
        //获取上下文中的图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            _drawView.alpha = 0;
            [_drawView clear];
        } completion:^(BOOL finished) {
            _clearButton.hidden = YES;
            _undoButton.hidden = YES;
        }];
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"保存成功");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate: nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

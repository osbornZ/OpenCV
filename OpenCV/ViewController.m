//
//  ViewController.m
//  OpenCV
//
//  Created by osborn on 2018/9/14.
//  Copyright © 2018年 osborn. All rights reserved.
//

#import "ViewController.h"
#import "OsbornOpenCV.h"

#define  KTestImageName @"ycl.jpg"


typedef NS_ENUM(NSInteger,ProcessType) {
    ProcessType_Gray,
    ProcessType_Blur,
    ProcessType_Mask,
    ProcessType_Style,
    ProcessType_Color,
};



@interface ViewController ()
{
    UIAlertController *alertVC;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) UIImage *originalImage;
@property (nonatomic,strong) UIImage *effectImage;


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.originalImage = [UIImage imageNamed:KTestImageName];
    self.effectImage   = _originalImage;

    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCompare:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:longPressGesture];
    
}

- (IBAction)actionSheet:(id)sender {
    [self configActionSheet];
}

- (void)configActionSheet {
    alertVC = [UIAlertController alertControllerWithTitle:nil message:@"process list" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *grayAction = [UIAlertAction actionWithTitle:@"Gray" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionOpenCVProcess:ProcessType_Gray];
    }];
    UIAlertAction *blurAction = [UIAlertAction actionWithTitle:@"Blur" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionOpenCVProcess:ProcessType_Blur];
    }];
    UIAlertAction *maskAction = [UIAlertAction actionWithTitle:@"Mask" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionOpenCVProcess:ProcessType_Mask];
    }];
    UIAlertAction *styleAction = [UIAlertAction actionWithTitle:@"Style" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionOpenCVProcess:ProcessType_Style];
    }];
    UIAlertAction *colorAction = [UIAlertAction actionWithTitle:@"Color" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionOpenCVProcess:ProcessType_Color];
    }];

    [alertVC addAction:grayAction];
    [alertVC addAction:blurAction];
    [alertVC addAction:maskAction];
    [alertVC addAction:styleAction];
    [alertVC addAction:colorAction];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alertVC animated:YES completion:^{
    }];
}


- (void)actionOpenCVProcess:(ProcessType)processType {
    UIImage *image  = self.originalImage;

    switch (processType) {
        case ProcessType_Gray:
            self.effectImage  = [OsbornOpenCV gray:image];
            break;
        case ProcessType_Blur:
            self.effectImage  = [OsbornOpenCV lowpassImage:image];
            break;
        case ProcessType_Mask:
            self.effectImage  = [OsbornOpenCV maskImage:image];
            break;
        case ProcessType_Style:
            self.effectImage  = [OsbornOpenCV changeStyle:image];
            break;
        case ProcessType_Color:
            self.effectImage  = [OsbornOpenCV changeColor:image];
            break;
        default:
            break;
    }
    [self.imageView setImage: self.effectImage];
    
}



#pragma mark -- UIGestureRecognizer

- (void)longPressCompare:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded ) {
        [self.imageView setImage: _effectImage];
    }else {
        UIImage *image = [UIImage imageNamed:KTestImageName];
        [self.imageView setImage: image];
    }
}





@end

//
//  ViewController.m
//  二维码生成保存
//
//  Created by nst on 2018/7/17.
//  Copyright © 2018年 nst. All rights reserved.
//

#import "ViewController.h"
#import "LCQRCodeUtil.h"
#import "QRCodeVC.h"
@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QRCodeVCDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *fieldResult;
@property (strong,nonatomic) UIImage * QRImage;
@property(nonatomic,strong) UIImagePickerController *imagepicker;
@end

@implementation ViewController
- (IBAction)saveQRCode:(id)sender {
    if (self.QRImage) {
        [self saveImage:self.QRImage];
    }
}

//保存二维码
-(void)saveImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (IBAction)creatQRCode:(id)sender {
    self.QRImage =  [LCQRCodeUtil createQRimageString:self.fieldResult.text sizeWidth:100 fillColor:[UIColor greenColor]];
    self.imageView.image = self.QRImage;
}


- (IBAction)searchQRCode:(id)sender {
      self.fieldResult.text =  [LCQRCodeUtil readQRCodeFromImage:self.QRImage];
    
}



- (IBAction)searchQRcode2:(id)sender {
    QRCodeVC *qrcodeVC =   [QRCodeVC new];
    qrcodeVC.delegate = self;
    [self presentViewController:qrcodeVC animated:YES completion:nil];
}
-(void)setQRCode:(NSString *)code{
    self.fieldResult.text = code;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)loadPhpto:(id)sender {
    [self headClick];
}

#pragma mark -头像UIImageview的点击事件-
- (void)headClick {
    NSUInteger sourceType = 0;
    // 判断系统是否支持相机
    self.imagepicker  = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagepicker.delegate = self; //设置代理
        self.imagepicker.allowsEditing = YES;
        self.imagepicker.sourceType = sourceType; //图片来源
    }else{
        return;
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"图片选择"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //拍照
                                                             self.imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                             [self presentViewController:self.imagepicker animated:YES completion:nil];
                                                         }];
    UIAlertAction* ptotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //相册
                                                            self.imagepicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                                            [self presentViewController:self.imagepicker animated:YES completion:nil];
                                                            
                                                        }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             return;
                                                         }];
    [alert addAction:cameraAction];
    [alert addAction:ptotoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    self.imageView.image = image;  //给UIimageView赋值已经选择的相片
    
    
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

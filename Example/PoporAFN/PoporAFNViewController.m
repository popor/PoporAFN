//
//  PoporAFNViewController.m
//  PoporAFN
//
//  Created by wangkq on 07/09/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporAFNViewController.h"

#import <PoporAFN/PoporAFN.h>
#import <PoporNetRecord/PoporNetRecord.h>

@interface PoporAFNViewController ()

@property (nonatomic, strong) PoporAFN * pAFN;

@end

@implementation PoporAFNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
   
    [self addViews];
}

- (void)config {
    // 设置head示例
    PoporAFNConfig * config = [PoporAFNConfig share];
    config.afnSMBlock = ^AFHTTPSessionManager *{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        // request
        manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        
        // response
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain",  @"image/jpeg", @"image/png", @"application/octet-stream", @"multipart/form-data", nil];
        
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        manager.requestSerializer.timeoutInterval = 10.0f;
        
        return manager;
    };
    
    config.afnHeaderBlock = ^NSDictionary * _Nullable{
        NSDictionary * header = @{
            @"appType":@"1",
            @"version":@"1.0",
            //@"Authorization":@"bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjUsInBob25lIjoiMTg3KioqKjAwMzAiLCJ1c2VyX25hbWUiOiJhMGM2MzBiNzA1MmRhZmUzZjgyYmExNTIyZWYxZmZlNyIsInNjb3BlIjpbImFsbCJdLCJuYW1lIjoieE5vVXY4TWQiLCJleHAiOjE2MDkxMjUzMjAsImp0aSI6IkVDemhLTmk1Y0hxUm5HYXhCak9HWWVGN1VYZz0iLCJjbGllbnRfaWQiOiJ1c2VyT2F1dGgyIn0.QNXlGlOwfHf25snXJlHGmi3lhYNyUUPf8U2YT3G24NC9bEVeVOuwBrJx1h6_LDfsC_IxiYCcRnZmfOmLMf8vvxtgTF7jY4C3bUpiOWYho1lW7kyGZY6R4XrtAhSYWFx6egEdmx6pfPpCqWVhbsbKy83x_hC6G7_x9Z2729g6VrnCJS8pQJZhPqi4gnb262Vfi9XAXg-5xMf1gRzRn1vftFuffna8oB3N48kBTR2eE31O8ubCGfyfKH9-RG15j1MCb6hjQBt-V76nYd6qjSd6fzgrhHsyPi7dOcS1is0uVa8uok5AfqMXumIG9KgUfhyf_Gu8YRHM-CX0j4FvJXOskQ",
            
        };
        return header;
    };
    
    // 设置 监测回调结果 block 方法
    
    {
        // extra
        __block NSString * pnrExtraForwadUrl;
        config.recordBlock = ^(NSString *url, NSString *title, PoporMethod method, id head, id parameters, id response) {
            //[PoporNetRecord addUrl:url title:title method:method head:head parameter:parameters response:response];
            [PoporNetRecord addUrl:url title:title method:@"GET" head:head parameter:parameters response:response];
        };
        
        [PoporNetRecord share].blockExtraRecord = ^(PnrEntity * _Nonnull pnrEntity) {
            PnrExtraEntity * e = [PnrExtraEntity share];
            if (e.forward) {
                pnrExtraForwadUrl = [NSString stringWithFormat:@"%@/recordAdd", e.selectUrlPort];
                if (![pnrExtraForwadUrl isEqualToString:pnrEntity.url]) {
                    //[NetService title:@"" url:pnrExtraForwadUrl method:PoporMethodPost parameters:entity.desDic success:nil failure:nil];
                    
                    //[PoporAFNTool title:@"" url:pnrExtraForwadUrl method:PoporMethodPost parameters:pnrEntity.parameterValue afnManager:nil header:pnrEntity.headValue progress:nil success:nil failure:nil];
                    [PoporAFNTool title:@"" url:pnrExtraForwadUrl method:PoporMethodPost parameters:pnrEntity.parameterValue afnManager:nil header:pnrEntity.headValue postData:nil progress:nil success:nil failure:nil];
                }
            }
        };
    }
}

- (void)addViews {
    NSArray * titleArray = @[@"文本get", @"文本post", @"文本formdata", @"image formdata"];
    for (NSInteger i = 0; i<titleArray.count; i++) {
        UIButton * oneBT = ({
            UIButton * oneBT = [UIButton buttonWithType:UIButtonTypeCustom];
            oneBT.frame =  CGRectMake(100, 100, 80, 44);
            [oneBT setTitle:titleArray[i] forState:UIControlStateNormal];
            [oneBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [oneBT setBackgroundColor:[UIColor brownColor]];
            
            // oneBT.titleLabel.font = [UIFont systemFontOfSize:17];
            oneBT.layer.cornerRadius = 5;
            oneBT.layer.borderColor = [UIColor lightGrayColor].CGColor;
            oneBT.layer.borderWidth = 1;
            oneBT.clipsToBounds = YES;
            
            [self.view addSubview:oneBT];
            
            oneBT;
        });
        oneBT.frame = CGRectMake(30, 64 + 50*i, 160, 40);
        switch (i) {
            case 0:{
                
                break;
            }
            case 1:{
                [self postText];
                break;
            }
            case 2:{
                [oneBT addTarget:self action:@selector(postTextFormData) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case 3:{
                [oneBT addTarget:self action:@selector(postImageData) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            default:
                break;
        }
    }
}

- (void)postText {
    //[PoporAFNTool title:@"测试" url:@"https://www.baidu.com" method:PoporMethodPostJson parameters:nil afnManager:nil header:nil success:nil failure:nil];
    // http://192.168.7.111:9000/record
    [PoporAFNTool title:@"测试" url:@"http://192.168.7.111:9000/test_a" method:PoporMethodPost parameters:nil success:^(NSString * _Nonnull url, NSData * _Nullable data, NSDictionary * _Nonnull _Nullabledic) {
        NSString * str  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"0 请求结果: %@", str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"0 请求error: %@", error.localizedDescription);
    }];
}

- (void)postTextFormData {
    NSString * url;
    //url = @"http://192.168.7.105:8881/api/userService/verification/getCode";
    url = @"http://192.168.7.249:18881/api/userService/verification/getCode";
    
    [PoporAFNTool title:@"测试" url:url method:PoporMethodFormData parameters:@{@"phone":@"13311110000", @"clientId":@"unknown", @"adf":@(1121)} success:^(NSString * _Nonnull url, NSData * _Nullable data, NSDictionary * _Nonnull dic) {
        if (data) {
            NSString * str  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"1 请求结果: %@", str);
        } else if(dic) {
            NSLog(@"1 请求结果: %@", [dic description]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"1 请求error: %@", error.localizedDescription);
    }];
}

- (void)postImageData {
    [self postImageData1];
}

- (void)postImageData1 {
    NSString * url;
    NSDictionary * paras;
    
    //url = @"http://192.168.7.105:8881/api/userService/verification/getCode";
    url = @"http://192.168.7.249:18881/api/userService/editAvatar";
    //url = @"http://192.168.7.105:8881/api/userService/editAvatar";
    
    UIImage * image = [UIImage imageNamed:@"testImage.jpg"];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
    
    paras = @{@"file":imageData};
    //paras = nil;
    
    [PoporAFNTool title:@"测试图片" url:url method:PoporMethodPost parameters:paras afnManager:nil header:nil postData:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSString * _Nonnull url, NSData * _Nullable data, NSDictionary * _Nonnull dic) {
        if (data) {
            NSString * str  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"1 请求结果: %@", str);
        } else if(dic) {
            NSLog(@"1 请求结果: %@", [dic description]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"1 请求error: %@", error.localizedDescription);
    }];
}

//- (void)postImageData2 {
//
//    UIImage * image = [UIImage imageNamed:@"testImage.jpg"];
//    NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 20;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
//
//    //NSDictionary *dict = @{@"token":access_toke};
//
//    NSDictionary * header = @{@"Authorization":@"bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjMsInBob25lIjoiMTg3KioqKjAwMzAiLCJ1c2VyX25hbWUiOiJhMGM2MzBiNzA1MmRhZmUzZjgyYmExNTIyZWYxZmZlNyIsInNjb3BlIjpbImFsbCJdLCJuYW1lIjoibHpPOXZZT3kiLCJleHAiOjE2MDkxMTkyMzQsImp0aSI6Im1JN2UxdGZaaXc4VncxNVJ0Q0xsR3pSV08wND0iLCJjbGllbnRfaWQiOiJ1c2VyT2F1dGgyIn0.UBe41by2C_OVpMpEjHiTJH9gUo9geT0a_FwhtOnwhtDK4Csxxxh9xHtx3I2NrznB01Afd3dYkZ6co4FvU5eiRHTh89D2dkA3Ig-cJaphw5FA3mobXO5IPoUNSBFgPWaPExQhWvmfOCMi5tZdRotzPmjoguvBdln1IAy1iXHWLoXfZeW0iUR_5VCKV63EQSEfMNyf44Fp2aeXrRItVvYwKEsS4u2JWQcXHDhHQkPPGbRdvY5VVVDUQmGtOvN01jbhhMb3WENMRA3S3P2tALZsypHfUwIcO4ZL9cN8FI5T8wo8vDb_HaSxVs6xKg53FK7kmi6ZC65iOudSuvpWqHS2qA"};
//
//
//    header = @{@"Authorization":@"bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjUsInBob25lIjoiMTg3KioqKjAwMzAiLCJ1c2VyX25hbWUiOiJhMGM2MzBiNzA1MmRhZmUzZjgyYmExNTIyZWYxZmZlNyIsInNjb3BlIjpbImFsbCJdLCJuYW1lIjoieE5vVXY4TWQiLCJleHAiOjE2MDkxMjUzMjAsImp0aSI6IkVDemhLTmk1Y0hxUm5HYXhCak9HWWVGN1VYZz0iLCJjbGllbnRfaWQiOiJ1c2VyT2F1dGgyIn0.QNXlGlOwfHf25snXJlHGmi3lhYNyUUPf8U2YT3G24NC9bEVeVOuwBrJx1h6_LDfsC_IxiYCcRnZmfOmLMf8vvxtgTF7jY4C3bUpiOWYho1lW7kyGZY6R4XrtAhSYWFx6egEdmx6pfPpCqWVhbsbKy83x_hC6G7_x9Z2729g6VrnCJS8pQJZhPqi4gnb262Vfi9XAXg-5xMf1gRzRn1vftFuffna8oB3N48kBTR2eE31O8ubCGfyfKH9-RG15j1MCb6hjQBt-V76nYd6qjSd6fzgrhHsyPi7dOcS1is0uVa8uok5AfqMXumIG9KgUfhyf_Gu8YRHM-CX0j4FvJXOskQ"};
//    NSString *url = @"http://192.168.7.249:18881/api/userService/editAvatar";
//    url = @"http://192.168.7.105:8881/api/userService/editAvatar";
//    [manager POST:url parameters:nil headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"file" fileName:@"1.jpg" mimeType:@"image/jpg"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"上传成功%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"上传失败");
//    }];
//
//}
// 测试form-data请求
- (void)testForm_data_request {
    NSString * urlString = @"http://192.168.7.105:8881/api/userService/verification/getCode";
    urlString = @"http://192.168.7.249:18881/api/userService/verification/getCode";
    //url = @"http://www.baidu.com";
    
    NSDictionary * parameters = @{@"phone":@"18717930030", @"clientId":@"unknown"};
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    [request addValue:@"1" forHTTPHeaderField:@"appType"];
    [request addValue:@"1" forHTTPHeaderField:@"version"];
    
    [request addValue:@"zh-Hans-US;q=1, en;q=0.9" forHTTPHeaderField:@"Accept-Language"];
    //[request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"PoporAFN_Example/1.0 (iPhone; iOS 13.5; Scale/2.00)" forHTTPHeaderField:@"User-Agent"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"response:%@, responseObject:%@", response, responseObject);
            NSString * message = responseObject[@"message"];
            //NSString * str  = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"message: %@", message);
        }
    }];
    
    [uploadTask resume];
}

// 使用自定义的AFNManage
- (void)customeAFNManage {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer     = [AFJSONRequestSerializer serializer];
    manager.responseSerializer    = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]; // 不然不支持www.baidu.com.
    
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"system"];
    
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    //[PoporAFNTool title:@"测试json" url:@"https://api.androidhive.info/volley/person_object.json" method:PoporMethodPost parameters:@{@"test":@"test1"} afnManager:nil header:nil success:nil failure:nil];
}

- (void)downloadAction {
    NSURL * URL = [NSURL URLWithString:@"https://stdl.qq.com/stdl/MACQQBrowser/kantu/img/gallery/1.png"];
    URL = [NSURL URLWithString:@"https://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.2.dmg"];
    self.pAFN = PoporAFNTool;
    [self.pAFN downloadUrl:URL destination:nil progress:^(float progress, NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度: %f", progress);
    } finish:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        NSLog(@"filePath: %@", filePath.absoluteString);
    }];
}

@end

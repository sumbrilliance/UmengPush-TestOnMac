//
//  ViewController.m
//  APS-MacTest
//
//  Created by sumbrill on 16/8/10.
//  Copyright © 2016年 sumbrill. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>

#define APP_KEY @""

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]) {
       self.textFld.stringValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appkey"]) {
        self.appkeyTxtFl.stringValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"appkey"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"secretKey"]) {
        self.appSecret.stringValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretKey"];
    }
    self.alertTxtFld.stringValue = @"您的车辆发生了某些报警";
    self.soundTxtFld.stringValue = @"engine.m4a";
    // Do any additional setup after loading the view.
}
/*
 {
 "appkey":"xx",          // 必填 应用唯一标识
 "timestamp":"xx",       // 必填 时间戳，10位或者13位均可，时间戳有效期为10分钟
 "type":"xx",            // 必填 消息发送类型,其值可以为:
 unicast-单播
 listcast-列播(要求不超过500个device_token)
 filecast-文件播
 (多个device_token可通过文件形式批量发送）
 broadcast-广播
 groupcast-组播
 (按照filter条件筛选特定用户群, 具体请参照filter参数)
 customizedcast(通过开发者自有的alias进行推送),
 包括以下两种case:
 - alias: 对单个或者多个alias进行推送
 - file_id: 将alias存放到文件后，根据file_id来推送
 "device_tokens":"xx",   // 可选 设备唯一表示
 当type=unicast时,必填, 表示指定的单个设备
 当type=listcast时,必填,要求不超过500个,
 多个device_token以英文逗号间隔
 "alias_type": "xx"      // 可选 当type=customizedcast时，必填，alias的类型,
 alias_type可由开发者自定义,开发者在SDK中
 调用setAlias(alias, alias_type)时所设置的alias_type
 "alias":"xx",           // 可选 当type=customizedcast时, 开发者填写自己的alias。
 要求不超过50个alias,多个alias以英文逗号间隔。
 在SDK中调用setAlias(alias, alias_type)时所设置的alias
 "file_id":"xx",         // 可选 当type=filecast时，file内容为多条device_token,
 device_token以回车符分隔
 当type=customizedcast时，file内容为多条alias，
 alias以回车符分隔，注意同一个文件内的alias所对应
 的alias_type必须和接口参数alias_type一致。
 注意，使用文件播前需要先调用文件上传接口获取file_id,
 具体请参照"2.4文件上传接口"
 "filter":{},            // 可选 终端用户筛选条件,如用户标签、地域、应用版本以及渠道等,
 具体请参考附录G。
 "payload":              // 必填 消息内容(iOS最大为2012B), 包含参数说明如下(JSON格式):
 {
 "aps":                 // 必填 严格按照APNs定义来填写
 {
 "alert": "xx"          // 必填
 "badge": xx,           // 可选
 "sound": "xx",         // 可选
 "content-available":xx // 可选
 "category": "xx",      // 可选, 注意: ios8才支持该字段。
 },
 "key1":"value1",       // 可选 用户自定义内容, "d","p"为友盟保留字段，
 key不可以是"d","p"
 "key2":"value2",
 ...
 },
 "policy":                // 可选 发送策略
 {
 "start_time":"xx",   // 可选 定时发送时间，默认为立即发送。发送时间不能小于当前时间。
 格式: "YYYY-MM-DD HH:mm:ss"。
 注意, start_time只对任务生效。
 "expire_time":"xx",  // 可选 消息过期时间,其值不可小于发送时间,
 默认为3天后过期。格式同start_time
 "max_send_num": xx   // 可选 发送限速，每秒发送的最大条数。
 开发者发送的消息如果有请求自己服务器的资源，可以考虑此参数。
 },
 "production_mode":"true/false" // 可选 正式/测试模式。测试模式下，广播/组播只会将消息发给测试设备。
 测试设备需要到web上添加。
 iOS: 测试模式对应APNs的开发环境(sandbox),
 正式模式对应APNs的正式环境(prod),
 正式、测试设备完全隔离。
 "description": "xx"      // 可选 发送消息描述，建议填写。
 "thirdparty_id": "xx"    // 可选 开发者自定义消息标识ID, 开发者可以为同一批发送的消息提供
 同一个thirdparty_id, 便于后期合并统计数据。
 }
 
 /6292f4e00317f924454b46f1b6933e301412003c65206358afb34b94e087ccdd
 
 */

- (NSDictionary *)constructContent {
    NSString *deviceID = self.textFld.stringValue;
    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] setObject:self.appkeyTxtFl.stringValue forKey:@"appkey"];
    [[NSUserDefaults standardUserDefaults] setObject:self.appSecret.stringValue forKey:@"secretKey"];
    
    double timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.f",timestamp];
    
    NSDictionary *content = @{@"appkey":self.appkeyTxtFl.stringValue,
                              @"timestamp":timeStamp,
                              @"type":@"unicast",
                              @"device_tokens":deviceID,
                              @"payload":
                                  @{
                                      @"aps":
                                          @{
                                              @"alert": self.alertTxtFld.stringValue,
                                              //                                          "badge": xx,
                                              //                                          @"msg":@"您的车辆发生低电压告警",
                                              @"content-available":@1,
                                              @"sound": self.soundTxtFld.stringValue,
                                              },
                                      @"msg":@"您的车辆发生震动告警"
                                      },
                             @"production_mode":@"true"
                              };
    
    return content;
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
  
    
    NSDictionary *content = [self constructContent];
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:content
                                                       options:0
                                                         error:nil];
    NSString *str = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    NSLog(@"str = %@",str);
    // Create a POST request with our JSON as a request body.
  
    
    NSString *MD5String = [self MD5HexDigest:[NSString stringWithFormat:@"POSThttp://msg.umeng.com/api/send%@%@",str,self.appSecret.stringValue]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://msg.umeng.com/api/send?sign=%@",MD5String]];
    
    NSLog(@"JSONData = %@",content);
    NSLog(@"MD5 = %@",MD5String);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = JSONData;
    
    // Create a task.
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data,
                                                                                     NSURLResponse *response,
                                                                                     NSError *error)
                                  {
                                      
                                      
                                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                      
                                      NSLog(@"返回 == %@",dic);
                                      if (!error)
                                      {
                                          NSLog(@"Status code: %li", (long)((NSHTTPURLResponse *)response).statusCode);
                                      }
                                      else
                                      {
                                          NSLog(@"Error: %@", error.localizedDescription);
                                      }
                                  }];
    
    // Start the task.
    [task resume];
    
}
- (IBAction)btnAction:(NSButton *)sender {
    
//    NSDictionary *content = [self constructContent];
//    
//    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:content
//                                                       options:0
//                                                         error:nil];
//    NSString *str = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
//    NSLog(@"str = %@",str);
    [self setRepresentedObject:nil];
}


- (NSString *)MD5HexDigest:(NSString *)inputString {
    
    NSMutableString *hash = [NSMutableString string];
    
    const char *original_str = [inputString UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
    
    
}

#pragma mark - delegate

- (void)controlTextDidChange:(NSNotification *)obj {
    
        NSDictionary *content = [self constructContent];
    
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:content
                                                           options:0
                                                             error:nil];
        NSString *str = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    self.finalTextView.string = [NSString stringWithFormat:@"最终内容：%@",str];
}


@end

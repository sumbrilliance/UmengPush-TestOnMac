//
//  ViewController.h
//  APS-MacTest
//
//  Created by sumbrill on 16/8/10.
//  Copyright © 2016年 sumbrill. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *textFld;
@property (unsafe_unretained) IBOutlet NSTextView *finalTextView;
@property (weak) IBOutlet NSTextField *appkeyTxtFl;
@property (weak) IBOutlet NSTextField *appSecret;
@property (weak) IBOutlet NSTextField *alertTxtFld;
@property (weak) IBOutlet NSTextField *soundTxtFld;
@property (weak) IBOutlet NSTextField *keyTxtFld;
@property (weak) IBOutlet NSTextField *valueTxtFld;


@end


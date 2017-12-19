//
//  SourceEditorCommand.m
//  AutoImport
//
//  Created by hhfa on 2017/12/19.
//  Copyright © 2017年 hhfa. All rights reserved.
//

#import "SourceEditorCommand.h"

#import "SortHeader.h"
#import "xTextModifier.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler {
    [xTextModifier select:invocation
                  handler:self.handlers[invocation.commandIdentifier]
     handlerForAllContent:self.handlers[@"AutoImport"]];
    completionHandler(nil);
}

- (NSDictionary *)handlers {
    static NSDictionary *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = @{
                      @"com.hhfa008.AutoImport":
                          ^NSString *(NSString *text) { return formatSelection(text); },
                      @"AutoImport":
                          ^NSArray *(NSArray *lines,NSString* text) { return formatSelectionLines(lines,text); }
                      };
    });
    return _instance;
}
@end

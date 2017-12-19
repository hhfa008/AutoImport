//
//  xTextModifier.m
//  xTextHandler
//
//  Created by cyan on 16/6/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "xTextModifier.h"
#import "xTextMatcher.h"
#import <AppKit/AppKit.h>

@implementation xTextModifier

+ (void)select:(XCSourceEditorCommandInvocation *)invocation
       handler:(xTextHandlerBlock)handler
handlerForAllContent:(xLineHandlerBlock)allContentHandler {
    
    
    NSString* selectedText = nil;
    // No selections but the file has lines.
    if (![self isNothingSelected:invocation] && invocation.buffer.lines) {
        xTextMatchResult *match = [xTextMatcher match:invocation.buffer.selections.firstObject invocation:invocation];
        selectedText = [match.text substringWithRange:match.range];
    }

    NSArray *formattedContentLines = allContentHandler(invocation.buffer.lines, selectedText);
    [invocation.buffer.lines removeAllObjects];
    [invocation.buffer.lines addObjectsFromArray: formattedContentLines];

}

+ (BOOL)isNothingSelected:(XCSourceEditorCommandInvocation *)invocation {
    
    if (!invocation.buffer.selections.count) {
        return YES;
    }
    
    if (invocation.buffer.selections.count == 1) {
        XCSourceTextRange *selectionRange = [invocation.buffer.selections firstObject];
        if(selectionRange.start.column == selectionRange.end.column &&
           selectionRange.start.line == selectionRange.end.line) {
            return YES;
        }
    }

    return NO;
}

@end

//
//  CCTextTools.h
//  Maxmoo
//
//  Created by 程超 on 2024/7/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCTextTools : NSObject

+ (NSString *)getVisibleStringWithWidth:(CGFloat)width font:(UIFont *)font str:(NSString*)str;

@end

NS_ASSUME_NONNULL_END

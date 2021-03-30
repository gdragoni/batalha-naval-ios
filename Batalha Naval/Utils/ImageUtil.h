//
//  ImageUtil.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/19/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ImageUtil : NSObject

+(UIImageView *)imageViewWithImageNamed:(NSString *)img size:(CGSize)size isHorizontal:(BOOL)horizontal;
+(UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

@end

//
//  ImageUtil.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/19/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

+(UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+(UIImageView *)imageViewWithImageNamed:(NSString *)img size:(CGSize)size isHorizontal:(BOOL)horizontal{
    UIImage *image = [UIImage imageNamed:img];
    image = [self imageWithImage:image convertToSize:size];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    if(!horizontal) imageView.transform = CGAffineTransformMakeRotation(1.5708);
    return imageView;
}
    
@end

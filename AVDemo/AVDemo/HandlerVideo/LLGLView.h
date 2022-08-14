//
//  LLGLView.h
//  AVDemo
//
//  Created by jinbang.li on 2022/8/14.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#define FBO_HEIGHT 640
#define FBO_WIDTH 480
NS_ASSUME_NONNULL_BEGIN

@interface LLGLView : UIView
@property(readonly) GLuint positionRenderTexture;

// OpenGL drawing
- (BOOL)createFramebuffers;
- (void)destroyFramebuffer;
- (void)setDisplayFramebuffer;
- (void)setPositionThresholdFramebuffer;
- (BOOL)presentFramebuffer;
@end

NS_ASSUME_NONNULL_END

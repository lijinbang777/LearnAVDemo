//
//  LLGLView.m
//  AVDemo
//
//  Created by jinbang.li on 2022/8/14.
//

#import "LLGLView.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
@interface LLGLView (){
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth, backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    GLuint positionRenderTexture;
    GLuint positionRenderbuffer, positionFramebuffer;
}
@end
@implementation LLGLView

+ (Class) layerClass
{
    return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // Do OpenGL Core Animation layer setup
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        // Set scaling to account for Retina display
//        if ([self respondsToSelector:@selector(setContentScaleFactor:)])
//        {
//            self.contentScaleFactor = [[UIScreen mainScreen] scale];
//        }
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffers])
        {
            
            return nil;
        }
        
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"---%@ dealloc",[self class]);
}


#pragma mark OpenGL drawing

- (BOOL)createFramebuffers
{
    glEnable(GL_TEXTURE_2D);
    glDisable(GL_DEPTH_TEST);

    // Onscreen framebuffer object
    glGenFramebuffers(1, &viewFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    
    glGenRenderbuffers(1, &viewRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    NSLog(@"Backing width: %d, height: %d", backingWidth, backingHeight);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"Failure with framebuffer generation");
        return NO;
    }
    
    // Offscreen position framebuffer object
    glGenFramebuffers(1, &positionFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, positionFramebuffer);

    glGenRenderbuffers(1, &positionRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, positionRenderbuffer);
    
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, FBO_WIDTH, FBO_HEIGHT);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, positionRenderbuffer);
    

    // Offscreen position framebuffer texture target
    glGenTextures(1, &positionRenderTexture);
    glBindTexture(GL_TEXTURE_2D, positionRenderTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glHint(GL_GENERATE_MIPMAP_HINT, GL_NICEST);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    //GL_NEAREST_MIPMAP_NEAREST

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, FBO_WIDTH, FBO_HEIGHT, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, FBO_WIDTH, FBO_HEIGHT, 0, GL_RGBA, GL_FLOAT, 0);

    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, positionRenderTexture, 0);
//    NSLog(@"GL error15: %d", glGetError());
    
    
    
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"Incomplete FBO: %d", status);
        exit(1);
    }
    
    
    
    return YES;
}

- (void)destroyFramebuffer;
{
    if (viewFramebuffer)
    {
        glDeleteFramebuffers(1, &viewFramebuffer);
        viewFramebuffer = 0;
    }
    
    if (viewRenderbuffer)
    {
        glDeleteRenderbuffers(1, &viewRenderbuffer);
        viewRenderbuffer = 0;
    }
}

- (void)setDisplayFramebuffer;
{
    if (context)
    {
//        [EAGLContext setCurrentContext:context];
        
        if (!viewFramebuffer)
        {
            [self createFramebuffers];
        }
        
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        
        glViewport(0, 0, backingWidth, backingHeight);
    }
}

- (void)setPositionThresholdFramebuffer;
{
    if (context)
    {
        //        [EAGLContext setCurrentContext:context];
        
        if (!positionFramebuffer)
        {
            [self createFramebuffers];
        }
        
        glBindFramebuffer(GL_FRAMEBUFFER, positionFramebuffer);
        
        glViewport(0, 0, FBO_WIDTH, FBO_HEIGHT);
    }
}

- (BOOL)presentFramebuffer;
{
    BOOL success = FALSE;
    
    if (context)
    {
  //      [EAGLContext setCurrentContext:context];
        
        glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
        
        success = [context presentRenderbuffer:GL_RENDERBUFFER];
    }
    
    return success;
}

@end

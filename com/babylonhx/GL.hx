package com.babylonhx;

/**
 * ...
 * @author Krtolica Vujadin
 */

// GL defines

#if snow

    typedef GL                  = snow.render.opengl.GL;
    typedef GLActiveInfo        = snow.render.opengl.GL.GLActiveInfo;
    typedef GLBuffer            = snow.render.opengl.GL.GLBuffer;
    typedef GLContextAttributes = snow.render.opengl.GL.GLContextAttributes;
    typedef GLFramebuffer       = snow.render.opengl.GL.GLFramebuffer;
    typedef GLProgram           = snow.render.opengl.GL.GLProgram;
    typedef GLRenderbuffer      = snow.render.opengl.GL.GLRenderbuffer;
    typedef GLShader            = snow.render.opengl.GL.GLShader;
    typedef GLTexture           = snow.render.opengl.GL.GLTexture;
    typedef GLUniformLocation   = snow.render.opengl.GL.GLUniformLocation;

#elseif lime

    typedef GL                  = lime.graphics.opengl.GL;
    typedef GLActiveInfo        = lime.graphics.opengl.GL.GLActiveInfo;
    typedef GLBuffer            = lime.graphics.opengl.GL.GLBuffer;
    typedef GLContextAttributes = lime.graphics.opengl.GL.GLContextAttributes;
    typedef GLFramebuffer       = lime.graphics.opengl.GL.GLFramebuffer;
    typedef GLProgram           = lime.graphics.opengl.GL.GLProgram;
    typedef GLRenderbuffer      = lime.graphics.opengl.GL.GLRenderbuffer;
    typedef GLShader            = lime.graphics.opengl.GL.GLShader;
    typedef GLTexture           = lime.graphics.opengl.GL.GLTexture;
    typedef GLUniformLocation   = lime.graphics.opengl.GL.GLUniformLocation;

#elseif kha

#end 



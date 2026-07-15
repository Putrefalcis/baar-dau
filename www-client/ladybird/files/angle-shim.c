/* angle-shim: satisfies Ladybird's ANGLE-only GL entry points on top of
 * Mesa's GLES3 core exports. Robust* variants forward to the core call,
 * reporting length = bufSize (Ladybird's callers pass length = NULL and
 * size their buffers from the pname, so this is sufficient).
 * Statically linked into LibWeb/Compositor via the angle.pc shim. */
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#include <GLES2/gl2ext_angle.h>
#include <GLES3/gl32.h>

GL_APICALL void GL_APIENTRY glGetActiveUniformBlockivRobustANGLE(GLuint program, GLuint uniformBlockIndex, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *params)
{
    glGetActiveUniformBlockiv(program, uniformBlockIndex, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetBooleanvRobustANGLE(GLenum pname, GLsizei bufSize, GLsizei *length, GLboolean *data)
{
    glGetBooleanv(pname, data);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetBufferParameterivRobustANGLE(GLenum target, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *params)
{
    glGetBufferParameteriv(target, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetFloatvRobustANGLE(GLenum pname, GLsizei bufSize, GLsizei *length, GLfloat *data)
{
    glGetFloatv(pname, data);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetInteger64vRobustANGLE(GLenum pname, GLsizei bufSize, GLsizei *length, GLint64 *data)
{
    glGetInteger64v(pname, data);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetIntegervRobustANGLE(GLenum pname, GLsizei bufSize, GLsizei *length, GLint *data)
{
    glGetIntegerv(pname, data);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetProgramivRobustANGLE(GLuint program, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *params)
{
    glGetProgramiv(program, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetQueryObjectuivRobustANGLE(GLuint id, GLenum pname, GLsizei bufSize, GLsizei *length, GLuint *params)
{
    glGetQueryObjectuiv(id, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetRenderbufferParameterivRobustANGLE(GLenum target, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *params)
{
    glGetRenderbufferParameteriv(target, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetShaderivRobustANGLE(GLuint shader, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *params)
{
    glGetShaderiv(shader, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetTexParameterfvRobustANGLE(GLenum target, GLenum pname, GLsizei bufSize, GLsizei *length, GLfloat *params)
{
    glGetTexParameterfv(target, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetTexParameterivRobustANGLE(GLenum target, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *params)
{
    glGetTexParameteriv(target, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetVertexAttribPointervRobustANGLE(GLuint index, GLenum pname, GLsizei bufSize, GLsizei *length, void **pointer)
{
    glGetVertexAttribPointerv(index, pname, pointer);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetVertexAttribfvRobustANGLE(GLuint index, GLenum pname, GLsizei bufSize, GLsizei *length, GLfloat *params)
{
    glGetVertexAttribfv(index, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetVertexAttribivRobustANGLE(GLuint index, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *params)
{
    glGetVertexAttribiv(index, pname, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glGetInternalformativRobustANGLE(GLenum target, GLenum internalformat, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *params)
{
    glGetInternalformativ(target, internalformat, pname, bufSize, params);
    if (length)
        *length = bufSize;
}

GL_APICALL void GL_APIENTRY glReadPixelsRobustANGLE(GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLsizei bufSize, GLsizei *length, GLsizei *columns, GLsizei *rows, void *pixels)
{
    glReadPixels(x, y, width, height, format, type, pixels);
    if (length)
        *length = bufSize;
    if (columns)
        *columns = width;
    if (rows)
        *rows = height;
}

GL_APICALL void GL_APIENTRY glTexImage2DRobustANGLE(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, GLsizei bufSize, const void *pixels)
{
    (void)bufSize;
    glTexImage2D(target, level, internalformat, width, height, border, format, type, pixels);
}

GL_APICALL void GL_APIENTRY glTexImage3DRobustANGLE(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLsizei bufSize, const void *pixels)
{
    (void)bufSize;
    glTexImage3D(target, level, internalformat, width, height, depth, border, format, type, pixels);
}

GL_APICALL void GL_APIENTRY glTexSubImage2DRobustANGLE(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLsizei bufSize, const void *pixels)
{
    (void)bufSize;
    glTexSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels);
}

GL_APICALL void GL_APIENTRY glTexSubImage3DRobustANGLE(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLsizei bufSize, const void *pixels)
{
    (void)bufSize;
    glTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels);
}

GL_APICALL void GL_APIENTRY glCompressedTexImage2DRobustANGLE(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLsizei bufSize, const void *data)
{
    (void)bufSize;
    glCompressedTexImage2D(target, level, internalformat, width, height, border, imageSize, data);
}

GL_APICALL void GL_APIENTRY glCompressedTexImage3DRobustANGLE(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLsizei bufSize, const void *data)
{
    (void)bufSize;
    glCompressedTexImage3D(target, level, internalformat, width, height, depth, border, imageSize, data);
}

GL_APICALL void GL_APIENTRY glCompressedTexSubImage2DRobustANGLE(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLsizei bufSize, const void *data)
{
    (void)bufSize;
    glCompressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, imageSize, data);
}

GL_APICALL void GL_APIENTRY glCompressedTexSubImage3DRobustANGLE(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLsizei bufSize, const void *data)
{
    (void)bufSize;
    glCompressedTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, data);
}

GL_APICALL void GL_APIENTRY glRequestExtensionANGLE(const GLchar *name)
{
    (void)name;
}

GL_APICALL void GL_APIENTRY glBindVertexArrayOES(GLuint array)
{
    glBindVertexArray(array);
}

GL_APICALL void GL_APIENTRY glDeleteVertexArraysOES(GLsizei n, const GLuint *arrays)
{
    glDeleteVertexArrays(n, arrays);
}

GL_APICALL void GL_APIENTRY glGenVertexArraysOES(GLsizei n, GLuint *arrays)
{
    glGenVertexArrays(n, arrays);
}

GL_APICALL void GL_APIENTRY glDrawArraysInstancedANGLE(GLenum mode, GLint first, GLsizei count, GLsizei primcount)
{
    glDrawArraysInstanced(mode, first, count, primcount);
}

GL_APICALL void GL_APIENTRY glDrawElementsInstancedANGLE(GLenum mode, GLsizei count, GLenum type, const void *indices, GLsizei primcount)
{
    glDrawElementsInstanced(mode, count, type, indices, primcount);
}

GL_APICALL void GL_APIENTRY glVertexAttribDivisorANGLE(GLuint index, GLuint divisor)
{
    glVertexAttribDivisor(index, divisor);
}

GL_APICALL void GL_APIENTRY glDrawBuffersEXT(GLsizei n, const GLenum *bufs)
{
    glDrawBuffers(n, bufs);
}

GL_APICALL GLboolean GL_APIENTRY glIsVertexArrayOES(GLuint array)
{
    return glIsVertexArray(array);
}

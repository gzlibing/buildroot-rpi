#define EGL_EGLEXT_PROTOTYPES

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <nexus_platform.h>
#include <nexus_display.h>
#include <nexus_core_utils.h>
#include <default_nexus.h>

#include "refsw_session_simple_client.h"

/**
  * Print table of all available configurations.
  */
static
EGLConfig* PrintConfigs(EGLDisplay d)
{
    EGLConfig *configs;
    EGLint numConfigs, i;

    if (eglGetConfigs(d, 0L, 0, &numConfigs) != EGL_TRUE)
    {
       printf ("eglGetConfigs -> %x\n", eglGetError());
       exit (EXIT_FAILURE);
    }

    configs = malloc(sizeof(EGLConfig) *numConfigs);

    eglGetConfigs(d, configs, numConfigs, &numConfigs);

    printf("Configurations:\n");
    printf("     bf lv d st colorbuffer dp st   supported \n");
    printf("  id sz  l b ro  r  g  b  a th cl   surfaces  \n");
    printf("----------------------------------------------\n");
    for (i = 0; i < numConfigs; i++) {
       EGLint id, size, level;
       EGLint red, green, blue, alpha;
       EGLint depth, stencil;
       EGLint surfaces;
       EGLint doubleBuf = 1, stereo = 0;
       char surfString[100] = "";

       eglGetConfigAttrib(d, configs[i], EGL_CONFIG_ID, &id);
       eglGetConfigAttrib(d, configs[i], EGL_BUFFER_SIZE, &size);
       eglGetConfigAttrib(d, configs[i], EGL_LEVEL, &level);

       eglGetConfigAttrib(d, configs[i], EGL_RED_SIZE, &red);
       eglGetConfigAttrib(d, configs[i], EGL_GREEN_SIZE, &green);
       eglGetConfigAttrib(d, configs[i], EGL_BLUE_SIZE, &blue);
       eglGetConfigAttrib(d, configs[i], EGL_ALPHA_SIZE, &alpha);
       eglGetConfigAttrib(d, configs[i], EGL_DEPTH_SIZE, &depth);
       eglGetConfigAttrib(d, configs[i], EGL_STENCIL_SIZE, &stencil);
       eglGetConfigAttrib(d, configs[i], EGL_SURFACE_TYPE, &surfaces);

       if (surfaces & EGL_WINDOW_BIT)
          strcat(surfString, "win,");
       if (surfaces & EGL_PBUFFER_BIT)
          strcat(surfString, "pb,");
       if (surfaces & EGL_PIXMAP_BIT)
          strcat(surfString, "pix,");
       if (strlen(surfString) > 0)
          surfString[strlen(surfString) - 1] = 0;

       printf("0x%02x %2d %2d %c  %c %2d %2d %2d %2d %2d %2d %-12s\n",
              id, size, level,
              doubleBuf ? 'y' : '.',
              stereo ? 'y' : '.',
              red, green, blue, alpha,
              depth, stencil, surfString);
    }
//   free(configs);
return configs;
}

const char* SurfaceMessage (EGLSurface message)
{
     const char* result;

     switch ((unsigned int) message)
     {
     case (unsigned int) EGL_NO_SURFACE:  result = "EGL_NO_SURFACE"; break;
     case EGL_NOT_INITIALIZED:  result = "EGL_NOT_INITIALIZED"; break;
     case EGL_BAD_CONFIG:  result = "EGL_BAD_CONFIG"; break;
     case EGL_BAD_NATIVE_WINDOW:  result = "EGL_BAD_NATIVE_WINDOW"; break;
     case EGL_BAD_ATTRIBUTE:  result = "EGL_BAD_ATTRIBUTE"; break;
     case EGL_BAD_ALLOC:  result = "EGL_BAD_ALLOC"; break;
     case EGL_BAD_MATCH:  result = "EGL_BAD_MATCH"; break;
     default: result = 0L; break;
     }

     return (result);
}

int
main(int argc, char *argv[])
{
    static unsigned int gs_screen_wdt   = 0;
    static unsigned int gs_screen_hgt   = 0;

    static void *gs_native_window = 0;

    NXPL_NativeWindowInfo   win_info;
    NEXUS_ClientAuthenticationSettings authSettings;

    NEXUS_Error err;

    printf ("simple_client_init(\"xre\", &authSettings)\n");
    simple_client_init("xre", &authSettings);

    err = NEXUS_Platform_AuthenticatedJoin(&authSettings);
    printf("NEXUS_Platform_AuthenticatedJoin(&authSettings) : %d\n", 
NEXUS_Platform_AuthenticatedJoin(&authSettings));

    if (err)
    {
        exit(EXIT_FAILURE);
    }


NXPL_PlatformHandle nxpl_handle = 0;
NXPL_RegisterNexusDisplayPlatform (&nxpl_handle, EGL_DEFAULT_DISPLAY );


    gs_screen_wdt = 1280;
    gs_screen_hgt = 720;

    win_info.x = 0;
    win_info.y = 0;
    win_info.width = gs_screen_wdt;
    win_info.height = gs_screen_hgt;
  //  win_info.stretch = true;
    gs_native_window = NXPL_CreateNativeWindow(&win_info);

    printf ("NXPL_CreateNativeWindow(&win_info) : %p\n", gs_native_window);

    int maj, min;
    EGLContext ctx = EGL_NO_CONTEXT;
    EGLSurface pdestroyWindow = EGL_NO_SURFACE, pwindow;
    EGLConfig* configs;
    EGLBoolean b;

     if ( eglBindAPI(EGL_OPENGL_ES_API) != EGL_TRUE )
     {
        printf("failed to bind api %x\n", eglGetError());
        exit (EXIT_FAILURE);
     }

    EGLDisplay d = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    assert(d);

    if (!eglInitialize(d, &maj, &min))
    {
       printf("demo: eglInitialize failed\n");
       exit(1);
    }

    printf("EGL version = %d.%d\n", maj, min);
    printf("EGL_VENDOR = %s\n", eglQueryString(d, EGL_VENDOR));

    configs=PrintConfigs(d);

    printf("eglCreateWindowSurface : configs[0] %p\n", configs[0]);

     int i =0;
     for (i=0; i<=0x1c; ++i)
     {
        pwindow = eglCreateWindowSurface(d, configs[i], gs_native_window, 0L);

        const char* message = SurfaceMessage(pwindow);
        if (message != 0L)
        {
            printf("failed to create eglCreateWindowSurface for config[%x], reason %s\n", i, message);
        }
        else
        {
            ctx = eglCreateContext(d, configs[i], EGL_NO_CONTEXT, 0L);

            if (ctx == EGL_NO_CONTEXT)
            {
               printf("failed to create context\n");
            }
            else
            {
                b = eglMakeCurrent(d, pwindow, pwindow, ctx);
                if (!b)
                {
                   printf("make current failed, error %X\n", eglGetError());
                }
                else
                {
                    printf("created and made current eglCreateWindowSurface for config[%x]\n", i);
                }

                eglDestroyContext(d, ctx);
                // If we would destroy the window here, the next create will lead to a segmentation fault !!!
                // eglDestroySurface(d, pwindow);
                pdestroyWindow = pwindow;
             }
        }
    }

    if (pdestroyWindow != EGL_NO_SURFACE)
    {
        printf("Clear the created window\n");
        eglDestroySurface(d, pwindow);
    }

    free(configs);

    eglTerminate(d);

    printf("Exit the test app sucesfully\n");
    return 0;
}



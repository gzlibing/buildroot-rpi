/*
 * Exercise EGL API functions
 */

#define EGL_EGLEXT_PROTOTYPES

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "nexus_platform.h"
#include "nexus_display.h"
#include "nexus_core_utils.h"
#include "default_nexus.h"

#include "refsw_session_simple_client.h"

/**
 * Print table of all available configurations.
 */
static 
EGLConfig* PrintConfigs(EGLDisplay d)
{
   EGLConfig *configs;
   EGLint numConfigs, i;

   if (eglGetConfigs(d, NULL, 0, &numConfigs) != EGL_TRUE)
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

      printf("0x%02x %2d %2d %c  %c %2d %2d %2d %2d %2d %2d   %-12s\n",
             id, size, level,
             doubleBuf ? 'y' : '.',
             stereo ? 'y' : '.',
             red, green, blue, alpha,
             depth, stencil, surfString);
   }
//   free(configs);
return configs;
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
   printf("NEXUS_Platform_AuthenticatedJoin(&authSettings) : %d\n", NEXUS_Platform_AuthenticatedJoin(&authSettings));

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
   win_info.stretch = true;
   gs_native_window = NXPL_CreateNativeWindow(&win_info);

   printf ("NXPL_CreateNativeWindow(&win_info) : %d\n", gs_native_window);

   int maj, min;
   EGLContext ctx;
   EGLSurface pbuffer, pwindow;
   EGLConfig* configs;
   EGLBoolean b;
   const EGLint pbufAttribs[] = {
      EGL_WIDTH, 500,
      EGL_HEIGHT, 500,
      EGL_NONE
   };

   const EGLint pwinAttribs[] = {
      EGL_WIDTH, 500,
      EGL_HEIGHT, 500,
      EGL_NONE
   };

if ( eglBindAPI(EGL_OPENGL_ES_API) != EGL_TRUE ) {
   printf("failed to bind api %x\n", eglGetError());
   exit (EXIT_FAILURE);
}

   EGLDisplay d = eglGetDisplay(EGL_DEFAULT_DISPLAY);
   assert(d);

   if (!eglInitialize(d, &maj, &min)) {
      printf("demo: eglInitialize failed\n");
      exit(1);
   }

   printf("EGL version = %d.%d\n", maj, min);
   printf("EGL_VENDOR = %s\n", eglQueryString(d, EGL_VENDOR));


   configs=PrintConfigs(d);

   ctx = eglCreateContext(d, configs[0], EGL_NO_CONTEXT, NULL);
   if (ctx == EGL_NO_CONTEXT) {
      printf("failed to create context\n");
      return 0;
   }

printf("eglCreateWindowSurface : configs[0] %p\n", configs[0]);

/*
   pbuffer = eglCreatePbufferSurface(d, configs[0], pbufAttribs);
   if (pbuffer == EGL_NO_SURFACE) {
      printf("failed to create pbuffer\n");
      return 0;
   }
*/
int i =0;
for (i=0; i<=0x1c; ++i) {
   pbuffer = eglCreatePbufferSurface(d, configs[i], pbufAttribs);
//   pwindow = eglCreateWindowSurface(d, i, gs_native_window, pwinAttribs);
//   if (pwindow == EGL_NO_SURFACE) {
   if (pbuffer == EGL_NO_SURFACE) {
      printf("failed to create pwindow for config[%x]\n", i);
//      return 0;
   }
   else
   {
      printf("created pwindow for config[%x]\n", i);
//      eglDestroySurface(d, pwindow);
   eglDestroySurface(d, pbuffer);
   }
}

//   b = eglMakeCurrent(d, pbuffer, pbuffer, ctx);
   b = eglMakeCurrent(d, pwindow, pwindow, ctx);
   if (!b) {
      printf("make current failed\n");
      return 0;
   }

   b = eglMakeCurrent(d, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);

//   eglDestroySurface(d, pbuffer);
//   eglDestroySurface(d, pwindow);
   eglDestroyContext(d, ctx);

free(configs);

   eglTerminate(d);

   return 0;
}

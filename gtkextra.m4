# Configure paths for GtkSheet
# Owen Taylor     97-11-3
# Adrian Feiguin  01-04-03 

dnl AM_PATH_GTK_SHEET([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND [, MODULES]]]])
dnl Test for GTK_SHEET, and define GTK_SHEET_CFLAGS and GTK_SHEET_LIBS
dnl
AC_DEFUN(AM_PATH_GTK_SHEET,
[dnl 
dnl Get the cflags and libraries from the gtksheet-config script
dnl
AC_ARG_WITH(gtksheet-prefix,[  --with-gtksheet-prefix=PFX   Prefix where GTK_SHEET is installed (optional)],
            gtksheet_config_prefix="$withval", gtksheet_config_prefix="")
AC_ARG_WITH(gtksheet-exec-prefix,[  --with-gtksheet-exec-prefix=PFX Exec prefix where GTK_SHEET is installed (optional)],
            gtksheet_config_exec_prefix="$withval", gtksheet_config_exec_prefix="")
AC_ARG_ENABLE(gtksheettest, [  --disable-gtksheettest       Do not try to compile and run a test GTK_SHEET program],
		    , enable_gtksheettest=yes)

  for module in . $4
  do
      case "$module" in
         gthread) 
             gtksheet_config_args="$gtksheet_config_args gthread"
         ;;
      esac
  done

  if test x$gtksheet_config_exec_prefix != x ; then
     gtksheet_config_args="$gtksheet_config_args --exec-prefix=$gtksheet_config_exec_prefix"
     if test x${GTK_SHEET_CONFIG+set} != xset ; then
        GTK_SHEET_CONFIG=$gtksheet_config_exec_prefix/bin/gtksheet-config
     fi
  fi
  if test x$gtksheet_config_prefix != x ; then
     gtksheet_config_args="$gtksheet_config_args --prefix=$gtksheet_config_prefix"
     if test x${GTK_SHEET_CONFIG+set} != xset ; then
        GTK_SHEET_CONFIG=$gtksheet_config_prefix/bin/gtksheet-config
     fi
  fi

  AC_PATH_PROG(GTK_SHEET_CONFIG, gtksheet-config, no)
  min_gtksheet_version=ifelse([$1], ,0.99.13,$1)
  AC_MSG_CHECKING(for GTK_SHEET - version >= $min_gtksheet_version)
  no_gtksheet=""
  if test "$GTK_SHEET_CONFIG" = "no" ; then
    no_gtksheet=yes
  else
    GTK_SHEET_CFLAGS=`$GTK_SHEET_CONFIG $gtksheet_config_args --cflags`
    GTK_SHEET_LIBS=`$GTK_SHEET_CONFIG $gtksheet_config_args --libs`
    gtksheet_config_major_version=`$GTK_SHEET_CONFIG $gtksheet_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\1/'`
    gtksheet_config_minor_version=`$GTK_SHEET_CONFIG $gtksheet_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\2/'`
    gtksheet_config_micro_version=`$GTK_SHEET_CONFIG $gtksheet_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\3/'`
    if test "x$enable_gtksheettest" = "xyes" ; then
      ac_save_CFLAGS="$CFLAGS"
      ac_save_LIBS="$LIBS"
      CFLAGS="$CFLAGS $GTK_SHEET_CFLAGS"
      LIBS="$GTK_SHEET_LIBS $LIBS"
dnl
dnl Now check if the installed GTK_SHEET is sufficiently new. (Also sanity
dnl checks the results of gtksheet-config to some extent
dnl
      rm -f conf.gtksheettest
      AC_TRY_RUN([
#include <gtksheet/gtksheet.h>
#include <stdio.h>
#include <stdlib.h>

int 
main ()
{
  int major, minor, micro;
  char *tmp_version;

  system ("touch conf.gtksheettest");

  /* HP/UX 9 (%@#!) writes to sscanf strings */
  tmp_version = g_strdup("$min_gtksheet_version");
  if (sscanf(tmp_version, "%d.%d.%d", &major, &minor, &micro) != 3) {
     printf("%s, bad version string\n", "$min_gtksheet_version");
     exit(1);
   }

  if ((gtksheet_major_version != $gtksheet_config_major_version) ||
      (gtksheet_minor_version != $gtksheet_config_minor_version) ||
      (gtksheet_micro_version != $gtksheet_config_micro_version))
    {
      printf("\n*** 'gtksheet-config --version' returned %d.%d.%d, but GTK_SHEET (%d.%d.%d)\n", 
             $gtksheet_config_major_version, $gtksheet_config_minor_version, $gtksheet_config_micro_version,
             gtksheet_major_version, gtksheet_minor_version, gtksheet_micro_version);
      printf ("*** was found! If gtksheet-config was correct, then it is best\n");
      printf ("*** to remove the old version of GTK_SHEET. You may also be able to fix the error\n");
      printf("*** by modifying your LD_LIBRARY_PATH enviroment variable, or by editing\n");
      printf("*** /etc/ld.so.conf. Make sure you have run ldconfig if that is\n");
      printf("*** required on your system.\n");
      printf("*** If gtksheet-config was wrong, set the environment variable GTK_SHEET_CONFIG\n");
      printf("*** to point to the correct copy of gtksheet-config, and remove the file config.cache\n");
      printf("*** before re-running configure\n");
    } 
#if defined (GTK_SHEET_MAJOR_VERSION) && defined (GTK_SHEET_MINOR_VERSION) && defined (GTK_SHEET_MICRO_VERSION)
  else if ((gtksheet_major_version != GTK_SHEET_MAJOR_VERSION) ||
	   (gtksheet_minor_version != GTK_SHEET_MINOR_VERSION) ||
           (gtksheet_micro_version != GTK_SHEET_MICRO_VERSION))
    {
      printf("*** GTK_SHEET header files (version %d.%d.%d) do not match\n",
	     GTK_SHEET_MAJOR_VERSION, GTK_SHEET_MINOR_VERSION, GTK_SHEET_MICRO_VERSION);
      printf("*** library (version %d.%d.%d)\n",
	     gtksheet_major_version, gtksheet_minor_version, gtksheet_micro_version);
    }
#endif /* defined (GTK_SHEET_MAJOR_VERSION) ... */
  else
    {
      if ((gtksheet_major_version > major) ||
        ((gtksheet_major_version == major) && (gtksheet_minor_version > minor)) ||
        ((gtksheet_major_version == major) && (gtksheet_minor_version == minor) && (gtksheet_micro_version >= micro)))
      {
        return 0;
       }
     else
      {
        printf("\n*** An old version of GTK_SHEET (%d.%d.%d) was found.\n",
               gtksheet_major_version, gtksheet_minor_version, gtksheet_micro_version);
        printf("*** You need a version of GTK_SHEET newer than %d.%d.%d. The latest version of\n",
	       major, minor, micro);
        printf("*** GTK_SHEET is always available from GitHub\n");
        printf("***\n");
        printf("*** If you have already installed a sufficiently new version, this error\n");
        printf("*** probably means that the wrong copy of the gtksheet-config shell script is\n");
        printf("*** being found. The easiest way to fix this is to remove the old version\n");
        printf("*** of GTK_SHEET, but you can also set the GTK_SHEET_CONFIG environment to point to the\n");
        printf("*** correct copy of gtksheet-config. (In this case, you will have to\n");
        printf("*** modify your LD_LIBRARY_PATH enviroment variable, or edit /etc/ld.so.conf\n");
        printf("*** so that the correct libraries are found at run-time))\n");
      }
    }
  return 1;
}
],, no_gtksheet=yes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
       CFLAGS="$ac_save_CFLAGS"
       LIBS="$ac_save_LIBS"
     fi
  fi
  if test "x$no_gtksheet" = x ; then
     AC_MSG_RESULT(yes)
     ifelse([$2], , :, [$2])     
  else
     AC_MSG_RESULT(no)
     if test "$GTK_SHEET_CONFIG" = "no" ; then
       echo "*** The gtksheet-config script installed by GTK_SHEET could not be found"
       echo "*** If GTK_SHEET was installed in PREFIX, make sure PREFIX/bin is in"
       echo "*** your path, or set the GTK_SHEET_CONFIG environment variable to the"
       echo "*** full path to gtksheet-config."
     else
       if test -f conf.gtksheettest ; then
        :
       else
          echo "*** Could not run GTK_SHEET test program, checking why..."
          CFLAGS="$CFLAGS $GTK_SHEET_CFLAGS"
          LIBS="$LIBS $GTK_SHEET_LIBS"
          AC_TRY_LINK([
#include <gtksheet/gtksheet.h>
#include <stdio.h>
],      [ return ((gtksheet_major_version) || (gtksheet_minor_version) || (gtksheet_micro_version)); ],
        [ echo "*** The test program compiled, but did not run. This usually means"
          echo "*** that the run-time linker is not finding GTK_SHEET or finding the wrong"
          echo "*** version of GTK_SHEET. If it is not finding GTK_SHEET, you'll need to set your"
          echo "*** LD_LIBRARY_PATH environment variable, or edit /etc/ld.so.conf to point"
          echo "*** to the installed location  Also, make sure you have run ldconfig if that"
          echo "*** is required on your system"
	  echo "***"
          echo "*** If you have an old version installed, it is best to remove it, although"
          echo "*** you may also be able to get things to work by modifying LD_LIBRARY_PATH"
          echo "***"
          echo "*** If you have a RedHat 5.0 system, you should remove the GTK_SHEET package that"
          echo "*** came with the system with the command"
          echo "***"
          echo "***    rpm --erase --nodeps gtksheet gtksheet-devel" ],
        [ echo "*** The test program failed to compile or link. See the file config.log for the"
          echo "*** exact error that occured. This usually means GTK_SHEET was incorrectly installed"
          echo "*** or that you have moved GTK_SHEET since it was installed. In the latter case, you"
          echo "*** may want to edit the gtksheet-config script: $GTK_SHEET_CONFIG" ])
          CFLAGS="$ac_save_CFLAGS"
          LIBS="$ac_save_LIBS"
       fi
     fi
     GTK_SHEET_CFLAGS=""
     GTK_SHEET_LIBS=""
     ifelse([$3], , :, [$3])
  fi
  AC_SUBST(GTK_SHEET_CFLAGS)
  AC_SUBST(GTK_SHEET_LIBS)
  rm -f conf.gtksheettest
])
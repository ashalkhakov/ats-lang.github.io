/***********************************************************************/
/*                                                                     */
/*                         Applied Type System                         */
/*                                                                     */
/***********************************************************************/

/* (*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2010-2013 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
**
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
**
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*) */

/* ****** ****** */

/*
** Source:
** $PATSHOME/libc/CATS/CODEGEN/fcntl.atxt
** Time of generation: Sat Jun 27 21:39:55 2015
*/

/* ****** ****** */

/*
(* Author: Hongwei Xi *)
(* Authoremail: hwxi AT cs DOT bu DOT edu *)
(* Start time: February, 2013 *)
*/

/* ****** ****** */

#ifndef ATSLIB_LIBC_CATS_FCNTL
#define ATSLIB_LIBC_CATS_FCNTL

/* ****** ****** */

#include <sys/types.h>
#include <fcntl.h> // HX: after sys/types

/* ****** ****** */

#define atslib_fildes_get_int(fd) (fd)

/* ****** ****** */

ATSinline()
atstype_bool
atslib_fildes_isgtez
  (atstype_int fd)
{
  return (fd >= 0 ? atsbool_true : atsbool_false) ;
} // end of [atslib_fildes_isgtez]

/* ****** ****** */

#define atslib_fcntlflags_lor(x1, x2) ((x1)|(x2))

/* ****** ****** */

#define atslib_open_flags(path, flags) open((char*)path, flags)
#define atslib_open_flags_mode(path, flags, mode) open((char*)path, flags, mode)

/* ****** ****** */

#define atslib_fcntl_getfl(fd) fcntl(fd, F_GETFL)
#define atslib_fcntl_setfl(fd, flags) fcntl(fd, F_SETFL, flags)

/* ****** ****** */

#endif // ifndef ATSLIB_LIBC_CATS_FCNTL

/* ****** ****** */

/* end of [fcntl.cats] */

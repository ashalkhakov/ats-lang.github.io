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
** $PATSHOME/libc/CATS/CODEGEN/alloca.atxt
** Time of generation: Sat Jun 27 21:39:53 2015
*/

/* ****** ****** */

/*
(* Author: Hongwei Xi *)
(* Authoremail: gmhwxiATgmailDOTcom *)
(* Start time: February, 2014 *)
*/

/* ****** ****** */

#ifndef ATSLIB_LIBC_CATS_ALLOCA
#define ATSLIB_LIBC_CATS_ALLOCA

/* ****** ****** */

#include <alloca.h>

/* ****** ****** */
//
#define atslib_alloca(bsz) alloca(bsz)
//
/* ****** ****** */
//
#define atslib_ptr_alloca_tsz(tsz) alloca(tsz)
//
#define atslib_array_ptr_alloca_tsz(asz, tsz) alloca((asz)*(tsz))
//
/* ****** ****** */

#endif // ifndef ATSLIB_LIBC_CATS_ALLOCA

/* ****** ****** */

/* end of [alloca.cats] */

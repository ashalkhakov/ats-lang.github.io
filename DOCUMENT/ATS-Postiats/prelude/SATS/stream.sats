(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
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
*)

(* ****** ****** *)

(*
** Source:
** $PATSHOME/prelude/SATS/CODEGEN/stream.atxt
** Time of generation: Sat Jun 27 21:39:14 2015
*)

(* ****** ****** *)

sortdef t0p = t@ype

(* ****** ****** *)
//
// HX: lazy streams
//
datatype
stream_con (a:t@ype+) =
  | stream_nil of ((*void*)) | stream_cons of (a, stream(a))
where stream (a:t@ype) = lazy (stream_con(a))
//
(* ****** ****** *)
//
exception StreamSubscriptExn of ((*void*))
//
(*
fun StreamSubscriptExn ():<> exn = "mac#StreamSubscriptExn_make"
fun isStreamSubscriptExn (x: !exn):<> bool = "mac#isStreamSubscriptExn"
*)
//
(* ****** ****** *)

fun{a:t0p}
stream2list
  (xs: stream (INV(a))):<!laz> List0_vt (a)
// end of [stream2list]

(* ****** ****** *)

fun{a:t0p}
stream_nth_exn
  (xs: stream (INV(a)), n: intGte(0)):<!laz> a
// end of [stream_nth_exn]
fun{a:t0p}
stream_nth_opt
  (xs: stream (INV(a)), n: intGte(0)):<!laz> Option_vt (a)
// end of [stream_nth_opt]

(* ****** ****** *)

fun{a:t0p}
stream_take_exn{n:nat}
  (xs: stream (INV(a)), n: int n):<!laz> list_vt (a, n)
// end of [stream_take_lte]

(* ****** ****** *)

fun{a:t0p}
stream_drop_exn
  (xs: stream (INV(a)), n: intGte(0)):<!laz> stream (a)
// end of [stream_drop_exn]

(* ****** ****** *)
//
fun{a:t0p}
stream_append
  (xs: stream (INV(a)), ys: stream (a)):<!laz> stream(a)
//
fun{a:t0p}
stream_concat (xss: stream(stream(INV(a)))):<!laz> stream(a)
//
(* ****** ****** *)

fun{a:t0p}
stream_filter$pred (x: a):<> bool
fun{a:t0p}
stream_filter (xs: stream (INV(a))):<!laz> stream (a)
fun{a:t0p}
stream_filter_fun
  (xs: stream (INV(a)), pred: (a) -<fun> bool):<!laz> stream (a)
// end of [stream_filter_fun]
fun{a:t0p}
stream_filter_cloref
  (xs: stream (INV(a)), pred: (a) -<cloref> bool):<!laz> stream (a)
// end of [stream_filter_cloref]

(* ****** ****** *)

fun{
a:t0p}{b:t0p
} stream_map
  (xs: stream(INV(a))):<!laz> stream(b)
fun{
a:t0p}{b:t0p
} stream_map$fopr (x: a):<(*none*)> (b)
//
fun{
a:t0p}{b:t0p
} stream_map_fun
  (xs: stream(INV(a)), f: (a) -<fun> b):<!laz> stream(b)
fun{
a:t0p}{b:t0p
} stream_map_cloref
  (xs: stream(INV(a)), f: (a) -<cloref> b):<!laz> stream(b)
//
(* ****** ****** *)
//
fun{
a:t0p}{b:t0p
} stream_imap{n:int}
  (xs: stream(INV(a))):<!laz> stream(b)
//
fun{
a:t0p}{b:t0p
} stream_imap$fopr (i: intGte(0), x: a):<> (b)
//
fun{
a:t0p}{b:t0p
} stream_imap_fun
(
  xs: stream(INV(a)), f: (intGte(0), a) -<fun> b
) :<!laz> stream (b) // end-of-fun
fun{
a:t0p}{b:t0p
} stream_imap_cloref
(
  xs: stream(INV(a)), f: (intGte(0), a) -<cloref> b
) :<!laz> stream (b) // end-of-fun
//
(* ****** ****** *)
//
fun{
a1,a2:t0p}{b:t0p
} stream_map2
(
  xs1: stream (INV(a1))
, xs2: stream (INV(a2))
) :<!laz> stream (b) // end-of-fun
fun{
a1,a2:t0p}{b:t0p
} stream_map2$fopr (x1: a1, x2: a2):<> b
//
fun{
a1,a2:t0p}{b:t0p
} stream_map2_fun
(
  xs1: stream (INV(a1))
, xs2: stream (INV(a2)), f: (a1, a2) -<fun> b
) :<!laz> stream (b) // end-of-fun
fun{
a1,a2:t0p}{b:t0p
} stream_map2_cloref
(
  xs1: stream (INV(a1))
, xs2: stream (INV(a2)), f: (a1, a2) -<cloref> b
) :<!laz> stream (b) // end-of-fun
//
(* ****** ****** *)

fun{a:t0p}
stream_merge$cmp (x1: a, x2: a):<> int
fun{a:t0p}
stream_merge
  (xs1: stream (INV(a)), xs2: stream (a)):<!laz> stream (a)
fun{a:t0p}
stream_merge_fun
(
  xs1: stream (INV(a)), xs2: stream (a), (a, a) -<fun> int
) :<!laz> stream (a) // end of [stream_merge_fun]
fun{a:t0p}
stream_merge_cloref
(
  xs1: stream (INV(a)), xs2: stream (a), (a, a) -<cloref> int
) :<!laz> stream (a) // end of [stream_merge_cloref]

(* ****** ****** *)

fun{a:t0p}
stream_mergeq$cmp (x1: a, x2: a):<> int
fun{a:t0p}
stream_mergeq
  (xs1: stream (INV(a)), xs2: stream (a)):<!laz> stream (a)
fun{a:t0p}
stream_mergeq_fun
(
  xs1: stream (INV(a)), xs2: stream (a), (a, a) -<fun> int
) :<!laz> stream (a) // end of [stream_mergeq_fun]
fun{a:t0p}
stream_mergeq_cloref
(
  xs1: stream (INV(a)), xs2: stream (a), (a, a) -<cloref> int
) :<!laz> stream (a) // end of [stream_mergeq_cloref]

(* ****** ****** *)

fun{
a:t0p
} stream_tabulate (): stream(a)
fun{
a:t0p
} stream_tabulate$fopr (i: intGte(0)): (a)

fun{
a:t0p
} stream_tabulate_fun (f: intGte(0) -> a): stream(a)
fun{
a:t0p
} stream_tabulate_cloref (f: intGte(0) -> a): stream(a)

(* ****** ****** *)
//
fun{
a:t0p}{env:vt0p
} stream_foreach$cont (x: a, env: &env): bool
fun{
a:t0p}{env:vt0p
} stream_foreach$fwork (x: a, env: &env): void
//
fun{a:t0p}
stream_foreach (xs: stream (a)): void
fun{
a:t0p}{env:vt0p
} stream_foreach_env (xs: stream (a), &env >> _): void
//
(* ****** ****** *)
//
fun{}
fprint_stream$sep (out: FILEref): void
fun{a:t0p}
fprint_stream
  (out: FILEref, xs: stream(INV(a)), n: int): void
//
(* ****** ****** *)
//
// overloading for certain symbols
//
(* ****** ****** *)

overload [] with stream_nth_exn

(* ****** ****** *)

(* end of [stream.sats] *)

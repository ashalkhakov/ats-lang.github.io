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
** $PATSHOME/prelude/DATS/CODEGEN/list.atxt
** Time of generation: Sat Jun 27 21:39:32 2015
*)

(* ****** ****** *)

(* Author: Hongwei Xi *)
(* Authoremail: gmhwxiATgmailDOTcom *)
(* Start time: Feburary, 2012 *)

(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"
staload _(*anon*) = "prelude/DATS/unsafe.dats"

(* ****** ****** *)

abstype List0_(a:t@ype+) = List0(a)

(* ****** ****** *)

implement
{x}(*tmp*)
list_make_sing (x) = list_vt_cons{x}(x, list_vt_nil)
implement
{x}(*tmp*)
list_make_pair (x1, x2) = list_vt_cons{x}(x1, list_vt_cons{x}(x2, list_vt_nil))

(* ****** ****** *)

implement
{x}(*tmp*)
list_make_elt
  {n} (n, x) = let
  fun loop
    {i:nat | i <= n} .<i>.
  (
    i: int i, x: x, res: list_vt (x, n-i)
  ) :<> list_vt (x, n) = (
    if i > 0 then
      loop (pred(i), x, list_vt_cons (x, res)) else res
    // end of [if]
  ) // end of [loop]
in
  loop (n, x, list_vt_nil ())
end // end of [list_make_elt]

(* ****** ****** *)

implement
{}(*tmp*)
list_make_intrange
  {l0,r} (l0, r) = let
//
typedef elt = intBtw (l0, r)
vtypedef res (l:int) = list_vt (elt, r-l)
fun loop {
  l:int | l0 <= l; l <= r
} .<r-l>. (
  l: int l, r: int r, res: &ptr? >> res (l)
) :<!wrt> void =
  if l < r then let
    val () = res :=
      list_vt_cons{elt}{0}(l, _)
    val+list_vt_cons (_, res1) = res
    val () = loop (l+1, r, res1)
  in
    fold@ (res)
  end else (res := list_vt_nil)
// end of [loop]
//
var res: ptr
val () = $effmask_wrt (loop (l0, r, res))
//
in
  res
end // end of [list_make_intrange]

(* ****** ****** *)

implement
{a}(*tmp*)
list_make_array
  {n} (A, n) = let
//
prval () = lemma_array_param (A)
vtypedef res (n:int) = list_vt (a, n)
fun loop
  {l:addr}
  {n:nat} .<n>. (
  pf: !array_v (a, l, n) >> array_v (a?!, l, n)
| p: ptr l
, n: size_t n
, res: &ptr? >> res(n)
) :<!wrt> void =
  if n > 0 then let
    prval (
      pf1, pf2
    ) = array_v_uncons (pf)
    val () = res :=
      list_vt_cons{a}{0}(_, _)
    val+list_vt_cons (x, res1) = res
    val () = x := !p
    val () = loop (pf2 | ptr1_succ<a> (p), pred(n), res1)
    prval () = pf := array_v_cons (pf1, pf2)
    prval () = fold@ (res)
  in
    // nothing
  end else let
    prval () = array_v_unnil (pf)
    prval () = pf := array_v_nil ()
  in
    res := list_vt_nil ()
  end // end of [if]
// end of [loop]
var res: ptr // uninitialized
val () = loop (view@(A) | addr@(A), n, res)
//
in
  res
end // end of [list_make_array]

(* ****** ****** *)

implement
{a}(*tmp*)
list_make_arrpsz
  {n} (A0) = let
//
var asz: size_t
val A = arrpsz_get_ptrsize (A0, asz)
val p = arrayptr2ptr (A)
prval pfarr = arrayptr_takeout (A)
val res = list_make_array (!p, asz)
prval () = arrayptr_addback (pfarr | A)
val () = arrayptr_free (A)
//
in
  res
end // end of [list_make_arrpsz]

(* ****** ****** *)

implement
{a}(*tmp*)
print_list (xs) = fprint_list<a> (stdout_ref, xs)
implement
{a}(*tmp*)
prerr_list (xs) = fprint_list<a> (stderr_ref, xs)

(* ****** ****** *)

implement
{}(*tmp*)
fprint_list$sep
  (out) = fprint_string (out, ", ")
// end of [fprint_list$sep]

implement
{a}(*tmp*)
fprint_list (out, xs) = let
//
implement(env)
list_iforeach$fwork<a><env>
  (i, x, env) = let
  val () =
    if i > 0 then fprint_list$sep<(*none*)> (out)
  // end of [val]
in
  fprint_val<a> (out, x)
end // end of [list_iforeach$fwork]
//
val _(*len*) = list_iforeach<a> (xs)
//
in
  // nothing
end // end of [fprint_list]

implement
{a}(*tmp*)
fprint_list_sep
  (out, xs, sep) = let
//
implement
fprint_list$sep<(*none*)> (out) = fprint_string (out, sep)
//
in
  fprint_list<a> (out, xs)
end // end of [fprint_list_sep]

(* ****** ****** *)
(*
//
// HX-2012-05:
// Compiling this can be a great challenge!
//
*)
implement
{a}(*tmp*)
fprint_listlist_sep
  (out, xss, sep1, sep2) = let
//
implement
fprint_val<List0_(a)>
  (out, xs) = let
  val xs = $UN.cast{List0(a)}(xs)
in
  fprint_list_sep<a> (out, xs, sep2)
end // end of [fprint_val]
//
in
  fprint_list_sep<List0_(a)> (out, $UN.cast{List(List0_(a))}(xss), sep1)
end // end of [fprint_listlist_sep]

(* ****** ****** *)

implement
{}(*tmp*)
list_is_nil (xs) =
  case+ xs of list_nil () => true | _ =>> false
// end of [list_is_nil]

implement
{}(*tmp*)
list_is_cons (xs) =
  case+ xs of list_cons _ => true | _ =>> false
// end of [list_is_cons]

implement
{x}(*tmp*)
list_is_sing (xs) =
  case+ xs of list_sing (x) => true | _ =>> false
// end of [list_is_sing]

implement
{x}(*tmp*)
list_is_pair (xs) =
  case+ xs of list_pair (x1, x2) => true | _ =>> false
// end of [list_is_pair]

(* ****** ****** *)

implement
{x}(*tmp*)
list_head (xs) =
  let val+list_cons (x, _) = xs in x end
// end of [list_head]
implement
{x}(*tmp*)
list_tail (xs) =
  let val+list_cons (_, xs) = xs in xs end
// end of [list_tail]
implement
{x}(*tmp*)
list_last (xs) = let
//
fun loop
  (xs: List1 (x)): x = let
  val+list_cons (x, xs) = xs
in
  case+ xs of
  | list_cons _ => loop (xs) | list_nil _ => x
end // end of [loop]
//
in
  $effmask_all (loop (xs))
end // end of [list_last]

(* ****** ****** *)

implement
{x}(*tmp*)
list_head_exn (xs) =
(
case+ xs of
| list_cons (x, _) => x | _ => $raise ListSubscriptExn()
) (* end of [list_head_exn] *)

implement
{x}(*tmp*)
list_tail_exn (xs) =
(
case+ xs of
| list_cons (_, xs) => xs | _ => $raise ListSubscriptExn()
) (* end of [list_tail_exn] *)

implement
{x}(*tmp*)
list_last_exn (xs) =
(
case+ xs of
| list_cons _ => list_last (xs) | _ => $raise ListSubscriptExn()
) (* end of [list_last_exn] *)

(* ****** ****** *)

implement
{a}(*tmp*)
list_nth (xs, i) = let
//
fun loop
  {n,i:nat | i < n} .<i>. (
  xs: list (a, n), i: int i
) :<> a =
  if i > 0 then let
    val+list_cons (_, xs) = xs in loop (xs, pred(i))
  end else list_head<a> (xs)
//
in
  loop (xs, i)
end // end of [list_nth]

implement
{a}(*tmp*)
list_nth_opt (xs, i) = let
//
fun loop
  {n:nat} .<n>.
(
  xs: list (a, n), i: intGte(0)
) :<> Option_vt (a) =
(
case+ xs of
| list_nil () => None_vt ()
| list_cons (x, xs) =>
    if i = 0 then Some_vt(x) else loop (xs, pred(i))
  // end of [list_vt_cons]
) (* end of [loop] *)
//
prval () = lemma_list_param (xs)
//
in
  loop (xs, i)
end // end of [list_nth_opt]

(* ****** ****** *)

implement
{a}(*tmp*)
list_get_at (xs, i) = list_nth<a> (xs, i)
implement
{a}(*tmp*)
list_get_at_opt (xs, i) = list_nth_opt<a> (xs, i)

(* ****** ****** *)

implement
{a}(*tmp*)
list_set_at
  (xs, i, x_new) = let
  val (xs1, xs2) =
    $effmask_wrt (list_split_at<a> (xs, i))
  val+list_cons (x_old, xs2) = xs2
  val xs2 = list_cons{a}(x_new, xs2)
in
  $effmask_wrt (list_append1_vt<a> (xs1, xs2))
end // ed of [list_set_at]

(* ****** ****** *)

implement
{a}(*tmp*)
list_exch_at
  (xs, i, x_new) = let
  val (xs1, xs2) =
    $effmask_wrt (list_split_at<a> (xs, i))
  val+list_cons (x_old, xs2) = xs2
  val xs2 = list_cons{a}(x_new, xs2)
in
  ($effmask_wrt (list_append1_vt<a> (xs1, xs2)), x_old)
end // ed of [list_exch_at]

(* ****** ****** *)

implement
{a}(*tmp*)
list_insert_at
  (xs, i, x) = let
//
fun loop{n:int}
  {i:nat | i <= n} .<i>.
(
  xs: list (a, n)
, i: int i, x: a
, res: &ptr? >> list (a, n+1)
) :<!wrt> void =
  if i > 0 then let
    val+list_cons (x1, xs1) = xs
    val () = res :=
      list_cons{a}{0}(x1, _(*?*))
    val+list_cons
      (_, res1) = res // res1 = res.1
    val () = loop (xs1, i-1, x, res1)
    prval () = fold@ (res)
  in
    // nothing
  end else res := list_cons (x, xs)
//
var res: ptr
val () = $effmask_wrt (loop (xs, i, x, res))
//
in
  res
end // end of [list_insert_at]

(* ****** ****** *)

implement
{a}(*tmp*)
list_takeout_at
  (xs, i, x0) = let
//
fun loop{n:int}
  {i:nat | i < n} .<i>.
(
  xs: list (a, n)
, i: int i, x0: &a? >> a
, res: &ptr? >> list (a, n-1)
) :<!wrt> void = let
//
val+list_cons (x, xs) = xs
//
in
//
if i > 0 then let
  val () =
    res := list_cons{a}{0}(x, _(*?*))
  val+list_cons
    (_, res1) = res // res1 = res.1
  val () = loop (xs, i-1, x0, res1)
  prval () = fold@ (res)
in
  // nothing
end else let
  val () = x0 := x; val () = res := xs
in
  // nothing
end // end of [if]
//
end // end of [loop]
//
var res: ptr?
val () = loop (xs, i, x0, res)
//
in
  res
end // end of [list_takeout_at]

(* ****** ****** *)

implement
{x}(*tmp*)
list_length (xs) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {i,j:nat} .<i>. (
  xs: list (x, i), j: int j
) :<> int (i+j) = (
  case+ xs of
  | list_cons (_, xs) => loop (xs, j+1) | _ =>> j
) // end of [loop]
//
in
  loop (xs, 0)
end // end of [list_length]

(* ****** ****** *)

implement
{x}(*tmp*)
list_copy
  (xs) = res where {
//
vtypedef res = List0_vt (x)
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat} .<n>.
(
  xs: list (x, n)
, res: &res? >> list_vt (x, n)
) :<!wrt> void = let
in
//
case+ xs of
| list_cons
    (x, xs) => let
    val () = res :=
      list_vt_cons{x}{0}(x, _(*?*))
    val+list_vt_cons
      (_, res1) = res // res1 = res.1
    val () = loop (xs, res1)
    prval () = fold@ (res)
  in
    // nothing
  end // end of [cons]
| list_nil () => res := list_vt_nil ()
//
end // end of [loop]
//
var res: res? ; val () = loop (xs, res)
//
} // end of [list_copy]

(* ****** ****** *)

implement
{a}(*tmp*)
list_append
  {m,n} (xs, ys) = let
  val ys = __cast (ys) where {
    extern castfn __cast (ys: list (a, n)):<> list_vt (a, n)
  } // end of [where] // end of [val]
in
$effmask_wrt
(
  list_of_list_vt (list_append2_vt (xs, ys))
) // end of [$effmask_wrt]
end // end of [list_append]

implement
{a}(*tmp*)
list_append1_vt
  {m,n} (xs, ys) = let
  val ys = __cast (ys) where {
    extern castfn __cast (ys: list (a, n)):<> list_vt (a, n)
  } // end of [val]
in
  list_of_list_vt (list_vt_append (xs, ys))
end // end of [list_append1_vt]

implement
{a}(*tmp*)
list_append2_vt
  {m,n} (xs, ys) = let
//
prval () = lemma_list_param (xs)
prval () = lemma_list_vt_param (ys)
//
fun loop
  {m:nat} .<m>. (
  xs: list (a, m)
, ys: list_vt (a, n)
, res: &ptr? >> list_vt (a, m+n)
) :<!wrt> void =
  case+ xs of
  | list_cons
      (x, xs) => let
      val () = res :=
        list_vt_cons{a}{0}(x, _(*?*))
      val+list_vt_cons
        (_, res1) = res // res1 = res.1
      val () = loop (xs, ys, res1)
      prval () = fold@ (res)
    in
      // nothing
    end // end of [list_cons]
  | list_nil () => res := ys
// end of [loop]
var res: ptr // uninitialized
val () = loop (xs, ys, res)
//
in
  res
end // end of [list_append2_vt]

(* ****** ****** *)

implement
{a}(*tmp*)
list_extend (xs, y) =
(
  list_append2_vt<a> (xs, list_vt_sing (y))
) // end of [list_extend]

(* ****** ****** *)

implement
{x}(*tmp*)
list_reverse (xs) = (
  list_reverse_append2_vt<x> (xs, list_vt_nil)
) // end of [list_reverse]

(* ****** ****** *)

implement
{a}(*tmp*)
list_reverse_append
  {m,n} (xs, ys) = let
//
val ys = __cast (ys) where
{
  extern castfn __cast (ys: list (a, n)):<> list_vt (a, n)
} // end of [where] // end of [val]
//
in
//
$effmask_wrt
(
  list_of_list_vt (list_reverse_append2_vt<a> (xs, ys))
) (* end of [$effmask_wrt] *)
//
end // end of [list_reverse_append]

implement
{a}(*tmp*)
list_reverse_append1_vt
  {m,n} (xs, ys) = let
//
prval (
) = lemma_list_vt_param (xs)
prval () = lemma_list_param (ys)
//
fun loop{m,n:nat} .<m>.
(
  xs: list_vt (a, m), ys: list (a, n)
) :<!wrt> list (a, m+n) = let
in
//
case+ xs of
| @list_vt_cons
    (x, xs1) => let
    val xs1_ = xs1
    val ys = __cast (ys) where {
      extern castfn __cast (ys: list (a, n)):<> list_vt (a, n)
    } // end of [val]
    val () = xs1 := ys
    prval () = fold@ (xs)
  in
    loop (xs1_, list_of_list_vt{a}(xs))
  end // end of [list_vt_cons]
| ~list_vt_nil () => ys
//
end // end of [loop]
//
in
  loop (xs, ys)
end // end of [list_reverse_append1_vt]

implement
{a}(*tmp*)
list_reverse_append2_vt
  (xs, ys) = let
//
prval () = lemma_list_param (xs)
prval () = lemma_list_vt_param (ys)
//
fun loop
  {m,n:nat} .<m>.
(
  xs: list (a, m), ys: list_vt (a, n)
) :<!wrt> list_vt (a, m+n) =
  case+ xs of
  | list_cons
      (x, xs) => loop (xs, list_vt_cons{a}(x, ys))
  | list_nil () => ys // end of [list_nil]
// end of [loop]
in
  loop (xs, ys)
end // end of [list_reverse_append2_vt]

(* ****** ****** *)

implement
{a}(*tmp*)
list_concat (xss) = let
//
prval () = lemma_list_param (xss)
//
typedef T = List (a)
fun aux {n:nat} .<n>.
(
  xs0: T
, xss: list (T, n)
) :<!wrt> List0_vt (a) = let
  prval () = lemma_list_param (xs0)
in
  case+ xss of
  | list_cons
      (xs, xss) => let
      val res = aux (xs, xss)
      val ys0 = list_copy (xs0)
    in
      list_vt_append<a> (ys0, res)
    end // end of [list_cons]
  | list_nil () => list_copy (xs0)
end // end of [aux]
//
in
//
case+ xss of
| list_cons
    (xs, xss) => aux (xs, xss)
| list_nil () => list_vt_nil ()
//
end // end of [list_concat]

(* ****** ****** *)

implement
{a}(*tmp*)
list_take (xs, i) = let
//
fun loop
  {n:int}
  {i:nat | i <= n} .<i>. (
  xs: list (a, n), i: int i
, res: &ptr? >> list_vt (a, i)
) :<!wrt> void =
  if i > 0 then let
    val+list_cons (x, xs) = xs
    val () = res :=
      list_vt_cons{a}{0}(x, _(*?*))
    val+list_vt_cons
      (_, res1) = res // res1 = res.1
    val () = loop (xs, i-1, res1)
    val () = fold@ (res)
  in
    // nothing
  end else (res := list_vt_nil ())
// end of [loop]
//
var res: ptr
val () = loop (xs, i, res)
//
in
  res
end // end of [list_take]

implement
{a}(*tmp*)
list_take_exn
  {n}{i} (xs, i) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat}
  {i:nat} .<i>. (
  xs: list (a, n), i: int i
, res: &ptr? >> list_vt (a, j)
) :<!wrt> #[
  j:nat | (i <= n && i == j) || (i > n && n == j)
] bool (i <= n) = let
//
in
//
if i > 0
then let
in
//
case+ xs of
| list_cons
    (x, xs1) => let
    val ((*void*)) =
    res := list_vt_cons{a}{0}(x, _)
    val+list_vt_cons (_, res1) = res
    val ans = loop (xs1, i-1, res1)
  in
    fold@ (res); ans
  end // end of [list_cons]
| list_nil () => let
    val ((*void*)) =
    res := list_vt_nil () in false(*fail*)
  end // end of [list_nil]
//
end // end of [then]
else let
  val () = res := list_vt_nil () in true(*succ*)
end // end of [else]
// end of [if]
//
end // end of [loop] 
//   
var res: ptr
val ans = loop{n}{i}(xs, i, res)
//
in
//
if ans
then res // i <= n && length (res) == i
else let
  val () = list_vt_free<a> (res) in $raise ListSubscriptExn()
end // end of [if]
//
end (* end of [list_take_exn] *)

(* ****** ****** *)

implement
{a}(*tmp*)
list_drop (xs, i) = let
//
fun loop
  {n:int}
  {i:nat | i <= n} .<i>.
  (xs: list (a, n), i: int i):<> list (a, n-i) =
  if i > 0 then let
    val+list_cons (_, xs) = xs in loop (xs, i-1)
  end else xs // end of [if]
//
in
  loop (xs, i)
end // end of [list_drop]

implement
{a}(*tmp*)
list_drop_exn
  (xs, i) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat}{i:nat} .<i>. (
  xs: list (a, n), i: int i
) :<!exn> [i <= n] list (a, n-i) =
  if i > 0 then (
    case+ xs of
    | list_cons (_, xs) => loop (xs, i-1)
    | list_nil () => $raise ListSubscriptExn()
  ) else (xs) // end of [if]
//
in
  loop (xs, i)
end // end of [list_drop_exn]

(* ****** ****** *)

implement
{x}(*tmp*)
list_split_at
  (xs, i) = let
//
fun loop
  {n:int}
  {i:nat | i <= n} .<n>.
(
  xs: list (x, n), i: int i
, res: &ptr? >> list_vt (x, i)
) :<!wrt> list (x, n-i) =
(
if i > 0
  then let
    val+list_cons (x, xs) = xs
    val () =
      res := list_vt_cons{x}{0}(x, _)
    // end of [val]
    val+list_vt_cons (_, res1) = res
    val xs2 = loop (xs, i-1, res1)
    prval () = fold@ (res)
  in
    xs2
  end // end of [then]
  else let
    val () = res := list_vt_nil () in xs
  end // end of [else]
// end of [if]
)
//
var res: ptr
val xs2 = loop (xs, i, res)
//
in
  (res, xs2)
end // end of [list_split_at]

(* ****** ****** *)

implement
{x}(*tmp*)
list_exists (xs) = let
in
//
case+ xs of
| list_cons (x, xs) =>
    if list_exists$pred<x> (x) then true else list_exists<x> (xs)
| list_nil () => false
//
end // end of [list_exists]

implement
{x}(*tmp*)
list_forall (xs) = let
in
//
case+ xs of
| list_cons (x, xs) =>
    if list_forall$pred<x> (x) then list_forall<x> (xs) else false
| list_nil () => true
//
end // end of [list_forall]

(* ****** ****** *)

implement
{a}(*tmp*)
list_equal$eqfn = gequal_val_val<a>

implement
{x}(*tmp*)
list_equal
  (xs1, xs2) = let
in
//
case+ xs1 of
| list_cons (x1, xs1) =>
  (
    case+ xs2 of
    | list_cons
        (x2, xs2) => let
        val iseq = list_equal$eqfn<x> (x1, x2)
      in
        if iseq then list_equal<x> (xs1, xs2) else false
      end
    | list_nil () => false
  ) // end of [list_cons]
| list_nil ((*void*)) =>
  (
    case+ xs2 of list_cons _ => false | list_nil () => true
  ) // end of [list_nil]
//
end // end of [list_equal]

(* ****** ****** *)

implement
{x}(*tmp*)
list_find_exn (xs) = let
in
//
case+ xs of
| list_cons (x, xs) =>
    if list_find$pred<x> (x) then x else list_find_exn<x> (xs)
| list_nil () => $raise NotFoundExn()
//
end // end of [list_find_exn]

implement
{x}(*tmp*)
list_find_opt (xs) = let
in
//
case+ xs of
| list_cons (x, xs) =>
    if list_find$pred<x> (x) then Some_vt{x}(x) else list_find_opt<x> (xs)
| list_nil () => None_vt(*void*)
//
end // end of [list_find_opt]

(* ****** ****** *)

implement
{key}(*tmp*)
list_assoc$eqfn = gequal_val_val<key>

implement
{key,itm}
list_assoc
  (kxs, k0, x0) = let
//
fun loop
(
  kxs: List @(key, itm)
, k0: key, x0: &itm? >> opt (itm, b)
) : #[b:bool] bool(b) =
(
  case+ kxs of
  | list_cons
      (kx, kxs) => let
      val iseq = list_assoc$eqfn<key> (k0, kx.0)
    in
      if iseq
        then let
          val () = x0 := kx.1
          prval () = opt_some{itm}(x0)
        in
          true
        end // end of [then]
        else loop (kxs, k0, x0)
      // end of [if]
    end // end of [list_cons]
  | list_nil ((*void*)) =>
      let prval () = opt_none{itm}(x0) in false end 
    // end of [list_nil]
) (* end of [loop] *)
//
in
  $effmask_all (loop (kxs, k0, x0))
end // end of [list_assoc]

(* ****** ****** *)

implement
{key,itm}
list_assoc_exn
  (kxs, k0) = let
  var x0: itm?
  val ans = list_assoc<key,itm> (kxs, k0, x0)
in
//
if ans
  then let
    prval () = opt_unsome{itm}(x0) in x0
  end // end of [then]
  else let
    prval () = opt_unnone{itm}(x0) in $raise NotFoundExn()
  end // end of [else]
//
end // end of [list_assoc_exn]

(* ****** ****** *)

implement
{key,itm}
list_assoc_opt
  (kxs, k0) = let
  var x0: itm?
  val ans = list_assoc<key,itm> (kxs, k0, x0)
in
//
if ans
  then let
    prval () = opt_unsome{itm}(x0) in Some_vt{itm}(x0)
  end // end of [then]
  else let
    prval () = opt_unnone{itm}(x0) in None_vt((*void*))
  end // end of [else]
//
end // end of [list_assoc_opt]

(* ****** ****** *)

implement
{x}(*tmp*)
list_filter {n} (xs) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat} .<n>. (
  xs: list (x, n)
, res: &ptr? >> listLte_vt (x, n)
) : void = (
  case+ xs of
  | list_cons (x, xs) => let
      val test = list_filter$pred<x> (x)
    in
      case+ test of
      | true => let
          val () = res :=
            list_vt_cons{x}{0}(x, _(*?*))
          val+list_vt_cons
            (_, res1) = res // res1 = res.1
          val () = loop (xs, res1)
          prval () = fold@ (res)
        in
          // nothing
        end // end of [true]
      | false => loop (xs, res)
    end // end of [list_cons]
  | list_nil () => (res := list_vt_nil)
) // end of [loop]
//
var res: ptr
val () = loop (xs, res)
//
in
  res (*listLte_vt(x, n)*)
end // end of [list_filter]

(* ****** ****** *)

implement
{x}(*tmp*)
list_labelize
  (xs) = res where {
//
typedef ix = @(int, x)
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat} .<n>. (
  xs: list (x, n), i: int
, res: &ptr? >> list_vt (ix, n)
) :<!wrt> void = let
in
  case+ xs of
  | list_cons
      (x, xs) => let
      val () = res :=
        list_vt_cons{ix}{0}(_, _)
      val+list_vt_cons (ix, res1) = res
      val () = ix.0 := i and () = ix.1 := x
      val () = loop (xs, i+1, res1)
    in
      fold@ (res)
    end // end of [list_cons]
  | list_nil () => (res := list_vt_nil)
end // end of [loop]
//
var res: ptr ; val () = loop (xs, 0, res)
//
} // end of [list_labelize]

(* ****** ****** *)

implement
{x}(*tmp*)
list_app (xs) = let
//
prval () = lemma_list_param (xs)
//
fun
loop{n:nat} .<n>. (xs: list (x, n)): void =
(
case+ xs of
| list_nil () => ()
| list_cons (x, xs) => (list_app$fwork(x); loop (xs))
) (* end of [loop] *)
//
in
  loop (xs)
end // end of [list_app]

(* ****** ****** *)

implement
{x}(*tmp*)
list_app_fun(xs, f) = let
//
prval () = lemma_list_param (xs)
//
fun
loop{n:nat} .<n>.
(
  xs: list (x, n), f: (x) -<fun1> void
) : void = (
//
case+ xs of
| list_nil () => ()
| list_cons (x, xs) => (f(x); loop (xs, f))
//
) (* end of [loop] *)
//
in
  loop (xs, f)
end // end of [list_app_fun]

implement
{x}(*tmp*)
list_app_cloref(xs, f) = let
//
prval () = lemma_list_param (xs)
//
fun
loop{n:nat} .<n>.
(
  xs: list (x, n), f: (x) -<cloref1> void
) : void = (
//
case+ xs of
| list_nil () => ()
| list_cons (x, xs) => (f(x); loop (xs, f))
//
) (* end of [loop] *)
//
in
  loop (xs, f)
end // end of [list_app_cloref]

(* ****** ****** *)

implement
{x}{y}(*tmp*)
list_map{n}(xs) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat} .<n>. (
  xs: list (x, n)
, res: &ptr? >> list_vt (y, n)
) : void = (
  case+ xs of
  | list_cons (x, xs) => let
      val y =
        list_map$fopr<x><y> (x)
      val () = res :=
        list_vt_cons{y}{0}(y, _(*?*))
      val+list_vt_cons
        (_, res1) = res // res1 = res.1
      val () = loop (xs, res1)
      prval () = fold@ (res)
    in
      // nothing
    end // end of [list_cons]
  | list_nil () => (res := list_vt_nil)
) // end of [loop]
//
var res: ptr
val () = loop (xs, res)
//
in
  res (*list_vt (y, n)*)
end // end of [list_map]

(* ****** ****** *)

implement
{x}{y}(*tmp*)
list_map_fun
  (xs, f) = let
//
implement
{x2}{y2}
list_map$fopr (x2) = $UN.castvwtp0{y2}(f($UN.cast{x}(x2)))
//
in
  list_map<x><y> (xs)
end // end of [list_map_fun]

implement
{x}{y}(*tmp*)
list_map_clo
  (xs, f) = let
//
val f = $UN.cast{(x) -<cloref1> y}(addr@f)
//
implement
{x2}{y2}
list_map$fopr (x2) = $UN.castvwtp0{y2}(f($UN.cast{x}(x2)))
//
in
  list_map<x><y> (xs)
end // end of [list_map_clo]

implement
{x}{y}(*tmp*)
list_map_cloref
  (xs, f) = let
//
implement
{x2}{y2}
list_map$fopr (x2) = $UN.castvwtp0{y2}(f($UN.cast{x}(x2)))
//
in
  list_map<x><y> (xs)
end // end of [list_map_cloref]

(* ****** ****** *)

(*
implement
{x}{y}(*tmp*)
list_map_funenv
  {v}{vt}{n}{fe}
  (pfv | xs, f, env) = let
//
viewtypedef ys = List0_vt (y)
//
prval () =
  lemma_list_param (xs) // prove [n >= 0]
// end of [prval]
fun loop {n:nat} .<n>. (
  pfv: !v
| xs: list (x, n)
, f: (!v | x, !vt) -<fun,fe> y
, env: !vt
, res: &ys? >> list_vt (y, n)
) :<!wrt,fe> void = let
in
//
case+ xs of
| list_cons
    (x, xs) => let
    val y = f (pfv | x, env)
    val () = res :=
      list_vt_cons{y}{0}(y, _(*?*))
    val+list_vt_cons
      (_, res1) = res // res1 = res.1
    val () = loop (pfv | xs, f, env, res1)
    prval () = fold@ (res)
  in
    (*nothing*)
  end // end of [list_vt_cons]
| list_nil (
  ) => (res := list_vt_nil ())
//
end // end of [loop]
//
var res: ys // uninitialized
val () = loop (pfv | xs, f, env, res)
//
in
  res(*list_vt(y,n)*)
end // end of [list_map_funenv]
*)

(* ****** ****** *)

implement
{x}{y}
list_imap{n}(xs) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat}{i:nat} .<n>.
(
  xs: list (x, n), i: int(i)
, res: &ptr? >> list_vt (y, n)
) : void = (
  case+ xs of
  | list_cons
      (x, xs) => let
      val y =
        list_imap$fopr<x><y> (i, x)
      val () = res :=
        list_vt_cons{y}{0}(y, _(*?*))
      val+list_vt_cons
        (_, res1) = res // res1 = res.1
      val () = loop (xs, i+1, res1)
      prval ((*void*)) = fold@ (res)
    in
      // nothing
    end // end of [list_cons]
  | list_nil () => (res := list_vt_nil)
) // end of [loop]
//
var res: ptr
val () = loop (xs, 0, res)
//
in
  res (*list_vt (y, n)*)
end // end of [list_imap]

(* ****** ****** *)

implement
{x}{y}
list_mapopt{n}(xs) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat} .<n>. (
  xs: list (x, n)
, res: &ptr? >> listLte_vt (y, n)
) : void = let
in
//
case+ xs of
| list_cons (x, xs) => let
    val opt =
      list_mapopt$fopr<x><y> (x)
    // end of [val]
  in
    case+ opt of
    | ~Some_vt (y) => let
        val () = res :=
          list_vt_cons{y}{0}(y, _(*?*))
        val+list_vt_cons
          (_, res1) = res // res1 = res.1
        val () = loop (xs, res1)
        prval () = fold@ (res)
      in
        // nothing
      end // end of [Some_vt]
    | ~None_vt () => loop (xs, res)
  end // end of [list_cons]
| list_nil () => (res := list_vt_nil)
//
end // end of [loop]
//
var res: ptr
val () = loop (xs, res)
//
in
  res (*listLte_vt(y, n)*)
end // end of [list_mapopt]

(* ****** ****** *)

(*
implement
{x}{y}(*tmp*)
list_mapopt_funenv
  {v}{vt}{n}{fe}
  (pfv | xs, f, env) = let
//
viewtypedef ys = List0_vt (y)
//
prval () =
  lemma_list_param (xs) // prove [n >= 0]
// end of [prval]
fun loop {n:nat} .<n>. (
  pfv: !v
| xs: list (x, n)
, f: (!v | x, !vt) -<fun,fe> Option_vt (y)
, env: !vt
, res: &ys? >> listLte_vt (y, n)
) :<!wrt,fe> void = let
in
  case+ xs of
  | list_cons
      (x, xs) => let
      val opt = f (pfv | x, env)
    in
      case+ opt of
      | ~Some_vt (y) => let
          val () = res :=
            list_vt_cons{y}{0}(y, _(*?*))
          val+list_vt_cons
            (_, res1) = res // res1 = res.1
          val () = loop (pfv | xs, f, env, res1)
          prval () = fold@ (res)
        in
          (*nothing*)
        end // end of [Some_vt]
      | ~None_vt () => loop (pfv | xs, f, env, res)
    end // end of [list_vt_cons]
  | list_nil () => (res := list_vt_nil ())
    // end of [list_nil]
end // end of [loop]
//
var res: ys // uninitialized
val () = loop (pfv | xs, f, env, res)
//
in
  res(*listLte_vt(y,n)*)
end // end of [list_mapopt_funenv]
*)

(* ****** ****** *)

implement
{x1,x2}{y}(*tmp*)
list_map2{n1,n2}(xs1, xs2) = let
//
prval () = lemma_list_param (xs1)
prval () = lemma_list_param (xs2)
//
fun
loop{n1,n2:nat}
(
  xs1: list (x1, n1)
, xs2: list (x2, n2)
, res: &ptr? >> list_vt (y, min(n1,n2))
) : void = let
in
//
case+ (xs1, xs2) of
| (list_cons (x1, xs1),
   list_cons (x2, xs2)) =>
  {
    val y = list_map2$fopr (x1, x2)
    val () =
      res := list_vt_cons{y}{0}(y, _)
    val+list_vt_cons (_, res1) = res
    val ((*void*)) = loop (xs1, xs2, res1)
    prval ((*folded*)) = fold@ (res)
  } (* end of [cons, cons] *)
| (_, _) =>> (res := list_vt_nil((*void*)))
//
end // end of [loop]
//
var res: ptr
val ((*void*)) = loop (xs1, xs2, res)
//
in
  res
end // end of [list_map2]

(* ****** ****** *)

implement
{x}(*tmp*)
list_tabulate
  (n) = res where {
//
fun loop
  {n:int}
  {i:nat | i <= n}
  .<n-i>. (
  n: int n, i: int i
, res: &ptr? >> list_vt (x, n-i)
) : void =
  if n > i then let
    val x =
      list_tabulate$fopr<x> (i)
    val () = res :=
      list_vt_cons{x}{0}(x, _(*?*))
    val+list_vt_cons
      (_, res1) = res // res1 = res.1
    val () = loop (n, succ(i), res1)
    prval () = fold@ (res)
  in
    // nothing
  end else (res := list_vt_nil)
//
var res: ptr
val () = loop (n, 0, res)
//
} // end of [list_tabulate]

(* ****** ****** *)

implement
{a}(*tmp*)
list_tabulate_fun (n, f) = let
//
val f = $UN.cast{int -> a}(f)
//
implement(a2)
list_tabulate$fopr<a2> (n) = $UN.castvwtp0{a2}(f(n))
//
in
  list_tabulate<a> (n)
end // end of [list_tabulate_fun]

implement
{a}(*tmp*)
list_tabulate_clo (n, f) = let
//
val f = $UN.cast{int -<cloref1> a}(addr@f)
//
implement(a2)
list_tabulate$fopr<a2> (n) = $UN.castvwtp0{a2}(f(n))
//
in
  list_tabulate<a> (n)
end // end of [list_tabulate_clo]

implement
{a}(*tmp*)
list_tabulate_cloref (n, f) = let
//
val f = $UN.cast{int -<cloref1> a}(f)
//
implement(a2)
list_tabulate$fopr<a2> (n) = $UN.castvwtp0{a2}(f(n))
//
in
  list_tabulate<a> (n)
end // end of [list_tabulate_cloref]

(* ****** ****** *)

implement
{x,y}
list_zip (xs, ys) = let
//
typedef xy = @(x, y)
//
implement
list_zipwith$fopr<x,y><xy> (x, y) = @(x, y)
//
in
  $effmask_all (list_zipwith<x,y><xy> (xs, ys))
end // end of [list_zip]

implement
{x,y}{xy}
list_zipwith
  (xs, ys) = let
//
prval () = lemma_list_param (xs)
prval () = lemma_list_param (ys)
//
fun loop
  {m,n:nat} .<m>. (
  xs: list (x, m)
, ys: list (y, n)
, res: &ptr? >> list_vt (xy, min(m,n))
) : void = let
in
//
case+ xs of
| list_cons (x, xs) => (
  case+ ys of
  | list_cons (y, ys) => let
      val xy =
        list_zipwith$fopr<x,y><xy> (x, y)
      // end of [val]
      val () = res :=
        list_vt_cons{xy}{0}(xy, _(*y*))
      val+list_vt_cons
        (xy, res1) = res // res1 = res.1
      val () = loop (xs, ys, res1)
    in
      fold@ (res)
    end // end of [list_cons]
  | list_nil () => (res := list_vt_nil)
  ) // end of [list_cons]
| list_nil () => (res := list_vt_nil)
//
end // end of [loop]
//
var res: ptr
val () = loop (xs, ys, res)
in
  res
end // end of [list_zipwith]

(* ****** ****** *)

implement
{x,y}
list_cross (xs, ys) = let
//
typedef xy = @(x, y)
//
implement
list_crosswith$fopr<x,y><xy> (x, y) = @(x, y)
//
in
  $effmask_all (list_crosswith<x,y><xy> (xs, ys))
end // end of [list_cross]

implement
{x,y}{xy}
list_crosswith (xs, ys) = let
//
prval () = lemma_list_param (xs)
prval () = lemma_list_param (ys)
//
fnx loop1
  {m,n:nat} .<m,0,0>.
(
  xs: list (x, m)
, ys: list (y, n)
, res: &ptr? >> list_vt (xy, m*n)
) : void = let
in
  case+ xs of
  | list_cons
      (x, xs) => loop2 (xs, ys, x, ys, res)
  | list_nil () => (res := list_vt_nil)
end // end of [loop1]

and loop2
  {m,n,n2:nat} .<m,n2,1>.
(
  xs: list (x, m)
, ys: list (y, n)
, x: x, ys2: list (y, n2)
, res: &ptr? >> list_vt (xy, m*n+n2)
) : void = let
in
//
case+ ys2 of
| list_cons
    (y, ys2) => let
    val xy = 
      list_crosswith$fopr<x,y><xy> (x, y)
    // end of [val]
    val () = res :=
      list_vt_cons{xy}{0}(xy, _(*?*))
    val+list_vt_cons (_, res1) = res
    val () = loop2 (xs, ys, x, ys2, res1)
    prval () = mul_gte_gte_gte {m,n} ()
  in
    fold@ (res)
  end // end of [list_cons]
| list_nil () => loop1 (xs, ys, res)
//
end // end of [loop2]
//
var res: ptr
val () = loop1 (xs, ys, res)
//
in
  res
end // end of [list_crosswith]

(* ****** ****** *)

implement
{x}(*tmp*)
list_foreach (xs) = let
  var env: void = () in list_foreach_env<x><void> (xs, env)
end // end of [list_foreach]

implement
{x}{env}
list_foreach_env
  (xs, env) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat} .<n>. (
  xs: list (x, n), env: &env
) : void = let
in
//
case+ xs of
| list_cons (x, xs) => let
    val test =
      list_foreach$cont<x><env> (x, env)
    // end of [val]
  in
    if test then let
      val () = list_foreach$fwork<x><env> (x, env)
    in
      loop (xs, env)
    end else () // end of [if]
  end // end of [list_cons]
| list_nil ((*void*)) => ()
//
end // end of [loop]
//
in
  loop (xs, env)
end // end of [list_foreach_env]

(* ****** ****** *)

implement
{x}{env}
list_foreach$cont (x, env) = true

(* ****** ****** *)

implement
{x}(*tmp*)
list_foreach_fun
  (xs, f) = let
//
fun loop (xs: List(x)): void =
//
case+ xs of
| list_nil () => ()
| list_cons (x, xs) => (f (x); loop (xs))
//
in
  $effmask_all (loop (xs))
end // end of [list_foreach_fun]

implement
{x}(*tmp*)
list_foreach_cloref
  (xs, f) = let
//
fun loop (xs: List(x)): void =
//
case+ xs of
| list_nil () => ()
| list_cons (x, xs) => (f (x); loop (xs))
//
in
  $effmask_all (loop (xs))
end // end of [list_foreach_cloref]

(* ****** ****** *)

implement
{x}(*tmp*)
list_foreach_funenv
  {v}{vt}{fe}
  (pfv | xs, f, env) = let
//
prval () = lemma_list_param (xs)
//
fun loop {n:nat} .<n>. (
  pfv: !v
| xs: list (x, n)
, f: (!v | x, !vt) -<fun,fe> void
, env: !vt
) :<fe> void =
  case+ xs of
  | list_cons (x, xs) => let
      val () = f (pfv | x, env) in loop (pfv | xs, f, env)
    end // end of [list_cons]
  | list_nil ((*void*)) => ()
// end of [loop]
in
  loop (pfv | xs, f, env)
end // end of [list_foreach_funenv]

(* ****** ****** *)

implement
{x,y}(*tmp*)
list_foreach2 (xs, ys) = let
  var env: void = () in list_foreach2_env<x,y><void> (xs, ys, env)
end // end of [list_foreach2]

implement
{x,y}{env}
list_foreach2_env
  (xs, ys, env) = let
//
prval () = lemma_list_param (xs)
prval () = lemma_list_param (ys)
//
fun loop
  {m,n:nat} .<m>. (
  xs: list (x, m), ys: list (y, n), env: &env
) : void = let
in
//
case+ xs of
| list_cons
    (x, xs) => (
  case+ ys of
  | list_cons (y, ys) => let
      val test =
        list_foreach2$cont<x,y><env> (x, y, env)
      // end of [val]
    in
      if test then let
        val () = list_foreach2$fwork<x,y><env> (x, y, env)
      in
        loop (xs, ys, env)
      end else () // end of [if]
    end // end of [list_cons]
  | list_nil () => ()
  ) // end of [list_cons]
| list_nil () => ()
//
end // end of [loop]
//
in
  loop (xs, ys, env)
end // end of [list_foreach2_env]

(* ****** ****** *)

implement
{x,y}{env}
list_foreach2$cont (x, y, env) = true

(* ****** ****** *)

implement
{x}(*tmp*)
list_iforeach (xs) = let
  var env: void = () in list_iforeach_env<x><void> (xs, env)
end // end of [list_iforeach]

implement
{x}{env}
list_iforeach_env
  (xs, env) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat}
  {i:nat} .<n>.
(
  i: int i, xs: list (x, n), env: &env
) : intBtwe(i,n+i) =
  case+ xs of
  | list_cons
      (x, xs) => let
      val test =
        list_iforeach$cont<x><env> (i, x, env)
      // end of [test]
    in
      if test then let
        val () = list_iforeach$fwork<x><env> (i, x, env)
      in
        loop (succ(i), xs, env)
      end else (i) // end of [if]
    end // end of [list_cons]
  | list_nil () => (i) // number of processed elements
// end of [loop]
//
in
  loop (0, xs, env)
end // end of [list_iforeach_env]

(* ****** ****** *)

implement
{x}{env}(*tmp*)
list_iforeach$cont (i, x, env) = true

(* ****** ****** *)

implement
{x}(*tmp*)
list_iforeach_funenv
  {v}{vt}{n}{fe}
  (pfv | xs, f, env) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {i:nat | i <= n} .<n-i>. (
  pfv: !v
| i: int i
, xs: list (x, n-i)
, f: (!v | natLt(n), x, !vt) -<fun,fe> void
, env: !vt
) :<fe> int n =
  case+ xs of
  | list_cons (x, xs) => let
      val () = f (pfv | i, x, env) in loop (pfv | i+1, xs, f, env)
    end // end of [list_cons]
  | list_nil () => i // = size(xs)
// end of [loop]
in
  loop (pfv | 0, xs, f, env)
end // end of [list_iforeach_funenv]

(* ****** ****** *)

implement
{x,y}(*tmp*)
list_iforeach2
  (xs, ys) = let
  var env: void = ()
in
  list_iforeach2_env<x,y><void> (xs, ys, env)
end // end of [list_iforeach2]

implement
{x,y}{env}
list_iforeach2_env
  (xs, ys, env) = let
//
prval () = lemma_list_param (xs)
prval () = lemma_list_param (ys)
//
fun loop
  {m,n:nat}{i:nat} .<m>.
(
  i: int i, xs: list (x, m), ys: list (y, n), env: &env
) : intBtwe(i, min(m,n)+i) = let
in
//
case+ xs of
| list_cons (x, xs) => (
  case+ ys of
  | list_cons (y, ys) => let
      val test =
        list_iforeach2$cont<x,y><env> (i, x, y, env)
      // end of [val]
    in
      if test then let
        val () = list_iforeach2$fwork<x,y><env> (i, x, y, env)
      in
        loop (succ(i), xs, ys, env)
      end else (i) // end of [if]
    end // end of [list_cons]
  | list_nil () => i // the number of processed elements
  ) // end of [list_cons]
| list_nil () => i // the number of processed elements
//
end // end of [loop]
//
in
  loop (0, xs, ys, env)
end // end of [list_iforeach2_env]

(* ****** ****** *)

implement
{x,y}{env}
list_iforeach2$cont (i, x, y, env) = true

(* ****** ****** *)

implement
{res}{x}
list_foldleft (xs, ini) = let
//
prval () = lemma_list_param (xs)
//
fun loop
  {n:nat} .<n>.
(
  xs: list (x, n), acc: res
) : res =
  case+ xs of
  | list_nil () => acc
  | list_cons (x, xs) => let
      val acc =
        list_foldleft$fopr<res><x> (acc, x)
      // end of [val]
    in
      loop (xs, acc)
    end // end of [list_cons]
// end of [loop]
//
in
  loop (xs, ini)
end // end of [list_foldleft]

(* ****** ****** *)

implement
{x}{res}
list_foldright (xs, snk) = let
//
prval () = lemma_list_param (xs)
//
fun aux
  {n:nat} .<n>.
(
  xs: list (x, n), acc: res
) : res =
  case+ xs of
  | list_nil () => acc
  | list_cons (x, xs) =>
      list_foldright$fopr<x><res> (x, aux (xs, acc))
    // end of [list_cons]
// end of [aux]
//
in
  aux (xs, snk)
end // end of [list_foldright]

(* ****** ****** *)

implement
{a}(*tmp*)
list_mergesort$cmp
  (x1, x2) = gcompare_val_val<a> (x1, x2)
// end of [list_mergesort$cmp]

implement
{a}(*tmp*)
list_mergesort
  (xs) = let
//
val xs = list_copy<a> (xs)
//
implement
list_vt_mergesort$cmp<a>
  (x1, x2) = list_mergesort$cmp<a> (x1, x2)
//
in
  list_vt_mergesort<a> (xs)
end // end of [list_mergesort]

(* ****** ****** *)

implement
{a}(*tmp*)
list_mergesort_fun
  (xs, cmp) = let
//
implement
{a2}(*tmp*)
list_mergesort$cmp
  (x1, x2) = let
//
typedef cmp2 = cmpval(a2)
//
val cmp2 = $UN.cast{cmp2}(cmp) in cmp2 (x1, x2)
//
end // end of [list_mergesort$cmp]
//
in
  list_mergesort<a> (xs)
end // end of [list_mergesort_fun]

implement
{a}(*tmp*)
list_mergesort_cloref
  (xs, cmp) = let
//
implement
{a2}(*tmp*)
list_mergesort$cmp
  (x1, x2) = let
//
typedef cmp2 = (a2, a2) -<cloref> int
//
val cmp2 = $UN.cast{cmp2}(cmp) in cmp2 (x1, x2)
//
end // end of [list_mergesort$cmp]
//
in
  list_mergesort<a> (xs)
end // end of [list_mergesort_cloref]

(* ****** ****** *)

implement
{a}(*tmp*)
list_quicksort$cmp
  (x1, x2) = gcompare_val_val<a> (x1, x2)
// end of [list_quicksort$cmp]

implement
{a}(*tmp*)
list_quicksort
  (xs) = let
//
val xs = list_copy<a> (xs)
//
implement
list_vt_quicksort$cmp<a>
  (x1, x2) = list_quicksort$cmp<a> (x1, x2)
//
in
  list_vt_quicksort<a> (xs)
end // end of [list_quicksort]

(* ****** ****** *)

implement
{a}(*tmp*)
list_quicksort_fun
  (xs, cmp) = let
//
implement
{a2}(*tmp*)
list_quicksort$cmp
  (x1, x2) = let
//
val cmp = $UN.cast{cmpval(a2)}(cmp) in cmp (x1, x2)
//
end // end of [list_quicksort$cmp]
//
in
  list_quicksort<a> (xs)
end // end of [list_quicksort_fun]

(* ****** ****** *)

(* end of [list.dats] *)

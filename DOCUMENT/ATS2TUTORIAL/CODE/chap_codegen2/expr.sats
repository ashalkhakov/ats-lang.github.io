(*
** For ATS2TUTORIAL
*)

(* ****** ****** *)
//
datatype expr =
  | Int of int
  | Var of string
  | Add of (expr, expr)
  | Sub of (expr, expr)
  | Mul of (expr, expr)
  | Div of (expr, expr)
  | Ifgtz of (expr, expr, expr) // if expr > 0 then ... else ...
  | Ifgtez of (expr, expr, expr) // if expr >= 0 then ... else ...
//
(* ****** ****** *)

fun{} datcon_expr : (expr) -> string
fun{} datcontag_expr : (expr) -> intGte(0)

(* ****** ****** *)
//
fun{} fprint_expr : (FILEref, expr) -> void
//
(* ****** ****** *)

(* end of [expr.sats] *)

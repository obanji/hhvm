(**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

open Typing_defs

module Env = Typing_env
module TDef = Typing_tdef
module N = Nast

(*****************************************************************************)
(* Check if a comparison is trivially true or false *)
(*****************************************************************************)

let assert_nontrivial p bop env ty1 ty2 =
  let _, ty1 = Env.expand_type env ty1 in
  let _, ty1, trail1 = TDef.force_expand_typedef env ty1 in
  let _, ty2 = Env.expand_type env ty2 in
  let _, ty2, trail2 = TDef.force_expand_typedef env ty2 in
  let trivial_result = match bop with
    | Ast.EQeqeq -> "false"
    | Ast.Diff2 -> "true"
    | _ -> assert false in
  match ty1, ty2 with
  | (_, Tprim N.Tnum),               (_, Tprim (N.Tint | N.Tfloat))
  | (_, Tprim (N.Tint | N.Tfloat)),  (_, Tprim N.Tnum)
  | (_, Tprim N.Tarraykey),          (_, Tprim (N.Tint | N.Tstring))
  | (_, Tprim (N.Tint | N.Tstring)), (_, Tprim N.Tarraykey) -> ()
  | (r, Tprim N.Tvoid), _
  | _, (r, Tprim N.Tvoid) ->
      (* Ideally we shouldn't hit this case, but well... *)
      Errors.void_usage p (Reason.to_string ("This is void") r)
  | (r1, (Tprim a as ty1)), (r2, (Tprim b as ty2)) when a <> b ->
      let tys1 = Typing_print.error ty1 in
      let tys2 = Typing_print.error ty2 in
      Errors.trivial_strict_eq p trivial_result
        (Reason.to_string ("This is " ^ tys1) r1)
        (Reason.to_string ("This is " ^ tys2) r2)
        trail1 trail2
  | _ -> ()

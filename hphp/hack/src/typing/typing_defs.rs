// Copyright (c) Facebook, Inc. and its affiliates.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the "hack" directory of this source tree.
pub use crate::typing_defs_core::*;
use bumpalo::collections::Vec as BVec;
use oxidized::ident::Ident;
use oxidized::pos::Pos;
use typing_collections_rust::SMap;

pub struct ExpandEnv<'a> {
    /// A list of the type defs and type access we have expanded thus far. Used
    /// to prevent entering into a cycle when expanding these types
    pub type_expansions: BVec<'a, (Pos, String)>,
    pub substs: SMap<'a, Ty<'a>>,
    // TODO(hrust) missing fields
}

impl Ty<'_> {
    pub fn get_var(&self) -> Option<Ident> {
        match self.get_node() {
            Ty_::Tvar(v) => Some(*v),
            _ => None,
        }
    }
}

impl InternalType_<'_> {
    pub fn get_var(&self) -> Option<Ident> {
        match self {
            InternalType_::LoclType(ty) => ty.get_var(),
            InternalType_::ConstraintType(_) => None,
        }
    }
}

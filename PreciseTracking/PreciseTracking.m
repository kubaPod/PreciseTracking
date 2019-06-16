
(* ::Chapter:: *)
(* Metadata*)


(* Mathematica Package *)

(* :Title: PreciseTracking *)
(* :Context: PreciseTracking` *)
(* :Author: Kuba Podkalicki (kuba.pod@gmail.com) *)
(* :Date: Mon 17 Jun 2019 00:55:33 *)

(* :Keywords: *)
(* :Discussion: *)



(* ::Chapter:: *)
(* Begin package*)


BeginPackage["PreciseTracking`"];


ClearAll["`*", "`*`*"]

  ToTrackedAssociation;
  PreciseDynamic;

Begin["`Private`"];

  If[ Not @ TrueQ @ AssociationQ @ $TrackedTargets
    ,  $TrackedTargets = <||>
  ];

  TrackTarget // Attributes = {HoldAll, Listable};

  TrackTarget[sym_[key_]]:= Catch @ With[
    { id   = First @ ValueTrack`GetTrackingState[]
    , bin := $TrackedTargets
    , root = Hold[sym]
    }
  , Lookup[bin, root, bin[root]=<|key -> {id}|>; Throw @ {id} ] (*initialize storage if needed*)
  ; If[
      FreeQ[id] @ Lookup[bin[root], key, bin[root, key] = {}]
    , AppendTo[bin[root, key], id]
    ]
  ]

  UpdateTarget // Attributes = HoldAll;

  UpdateTarget[sym_[key_]]:= With[
    { root = Hold[sym]
    , bin := $TrackedTargets
    }
  , { ids = Lookup[bin[root], key, {}] /. {} :> Return[Null, With]}

  , bin[root, key] = {}
  ; CallPacket @ FrontEndExecute @ FrontEnd`UpdateDynamicObjects @ ids
  ]



  PreciseDynamic // Attributes = HoldAll;

  PreciseDynamic[expr_, target_]:= Dynamic[TrackTarget[target]; expr, TrackedSymbols:>{}];

  PreciseDynamic[sym_[key_]]:= PreciseDynamic[sym[key],sym[key]]



  ToTrackedAssociation // Attributes = {HoldFirst};

  ToTrackedAssociation[sym_Symbol]:=Module[
    {   $inside = False }
    , sym /: Set[sym[key_], val_] /; !TrueQ@$inside :=Block[
      {$inside = True, $old = sym[key]}
      , sym[key]=val
      ; If[ $old != val, UpdateTarget[sym[key]] ]
      ; val
    ]
  ]

End[];

EndPackage[];
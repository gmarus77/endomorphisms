/***
 *  Number field functionality and attributes
 *
 *  Copyright (C) 2016-2017
 *            Edgar Costa      (edgarcosta@math.dartmouth.edu)
 *            Davide Lombardo  (davide.lombardo@math.u-psud.fr)
 *            Jeroen Sijsling  (jeroen.sijsling@uni-ulm.de)
 *
 *  See LICENSE.txt for license details.
 */


declare attributes FldNum : base, base_gen, CC, iota, aut;
declare attributes FldRat : base, base_gen, CC, iota, aut;

forward ExtendNumberFieldExtraStep;
forward ExtendSplittingFieldExtraStep;
forward ExtendSplittingFieldExtraStepQQ;
forward ExtendSplittingFieldExtraStepGen;


intrinsic IsQQ(K::Fld) -> BoolElt
{Returns whether or not the field K equals QQ.}

return Type(K) eq FldRat;

end intrinsic;


intrinsic BaseFieldExtra(K::Fld) -> Fld, .
{Returns distinguished subfield of K and the map to it.}

F := K`base;
if IsQQ(F) then
    FinK := F;
    h := hom< F -> FinK | >;
    hFK := hom< F -> K | >;
else
    FinK := sub< K | K`base_gen >;
    h := hom< F -> FinK | K`base_gen >;
    hFK := hom< F -> K | K`base_gen >;
end if;
return F, hFK, FinK, h;

end intrinsic;


intrinsic FieldDescriptionExtra(K::Fld) -> SeqEnum
{Returns a list describing the field K.}

/* Less structured fields encountered in endomorphism lattice */
if not assigned K`base then
    return [ Rationals() ! c : c in Eltseq(MinimalPolynomial(K.1)) ];
end if;
/* Now fields with extra structure */
_, _, F := BaseFieldExtra(K);
if IsQQ(F) then
    return [ Rationals() ! c : c in Eltseq(MinimalPolynomial(K.1)) ];
else
    return [ [ Rationals() ! c : c in Eltseq(F ! coeff) ] : coeff in Eltseq(MinimalPolynomial(K.1, F)) ];
end if;

end intrinsic;


intrinsic ElementDescriptionExtra(r::.) -> .
{Returns a list describing the field element r.}

K := Parent(r);
if IsQQ(K`base) then
    return [ Rationals() ! c : c in Eltseq(r) ];
else
    return [ [ Rationals() ! c : c in Eltseq(d) ] : d in Eltseq(r) ];
end if;

end intrinsic;


intrinsic InfinitePlacesExtra(K::Fld) -> SeqEnum
{The infinite places of K, not taken up to complex conjugation, represented by the roots of the generator in the associated complex field.}

return [ K`CC ! tup[1] : tup in Roots(MinimalPolynomial(K.1), ComplexField(Precision(K`CC) + 20)) ];

end intrinsic;


intrinsic EmbedExtra(r::., iota::.) -> .
{Evaluates infinite place.}

seq := Eltseq(r);
return &+[ seq[i]*iota^(i - 1) : i in [1..#seq] ];

end intrinsic;


intrinsic EmbedMatrixExtra(M::., iota::.) -> .
{Evaluates infinite place.}

return Matrix([ [ EmbedExtra(r, iota) : r in Eltseq(row) ] : row in Rows(M) ]);

end intrinsic;


intrinsic RationalsExtra(prec::RngIntElt) -> FldNum
{Returns the number field defined by f along with an infinite place.}

K := Rationals();
K`base := K; K`base_gen := K ! 1;
K`CC := ComplexFieldExtra(prec);
K`iota := InfinitePlacesExtra(K)[1];
return K;

end intrinsic;


intrinsic NumberFieldExtra(f::RngUPolElt) -> FldNum
{Returns the number field defined by f over the base of f, which is itself assumed to be a NumberFieldExtra. The field is simplified and a root is returned separately.}

K := BaseRing(f);
Lrel<r> := NumberField(f);
L := AbsoluteField(Lrel);
L`base := K; L`base_gen := L ! Lrel ! K.1;
L`CC := K`CC;

/* Inclusion map */
if IsQQ(K) then
    hKL := hom< K -> L | >;
else
    hKL := hom< K -> L | L ! Lrel ! K.1 >;
end if;
L`iota := AscendInfinitePlace(K, L, hKL);

/* Final improvement step before returning root */
L0, hLL0 := ImproveFieldExtra(L);
return L0, hLL0(L ! r), hKL * hLL0;

end intrinsic;


intrinsic EmbedPolynomialExtra(f::RngUPolElt) -> RngUPolElt
{Returns the polynomial f considered as a complex polynomial to precision
prec.}

K := BaseRing(f);
RCC := PolynomialRing(K`CC);
if IsZero(f) then
    return RCC ! 0;
else
    prec := Precision(BaseRing(RCC));
    mons := Monomials(f);
    return &+[ EmbedExtra(MonomialCoefficient(f, mon), K`iota) * RCC.1^Degree(mon) : mon in mons ];
end if;

end intrinsic;


intrinsic EmbedPolynomialExtra(f::RngMPolElt) -> RngMPolElt
{Returns the polynomial f considered as a complex polynomial to precision
prec.}

K := BaseRing(Parent(f));
RCC := PolynomialRing(K`CC, #GeneratorsSequence(Parent(f)));
if IsZero(f) then
    return RCC ! 0;
else
    prec := Precision(BaseRing(RCC));
    mons := Monomials(f);
    return &+[ EmbedExtra(MonomialCoefficient(f, mon), K`iota) * Monomial(RCC, Exponents(mon)) : mon in mons ];
end if;

end intrinsic;


intrinsic EmbedPolynomialExtras(fs::SeqEnum) -> SeqEnum
{Returns the list of polynomials fs considered as complex polynomials to
precision prec.}

return [ EmbedPolynomialExtra(f) : f in fs ];

end intrinsic;


intrinsic DescendInfinitePlace(L::Fld, K::Fld, h::Map) -> Fld
{Descends infinite place from codomain L to domain K of h.}

assert K eq Domain(h);
assert L eq Codomain(h);
assert Precision(K`CC) eq Precision(L`CC);
CC := K`CC; genK := K.1; genL := h(K.1);
for iotaK in InfinitePlacesExtra(K) do
    genKCC := CC ! EmbedExtra(genK, iotaK);
    genLCC := CC ! EmbedExtra(genL, L`iota);
    if Abs(genKCC - genLCC) lt CC`epscomp then
        return iotaK;
    end if;
end for;
error "Failed to descend infinite place";

end intrinsic;


intrinsic AscendInfinitePlace(K::Fld, L::Fld, h::Map) -> Fld
{Ascends infinite place from domain K to codomain L of h.}

assert K eq Domain(h);
assert L eq Codomain(h);
assert Precision(K`CC) eq Precision(L`CC);
CC := K`CC; genK := K.1; genL := h(K.1);
for iotaL in InfinitePlacesExtra(L) do
    genKCC := CC ! EmbedExtra(genK, K`iota);
    genLCC := CC ! EmbedExtra(genL, iotaL);
    if Abs(genKCC - genLCC) lt CC`epscomp then
        return iotaL;
    end if;
end for;
error "Failed to ascend infinite place";

end intrinsic;


intrinsic DescendAttributesExtra(L::Fld, K::Fld, h::Map)
{Descend the attributes from L to K using the homomorphism h.}

assert K eq Domain(h);
assert L eq Codomain(h);
K`base := L`base; K`base_gen := CoerceToSubfieldElement(L`base_gen, L, K, h);
K`CC := L`CC; CC := K`CC;
K`iota := DescendInfinitePlace(L, K, h);

end intrinsic;


intrinsic AscendAttributesExtra(L::Fld, K::Fld, h::Map)
{Ascend the attributes from K to L using the homomorphism h.}

assert K eq Domain(h);
assert L eq Codomain(h);
L`base := K`base; L`base_gen := h(K`base_gen);
L`CC := K`CC; CC := L`CC;
L`iota := AscendInfinitePlace(L, K, h);

end intrinsic;


intrinsic TransferAttributesExtra(K::Fld, L::Fld, h::Map)
{Transfer the attributes from K to L using the homomorphism h.}

assert K eq Domain(h);
assert L eq Codomain(h);
L`base := K`base;
L`base_gen := h(K`base_gen);
L`CC := K`CC; CC := K`CC;
if IsQQ(K) then
    L`iota := InfinitePlacesExtra(L)[1]; return;
end if;
for iotaL in InfinitePlacesExtra(L) do
    evL := EmbedExtra(h(K.1), iotaL);
    evK := EmbedExtra(K.1, K`iota);
    if Abs(evL - evK) lt CC`epscomp then
        L`iota := iotaL; return;
    end if;
end for;

end intrinsic;


intrinsic CanonicalInclusionMap(K::Fld, L::Fld) -> Map
{Gives the canonical inclusion map from K into L, usually obtained by defining L as a NumberField over K.}

if IsQQ(K) then
    return hom< K -> L | >;
else
    assert IsSubfield(K, L);
    return hom< K -> L | L ! K.1 >;
end if;

end intrinsic;


intrinsic SubfieldExtra(L::Fld, seq::.) -> .
{Gives subfield of L generated by seq.}

if IsQQ(L) then
    K := L;
    h := hom< K -> L | >;
    return K, h;
else
    K := sub< L | seq >; hKL := CanonicalInclusionMap(K, L);
    if IsQQ(K) then
        DescendAttributesExtra(L, K, hKL);
        return K, hKL;
    end if;
    K0, hKK0 := Polredbestabs(K);
    hKK0i := Inverse(hKK0);
    hK0L := hom< K0 -> L | hKL(hKK0i(K0.1)) >;
    DescendAttributesExtra(L, K0, hK0L);
    return K0, hK0L;
end if;

end intrinsic;


intrinsic ImproveFieldExtra(K::Fld) -> Fld, Map
{Polredbestabs plus attribute transfer. Returns the isomorphism.}

K0, hKK0 := Polredbestabs(K);
TransferAttributesExtra(K, K0, hKK0);
return K0, hKK0;

end intrinsic;


intrinsic FixedFieldExtra(L::Fld, gens::SeqEnum) -> Fld
{Returns the fixed subfield K of L under the automorphisms in gens, along with the inclusion of K in L.}

if #gens eq 0 then
    return L;
end if;
dL := Degree(L);
Ms := [ Matrix([ Eltseq(gen(L.1^i) - L.1^i) : i in [0..(dL - 1)] ]) : gen in gens ];
Ker := &meet[ Kernel(M) : M in Ms ];
B := [ &+[ b[i + 1]*L.1^i : i in [0..(dL - 1)] ] : b in Basis(Ker) ];
return SubfieldExtra(L, B);

end intrinsic;


intrinsic FixedGroupExtra(L::Fld, K::Fld, h::.) -> .
{More stable and precise version of FixedGroup: h is the inclusion of K into L.}

Gp, Gf, Gphi := AutomorphismGroupPari(L);
if IsQQ(L) then
    return Gp;
else
    r := h(K.1);
    return sub< Gp | [ g : g in Gp | (Gphi(g))(r) eq r ] >;
end if;

end intrinsic;


intrinsic ConjugatePolynomial(h::Map, f::RngUPolElt) -> RngUPolElt
{Returns the transformation of the univariate polynomial f by the map h.}

K := Domain(h); L := Codomain(h); S := PolynomialRing(L);
return &+[ h(Coefficient(f, i))*S.1^i : i in [0..Degree(f)] ];

end intrinsic;


intrinsic ConjugateMatrix(h::Map, M::.) -> .
{Returns the transformation of the matrix M by the map h.}

return Matrix([ [ h(elt) : elt in Eltseq(row) ] : row in Rows(M) ]);

end intrinsic;


intrinsic NumberFieldExtra(aCCs::SeqEnum[FldComElt], F::Fld) -> Fld, SeqEnum
{Given complex number aCCs and a NumberFieldExtra F, finds the number field generated by the elements of aCCs and realizes said elements in that field.}

if #aCCs eq 0 then
    return F, [ ];
end if;

/* Initiate and make sure that the field of K is good for comparison purposes */
K := F; K`base := K; K`base_gen := K.1;
assert Precision(Parent(aCCs[1])) ge Precision(K`CC);

/* Iterative extension */
tupsa := [ ];
for aCC in aCCs do
    Knew, tupsa := ExtendNumberFieldExtraStep(K, tupsa, aCC);
    if Knew ne K then
        vprint EndoFind : "";
        vprint EndoFind : "After extension:";
        vprint EndoFind : Knew;
        vprint EndoFind : "";
    end if;
    K := Knew;
end for;

/* Sanity check before returning */
F := K`base; CC := K`CC;
genFCC0 := CC ! EmbedExtra(F.1, F`iota);
genFCC1 := CC ! EmbedExtra(K`base_gen, K`iota);
assert Abs(genFCC1 - genFCC0) lt CC`epscomp;
for tupa in tupsa do
    aCC0 := CC ! tupa[2];
    aCC1 := CC ! EmbedExtra(tupa[1], K`iota);
    assert Abs(aCC1 - aCC0) lt CC`epscomp;
end for;
return K, [ tupa[1] : tupa in tupsa ];

end intrinsic;


intrinsic ExtendNumberFieldExtra(K::Fld, aCCs::SeqEnum[FldComElt]) -> Fld, SeqEnum
{Given complex number aCCs and a NumberFieldExtra K, finds the number field generated by the elements of aCCs and realizes said elements in that field. This is the base field fixing version of NumberFieldExtra.}

if #aCCs eq 0 then
    return K, [ ], CanonicalInclusionMap(K, K);
end if;

/* Initiate and make sure that the field of K is good for comparison purposes */
L := K; h := CanonicalInclusionMap(K, K);
assert Precision(Parent(aCCs[1])) ge Precision(L`CC);

/* Iterative extension */
tupsa := [ ];
for aCC in aCCs do
    Lnew, tupsa, hnew := ExtendNumberFieldExtraStep(L, tupsa, aCC);
    if Lnew ne L then
        h := h*hnew;
        vprint EndoFind : "";
        vprint EndoFind : "After extension:";
        vprint EndoFind : Lnew;
        vprint EndoFind : "";
    end if;
    L := Lnew;
end for;

/* Sanity check before returning */
F := L`base; CC := L`CC;
genFCC0 := CC ! EmbedExtra(F.1, F`iota);
genFCC1 := CC ! EmbedExtra(L`base_gen, L`iota);
assert Abs(genFCC1 - genFCC0) lt CC`epscomp;
for tupa in tupsa do
    aCC0 := CC ! tupa[2];
    aCC1 := CC ! EmbedExtra(tupa[1], L`iota);
    assert Abs(aCC1 - aCC0) lt CC`epscomp;
end for;
return L, [ tupa[1] : tupa in tupsa ], h;

end intrinsic;


function ExtendNumberFieldExtraStep(K, tupsa, anewCC : minpolQQ := 0)
// Let K be a NumberFieldExtra with elements tupsa, and let anewCC be a complex
// number. This function returns the field generated by K and anewCC, and
// transports tupsa to that field.

/* Determine minimal polynomial over K */
gK, gQQ := MinimalPolynomialExtra(anewCC, K : minpolQQ := minpolQQ);
if Degree(gK) eq 1 then
    anew := -Coefficient(gK, 0)/Coefficient(gK, 1);
    Append(~tupsa, <anew, anewCC>);
    return K, tupsa, CanonicalInclusionMap(K, K);
end if;

/* Information about the base needed later */
F := K`base; genFCC0 := EmbedExtra(F.1, F`iota);
CC := K`CC;

/* Get absolute field and we need an iso that respects results so far */
Lrel := NumberField(gK);
Labs := AbsoluteField(Lrel);
L, h := Polredbestabs(Labs);
//L := Labs; h := hom< L -> L | L.1 >;
anew := h(Labs ! Lrel.1);
f := MinimalPolynomial(K.1);
rtsf := RootsPari(f, L);
L`CC := CC; L`base := F;

/* Choose compatible root */
for rtf in rtsf do
    if IsQQ(K) then
        h := hom< K -> L | >;
    else
        h := hom< K -> L | rtf >;
    end if;
    L`base_gen := h(K`base_gen);

    for iotaL in InfinitePlacesExtra(L) do
        test := true;

        /* First test: generator of F */
        genFCC1 := EmbedExtra(L`base_gen, iotaL);
        if not Abs(genFCC1 - genFCC0) lt CC`epscomp then
            test := false;
        end if;

        /* Second test: old a */
        for tupa in tupsa do
            a := tupa[1]; aCC0 := tupa[2];
            aCC1 := EmbedExtra(h(a), iotaL);
            if not Abs(aCC1 - CC ! aCC0) lt CC`epscomp then
                test := false;
                break;
            end if;
        end for;

        /* Third test: new a */
        anewCC1 := EmbedExtra(anew, iotaL);
        if not Abs(anewCC1 - CC ! anewCC) lt CC`epscomp then
            test := false;
        end if;

        if test then
            L`iota := iotaL;
            newa := < anew, anewCC >;
            tupsa := [ < h(tupa[1]), tupa[2] > : tupa in tupsa ] cat [ newa ];
            return L, tupsa, h;
        end if;
    end for;
end for;
error "Failed to find a relative number field";

end function;


intrinsic ExtendNumberFieldExtra(f::RngUPolElt) -> .
{Let f be a polynomial over the NumberFieldExtra K. This function returns the field generated by g with the same base, a root, and an inclusion from K into the new field. This is the base field fixing version of NumberFieldExtra.}

K := BaseRing(f);
Lrel<r> := NumberField(f);
L := AbsoluteField(Lrel);
L`base := K`base; L`base_gen := L ! Lrel ! K`base_gen;
L`CC := K`CC;

/* Inclusion map */
if IsQQ(K) then
    hKL := hom< K -> L | >;
else
    hKL := hom< K -> L | L ! Lrel ! K.1 >;
end if;
L`iota := AscendInfinitePlace(K, L, hKL);

/* Final improvement step before returning root */
L0, hLL0 := ImproveFieldExtra(L);
return L0, hLL0(L ! r), hKL * hLL0;

end intrinsic;


intrinsic SplittingFieldExtra(aCCs::SeqEnum[FldComElt], F::Fld) -> Fld, SeqEnum
{Given complex number aCCs and a NumberFieldExtra F, finds the splitting field generated by the elements of aCCs and realizes said elements in that field.}

if #aCCs eq 0 then
    return F, [ ];
end if;

/* Initiate and make sure that the field of K is good for comparison purposes */
K := F; K`base := K; K`base_gen := K.1;
assert Precision(Parent(aCCs[1])) ge Precision(K`CC);

/* Iterative extension */
tupsa := [ ];
for aCC in aCCs do
    Knew, tupsa := ExtendSplittingFieldExtraStep(K, tupsa, aCC);
    if Knew ne K then
        vprint EndoFind : "";
        vprint EndoFind : "After extension:";
        vprint EndoFind : Knew;
        vprint EndoFind : "";
    end if;
    K := Knew;
end for;

/* Sanity check before returning */
F := K`base; CC := K`CC;
genFCC0 := CC ! EmbedExtra(F.1, F`iota);
genFCC1 := CC ! EmbedExtra(K`base_gen, K`iota);
assert Abs(genFCC1 - genFCC0) lt CC`epscomp;
for tupa in tupsa do
    aCC0 := CC ! tupa[2];
    aCC1 := CC ! EmbedExtra(tupa[1], K`iota);
    assert Abs(aCC1 - aCC0) lt CC`epscomp;
end for;
return K, [ tupa[1] : tupa in tupsa ];

end intrinsic;


function ExtendSplittingFieldExtraStep(K, tupsa, anewCC)
// Let K be a SplittingFieldExtra with elements tupsa, and let anewCC be a
// complex number. This function returns the splitting field generated by K and
// anewCC, and transports tupsa to that field.

if IsQQ(K`base) then
    return ExtendSplittingFieldExtraStepQQ(K, tupsa, anewCC);
end if;
return ExtendSplittingFieldExtraStepGen(K, tupsa, anewCC);

end function;


function ExtendSplittingFieldExtraStepQQ(K, tupsa, anewCC : minpolQQ := 0)
// Let K be a SplittingFieldExtra with elements tupsa, and let anewCC be a
// complex number. This function returns the splitting field generated by K and
// anewCC, and transports tupsa to that field.

/* Determine minimal polynomial over K */
gK, gQQ := MinimalPolynomialExtra(anewCC, K : minpolQQ := minpolQQ);
if Degree(gK) eq 1 then
    anew := -Coefficient(gK, 0)/Coefficient(gK, 1);
    Append(~tupsa, <anew, anewCC>);
    return K, tupsa;
end if;

/* Information about the base needed later */
F := K`base; genFCC0 := EmbedExtra(F.1, F`iota);
CC := K`CC;

/* Get absolute field and we need an iso that respects results so far */
Lrel := Compositum(K, SplittingFieldPari(gQQ));
Labs := AbsoluteField(Lrel);
L, h := Polredbestabs(Labs);
rtsg := RootsPari(gQQ, L);
f := MinimalPolynomial(K.1);
rtsf := RootsPari(f, L);
L`CC := CC; L`base := F;

/* Choose compatible root */
for rtf in rtsf do
    if IsQQ(K) then
        h := hom< K -> L | >;
    else
        h := hom< K -> L | rtf >;
    end if;
    L`base_gen := h(K`base_gen);

    for iotaL in InfinitePlacesExtra(L) do
        test := true;

        /* First test: generator of F */
        genFCC1 := EmbedExtra(L`base_gen, iotaL);
        if not Abs(genFCC1 - genFCC0) lt CC`epscomp then
            test := false;
        end if;

        /* Second test: old a */
        for tupa in tupsa do
            a := tupa[1]; aCC0 := tupa[2];
            aCC1 := EmbedExtra(h(a), iotaL);
            if not Abs(aCC1 - CC ! aCC0) lt CC`epscomp then
                test := false;
                break;
            end if;
        end for;

        /* Third test: new a */
        if test then
            test := false;
            for rtg in rtsg do
                anewCC1 := EmbedExtra(rtg, iotaL);
                if Abs(anewCC1 - CC ! anewCC) lt CC`epscomp then
                    test := true;
                    anew := rtg;
                end if;
            end for;
        end if;

        if test then
            L`iota := iotaL;
            newa := < anew, anewCC >;
            tupsa := [ < h(tupa[1]), tupa[2] > : tupa in tupsa ] cat [ newa ];
            return L, tupsa;
        end if;
    end for;
end for;
error "Failed to find a root in ExtendSplittingFieldExtraStepQQ";

end function;


function ExtendSplittingFieldExtraStepGen(K, tupsa, anewCC)
// Let K be a SplittingFieldExtra with elements tupsa, and let anewCC be a
// complex number. This function returns the splitting field generated by K and
// anewCC, and transports tupsa to that field.

gK, gQQ := MinimalPolynomialExtra(anewCC, K);
CC := Parent(anewCC); aCCs := [ tup[1] : tup in Roots(gQQ, CC) ];
tupsaadd := [ ]; tupsanew := tupsa;
for aCC in aCCs do
    K, tupsanew := ExtendNumberFieldExtraStep(K, tupsanew, aCC : minpolQQ := gQQ);
    Append(~tupsaadd, tupsanew[#tupsanew]);
end for;
for tupa in tupsaadd do
    if Abs(tupa[2] - anewCC) lt CC`epscomp then
        return K, tupsanew[1..#tupsa] cat [ tupa ];
    end if;
end for;
error "Failed to find a root in ExtendSplittingFieldExtraStepGen";

end function;


intrinsic CoerceToSubfieldElement(a::., L::Fld, K::Fld, h::Map) -> .
{Realizes a as an element of K.}

assert K eq Domain(h);
assert L eq Codomain(h);
if IsQQ(K) then
    return K ! a;
else
    return a @@ h;
end if;

end intrinsic;


intrinsic CoerceToSubfieldPolynomial(f::., L::Fld, K::Fld, h::Map) -> .
{Realizes f as a polynomial over K.}

assert K eq Domain(h);
assert L eq Codomain(h);
if Type(f) eq RngUPolElt then
    coeffs := Coefficients(f);
    coeffs0 := [ CoerceToSubfieldElement(c, L, K, h) : c in coeffs ];
    return Polynomial(coeffs0);

elif Type(f) eq RngMPolElt then
    mons := Monomials(f);
    R := PolynomialRing(K, #GeneratorsSequence(Parent(f)));
    if IsZero(f) then
        return R ! 0;
    else
        return &+[ CoerceToSubfieldElement(MonomialCoefficient(f, mon), L, K, h) * Monomial(R, Exponent(mon)) : mon in mons ];
    end if;
end if;

end intrinsic;


intrinsic CoerceToSubfieldMatrix(M::., L::Fld, K::Fld, h::Map) -> .
{Realizes M as a matrix over K.}

return Matrix([ [ CoerceToSubfieldElement(a, L, K, h) : a in Eltseq(row) ] : row in Rows(M) ]);

end intrinsic;


intrinsic CompositumExtra(K::Fld, L::Fld : Compat := true) -> Fld
{Returns the compositum of the fields K and L over their common base field, by
taking the splitting field of the polynomial defining L to extend K. We require
L to be normal over the base.}

if IsQQ(K) and IsQQ(L) then
    M := K;
    hKM := hom<K -> M | >;
    hLM := hom<L -> M | >;
    return M, [* hKM, hLM *];
elif IsQQ(K) then
    M := L;
    hKM := hom<K -> M | >;
    hLM := hom<L -> M | L.1>;
    return M, [* hKM, hLM *];
elif IsQQ(L) then
    M := K;
    hKM := hom<K -> M | K.1>;
    hLM := hom<L -> M | >;
    return M, [* hKM, hLM *];
end if;

F, _, FinK, hFK := BaseFieldExtra(K);
F, _, FinL, hFL := BaseFieldExtra(L);

/* Find minimal polynomial of both fields over the base */
fK := MinimalPolynomial(K.1, FinK);
fL := MinimalPolynomial(L.1, FinL);
fLF := CoerceToSubfieldPolynomial(fL, FinL, F, hFL);
fKF := CoerceToSubfieldPolynomial(fK, FinK, F, hFK);

/* Take corresponding root and remember old one as well */
fLK := ConjugatePolynomial(hFK, fLF);
g := Factorization(fLK, K)[1][1];
M, rL, hKM := ExtendNumberFieldExtra(g);
hLM := hom< L -> M | rL >;

if not Compat then
    return M, [* hKM, hLM *];
end if;

/* Take place compatible with both previous ones */
CC := K`CC; genK := hKM(K.1); genL := hLM(L.1);
genKCC0 := CC ! EmbedExtra(K.1, K`iota);
genLCC0 := CC ! EmbedExtra(L.1, L`iota);
for iotaM in InfinitePlacesExtra(M) do
    genKCC := CC ! EmbedExtra(genK, iotaM);
    genLCC := CC ! EmbedExtra(genL, iotaM);
    if Abs(genKCC - genKCC0) lt CC`epscomp then
        if Abs(genLCC - genLCC0) lt CC`epscomp then
            M`iota := iotaM;
            return M, [* hKM, hLM *];
        end if;
    end if;
end for;
error "No compatible infinite place found while taking compositum";

end intrinsic;


intrinsic CompositumExtra(Ks::List) -> Fld, List
{Returns the compositum of the fields in Ks over their common base ring.}

if #Ks eq 1 then
    return Ks[1], CanonicalInclusionMap(Ks[1], Ks[1]);
elif #Ks eq 2 then
    return CompositumExtra(Ks[1], Ks[2]);
end if;
L, psis := CompositumExtra(Ks[1..(#Ks - 1)]);
M, phis := CompositumExtra(L, Ks[#Ks]);
return M, [* psi * phis[1] : psi in psis *] cat [* phis[2] *];

end intrinsic;

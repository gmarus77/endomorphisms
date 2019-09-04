/***
 *  Recognizing complex numbers as algebraic numbers in relative fields
 *
 *  Copyright (C) 2016-2017
 *            Edgar Costa      (edgarcosta@math.dartmouth.edu)
 *            Davide Lombardo  (davide.lombardo@math.u-psud.fr)
 *            Jeroen Sijsling  (jeroen.sijsling@uni-ulm.de)
 *
 *  See LICENSE.txt for license details.
 */


forward MinimalPolynomialLLL;
forward AlgebraizeElementLLL;


function ScalingFactor(aCC)
/* Simple rational factor such that aCC / fac has small absolute value */

return 1;

absa := Abs(aCC); fac := 1;
while absa gt 2 do
    fac *:= 2; absa /:= 2;
end while;
while absa lt 1/2 do
    fac *:= 1/2; absa /:= 1/2;
end while;
return fac;

absa := Abs(aCC);
if absa gt 1 then
    d := Floor(absa);
else
    d := 1 / Floor(1 / absa);
end if;
bCC := aCC / d; absb := Abs(bCC);
d *:= (Floor(4*absb) / 4);
return d;

absa := Abs(aCC);
if absa gt 1 then
    d := Floor(absa);
else
    d := 1 / Floor(1 / absa);
end if;
bCC := aCC / d; absb := Abs(bCC);
d *:= (Floor(4*absb) / 4);
return d;

end function;


function TestCloseToRoot(f, aCC, epscomp);
/* Tests whether complex number aCC is close to a root of polynomial f over
 * NumberFieldExtra */

fCC := EmbedPolynomialExtra(f); rtsCC := [ tup[1] : tup in Roots(fCC) ];
for rtCC in rtsCC do
    abs := Abs(rtCC - aCC);
    if abs le epscomp then
        vprint EndoFind, 3 : "";
        vprint EndoFind, 3 : "Distance to root:";
        vprint EndoFind, 3 : RealField(5) ! abs;
        return true;
    end if;
end for;
return false;

end function;


function MinimalPolynomialLLL(aCC, K : LowerBound := 1, UpperBound := Infinity(), StepSize := 1)
/* Returns a relative minimal polynomial of the complex number aCC with respect
 * to the stored infinite place of K. */

CCSmall := ComplexField(5);
vprint EndoFind, 3 : "";
vprint EndoFind, 3 : "Determining minimal polynomial over QQ using LLL for:";
vprint EndoFind, 3 : CCSmall ! aCC;

/* Zero is easy */
degK := Degree(K); R := PolynomialRing(K); genK := K.1; CCK := K`CC;
assert Precision(Parent(aCC)) ge Precision(CCK);
if Abs(aCC) le CCK`epscomp then
    f := R.1;
    vprint EndoFind, 3 : "";
    vprint EndoFind, 3 : f;
    vprint EndoFind, 3 : "done determining minimal polynomial over QQ using LLL.";
    return f;
end if;

/* Scale and take the images of a power basis of K over QQ */
/* This is all over a complex field CC with higher precision than CCK */
faca := ScalingFactor(aCC); aCCsc := aCC / faca;
genCC := EmbedExtra(genK); CCiota := Parent(genCC);
facK := ScalingFactor(genCC); genK /:= facK; genCC /:= facK;
powersgenCC := [ EmbedExtra(genK^i) : i in [0..(degK - 1)] ];

/* Create first entry corresponding to constant term */
MLine := [ ]; poweraCCsc := 1; degf := 0;
MLine cat:= [ powergenCC * poweraCCsc : powergenCC in powersgenCC ];

/* Successively adding other entries to find relations */
while degf lt UpperBound do
    degf +:= 1; poweraCCsc *:= aCCsc;
    MLine cat:= [ powergenCC * poweraCCsc : powergenCC in powersgenCC ];
    M := Transpose(Matrix(CCK, [ MLine ]));

    if (degf ge LowerBound) and (degf mod StepSize eq 0) then
        /* Split and take an IntegralLeftKernel */
        MSplit := HorizontalSplitMatrix(M);
        Ker, test_ker := IntegralLeftKernel(MSplit : CalcAlg := true);

        if test_ker then
            row := Rows(Ker)[1];
            f := &+[ &+[ row[i*degK + j + 1]*genK^j : j in [0..(degK - 1)] ] * R.1^i : i in [0..degf] ];
            f := Evaluate(f, R.1 / faca); f /:= LeadingCoefficient(f);

            if TestCloseToRoot(f, aCC, CCK`epscomp) then
                vprint EndoFind, 3 : "";
                vprint EndoFind, 3 : f;
                vprint EndoFind, 3 : "done determining minimal polynomial over QQ using LLL.";
                return f;
            end if;
        end if;
    end if;
end while;
return "Failed to find minimal polynomial using LLL";

end function;


function AlgebraizeElementLLL(aCC, K)
/* Returns an approximation of the complex number aCC as an element of K. */

genK := K.1; genCC := EmbedExtra(genK); CCiota := Parent(genCC);
facK := ScalingFactor(genCC); genK /:= facK; genCC /:= facK;
CCK := K`CC; prec := Precision(CCK);
assert Precision(Parent(aCC)) ge Precision(CCK);

degK := Degree(K);
MLine := &cat[ EmbedExtra(genK^i) : i in [0..(degK - 1)] ] cat [ -aCC ];
M := Transpose(Matrix(CCK, [ MLine ]));

vprint EndoFind, 3 : "";
vprint EndoFind, 3 : "Algebraizing element...";
vprint EndoFind, 3 : "";
/* Split and take an IntegralLeftKernel */
MSplit := HorizontalSplitMatrix(M);
Ker, test_ker := IntegralLeftKernel(MSplit : CalcAlg := true);

if test_ker then
    row := Rows(Ker)[1];
    vprint EndoFind, 3 : "Trying row:", row;
    den := row[#Eltseq(row)];
    if den ne 0 then
        a := &+[ row[i + 1]*genK^i : i in [0..(degK - 1)] ] / den;

        if Abs(EmbedExtra(a) - aCC) le CCK`epscomp then
            vprint EndoFind, 3 : a;
            vprint EndoFind, 3 : "done algebraizing element.";
            return true, a;
        end if;
    end if;
end if;
vprint EndoFind, 3 : "No element found.";
return false, 0;

end function;


intrinsic FractionalApproximation(aCC::FldComElt) -> FldRatElt
{Returns a fractional approximation of the complex number aCC.}

CC := Parent(aCC); RR := RealField(CC);
M := Matrix(RR, [ [ 1 ], [ -Real(aCC) ] ]);
Ker, test_ker := IntegralLeftKernel(M : CalcAlg := true);
if not test_ker then
    return Rationals() ! 0, false;
end if;
q := Ker[1,1] / Ker[1,2];
if (RR ! Abs(q - aCC)) le RR`epscomp then
    return q, true;
else
    return Rationals() ! 0, false;
end if;

end intrinsic;


intrinsic FractionalApproximation(aRR::FldReElt) -> FldRatElt
{Returns a fractional approximation of the real number aRR.}

RR := Parent(aRR);
M := Matrix(RR, [ [ 1 ], [ -aRR ] ]);
K, test_ker := IntegralLeftKernel(M : CalcAlg := true);
if not test_ker then
    return Rationals() ! 0, false;
end if;
q := K[1,1] / K[1,2];
if (RR ! Abs(q - aRR)) le RR`epscomp then
    return q, true;
else
    return Rationals() ! 0, false;
end if;

end intrinsic;


intrinsic FractionalApproximationMatrix(ACC::.) -> .
{Returns a fractional approximation of the matrix ACC.}

test := true;
rows_alg := [ ];
for row in Rows(ACC) do
    row_alg := [ ];
    for c in Eltseq(row) do
        q, test_q := FractionalApproximation(c);
        test and:= test_q;
        Append(~row_alg, q);
    end for;
    Append(~rows_alg, row_alg);
end for;
return Matrix(rows_alg), test;

end intrinsic;


// TODO: This function can be used and is very useful, but it masks problems with precision loss
function RationalReconstruction(r);
    r1 := Real(r);
    r2 := Imaginary(r);
    p := Precision(r2);
    if r2 ne Parent(r2) ! 0 then
        e := Log(AbsoluteValue(r2));
    else
        e := -p;
    end if;
    if -e lt p/2 then
        return false, 0;
    end if;
    best := 0;
    i := p div 10;
    b := BestApproximation(r1, 10^i);
    while b ne best and i le p do
        i +:= 5;
        best := b;
        b := BestApproximation(r1, 10^i);
    end while;
    if b ne best then
        return false, 0;
    else
        return true, b;
    end if;
end function;


intrinsic AlgebraizeElementExtra(aCC::FldComElt, K::Fld : UseRatRec := true, minpol := 0) -> .
{Returns an approximation of the complex number aCC as an element of K. It calculates a minimal polynomial over QQ first.}

CCK := K`CC; CCiota := Parent(K`iota);
assert Precision(Parent(aCC)) ge Precision(CCK); 

if UseRatRec and Type(K) eq FldRat then
    return RationalReconstruction(aCC);
end if;

if Type(minpol) eq RngIntElt then
    minpol := MinimalPolynomialLLL(aCC, RationalsExtra(Precision(CCK)));
end if;
vprint EndoFind, 3 : "";
vprint EndoFind, 3 : "Finding roots in field with Pari...";
rts := RootsPari(minpol, K);
vprint EndoFind, 3 : rts;
vprint EndoFind, 3 : "done finding roots in field with Pari.";

for rt in rts do
    rtCC := EmbedExtra(rt);

    if Abs(rtCC - aCC) le CCK`epscomp then
        return true, rt;
    end if;
end for;
return false, 0;

end intrinsic;


intrinsic AlgebraizeElementsExtra(LCC::SeqEnum, K::Fld : UseRatRec := true) -> .
{Returns an approximation of the elements of the list LCC over K.}

L := [ ];
for aCC in LCC do
    test, a := AlgebraizeElementExtra(aCC, K : UseRatRec := UseRatRec);
    if not test then
        return false, 0;
    end if;
    Append(~L, a);
end for;
return true, L;

end intrinsic;


intrinsic AlgebraizeMatrixExtra(MCC::., K::Fld : UseRatRec := true) -> .
{Returns an approximation of the complex matrix MCC over K.}

rows := [ ];
for rowCC in Rows(MCC) do
    row := [ ];
    for cCC in Eltseq(rowCC) do
        test, c := AlgebraizeElementExtra(cCC, K : UseRatRec := UseRatRec);
        if not test then
            return false, 0;
        end if;
        Append(~row, c);
    end for;
    Append(~rows, row);
end for;
return true, Matrix(rows);

end intrinsic;


intrinsic MinimalPolynomialExtra(aCC::FldComElt, K::Fld : UpperBound := Infinity(), minpolQQ := 0) -> RngUPolElt
{Given a complex number aCC and a NumberFieldExtra K, finds the minimal polynomial of aCC over K. More stable than MinimalPolynomialLLL via the use of RootsPari. If the minimal polynomial over QQ is already known, then it can be specified by using the keyword argument minpolQQ. This minimal polynomial over QQ is the second return value.}

CCK := K`CC; CCiota := Parent(K`iota);
assert Precision(Parent(aCC)) ge Precision(CCK); 
if Type(minpolQQ) eq RngIntElt then
    f := MinimalPolynomialLLL(aCC, RationalsExtra(Precision(CCK)) : UpperBound := UpperBound);
else
    f := minpolQQ;
end if;

/* First try faster algorithm for linear factors */
rts := RootsPari(f, K);
R := PolynomialRing(K);
gs := [ R.1 - rt : rt in rts ];
for g in gs do
    if TestCloseToRoot(g, aCC, CCK`epscomp) then
        return g, f;
    end if;
end for;

/* Then try more general algorithm */
gs := FactorizationPari(f, K);
for g in gs do
    if TestCloseToRoot(g, aCC, CCK`epscomp) then
        return g, f;
    end if;
end for;
error "Failed to find relative minimal polynomial";

end intrinsic;

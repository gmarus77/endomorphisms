/*
  An example in Magma (to be made into an intuitve package there as well).
  Examples of verifications and projections can be found in the puiseux/
  directory; this file shows how to access the heuristic part.
*/

AttachSpec("../endomorphisms/magma/spec");
SetVerbose("EndoFind", 1);

F := RationalsExtra();
R<x> := PolynomialRing(F);
f := x^5 - x^4 + 4*x^3 - 8*x^2 + 5*x - 1; h := 0;
f := x^6 + x^2 + 1; h := 0;
f := 15*x^5 + 50*x^4 + 55*x^3 + 22*x^2 + 3*x; h := x;
f := -x^5; h := x^3 + x + 1;
f := x^6 + x^2 + 1; h := R ! 0;
f := 15*x^5 + 50*x^4 + 55*x^3 + 22*x^2 + 3*x; h := x;
f := x^4 + x^3 + 2*x^2 + x + 1; h := x^3 + x^2 + x + 1;
f := x^6 - 8*x^4 - 8*x^3 + 8*x^2 + 12*x - 8; h := 0;
f := x^5 - x^4 + 4*x^3 - 8*x^2 + 5*x - 1; h := R ! 0;
f := x^5 + x^4 + 2*x^3 + x^2 + x; h := x^2 + x;
f := 3*x^3 - 2*x^2 + 6*x + 2; h := x^3 + x;
f := x^7 - 14*x^6 + 210*x^5 - 658*x^4 + 245*x^3 + 588*x^2 + 637*x - 686; h := 0;
f := 21*x^7 + 37506*x^5 + 933261*x^3 + 5841759*x; h := 0;
f := x^7 + 6*x^5 + 9*x^3 + x; h := 0;
f := 16*x^7 + 357*x^5 - 819*x^3 + 448*x; h := 0;
f := -4*x^8 + 105*x^6 - 945*x^4 + 2100*x^2 - 5895*x + 420; h := x^4;
f := 2*x^10 + 6*x^9 + 6*x^8 + 12*x^7 + 7*x^6 + 7*x^4 - 12*x^3 + 6*x^2 - 6*x + 2; h := 0;
f := x^4 + x^2; h := x^3 + 1;
f := 10*x^10 + 24*x^9 + 23*x^8 + 48*x^7 + 35*x^6 + 35*x^4 - 48*x^3 + 23*x^2 - 24*x + 10; h := 0;
f := 11*x^6 + 11*x^3 - 4; h := 0;
f := x^5 + x; h := 0;
f := x^6 + 10*x^3 - 2; h := 0;
f := x^6 + 10*x^3 - 2; h := 0;
f := x^6 + 6*x^5 - 30*x^4 - 40*x^3 + 60*x^2 + 24*x - 8; h := 0;
f:= x^5 - x; h := 0;
f:= x^6 - 8*x^4 - 8*x^3 + 8*x^2 + 12*x - 8; h := 0;

R<t> := PolynomialRing(Rationals());
F<r> := NumberFieldExtra(t^2 - t + 1);
R<x> := PolynomialRing(F);
f := R ! [ -30*r + 42, -156*r + 312, -66*r + 186, -1456*r + 1040, -90*r + 126, 156*r - 312, -22*r + 62 ]; h := R ! 0;
/* TODO: This takes too long */
f := x^6 + r; h := R ! 0;

//R<t> := PolynomialRing(Rationals());
//F<r> := NumberFieldExtra(t^2 - 5);
//R<x> := PolynomialRing(F);
//f := x^5 + r*x^3 + x; h := R ! 0;
//f := x^5 + x + 1; h := R ! 0;

X := HyperellipticCurve(f, h);

prec := 300;
CCSmall := ComplexField(5);

print "Curve:";
print X;

eqsCC := EmbedCurveEquations(X, prec);
eqsF := DefiningEquations(X);
P := PeriodMatrix(eqsCC, eqsF : MolinNeurohr := true);

print "";
print "Period matrix:";
print ChangeRing(P, CCSmall);

GeoEndoRep := GeometricEndomorphismRepresentation(P, F);
L<s> := BaseRing(GeoEndoRep[1][1]);

print "";
print "Endomorphism representations:";
print GeoEndoRep;

R<x> := PolynomialRing(F);
K<s> := NumberField(x^2 + 13);
EndoRep := EndomorphismRepresentation(GeoEndoRep, K);
K<s> := BaseRing(EndoRep[1][1]);
print EndoRep;

lat, sthash := EndomorphismLattice(GeoEndoRep);
print "";
print "Endomorphism lattice:";
print lat;

print "";
print "Sato-Tate hash:";
print sthash;

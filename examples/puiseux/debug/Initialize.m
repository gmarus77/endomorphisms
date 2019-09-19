import "../../../endomorphisms/magma/puiseux/Initialize.m": InitializeCurve;

F := RationalsExtra();
R<x> := PolynomialRing(F);
X := HyperellipticCurve(x^6 + 3*x + 4);
P := X ! [ 1, 1, 0 ];
P := X ! [ 0, 2, 1 ];
InitializeCurve(X, P);
print "";
print X`U;
print X`unif_index;

S<x,y,z> := PolynomialRing(F, 3);
X := PlaneCurve(3*x^3*y + 5*y^3*z + 7*z^3*x);
P := X ! [ 0, 1, 0 ];
InitializeCurve(X, P);
print "";
print X`U;
print X`unif_index;
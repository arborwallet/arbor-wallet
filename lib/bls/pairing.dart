// ignore_for_file: non_constant_identifier_names

import 'package:arbor/bls/ec.dart';
import 'package:arbor/bls/field.dart';
import 'package:arbor/bls/field_base.dart';
import 'package:arbor/bls/field_ext.dart';

List<int> intToBits(BigInt i) {
  if (i < BigInt.one) {
    return [0];
  }
  List<int> bits = [];
  while (i != BigInt.zero) {
    bits.add((i % BigInt.two).toInt());
    i = i ~/ BigInt.two;
  }
  return bits.reversed.toList();
}

Field doubleLineEval(AffinePoint R, AffinePoint P, {EC? ec}) {
  ec ??= defaultEc;
  var R12 = untwist(R);
  var slope = (Fq(ec.q, BigInt.from(3)) *
      (R12.x.pow(BigInt.two) + ec.a) /
      (R12.y * Fq(ec.q, BigInt.two)));
  var v = R12.y - R12.x * slope;
  return P.y - P.x * slope - v;
}

Field addLineEval(AffinePoint R, AffinePoint Q, AffinePoint P, {EC? ec}) {
  ec ??= defaultEc;
  var R12 = untwist(R);
  var Q12 = untwist(Q);
  if (R12 == -Q12) {
    return P.x - R12.x as Fq;
  }
  var slope = (Q12.y - R12.y) / (Q12.x - R12.x);
  var v = (Q12.y * R12.x - R12.y * Q12.x) / (R12.x - Q12.x);
  return P.y - P.x * slope - v;
}

Fq12 millerLoop(BigInt T, AffinePoint P, AffinePoint Q, {EC? ec}) {
  ec ??= defaultEc;
  var T_bits = intToBits(T);
  var R = Q;
  var f = Fq12.one(ec.q);
  for (var i = 1; i < T_bits.length; i++) {
    var lrr = doubleLineEval(R, P, ec: ec);
    f = f * f * lrr as Fq12;
    R *= Fq(ec.q, BigInt.two);
    if (T_bits[i] == 1) {
      var lrq = addLineEval(R, Q, P, ec: ec);
      f = f * lrq as Fq12;
      R += Q;
    }
  }
  return f;
}

Fq12 finalExponentiation(Fq12 element, {EC? ec}) {
  ec ??= defaultEc;
  if (ec.k == BigInt.from(12)) {
    var ans = element.pow((ec.q.pow(4) - ec.q.pow(2) + BigInt.one) ~/ ec.n);
    ans = ans.qiPower(2) * ans as Fq12;
    ans = ans.qiPower(6) / ans as Fq12;
    return ans as Fq12;
  } else {
    return element.pow((ec.q.pow(ec.k.toInt()) - BigInt.one) ~/ ec.n) as Fq12;
  }
}

Fq12 atePairing(JacobianPoint P, JacobianPoint Q, {EC? ec}) {
  ec ??= defaultEc;
  var t = defaultEc.x + BigInt.one;
  var T = (t - BigInt.one).abs();
  return finalExponentiation(millerLoop(T, P.toAffine(), Q.toAffine()), ec: ec);
}

Fq12 atePairingMulti(List<JacobianPoint> Ps, List<JacobianPoint> Qs, {EC? ec}) {
  ec ??= defaultEc;
  var t = defaultEc.x + BigInt.one;
  var T = (t - BigInt.one).abs();
  var prod = Fq12.one(ec.q);
  for (var i = 0; i < Qs.length; i++) {
    prod = prod * millerLoop(T, Ps[i].toAffine(), Qs[i].toAffine(), ec: ec)
        as Fq12;
  }
  return finalExponentiation(prod, ec: ec);
}

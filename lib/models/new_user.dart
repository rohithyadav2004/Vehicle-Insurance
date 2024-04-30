import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class cust_det{
  cust_det({
     required this.fname,
     this.lname,
     this.date,
     this.gender,
     this.address,
     this.phoneNo,
     this.email,
     this.maritalSt,
     this.passportNo,
     this.ppsNo,
  });
  final String fname;
  final String? lname;
  final String? date;
  final String? gender;
  final String? address;
  final int? phoneNo;
  final String? email;
  final String? maritalSt;
  final String? passportNo;
  final String? ppsNo;
}
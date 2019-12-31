; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -enable-no-signed-zeros-fp-math=true < %s | FileCheck %s

; FIXME: This should be the same when the extra instructions are fixed
; XUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -enable-no-signed-zeros-fp-math=false < %s | FileCheck %s

; no-signed-zeros-fp-math should not increase the number of
; instructions emitted.

define { double, double } @testfn(double %arg, double %arg1, double %arg2) {
; CHECK-LABEL: testfn:
; CHECK:       ; %bb.0: ; %bb
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_add_f64 v[6:7], v[4:5], -v[0:1]
; CHECK-NEXT:    v_add_f64 v[4:5], v[0:1], -v[4:5]
; CHECK-NEXT:    v_add_f64 v[0:1], v[6:7], -v[2:3]
; CHECK-NEXT:    v_add_f64 v[2:3], -v[2:3], v[4:5]
; CHECK-NEXT:    s_setpc_b64 s[30:31]
bb:
  %tmp = fsub fast double 0.000000e+00, %arg1
  %tmp3 = fsub fast double %arg2, %arg
  %tmp4 = fadd fast double %tmp3, %tmp
  %tmp5 = fsub fast double %tmp, %tmp3
  %tmp6 = insertvalue { double, double } undef, double %tmp4, 0
  %tmp7 = insertvalue { double, double } %tmp6, double %tmp5, 1
  ret { double, double } %tmp7
}

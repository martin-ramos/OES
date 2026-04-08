# OES Core

MODE: standard

@std
  cc: fn-small | names-clear | no-dup | no-mixed-resp
  solid: srp | ocp? | dip?
  sec: no-secrets | validate-input

@perf
  O(n) declare when non-trivial
  no-recompute | no-redundancy

@rel
  err-explicit | invariants | state-consistent

@end → review-final + EQI[0-100]

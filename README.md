# PreciseTracking

Fine grained Dynamic updating for Mathematica

## Introduction

`Dynamic` can only track symbols mutations so if you move the slider in:
    
    asso = <|"a" -> 1, "b" -> 1|>;
    
    Slider@Dynamic@asso["a"]
    
    Dynamic[Print@"a"; asso["a"]]
    Dynamic[Print@"b"; asso["b"]]
    
You will see `"a"` and `"b"` printed together. It is a real problem for larger applications.

Here is a prototype solution that  handles 'track expression' + 'update object' instead of e.g. creating artificial symbols to manage the binding.   

User does not need to worry about that, only to specify what should be tracked: 

    << PreciseTracking`
    
    asso = <|"a" -> 1, "b" -> 1|>;
    
    ToTrackedAssociation @ asso;  (*now asso[key] = value will try to update associated dynamics *)
    
    Slider@Dynamic@asso["a"]
    
    PreciseDynamic[Print@"a"; asso["a"], asso["a"]] (*second argument serves like a 'TrackedTarget'*)
    PreciseDynamic[Print@"b"; asso["b"], asso["b"]]
    
## TODO    

- [x] support for simple 'flat' associations
- [x] track many targets
- [ ] two-way `PreciseDynamic`, e.g. proper behavior for `Slider @ PreciseDynamic @ ...`
- [ ] handle kernel quit/restart
- [ ] support for nested associations
- [ ] robustness measures, don't reapply `ToTrackedAssociation` etc

## Installation
 
### Manually
 
   Go to 'releases' tab and download appropriate .paclet file.
    
   Run `PacletInstall @ path/to/the.paclet` file
   
### or using ``MPM` `` package
   
If you don't have ``MPM` `` yet, run:
   
    Import["https://raw.githubusercontent.com/kubapod/mpm/master/install.m"]
   
and then:
   
    Needs @ "MPM`"    
    MPM`MPMInstall["kubapod", "PreciseTracking"]

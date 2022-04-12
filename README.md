# NSInjector
A macOS tool for .dylib injection , ipa signing & installing
 
### Requirments :
- ideviceinstaller tool [For installation feature]


### How to use :
```
NSInjector -d /path/to/file.dylib -b /path/to/file.bundle -a /path/to/file.ipa -p /path/to/file.mobileprovision
```
### Usage :
```
Usage: NSInjector <command>

  -d      dylib path [Optional]
  -b      bundle path [Optional]
  -a      ipa path [Required]
  -p      profile path [Required]
  -i      just type -i at the end to install ipa after signing [Optional]

  Ex.1 : NSInjector -d /path/to/dylib -b /path/to/bundle -a /path/to/ipa -p /path/to/profile
  Ex.2 : NSInjector -d /path/to/dylib,/path/to/dylib2,/path/to/dylib3 -b /path/to/bundle -a /path/to/ipa -p /path/to/profile
  Ex.3 : NSInjector -d /path/to/dylib,/path/to/dylib2,/path/to/dylib3 -b /path/to/bundle,/path/to/bundle2,/path/to/bundle3 -a /path/to/ipa -p /path/to/profile -i 
```
 

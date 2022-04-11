//
//  main.m
//  NSInjector
//
//  Created by @CrazyMind90 on 11/04/2022 .
//


#import <Foundation/Foundation.h>
#import "SSZipArchive.h"


#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"
//Regular text
#define BLK "\e[0;30m"
#define RED "\e[0;31m"
#define GRN "\e[0;32m"
#define YEL "\e[0;33m"
#define BLU "\e[0;34m"
#define MAG "\e[0;35m"
#define CYN "\e[0;36m"
#define WHT "\e[0;37m"

//Regular bold text
#define BBLK "\e[1;30m"
#define BRED "\e[1;31m"
#define BGRN "\e[1;32m"
#define BYEL "\e[1;33m"
#define BBLU "\e[1;34m"
#define BMAG "\e[1;35m"
#define BCYN "\e[1;36m"
#define BWHT "\e[1;37m"

//Regular underline text
#define UBLK "\e[4;30m"
#define URED "\e[4;31m"
#define UGRN "\e[4;32m"
#define UYEL "\e[4;33m"
#define UBLU "\e[4;34m"
#define UMAG "\e[4;35m"
#define UCYN "\e[4;36m"
#define UWHT "\e[4;37m"

//Regular background
#define BLKB "\e[40m"
#define REDB "\e[41m"
#define GRNB "\e[42m"
#define YELB "\e[43m"
#define BLUB "\e[44m"
#define MAGB "\e[45m"
#define CYNB "\e[46m"
#define WHTB "\e[47m"

//High intensty background
#define BLKHB "\e[0;100m"
#define REDHB "\e[0;101m"
#define GRNHB "\e[0;102m"
#define YELHB "\e[0;103m"
#define BLUHB "\e[0;104m"
#define MAGHB "\e[0;105m"
#define CYNHB "\e[0;106m"
#define WHTHB "\e[0;107m"

//High intensty text
#define HBLK "\e[0;90m"
#define HRED "\e[0;91m"
#define HGRN "\e[0;92m"
#define HYEL "\e[0;93m"
#define HBLU "\e[0;94m"
#define HMAG "\e[0;95m"
#define HCYN "\e[0;96m"
#define HWHT "\e[0;97m"

//Bold high intensity text
#define BHBLK "\e[1;90m"
#define BHRED "\e[1;91m"
#define BHGRN "\e[1;92m"
#define BHYEL "\e[1;93m"
#define BHBLU "\e[1;94m"
#define BHMAG "\e[1;95m"
#define BHCYN "\e[1;96m"
#define BHWHT "\e[1;97m"

//Reset
#define reset "\e[0m"

NSString *CMD(NSString *CMD) {
        
   NSTask *task = [[NSTask alloc] init];
   NSMutableArray *args = [NSMutableArray array];
   [args addObject:@"-c"];
   [args addObject:CMD];
   [task setLaunchPath:@"/bin/sh"];
   [task setArguments:args];
   NSPipe *outputPipe = [NSPipe pipe];
   [task setStandardInput:[NSPipe pipe]];
   [task setStandardOutput:outputPipe];
   [task launch];
    
    NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];

    return outputString;
}


NSString *GetFromString(NSString *From,NSString *To,id String) {
    
    NSString *str = [NSString stringWithFormat:@"%@",String];
    NSString *stringlast = nil;
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToString:[NSString stringWithFormat:@"%@",From] intoString:nil];
    while(![scanner isAtEnd]) {
    [scanner scanString:[NSString stringWithFormat:@"%@",From] intoString:nil];
    if([scanner scanUpToString:[NSString stringWithFormat:@"%@",To] intoString:&stringlast]) {
    }
    [scanner scanUpToString:[NSString stringWithFormat:@"%@",From] intoString:nil];
    }
    
  return stringlast;
}



static NSString *SWF(id Value, ...) {
    va_list args;
    va_start(args, Value);
    NSString *Formated = [[NSString alloc] initWithFormat:Value arguments:args];
    va_end(args);
    return Formated;
}

 
void Usage(void) {
    printf(BGRN"\n\nUsage: NSInjector <command>\n\n  -d      dylib path [Optional]\n  -b      bundle path [Optional]\n  -a      ipa path [Required]\n  -p      profile path [Required]\n  -i      just type -i at the end to install ipa after signing [Optional]\n\n  Ex.1 : NSInjector -d /path/to/dylib -b /path/to/bundle -a /path/to/ipa -p /path/to/profile\n  Ex.2 : NSInjector -d /path/to/dylib,/path/to/dylib2,/path/to/dylib3 -b /path/to/bundle -a /path/to/ipa -p /path/to/profile\n  Ex.3 : NSInjector -d /path/to/dylib,/path/to/dylib2,/path/to/dylib3 -b /path/to/bundle,/path/to/bundle2,/path/to/bundle3 -a /path/to/ipa -p /path/to/profile -i \n \n\n  By : @CrazyMind90\n\n\n"reset);
}

NSString *GetFullCertNameFromKeyChainWithCertID(NSString *Cert) {
    
    NSString *iReturn;
    NSString *DumpKeyChain = CMD(@"security find-identity -v");
    NSArray *Certs = [DumpKeyChain componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];

    for (NSString *EachCertName in Certs) {
    if ([EachCertName containsString:Cert])
        iReturn = EachCertName;
    }
    
    return iReturn;
}

NSString *FixSS(NSString *Str) {
    return [Str stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
}

 
int main(int argc, const char * argv[]) {
    @autoreleasepool {

    setuid(0);
        
    NSString *args;
    for (int counter = 1; counter < argc; counter ++) {
    if (counter == 1)
    args = SWF(@"%s",argv[counter]);
    else
    args = SWF(@"%@ %s",args,argv[counter]);
    }

   
    if (![args containsString:@"-a"] || ![args containsString:@"-p"]) {
        Usage();
        return 0;
    }
        

    NSString *CurrentPath = SWF(@"%s",argv[0]);
    NSString *Optool = SWF(@"%@/optool",CurrentPath.stringByDeletingLastPathComponent);
    BOOL HasBundle = NO;
    BOOL HasDylib = NO;
    BOOL isMultiDylib = NO;
    BOOL isMultiBundle = NO;
    BOOL installToiDevice = NO;
    NSArray *Dylibs;
    NSArray *Bundles;
        
    if ([args containsString:@"-d"])
    HasDylib = YES;
        
    if ([args containsString:@"-b"])
    HasBundle = YES;
        
    if ([args containsString:@"-i"])
    installToiDevice = YES;
        
    NSString *DylibPath = GetFromString(@"-d", @" -", args);
    NSString *BundlePath = GetFromString(@"-b", @" -", args);
    NSString *iPAPath = GetFromString(@"-a", @" -", args);
    NSString *ProfilePath = GetFromString(@"-p", @" -", args);
 
#pragma CheckOptool
    if (![[NSFileManager defaultManager] fileExistsAtPath:Optool]) {
    printf(BRED"Optool not found - it must be at the same directory with NSInjector\nDownload link : https://crazy90.com/Crazy/Files/optool\n"reset);
    return 0;
    }
        
        
#pragma CheckIfMultiDylib
    if (HasDylib) {
    if ([DylibPath containsString:@","]) {
    isMultiDylib = YES;
    DylibPath = [DylibPath stringByReplacingOccurrencesOfString:@", " withString:@","];
    DylibPath = [DylibPath stringByReplacingOccurrencesOfString:@".dylib " withString:@".dylib"];
    Dylibs = [DylibPath componentsSeparatedByString:@","];
    NSMutableArray *ClearArray = Dylibs.mutableCopy;
    [ClearArray removeObject:@""];
    Dylibs = ClearArray.copy;
    }
    }
        
#pragma CheckIfMultiBundle
    if (HasBundle) {
    if ([BundlePath containsString:@","]) {
    isMultiBundle = YES;
    BundlePath = [BundlePath stringByReplacingOccurrencesOfString:@", " withString:@","];
    BundlePath = [BundlePath stringByReplacingOccurrencesOfString:@".bundle " withString:@".bundle"];
    Bundles = [BundlePath componentsSeparatedByString:@","];
    NSMutableArray *ClearArray = Bundles.mutableCopy;
    [ClearArray removeObject:@""];
    Bundles = ClearArray.copy;
    }
    }
        
#pragma CheckDylibs
    if (HasDylib) {
    if (isMultiDylib) {
    for (NSString *EachDylibPath in Dylibs) {
    if (![[NSFileManager defaultManager] fileExistsAtPath:EachDylibPath]) {
    printf(BRED"Dylib not found : %s\n"reset,EachDylibPath.UTF8String);
    return 0;
    }
    }
    } else {
    if (![[NSFileManager defaultManager] fileExistsAtPath:DylibPath]) {
    printf(BRED"Dylib not found : %s\n"reset,DylibPath.lastPathComponent.UTF8String);
    return 0;
    }
    }
    }
#pragma CheckBundles
    if (HasBundle) {
    if (isMultiBundle) {
    for (NSString *EachBundlePath in Bundles) {
    if (![[NSFileManager defaultManager] fileExistsAtPath:EachBundlePath]) {
    printf(BRED"Bundle not found : %s\n"reset,EachBundlePath.lastPathComponent.UTF8String);
    return 0;
    }
    }
    } else {
    if (![[NSFileManager defaultManager] fileExistsAtPath:BundlePath]) {
    printf(BRED"Bundle not found : %s\n"reset,BundlePath.lastPathComponent.UTF8String);
    return 0;
    }
    }
    }
#pragma CheckiPA
    if (![[NSFileManager defaultManager] fileExistsAtPath:iPAPath]) {
    printf(BRED"iPA not found\n"reset);
    return 0;
    }
 
        
#pragma CheckProfile
   if (![[NSFileManager defaultManager] fileExistsAtPath:ProfilePath]) {
   printf(BRED"Profile not found\n"reset);
   return 0;
   }
        
        
#pragma UnzippingiPA
    printf(BYEL"[+] Unzipping ..\n"reset);
    NSString *Payload = SWF(@"%@/Payload",iPAPath.stringByDeletingLastPathComponent);
    NSString *WorkingPath = Payload.stringByDeletingLastPathComponent;
    [[NSFileManager defaultManager] removeItemAtPath:Payload error:nil];
        
    [SSZipArchive unzipFileAtPath:iPAPath toDestination:SWF(@"%@",iPAPath.stringByDeletingLastPathComponent)];
 
    NSString *AppPath;
    for (NSString *EachFolder in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:Payload error:nil]) {
    if ([EachFolder.pathExtension isEqual:@"app"])
    AppPath = SWF(@"%@/%@",Payload,EachFolder);
    }

#pragma Copying
    printf(BYEL"[+] Copying files ..\n"reset);
    
    if (HasDylib) {
    if (isMultiDylib) {
    for (NSString *EachDylibPath in Dylibs) {
    [[NSFileManager defaultManager] copyItemAtPath:EachDylibPath toPath:SWF(@"%@/%@",AppPath,EachDylibPath.lastPathComponent) error:nil];
    printf(BGRN"[+] Copying %s ..\n"reset,EachDylibPath.lastPathComponent.UTF8String);
    }
    } else {
    [[NSFileManager defaultManager] copyItemAtPath:DylibPath toPath:SWF(@"%@/%@",AppPath,DylibPath.lastPathComponent) error:nil];
    printf(BGRN"[+] Copying %s ..\n"reset,DylibPath.lastPathComponent.UTF8String);
    }
    }
    
    if (HasBundle) {
    if (isMultiBundle) {
    for (NSString *EachBundlePath in Bundles) {
    [[NSFileManager defaultManager] copyItemAtPath:EachBundlePath toPath:SWF(@"%@/%@",AppPath,EachBundlePath.lastPathComponent) error:nil];
    printf(BGRN"[+] Copying %s ..\n"reset,EachBundlePath.lastPathComponent.UTF8String);
    }
    } else {
    [[NSFileManager defaultManager] copyItemAtPath:BundlePath toPath:SWF(@"%@/%@",AppPath,BundlePath.lastPathComponent) error:nil];
    printf(BGRN"[+] Copying %s ..\n"reset,BundlePath.lastPathComponent.UTF8String);
    }
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:SWF(@"%@/PlugIns",AppPath) error:nil];
    CMD(SWF(@"rm -rf %@/*.mobileprovision",FixSS(AppPath)));
    [[NSFileManager defaultManager] copyItemAtPath:ProfilePath toPath:SWF(@"%@/embedded.mobileprovision",AppPath) error:nil];
        
#pragma Setting_Info.plist
    NSString *InfoPlist = SWF(@"%@/Info.plist",AppPath);
    NSMutableDictionary *InfoDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:SWF(@"%@/Info.plist",AppPath)];
    NSString *ExcutableBinary = InfoDictionary[@"CFBundleExecutable"];
    // Fix Icon
    NSMutableDictionary *CFBundleIcons = [InfoDictionary objectForKey:@"CFBundleIcons"];
    NSMutableDictionary *PatchesStringNames = [CFBundleIcons objectForKey:@"CFBundlePrimaryIcon"];
    [PatchesStringNames removeObjectForKey:@"CFBundleIconName"];

    [InfoDictionary setValue:@"10.0" forKey:@"MinimumOSVersion"];
    [InfoDictionary removeObjectForKey:@"UISupportedDevices"];

    NSMutableArray *AddEr = [InfoDictionary objectForKey:@"UIDeviceFamily"];
    [AddEr addObject:[NSNumber numberWithInt:2]];
    [InfoDictionary setValue:AddEr forKey:@"UIDeviceFamily"];

    [InfoDictionary writeToFile:InfoPlist atomically:YES];
        
        
#pragma Injecting
    
    if (HasDylib) {
    printf(BYEL"[+] Injecting dylibs ..\n"reset);
    if (isMultiDylib) {
    for (NSString *EachDylibPath in Dylibs) {
    CMD(SWF(@"%@ install -c load -p \"@executable_path/%@\" -t %@",Optool,EachDylibPath.lastPathComponent,SWF(@"%@/%@",AppPath,ExcutableBinary)));
    printf(BGRN"[&] %s injected ..\n"reset,EachDylibPath.lastPathComponent.UTF8String);
    }
    } else {
    CMD(SWF(@"%@ install -c load -p \"@executable_path/%@\" -t %@",Optool,DylibPath.lastPathComponent,SWF(@"%@/%@",AppPath,ExcutableBinary)));
    printf(BGRN"[&] %s injected ..\n"reset,DylibPath.lastPathComponent.UTF8String);
    }
    }

#pragma SettingUp_Entitlements
        
    printf(BYEL"[+] Preparing profile ..\n"reset);
    CMD(SWF(@"security cms -D -i %@ > %@/ent.xml",FixSS(ProfilePath),FixSS(WorkingPath)));
    NSString *OwnerName = [NSMutableDictionary dictionaryWithContentsOfFile:SWF(@"%@/ent.xml",WorkingPath)][@"TeamIdentifier"][0];
    NSString *CertName = GetFullCertNameFromKeyChainWithCertID(OwnerName);
    if (!CertName) {
    printf(BRED"Could not find a valid certificate in keychain\n"reset);
    return 0;
    }
    CMD(SWF(@"/usr/libexec/PlistBuddy -x -c 'Print:Entitlements' %@/ent.xml > %@/ent.plist",FixSS(WorkingPath),FixSS(WorkingPath)));

 
#pragma Signing
    sleep(1.5);
    printf(BYEL"[+] Signing ..\n"reset);
    printf(BGRN"\n"reset);
    CMD(SWF(@"codesign -f -s \"%@\" --entitlements %@/ent.plist %@/Frameworks/*",CertName,FixSS(WorkingPath),FixSS(AppPath)));
    CMD(SWF(@"codesign -f -s \"%@\" --entitlements %@/ent.plist %@/Frameworks/*/*",CertName,FixSS(WorkingPath),FixSS(AppPath)));
    CMD(SWF(@"codesign -f -s \"%@\" --entitlements %@/ent.plist %@/Frameworks/*.dylib",CertName,WorkingPath,FixSS(AppPath)));
    CMD(SWF(@"codesign -f -s \"%@\" --entitlements %@/ent.plist %@/*/*.dylib",CertName,FixSS(WorkingPath),FixSS(AppPath)));
    CMD(SWF(@"codesign -f -s \"%@\" --entitlements %@/ent.plist %@/*.dylib",CertName,FixSS(WorkingPath),FixSS(AppPath)));
    CMD(SWF(@"codesign -f -s \"%@\" --entitlements %@/ent.plist %@/%@",CertName,FixSS(WorkingPath),FixSS(AppPath),ExcutableBinary));
            
#pragma Zip_iPA
    NSString *SignediPA = SWF(@"%@/%@_Signed.ipa",WorkingPath,ExcutableBinary);
    [SSZipArchive createZipFileAtPath:SignediPA withContentsOfDirectory:Payload keepParentDirectory:true];
        
#pragma Clearing
    printf(BYEL"[+] Clearing ..\n"reset);
    [[NSFileManager defaultManager] removeItemAtPath:Payload error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:SWF(@"%@/ent.plist",WorkingPath) error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:SWF(@"%@/ent.xml",WorkingPath) error:nil];
#pragma Installing
    if (![[NSFileManager defaultManager] fileExistsAtPath:SignediPA]) {
    printf(BRED"Signed iPA not found - something went wrong\n"reset);
    return 0;
    } else
    printf(BGRN"[*] SignediPA is ready at : %s ..\n"reset,SignediPA.UTF8String);
    if (installToiDevice) {
    printf(BGRN"[+] Installing ..\n"reset);
    CMD(SWF(@"/usr/local/bin/ideviceinstaller -i %@",FixSS(SignediPA)));
    }
 

    }
    return 0;
}







//

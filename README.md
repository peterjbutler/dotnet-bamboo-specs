# dotnet-bamboo-specs

This package allows the use of the Atlassian Bamboo Specs API natively from within dotnet.

Built for [`bamboo-specs-6.5.0`](https://docs.atlassian.com/bamboo-specs-docs/6.5.0/).

## Pre-requisites

To make the best use of this build script you will need the following pre-requisites:

`git`
`psake`
`maven`
`ikvm`
`nuget`

### Download and install Chocolatey

This example is going to use Chocolatey for installation management, you can get by without it but I recommend it as it makes the whole process of installation much easier.

You can download chocolatey here https://chocolatey.org.

### Git

In case you don't already have `git` installed, use the following chocolatey command to install it.

```
C:\> choco install git
```

### Psake

The build script uses `psake`, use the following chocolatey command to install it.

```
C:\> choco install psake
```

### Maven

The build script uses `maven` to download the required `java` dependencies for the [Atlassian Bamboo Specs](https://docs.atlassian.com/bamboo-specs-docs/6.5.0/) packages, use the following chocolatey command to install it.

```
C:\> choco install maven
```

Note: This will also install the latest JDK if it is not already installed on your machine.

### IKVM.NET

The build script uses `ikvmc` to convert java to dotnet, use the following chocolatey command to install it.

```
C:\> choco install ikvm
```

Note: This is really the heart of the process as it translates the java `byte-code` into `CIL` and compiles it into dotnet compatible DLL's.

### dot-net-bamboospecs

Clone this GitHub repository and change directory:

```
C:\> git clone https://github.com/peterjbutler/dotnet-bamboo-specs.git

C:\> cd dotnet-bamboo-specs
```

## Build it!

Building the libraries is simple, just execute the `psake` build script:

```
C:\dotnet-bamboo-specs> psake
```

At the end the process should finish with `Build Succeeded!`, an example output is shown below:

```
C:\dotnet-bamboo-specs> psake
psake version 4.7.0
Copyright (c) 2010-2017 James Kovacs & Contributors
...

...
Build Succeeded!

----------------------------[ Build Time Report ]----------------------------
Name                           Duration
----                           --------
Header                         00:00:00.041
Clean-Java                     00:00:00.024
Clean-DotNet                   00:00:00.003
Clean-Nuget                    00:00:00.002
Clean                          00:00:00.000
MavenDependencyCopy            00:00:05.257
IkvmcBuild-commons-lang        00:00:01.925
IkvmcBuild-gson                00:00:01.037
IkvmcBuild-httpcore            00:00:01.044
IkvmcBuild-snakeyaml           00:00:01.027
IkvmcBuild-bamboo-specs-api    00:00:01.041
IkvmcBuild-commons-codec       00:00:01.009
IkvmcBuild-commons-logging     00:00:00.960
IkvmcBuild-httpclient          00:00:03.175
IkvmcBuild-commons-collections 00:00:01.152
IkvmcBuild-commons-beanutils   00:00:02.205
IkvmcBuild-commons-digester    00:00:01.000
IkvmcBuild-commons-validator   00:00:04.199
IkvmcBuild-bamboo-specs        00:00:14.588
IkvmcBuild                     00:00:00.000
NugetPack                      00:00:01.428
Total:                         00:00:21.417
```

## NuGet Package

A NuGet package will be output into the `nuget` directory.

```
C:\dotnet-bamboo-specs> cd nuget
C:\dotnet-bamboo-specs\nuget> dir
 Volume in drive C is EXAMPLE
 Volume Serial Number is 0000-0000

 Directory of C:\dotnet-bamboo-specs\nuget

08/06/2018  15:17    <DIR>          .
08/06/2018  15:17    <DIR>          ..
08/06/2018  15:17         1,602,727 DotnetBambooSpecs.6.5.0.nupkg
               1 File(s)      1,602,727 bytes
               2 Dir(s)  999,999,999,999 bytes free
```
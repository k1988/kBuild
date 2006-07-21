@echo off
REM # $Id: $
REM ## @file
REM #
REM # Environment setup script.
REM #
REM # Copyright (c) 2005 knut st. osmundsen <bird@innotek.de>
REM #
REM #
REM # This file is part of kBuild.
REM #
REM # kBuild is free software; you can redistribute it and/or modify
REM # it under the terms of the GNU General Public License as published by
REM # the Free Software Foundation; either version 2 of the License, or
REM # (at your option) any later version.
REM #
REM # kBuild is distributed in the hope that it will be useful,
REM # but WITHOUT ANY WARRANTY; without even the implied warranty of
REM # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM # GNU General Public License for more details.
REM #
REM # You should have received a copy of the GNU General Public License
REM # along with kBuild; if not, write to the Free Software
REM # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
REM #


REM #
REM # Deal with the arguments.
REM #
if ".%1" = ".-win"      goto want_win_bit
if ".%1" = ".-win32"    goto want_win32_bit
if ".%1" = ".-win64"    goto want_win64_bit
if ".%1" = ".-nt"       goto want_nt_bit
if ".%1" = ".-nt32"     goto want_nt32_bit
if ".%1" = ".-nt64"     goto want_nt64_bit
goto done_arguments

:want_win_bit
shift
set BUILD_TARGET=win
set BUILD_PLATFORM=win
goto done_arguments

:want_win32_bit
shift
set BUILD_PLATFORM=win32
set BUILD_TARGET=win32
set BUILD_TARGET_ARCH=x86
goto done_arguments

:want_win64_bit
shift
set BUILD_TARGET=win64
set BUILD_TARGET_ARCH=amd64
goto done_arguments

:want_nt_bit
shift
set BUILD_PLATFORM=nt
set BUILD_TARGET=nt
goto done_arguments

:want_nt32_bit
shift
set BUILD_PLATFORM=nt
set BUILD_TARGET=nt
set BUILD_TARGET_ARCH=x86
goto done_arguments

:want_nt64_bit
shift
set BUILD_PLATFORM=nt
set BUILD_TARGET=nt
set BUILD_TARGET_ARCH=amd64
goto done_arguments

:done_arguments

REM #
REM # figure the current directory.
REM #
for /f "tokens=*" %d in ('cd') do set CURDIR=%d

REM #
REM # find kBuild.
REM #
if exist %PATH_KBUILD%\footer.kmk goto found_kbuild
set PATH_KBUILD=%CURDIR
if exist %PATH_KBUILD%\footer.kmk goto found_kbuild
set PATH_KBUILD=%CURDIR\kBuild
if exist %PATH_KBUILD%\footer.kmk goto found_kbuild
set PATH_KBUILD=%CURDIR\..\kBuild
if exist %PATH_KBUILD%\footer.kmk goto found_kbuild
set PATH_KBUILD=%CURDIR\..\..\kBuild
if exist %PATH_KBUILD%\footer.kmk goto found_kbuild
set PATH_KBUILD=%CURDIR\..\..\..\kBuild
if exist %PATH_KBUILD%\footer.kmk goto found_kbuild
set PATH_KBUILD=%CURDIR\..\..\..\..\kBuild
if exist %PATH_KBUILD%\footer.kmk goto found_kbuild
echo kBuild: Can't find the kBuild directory!
set CURDIR=
goto failed

:found_kbuild
echo dbg: PATH_KBUILD=%PATH_KBUILD%
set CURDIR=

REM #
REM # Type.
REM #
IF NOT ".%BUILD_TYPE%" = "." goto have_BUILD_TYPE
set BUILD_TYPE=debug
:have_BUILD_TYPE
echo dbg: BUILD_TYPE=%BUILD_TYPE%


REM #
REM # Host platform.
REM #
IF NOT ".%BUILD_PLATFORM%" = "." goto have_2_BUILD_PLATFORM
set BUILD_PLATFORM=win
echo dbg: BUILD_PLATFORM=%BUILD_PLATFORM%

IF NOT ".%BUILD_PLATFORM_ARCH%" = "."   goto have_BUILD_PLATFORM_ARCH
set TEST_PROCESSOR_ARCH=%PROCESSOR_ARCHITECTURE%
IF NOT ".%PROCESSOR_ARCHITEW6432%" = "." set TEST_PROCESSOR_ARCH=%PROCESSOR_ARCHITEW6432%
IF "%TEST_PROCESSOR_ARCH%" = "x86"      set BUILD_PLATFORM_ARCH=x86
IF "%TEST_PROCESSOR_ARCH%" = "X86"      set BUILD_PLATFORM_ARCH=x86
IF "%TEST_PROCESSOR_ARCH%" = "AMD64"    set BUILD_PLATFORM_ARCH=amd64
IF "%TEST_PROCESSOR_ARCH%" = "x64"      set BUILD_PLATFORM_ARCH=amd64
IF "%TEST_PROCESSOR_ARCH%" = "X64"      set BUILD_PLATFORM_ARCH=amd64
IF NOT ".%BUILD_PLATFORM_ARCH%" = "."   goto have_BUILD_PLATFORM_ARCH
set TEST_PROCESSOR_ARCH=
echo kBuild: Cannot figure BUILD_PLATFORM_ARCH!
goto failed
:have_BUILD_PLATFORM_ARCH
echo dbg: BUILD_PLATFORM_ARCH=%BUILD_PLATFORM_ARCH%
set TEST_PROCESSOR_ARCH=

IF NOT ".%BUILD_PLATFORM_CPU%" = "."    goto have_BUILD_PLATFORM_CPU
IF "%BUILD_PLATFORM_ARCH%" = "amd64"    set BUILD_PLATFORM_CPU=k8
IF "%BUILD_PLATFORM_ARCH%" = "x86"      set BUILD_PLATFORM_CPU=i386
IF NOT ".%BUILD_PLATFORM_CPU%" = "."    goto have_BUILD_PLATFORM_CPU
echo kBuild: Cannot figure BUILD_PLATFORM_CPU!
goto failed
:have_BUILD_PLATFORM_CPU
echo dbg: BUILD_PLATFORM_CPU=%BUILD_PLATFORM_CPU%
goto process_BUILD_TARGET


:have_2_BUILD_PLATFORM
echo dbg: BUILD_PLATFORM=%BUILD_PLATFORM%
IF "%BUILD_PLATFORM%" = "win32"         set BUILD_PLATFORM_ARCH=x86
IF "%BUILD_PLATFORM%" = "win64"         set BUILD_PLATFORM_ARCH=amd64
IF NOT ".%BUILD_PLATFORM_ARCH%" = "."   goto have_2_BUILD_PLATFORM_ARCH
set TEST_PROCESSOR_ARCH=%PROCESSOR_ARCHITECTURE%
IF NOT ".%PROCESSOR_ARCHITEW6432%" = "." set TEST_PROCESSOR_ARCH=%PROCESSOR_ARCHITEW6432%
IF "%TEST_PROCESSOR_ARCH%" = "x86"      set BUILD_PLATFORM_ARCH=x86
IF "%TEST_PROCESSOR_ARCH%" = "X86"      set BUILD_PLATFORM_ARCH=x86
IF "%TEST_PROCESSOR_ARCH%" = "AMD64"    set BUILD_PLATFORM_ARCH=amd64
IF "%TEST_PROCESSOR_ARCH%" = "x64"      set BUILD_PLATFORM_ARCH=amd64
IF "%TEST_PROCESSOR_ARCH%" = "X64"      set BUILD_PLATFORM_ARCH=amd64
IF NOT ".%BUILD_PLATFORM_ARCH%" = "."   goto have_2_BUILD_PLATFORM_ARCH
set TEST_PROCESSOR_ARCH=
echo kBuild: Cannot figure BUILD_PLATFORM_ARCH!
goto failed
:have_2_BUILD_PLATFORM_ARCH
echo dbg: BUILD_PLATFORM_ARCH=%BUILD_PLATFORM_ARCH%

IF NOT ".%BUILD_PLATFORM_CPU%" = "."    goto have_2_BUILD_PLATFORM_CPU
IF "%BUILD_PLATFORM_ARCH%" = "amd64"    set BUILD_PLATFORM_CPU=k8
IF "%BUILD_PLATFORM_ARCH%" = "x86"      set BUILD_PLATFORM_CPU=i386
IF NOT ".%BUILD_PLATFORM_CPU%" = "."    goto have_2_BUILD_PLATFORM_CPU
echo kBuild: Cannot figure BUILD_PLATFORM_CPU!
goto failed
:have_2_BUILD_PLATFORM_CPU
echo dbg: BUILD_PLATFORM_CPU=%BUILD_PLATFORM_CPU%


REM #
REM # Target platform.
REM #
:process_BUILD_TARGET
IF NOT ".%BUILD_TARGET%" = "." goto have_BUILD_TARGET
set BUILD_TARGET=%BUILD_PLATFORM%
IF NOT ".%BUILD_TARGET_ARCH%" = "." goto have_BUILD_TARGET_ARCH
set BUILD_TARGET_ARCH=%BUILD_PLATFORM_ARCH%
:have_BUILD_TARGET_ARCH
IF NOT ".%BUILD_TARGET_CPU%" = "." goto have_BUILD_TARGET_CPU
set BUILD_TARGET_CPU=%BUILD_PLATFORM_CPU%
:have_BUILD_TARGET_CPU
echo dbg: BUILD_TARGET=%BUILD_TARGET%
echo dbg: BUILD_TARGET_ARCH=%BUILD_TARGET_ARCH%
echo dbg: BUILD_TARGET_CPU=%BUILD_TARGET_CPU%
goto next

:have_BUILD_TARGET
echo dbg: BUILD_TARGET=%BUILD_TARGET%
IF NOT ".%BUILD_TARGET_ARCH%" = "." goto have_2_BUILD_TARGET_ARCH
IF "%BUILD_TARGET%" = "os2"             set BUILD_TARGET_ARCH=x86
IF "%BUILD_TARGET%" = "win32"           set BUILD_TARGET_ARCH=x86
IF "%BUILD_TARGET%" = "win64"           set BUILD_TARGET_ARCH=amd64
IF ".%BUILD_TARGET_ARCH%" = "."         set BUILD_TARGET_ARCH=%BUILD_PLATFORM_ARCH%
:have_2_BUILD_TARGET_ARCH
echo dbg: BUILD_TARGET_ARCH=%BUILD_TARGET_ARCH%
IF NOT ".%BUILD_TARGET_CPU%" = "." goto have_2_BUILD_TARGET_CPU
IF "%BUILD_TARGET_ARCH%" = "amd64"      set BUILD_TARGET_CPU=k8
IF "%BUILD_TARGET_ARCH%" = "x86"        set BUILD_TARGET_CPU=i386
IF NOT ".%BUILD_TARGET_CPU%" = "." goto have_2_BUILD_TARGET_CPU
echo kBuild: Cannot figure BUILD_TARGET_CPU!
goto failed
:have_2_BUILD_TARGET_CPU
echo dbg: BUILD_TARGET_CPU=%BUILD_TARGET_CPU%

:next

REM # Make shell
set MAKESHELL="%PATH_KBUILD%\bin\%BUILD_PLATFORM_ARCH%.%BUILD_PLATFORM%/kmk_ash.exe"

REM # The PATH.
IF "%BUILD_PLATFORM_ARCH%.%BUILD_PLATFORM%" = "x86.nt"      set PATH=%PATH_KBUILD%\bin\x86.win32;%PATH%
IF "%BUILD_PLATFORM_ARCH%.%BUILD_PLATFORM%" = "x86.win"     set PATH=%PATH_KBUILD%\bin\x86.win32;%PATH%
IF "%BUILD_PLATFORM_ARCH%.%BUILD_PLATFORM%" = "amd64.nt"    set PATH=%PATH_KBUILD%\bin\amd64.nt;%PATH_KBUILD%\bin\x86.win32;%PATH%
IF "%BUILD_PLATFORM_ARCH%.%BUILD_PLATFORM%" = "amd64.win"   set PATH=%PATH_KBUILD%\bin\amd64.win64;%PATH_KBUILD%\bin\x86.win32;%PATH%
IF "%BUILD_PLATFORM_ARCH%.%BUILD_PLATFORM%" = "amd64.win64" set PATH=%PATH_KBUILD%\bin\x86.win32;%PATH%
set PATH=%PATH_KBUILD%\bin\%BUILD_PLATFORM_ARCH%.%BUILD_PLATFORM%;%PATH%
echo dbg: PATH=%PATH%

REM # Execute command
IF ".%1" = "." goto end
%1 %2 %3 %4 %5 %6 %7 %8 %9
goto end

:failed
:end

LuaJIT + Luarocks + Torch7 on Windows
=============================
I strongly recommend using Torch on a Unix environment. It would be extremely easier to set everything up. 
Specially, if you do not need CUDA capabilities, I urge you to try to set up a virtual Linux machine using Windows Hyper-V, or try the new Linux Subsystem for Windows ( aka Bash on Windows).
That being said, if you, like me, prefer working on your Windows machine, this guide will walk you through all the steps.
This is an easy to use (well, relitively) installation for _recent_ versions of LuaJIT, luarocks, torch7 and various torch7 modules on Windows.
The provided LuaJIT, luarocks, torch7 and its modules point to their respective git repository. Unless specified (i.e. necessary), no changes are made except for the compilation and installation processes.
This repository is forked from [torch/luajit-rocks](https://github.com/torch/luajit-rocks) with imported changes from [diz-vara/luajit-rocks](https://github.com/diz-vara/luajit-rocks).

# Current Module Versions
[LuaJIT](https://github.com/LuaJIT/LuaJIT/tree/v2.1) 2.1.0-beta2

[luarocks](https://github.com/keplerproject/luarocks) 2.2.0-beta1

# Pre-requisites
Install [CMake](http://cmake.org), [Git](https://git-scm.com/), and a version of [Visual Studio 2013/2015](https://www.visualstudio.com/) (Community editions are free) on your system.
If you want CUDA capabalities (for cutorch and cunn modules), install [CUDA Toolkit v7.5](https://developer.nvidia.com/cuda-downloads) after installing Visual Studio.
If you want cuDNN support (for cudnn module), install [cuDNN](https://developer.nvidia.com/cudnn).
If you want Qt support (for qtlua and qttorch modules), follow [this guide](http://doc.qt.io/qt-4.8/install-win.html) to install Qt 4.8. You can download the source, I recommend 4.8.6, from [here](https://download.qt.io/archive/qt/). Note that there are also pre-built binaries for VS2008 and VS2010. But we need to build it for our choice of Visual Studio.

# Installing LuaJIT/Luarocks/Torch7
During all the following steps, we use the Visual Studio Native Tools Command Prompt, which is a command prompt with appropriate environment variables set. You can locate it inside C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\Shortcuts for VS2013, and C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2015\Visual Studio Tools\Windows Desktop Command Prompts for VS2015.

I recommend using the 64-bit Native Tools (e.g. VS2013 x64 Native Tools Command Prompt or VS2015 x64 Native Tools Command Prompt). We will refer to this by NTCP in the reset of this guide. Make sure you do not switch from 32-bit to 64-bit (or vice versa) compilation at any point.

## 1. LuaJIT and Luarocks
Choose a directory to put the source files into, preferably a short path with no spaces (e.g. C:\Programs).
Since we will be refering to this directory a lot, let's create an Environment Varibale for it first. 
You can do this either by running

```sh
setx LuaJIT-Luarocks-Torch7_ROOT C:\Programs\LuaJIT-Luarocks-Torch7	
```

on a regular Command Prompt (BTW, you can open a CP session by pressing WindowsKey+X followed by C (or A for admin)), or using __Control Panel|System|Advanced|Environment variables menu__.
Keep in mind that the setx command sets the variable for the current user.
You can close the Command Prompt window.


On your NTCP run,

```sh
cd %LuaJIT-Luarocks-Torch7_ROOT%\..
git clone https://github.com/SiavashGorji/LuaJIT-Luarocks-Torch7.git
cd %LuaJIT-Luarocks-Torch7_ROOT%
mkdir build
cd build
```

Please do not close the NTCP session yet.
This will first download the LuaJIT-Luarocks-Torch7 source files into the LuaJIT-Luarocks-Torch7 folder, then creates and moves to the build directory within it.

Note that if you do not use the git command and download the repository directly from https://github.com/SiavashGorji/LuaJIT-Luarocks-Torch7, the unzipped directory would be named LuaJIT-Luarocks-Torch7-master. Rename this to LuaJIT-Luarocks-Torch7 before proceeding from the second cd command above.

Now, for the destination directory to install LuaJIT-Luarocks-Torch7, we use an "install" folder within the LuaJIT-Luarocks-Torch7 directory (i.e. %LuaJIT-Luarocks-Torch7_ROOT%\install). Note that later on, the torch installation will create a "share "folder outside of the installation directory (i.e. %LuaJIT-Luarocks-Torch7_ROOT%).
On the NTCP run,

```sh
cmake .. -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX=%LuaJIT-Luarocks-Torch7_ROOT%\install
nmake
cmake .. -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX=%LuaJIT-Luarocks-Torch7_ROOT%\install -P cmake_install.cmake
```

After the above commands, you can close your NTCP.
The .. argument to the cmake commands tells them the location of the root CMakeLists.txt (which in our case is located in %LuaJIT-Luarocks-Torch7_ROOT%), relative to the current directory (i.e. %LuaJIT-Luarocks-Torch7_ROOT%\build). 
This is usefull since cmake puts all of its generated makefiles into the current directory.
The -G "NMake Makefiles" flag tells cmake to generate NMake files instead of a Visual Studio Solution (which it does by default on Windows).
The nmake command actually builds the source files using the cmake-generated make files. 
The second cmake command copies (installs) all the required files into the installation directory.


Finally, we need to add some variables to the Environment Variables and add the installation directory to the Windows path:
First, add the installation directory (%LuaJIT-Luarocks-Torch7_ROOT%\install) to the System Path, 

```sh
setx path "%LuaJIT-Luarocks-Torch7_ROOT%\install;%path%"
```

Now, on a regular Command Prompt (exit and reopen if it's already open), run

```sh
luajit -e print(package.path)
```

We need to create an Environment Variable called LUA_PATH and set its value to the results of the above command (which in our case was ".\?.lua;C:\Programs\LuaJIT-Luarocks-Torch7\install\lua\?.lua;C:\Programs\LuaJIT-Luarocks-Torch7\install\lua\?\init.lua;").
Again, we can do this using setx,

```sh
setx LUA_PATH .\?.lua;C:\Programs\LuaJIT-Luarocks-Torch7\install\lua\?.lua;C:\Programs\LuaJIT-Luarocks-Torch7\install\lua\?\init.lua;
```
Similarly, we need to create LUA_CPATH and set its value to the output of

```sh
luajit -e print(package.cpath)
```

which in our case was ".\?.dll;C:\Programs\LuaJIT-Luarocks-Torch7\install\?.dll;C:\Programs\LuaJIT-Luarocks-Torch7\install\loadall.dll".

```sh
setx LUA_CPATH .\?.dll;C:\Programs\LuaJIT-Luarocks-Torch7\install\?.dll;C:\Programs\LuaJIT-Luarocks-Torch7\install\loadall.dll
```

Finally, we need to set LUA_DEV to the Lua installation directory

```sh
setx LUA_DEV %LuaJIT-Luarocks-Torch7_ROOT%\install
```

You can check your luarocks installation by running "luarocks" or "luarocks list" in a regular Command Prompt. 
The former should display the luarocks help and the latter should return the installed packages, which are none for now.

Note that in the installation directory, there is a cmake.cmd which automatically appends any cmake commands (which are called by luarocks) with the -G "NMake Makefiles" flag. In order for this to work, you should make sure that the installation directory precedes cmake installation directory.

## 2. Torch7
From this point on, we will use luarocks to install all the required packages, including torch7 and its modules.
Basically, there are two types of lua packages, ones written completely in lua, and ones that contain C/C++ implementation.
Whenever we want to install a package containing C codes using luarocks, we need to run luarocks within our NTCP instead of a regular Command Prompt (to be safe, you can always use NTCP).

Before installing torch7, we need to install cwrap (purly lua code) and paths (containing C code) modules. 
While we can install modules like cwrap using luarocks on a regular Command Prompt, for many other modules that contain C code, we will going to need the NTCP.
So to keep things simple, try to always call luarocks within your NTCP session.

```sh
luarocks install cwrap
```
Note that if you run "luarocks list" after this, you should see cwrap in the list of installed modules. Similarly,

```sh
luarocks install paths
```

We can now procede by installing torhc7 on the NTCP,

```sh
luarocks install torch
```
To test the torch installation, we can create and display a 2x3x4 randomly initialized tensor on a regular Command Prompt by

```sh
luajit
require "torch"
print(torch.Tensor(2,3,4))
```
You can exit from luajit by pressing Ctrl+C.

Finnaly, set Torch_DIR as an Environment Variable to the LuaJIT-Luarocks-Torch7_ROOT%\share\cmake\torch directory.
```sh
setx Torch_DIR %LuaJIT-Luarocks-Torch7_ROOT%\share\cmake\torch
```

# Installing Torch Modules
When you install torch on Unix environments, it will automatically installs "lots of nice goodies". 
In the following section, we try to install them (i.e. most of them) one by one using luarocks installer.
Try to install these in the same order presented here.
To install some of the lua/torch modules that contain C code on Windows, we need to make some changes to them (since we are basically porting them from Linux).
You can find all such editted modules inside the extra folder in "%LuaJIT-Luarocks-Torch7_ROOT%. 
To install these, we will use luarocks local installation capabality (i.e. using "luarocks make" instead of "luarocks install").
As you can see below, all we need to do is to cd the NTCP to the main directory of each module, and run "luarocks make path-to-module-rockspec-file".


```sh
luarocks install luafilesystem
luarocks install penlight

cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\lua-cjson
luarocks make lua-cjson-2.1devel-1.rockspec

cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\luaffifb
luarocks make luaffi-scm-1.rockspec

luarocks install sundown
luarocks install dok

cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\sys
luarocks make sys-1.1-0.rockspec

luarocks install xlua
luarocks install nn
luarocks install graph
luarocks install nngraph
luarocks install image
luarocks install optim
luarocks install gnuplot
luarocks install env

cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\nnx
luarocks make nnx-0.1-1.rockspec

luarocks install graphicsmagick
luarocks install argcheck
luarocks install fftw3

cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\torch-signal
luarocks make ./rocks/signal-scm-1.rockspec
```

## Installing cutorch, cunn, cunnx and cudnn Modules
Installing the cutorch module requires some additional steps. 
First of all, make sure you have already installed CUDA Toolkit on your machine.
Currently, there is a problem with the CMakeCache.txt (probably some linux endline that are not properly interpreted by windows).
So, we will use the CMake GUI to ensure that everything would be compatible with Windows. On your NTCP,

```sh
cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\cutorch
luarocks make ./rocks/cutorch-scm-1.rockspec
```

This will be terminated with some parsing error from CMake. Keep the NTCP session opened for now.
Now, open CMake GUI and set the source code directory (e.g. C:\Programs\LuaJIT-Luarocks-Torch7\extra\cutorch) and build directory (C:\Programs\LuaJIT-Luarocks-Torch7\extra\cutorch\build). 
Click on Configure and after seeing "Configuring done" in the message box, click on Generate. You can now close the CMake GUI window.
Back to our NTCP, we will try to install the module once more

```sh
luarocks make ./rocks/cutorch-scm-1.rockspec
```

This should take care of the parsing errors.
Note that since we are compiling cude files, this could take a while.

Now, we can procede by installing the cunn module. We will follow the exact procedure as we did for cutorch. On your NTCP,

```sh
cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\cunn
luarocks make ./rocks/cunn-scm-1.rockspec
```

Again, this will be terminated with some parsing error from CMake. Keep the NTCP session opened for now.
Now, open CMake GUI and set the source code directory (e.g. C:\Programs\LuaJIT-Luarocks-Torch7\extra\cunn) and build directory (C:\Programs\LuaJIT-Luarocks-Torch7\extra\cunn\build). 
Click on Configure and after seeing "Configuring done" in the message box, click on Generate. You can now close the CMake GUI window.
Back to our NTCP, we will try to install the module once more

```sh
luarocks make ./rocks/cunn-scm-1.rockspec
```

Installing cunnx module requires the same fix. On your NTCP,

```sh
cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\cunnx
luarocks make ./rocks/cunnx-scm-1.rockspec
```

Again, this will be terminated with some parsing error from CMake. Keep the NTCP session opened for now.
Now, open CMake GUI and set the source code directory (e.g. C:\Programs\LuaJIT-Luarocks-Torch7\extra\cunnx) and build directory (C:\Programs\LuaJIT-Luarocks-Torch7\extra\cunnx\build). 
Click on Configure and after seeing "Configuring done" in the message box, click on Generate. You can now close the CMake GUI window.
Back to our NTCP, we will try to install the module once more
```sh
luarocks make ./rocks/cunnx-scm-1.rockspec
```

If you have cuDNN installed, you can easily install cudnn module by running
```sh
luarocks install cudnn
```
on a NTCP session.

## Installing qtlua and qttorch
Make sure you have installed Qt 4.X on your machine and qmake.exe is on the system path.
Installing qtlua is then straightforward. On a NTCP, run

```sh
luarocks install qtlua
``
And for qttorch,

```sh
cd %LuaJIT-Luarocks-Torch7_ROOT%\extra\qttorch
luarocks make ./rocks/qttorch-scm-1.rockspec
``

# Currently not Working

The following modules are currently unavailable due to some unsolved errors during compiling.

```sh
trepl
threads
audio
```


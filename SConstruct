#!python

#reference:https://github.com/BastiaanOlij/gdnative_cpp_example/blob/1b8d45ca5b661bf30dcfac16e8918adaf5995de6/SConstruct

import os, subprocess

opts = Variables([], ARGUMENTS)

# Gets the standard flags CC, CCX, etc.
env = DefaultEnvironment()

# Define our options
opts.Add(EnumVariable('target', "Compilation target", 'debug', ['editor','template_release','template_debug']))
opts.Add(EnumVariable('platform', "Compilation platform", '', ['', 'windows', 'x11', 'linux', 'osx']))
opts.Add(EnumVariable('p', "Compilation target, alias for 'platform'", '', ['', 'windows', 'x11', 'linux', 'osx']))
opts.Add(BoolVariable('use_llvm', "Use the LLVM / Clang compiler", 'no'))
opts.Add(PathVariable('target_path', 'The path where the lib is installed.', 'bin/'))
opts.Add(PathVariable('target_name', 'The library name.', 'libgdexample', PathVariable.PathAccept))

# Local dependency paths, adapt them to your setup
cpp_bindings_path = "cpp/godot-cpp/"
cpp_library = "libgodot-cpp"

# only support 64 at for now...
arch = "x86_64"

# Updates the environment with the option variables.
opts.Update(env)

# Process some arguments
if env['use_llvm']:
    env['CC'] = 'clang'
    env['CXX'] = 'clang++'

if env['p'] != '':
    env['platform'] = env['p']

if env['platform'] == '':
    print("No valid target platform selected.")
    quit();

# Check our platform specifics
if env['platform'] == "osx":
    env['target_path'] += 'osx/'
    cpp_library += '.osx'
    if env['target'] == 'editor':
        env.Append(CCFLAGS = ['-g','-O2', '-arch', 'x86_64', '-std=c++17'])
        env.Append(LINKFLAGS = ['-arch', 'x86_64'])
    else:
        env.Append(CCFLAGS = ['-g','-O3', '-arch', 'x86_64', '-std=c++17'])
        env.Append(LINKFLAGS = ['-arch', 'x86_64'])

elif env['platform'] in ('x11', 'linux'):
    env['target_path'] += 'x11/'
    cpp_library += '.linux'
    if env['target'] in ('debug', 'd'):
        env.Append(CCFLAGS = ['-fPIC', '-g3','-Og', '-std=c++17'])
    else:
        env.Append(CCFLAGS = ['-fPIC', '-g','-O3', '-std=c++17'])

elif env['platform'] == "windows":
    env['target_path'] += 'win64/'
    cpp_library += '.windows'
    # This makes sure to keep the session environment variables on windows,
    # that way you can run scons in a vs 2017 prompt and it will find all the required tools
    env.Append(ENV = os.environ)

    env.Append(CCFLAGS = ['-DWIN32', '-D_WIN32', '-D_WINDOWS', '-W3', '-GR', '-D_CRT_SECURE_NO_WARNINGS', '-EHsc', '-DNDEBUG', '-MD', '-DTYPED_METHOD_BIND', '-DNOMINMAX'])
    if env['target'] != 'editor':
        env.Append(CCFLAGS = ['-O2', '-DEDITOR_FEATURE_DISABLED'])

cpp_library += '.' + env['target'] + '.' + arch + '.lib'

# make sure our binding library is properly includes
env.Append(CPPPATH=[
        cpp_bindings_path + 'include/',
        cpp_bindings_path + 'gen/include',
        cpp_bindings_path + 'gdextension',
    ],
)
## godot-cpp
env.Append(LIBPATH=[cpp_bindings_path + 'bin/'])
env.Append(LIBS=[cpp_library])

## lunasvg
env.Append(LIBPATH=['cpp/lunasvg_build'])
env.Append(LIBS=['lunasvg.lib'])

# tweak this if you want to use different folders, or more folders, to store your source code in.
env.Append(CPPPATH=[
    'cpp/src/',
    'cpp/lunasvg/include/',
    'cpp/lunasvg/3rdparty/plutovg',
    'cpp/lunasvg/3rdparty/software'
    ]
)


def add_sources(sources, dir, extension):
    for f in os.listdir(dir):
        if f.endswith("." + extension):
            sources.append(dir + "/" + f)


sources = []
## godot-svgsprite
add_sources(sources, 'cpp/src', 'cpp')

library = env.SharedLibrary(target=env['target_path'] + env['target_name'] + "-" + env['target'], source=sources)

Default(library)

# Generates help for the -h scons option.
Help(opts.GenerateHelpText(env))
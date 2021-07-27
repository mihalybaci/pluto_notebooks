### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ a77b1794-6c71-11eb-1472-d9b2e129335f
begin
	import Pkg# Import the package manager
	Pkg.activate(mktempdir())# Activate the temporary environment
	# Add the packages (downloading them if necessary)
	Pkg.add(["BenchmarkTools", "CUDA", "Images", "PlutoUI", "PyCall", "SatelliteToolbox"])
	# Load the packages
	using BenchmarkTools
	using CUDA
	using Images
	using PlutoUI
	using Printf
	using PyCall
	using SatelliteToolbox
end

# ╔═╡ f85eb8ca-649c-11eb-19bb-99e1a83e459b
br = HTML("<br>");  # Add a semi-colon to block the output

# ╔═╡ 2055d28c-649d-11eb-3b12-639929fff5fa
bigbr = HTML("<br><br><br><br>");

# ╔═╡ 91f08860-7118-11eb-304f-298cb1a9d953
hr = html""" <hr style="border: 1px dotted"> """;

# ╔═╡ f499ecb4-6492-11eb-19c2-43bda1cf2a0c
html"<button onclick=present()>Present</button>"

# ╔═╡ 8363f966-6c8a-11eb-0485-b39bfa77d265
md"# Exploring the Julia  Language"

# ╔═╡ 050d8af6-921a-11eb-3ae2-23845d02b6a9
br

# ╔═╡ 007fdd68-921a-11eb-1a21-3d505f0541b0
md"### This notebook is available on Github!
#### [https://github.com/mihalybaci/pluto_notebooks](https://github.com/mihalybaci/pluto_notebooks)
"

# ╔═╡ d554a44d-7eaf-49ed-a5a3-bf9a2fb38ed7
br

# ╔═╡ e2b9a78e-9313-11eb-2899-b5354d00b10c
md"""
#### julialang.org - Julia language homepage
#### juliacomputing.com - Julia language homepage
#### juliahub.com - Julia language homepage
"""

# ╔═╡ b681e152-8e31-11eb-37a1-73d640a225b0
md"""
# Julia v1.6.0 released on 25 March 2021!
### Notable updates
_____________________
#### Parallel precompilation*
#### Pre-compilation at install, not first run
#### Reduced recompilation
#### Reduced compiled latency
#### Faster binary loading
#### Improved networking features*
"""

# ╔═╡ 47cda722-9187-11eb-3126-f5edb8b1057e
br

# ╔═╡ 492e55c8-9187-11eb-08c1-418da2d63ba1
md"### Get download Julia today!
##### [https://julialang.org/downloads](https://julialang.org/downloads)
"

# ╔═╡ 03c3bf38-6493-11eb-1cd2-4bcf96696f89
md"""
# A short list about Julia
- #### Designed from the ground-up for scientific computing
- #### Walks like Python, runs like C
- #### Simple project environment management
- #### Full parallelism (multi-threading, multi-process, GPU)
- #### Bye-bye, OOP! Hello, multiple dispatch!
- #### Unbeatable interoperability
- #### 5000+ registered packages (2000+ new since March 2020)
- #### It has its own [font](https://cormullion.github.io/pages/2020-07-26-JuliaMono/#unicode_coverage), JuliaMono!!!
"""

# ╔═╡ d3220a8c-6495-11eb-0c22-0d1b450c91f1
md"# How much can you bench(mark)?"

# ╔═╡ 0bd4be8a-6c8c-11eb-0f56-e9c2d10bacaa
md"#### Base language only!"

# ╔═╡ 80745e40-6498-11eb-2f82-d133e2d32f78
load(download("https://raw.githubusercontent.com/mihalybaci/pluto_notebooks/main/images/julia_bench.png"))

# ╔═╡ ea2b7858-649c-11eb-36a8-2f2670063bee
bigbr

# ╔═╡ 482e7128-64c1-11eb-3af8-2dff4ca691c3
br

# ╔═╡ a2ef89dc-649c-11eb-100f-55274909e1b4
load(download("https://github.com/mihalybaci/pluto_notebooks/raw/main/images/benchmarksgame_1.png"))

# ╔═╡ ac11c534-649c-11eb-0d82-dff01e7f1cc8
load(download("https://github.com/mihalybaci/pluto_notebooks/raw/main/images/benchmarksgame_2.png"))

# ╔═╡ 8200b8b0-64b3-11eb-30c8-0f043db218d4
bigbr

# ╔═╡ a107c3ae-751e-11eb-2449-e1a746074ca0
bigbr

# ╔═╡ 91372ae6-751e-11eb-1615-d94fa16a7f4e
md"### Optimized matrix-matrix multiplication"

# ╔═╡ 7123daf8-751e-11eb-1cb0-8b00a6f054ac
load(download("https://user-images.githubusercontent.com/8043603/105195788-f6001a80-5b08-11eb-81ff-c6eec15b60bf.png"))

# ╔═╡ 7dc1f860-751e-11eb-03ff-5f18abfa6ad8
bigbr

# ╔═╡ a5943e0c-751e-11eb-29b8-af711725dba9
bigbr

# ╔═╡ 02992046-751e-11eb-1e8e-37534d3b339c
load(download("https://github.com/mihalybaci/pluto_notebooks/raw/main/images/numpytimings.png"))

# ╔═╡ bd00765a-751e-11eb-3729-5904acfefaff
bigbr

# ╔═╡ bee68ed2-751e-11eb-3c09-d1a25383b36c
bigbr

# ╔═╡ a7d1d688-64b2-11eb-3c21-159fe6996ff1
md"""
### Julia ❤ HPC!|

#### petaFLOPS club
- C
- C++
- FORTRAN
- Julia

##### In 2017, the Celeste astronomical image analysis project (writtin in Julia) reached 1.54 petaFLOPS on the Knights Landing supercomputer at LBNL."""

# ╔═╡ 9b7ee436-751d-11eb-1ffe-bd3f35127821
bigbr

# ╔═╡ 0dda3e88-7510-11eb-3ebc-310d68675c2d
md"""### A final note on benchmarks from Dr. Steven Johnson
#### MIT Professor, creator of FFTW and Julia contributor.

>It’s impressive that it’s possible to beat optimized C libraries in certain cases with native Julia code, but focusing too much on such cases will often lead people astray. Benchmarks against optimized C code help establish Julia’s performance capabilities, but only represent a *starting* point for interesting work.
>
>Fundamentally, the reason Julia exists **is not to beat the performance of existing C libraries on existing problems.** If all the high-performance code you will ever need has already been written, then you don’t have as much need for a new language. Julia is attractive for people who need to write **new** high-performance code to solve **new** problems, which don’t fit neatly into the boxes provided by existing numpy library functions.
>
> It’s not that Julia has some secret sauce that allows it to beat C — it is just that its compiled performance is comparable to that of C (boiling down to the same LLVM backend), so depending on the programmer’s cleverness and time it will sometimes beat C libraries and sometimes not.
>
>It is, however, vastly **easier** to write high-performance Julia code than comparable C code in most cases, because Julia is a higher level language with performant high-level abstractions. This can also make it easier to be clever, with tricks like metaprogramming that are tedious in C. And the code you write in Julia can at the same time be more flexible (type-generic and composable), allowing greater code re-use.
>
>This is important for those of us who want to work on new problems and to go beyond endlessly recycling the solutions of the past.

##### Excerpt from a [post](https://discourse.julialang.org/t/julias-applicable-context-is-getting-narrower-over-time/55042/40) on the Julia Discourse forums. 
"""

# ╔═╡ ca6e9678-7118-11eb-25bd-39cd6b1416c3
hr

# ╔═╡ dbbe2972-6c70-11eb-3b23-ab10538061b6
md"## Pkg and working with environments"

# ╔═╡ 85a888f0-6c72-11eb-1f27-3dcdb744e584
md"""
### Importing the Julia package manager
```
julia> import Pkg

# OR

julia> ]  # Goes into `Pkg mode`
```


$br

### Starting a fresh environment

```
julia> mkdir("MyProject")

julia> cd("MyProject")

#type `]`
(@v1.6) pkg> activate .

(MyProject) pkg> add SomePackage  # Registered packages

(MyProject) pkg> add http://github.com/Some/Other/Package  # Unregistered package

(MyProject) pkg> add /my/local/package  # Must be a `git` repo
```


$br
$br


### Recreating someone else's environment

```
julia>
# Open Julia REPL and type `;`
# Repo must contain Project.toml
shell> git clone https://github.com/my/ClonedRepo
# `backspace`
julia> cd("ClonedRepo")
# `]`
pkg> activate .
(ClonedRepo) pkg> instantiate  # Automatically downloads dependencies according to `Project.toml`
```

$br

#### How does this work for this notebook? Let's check!
"""

# ╔═╡ 88a95a89-7542-4047-b75a-d4d4198c6294
md"#### Pluto v0.15 added built-in package management!"

# ╔═╡ 5ad51346-b186-4fb1-abe3-b332ca01fbfc
md"""
$bigbr 

##### Quick digression 
##### typing `;` in the REPL* opens `shell` mode
##### typing `?` in the REPL opens the help docs
##### typing `backspace` returns to the REPL from the other modes

*Read, evaluate, print loop


"""

# ╔═╡ a5d7823c-6c72-11eb-1daf-a1e1616ff019
bigbr

# ╔═╡ 8af30d8e-7119-11eb-0ab0-e3528a469764
hr

# ╔═╡ 286fb7e8-6496-11eb-1306-b56859f2ee3b
md"""
## What's the deal with multiple dispatch?
"""

# ╔═╡ 3ab45088-6496-11eb-0c8d-b170a971e912
md"""
### Consider object-oriented programming (OOP) 

	# Python example
	class Alien:
		planet = ""
		def is_evil(p):
			if rand < p:
				True

	an_alien = Alien()
	an_alien.planet = "Mars"

	an_alien.is_evil(0.5)
"""

# ╔═╡ fb96aa58-fecf-4973-aa6e-8f3485d4703e
br

# ╔═╡ 9d185a72-649f-11eb-061d-3ba4357d4e4d
md"""
### Compare with multiple-dispatch methods

	mutable struct Alien
		planet
		Alien() = new("")
	end

	an_alien = Alien()
	an_alien.planet = "Mars"

	is_evil(p) = rand() < p  # Create the generic method
	is_evil(obj::Alien) = is_evil(0.5)  # Add a type-specific method
	is_evil(an_alien)

"""

# ╔═╡ 6a37ffac-713d-11eb-0444-03a10357adb7
mutable struct Alien
	planet  
	Alien() = new("")
end

# ╔═╡ 70efa204-711d-11eb-2373-fd5ed207de9a
bigbr

# ╔═╡ e213ca9a-7134-11eb-12eb-adeb89716b61
bigbr

# ╔═╡ b8dbbfa4-64a1-11eb-21f3-bf8d4517e086
md"""### Does Google live up to it's "Don't Be Evil" code of conduct?"""

# ╔═╡ 4dbfbc7e-64a2-11eb-29f0-891d4121fc8f
mutable struct Corporation
	name
	Corporation(str) = new(str)
end

# ╔═╡ ee7515e0-64a4-11eb-3d94-77b8a34c3f7b
bigbr

# ╔═╡ d4581d5c-64a3-11eb-0f0f-d9e006e75a06
bigbr

# ╔═╡ 9e6269f0-64a3-11eb-14ce-c1877e9fbc9e
md"
### Multiple dispatch:
 - Reduces need to copy/paste code
 - Increases code sharing
 - Increases package interoperability
 - Increases code clarity (IMHO)
 - Just makes more sense (IMHO)

Watch Stefan Karpinski's [The Unreasonable Effectivness of Multiple Dispatch](https://youtu.be/kc9HwsxE1OY) on YouTube for more details.
"

# ╔═╡ 98336ce6-7119-11eb-1ac5-f5f3bd8f75da
hr

# ╔═╡ 36292f5d-6bfe-415c-a119-35fd12cc4bd4
md"""## Metaprogramming
### Writing functions that write other functions.


#### For more in-depth information see: ['Adventures in Code Generation'](https://www.youtube.com/watch?v=mSgXWpvQEHE&list=PLP8iPy9hna6StY9tIJIUN3F_co9A0zh0H&index=5)
#####  by Steven Johnson, JuliaCon 2019, video available on YouTube"""

# ╔═╡ dcbf8055-b94e-457d-a261-02d914235033
bigbr

# ╔═╡ 9376a8b8-0719-4b97-bd1a-f1ffe34b4a87
macro only1(code)
	return :( 1 )
end

# ╔═╡ b21b30e3-67e4-423d-9d4e-80c28a1b263e
@only1 sin(π)

# ╔═╡ 9e3393aa-d6de-47c1-85de-ec8488d34458
@macroexpand @benchmark sin(1)

# ╔═╡ f9604c02-69b4-4764-bcc5-081c39c0cebb
bigbr

# ╔═╡ bc64e284-aaf5-43c2-9cc9-a0c352f7044f
sayhello(name) = println("Hello, ", name, ".")

# ╔═╡ 9960cea7-2e2a-4b7f-aaab-633ff0308bda
sayhello("Bob")

# ╔═╡ 7bdb090a-50f8-4b86-9d82-77db15939b17
br

# ╔═╡ 1599e255-2467-4dfb-b352-d2b6ad5117b5
with_terminal() do
    sayhello("Bob")
end

# ╔═╡ 409ce0d7-8996-4136-9b08-28b7274a3b0c
br

# ╔═╡ 15de8d9c-a1ef-4821-a1dc-52b28a09b889
macro terminal(stuff)
	quote
		with_terminal() do
			$(esc(stuff))
		end
	end
end

# ╔═╡ 986417d2-768c-4401-ace2-4f340815899e
@terminal sayhello("Alice")

# ╔═╡ 4f10b094-19ba-491c-86ae-c26853149da5
hr

# ╔═╡ 05b9366a-64ae-11eb-1535-63b2eb1a237c
md"""
## Unparalleled interoperability
### From within Julia is possible to use code from:
- **C**
- **FORTRAN**
- C++
- Python
- R
- Java
- Matlab
- Octave
- Mathematica
- Objective-C
"""

# ╔═╡ 7fab76be-92e3-11eb-11cc-051b8bd8bbce
br

# ╔═╡ 7bfaadfa-92e3-11eb-39ca-89cb7e4fd8c1
md"""### It also works the other way!
- **pyjulia** - Run Julia within Python
- **JuliaCall** - Run Julia within R
"""

# ╔═╡ 010ee5f4-7135-11eb-2987-f34bb67004c1
bigbr

# ╔═╡ be821d4a-64b3-11eb-0013-39de4b85317c
md"### Examples from C"

# ╔═╡ 1078b698-64ae-11eb-23b5-59dafc065ec8
# This code prints the system clock time directly from the C standard library
ccall(:clock, Int32, ())

# ╔═╡ 36f1b350-6c70-11eb-2609-bb5ab899eef5
s = "The Julia programming language rocks!"

# ╔═╡ 07b47076-6c70-11eb-3e80-b1783abb82fc
@ccall strlen(s::Cstring)::Csize_t

# ╔═╡ 58995522-99b5-46d6-99d5-2de20db37991
path = let
	cpath = ccall(:getenv, Cstring, (Cstring,), "SHELL")  # Get the PATH as a Cstring
	try
		unsafe_string(cpath)  # Try to convert to string
	catch e
		cpath, e  # If there is an error, capture cpath and the error
	end
end

# ╔═╡ 89a23598-64af-11eb-2cc6-6556d23893db
bigbr

# ╔═╡ 802f5856-6c70-11eb-2416-6bf168fb3f6a
md"""
### Examples from Python

##### Adding Packages via Conda/pip
```
using Conda
Conda.add("package")  # = conda add
Conda.pip_interop(true, env)
Conda.pip("install", "package")  # = pip install
```
##### Setup PyCall
```
# Only has to be done once
julia> ENV["PYTHON" = "/path/to/python"  # "" --> Conda.jl default
julia> Pkg.build("PyCall")
# Re-launch Julia
```

#### At home, I use Julia to run my Python environment.
"""

# ╔═╡ 024eb854-92e4-11eb-0ee6-73bc6086aca3
bigbr

# ╔═╡ 10d9e896-92e4-11eb-2fe4-dd2ed7694134
md"### Time how long it takes to calculcate the sine of 10⁵ random numbers..."

# ╔═╡ f9679ea6-92e3-11eb-0815-dfb76fa6c38c
md"""
##### from within Python...

```
import timeit
import numpy as np

the_setup = '''\
import numpy as np

a = np.random.rand(100000)

def f(x):
	return np.sin(x)
'''

np.min(timeit.repeat('f(a)', setup=the_setup, number=1, repeat=1000))*1e6

```
##### Runtime: 1098 μs
"""

# ╔═╡ 7de2494c-92e4-11eb-0c54-69df9b5a698b
br

# ╔═╡ 39f00350-92e4-11eb-272b-c9913be4e25c
md"#### using Python within Julia, version 1..."

# ╔═╡ 5ab88792-92e4-11eb-388d-1f147881b2bf
begin
	py"""
import timeit
import numpy as np

def time_of_the_sines():
	su = '''\
import numpy as np

a = np.random.rand(100000)

def f(x):
	return np.sin(x)
	'''

	stmnt = '''f(a)'''
	
	return np.min(timeit.repeat(stmnt, setup=su, number=1, repeat=1000))*1e6
"""
	pysintime = round(Int, py"time_of_the_sines"())
	md""  
end

# ╔═╡ 734b4b82-92e4-11eb-0705-c30c20bfc0ef
md"""##### Runtime: $pysintime μs"""

# ╔═╡ 7b133a82-92e4-11eb-1e88-719b4c135b07
br

# ╔═╡ 63838f7a-92e4-11eb-3548-5dcc29652ffe
md"### using Python within Julia, version 2..."

# ╔═╡ d0f30bea-706f-11eb-15a6-d7ba972ec3d2
x = rand(100_000);

# ╔═╡ b5723bfe-706f-11eb-3145-e59fad8e37c2
np = pyimport("numpy")

# ╔═╡ bf3fb88a-706f-11eb-2eff-c78593c02a4a
@benchmark np.sin($x)

# ╔═╡ d6717d9e-92e4-11eb-3a23-adae327a1b45
br

# ╔═╡ c86de822-92e4-11eb-390d-b1675062f70c
md"### and finally, just using Julia."

# ╔═╡ 07124a24-7070-11eb-27aa-bb67c4fb65b3
time_sin = @benchmark sin.($x)

# ╔═╡ d2bd088a-92e4-11eb-1f59-09fd6b850699
bigbr

# ╔═╡ 10d1a370-7070-11eb-374a-f3d5421d8eb9
md"#### Key points:

- ##### There are multiple ways to interact with Python code
- ##### It is possible to time python functions from Julia
- ##### Sine calculations were $(round(1098/(time_sin.times[1]*1e-3), digits=2))x faster in Julia!
"

# ╔═╡ a70a5e8c-7119-11eb-0ca5-ab74559db699
hr

# ╔═╡ c07d8068-64af-11eb-3ebd-2b8475096673
md"## State-of-the-Art Packages"

# ╔═╡ 52ceed22-64b4-11eb-2128-89132de079cb
md"""
### Noteworthy packages
(all Julia packages end in .jl)
- **Conda, PyCall** -- Python interop
- **IJulia** -- Jupyter notebooks
- **Pluto, PlutoUI** -- Pluto notebooks!!!
- **CSV, DataFrames** -- Core dataframes support
- **Plots, Gadfly** -- Plotting
- **Differential Equations** -- State-of-the-art diff eq solvers
"""

# ╔═╡ ced304c6-64af-11eb-28a9-bd26b77e4b48
md"### Check [juliahub.com](https://juliahub.com/ui/Home) for your favorites!"

# ╔═╡ 489df172-6577-11eb-036a-0721f2d5e86a
bigbr

# ╔═╡ 3d05e82a-711f-11eb-2cc6-03e9b45e4d16
bigbr

# ╔═╡ 4f914b28-6577-11eb-307e-d3fcb5d7090b
md"
### Package Spotlight: SatelliteToolbox
#### [Julia and Amazonia-1](https://discourse.julialang.org/t/julia-and-the-satellite-amazonia-1/57541)
"

# ╔═╡ 65661654-6577-11eb-3a2a-cd07152d69ee
md"#### Estimate satellite positions: Matlab vs Julia vs Python
- 196 satellites
- Use the SGP4 propagator
- Time range of 24 hours
- Estimate the oribital elements and positions every 15 seconds
"

# ╔═╡ 4eb669bd-8c69-4f5f-a574-76155df88c67
br

# ╔═╡ 82081be6-7070-11eb-176c-bd1e2329373e
md"""
##### The Python version - requires numpy and sgp4 

```
import timeit
import numpy as np

the_setup = '''
import numpy as np
from sgp4.api import Satrec

line0s, line1s, line2s = [], [], []

with open("/home/michael/dev/presentations/sats.txt") as file:
    tles = file.readlines()
    for line in tles:
        if line[0] == '0':
            line0s.append(line)
        elif line[0] == '1':
            line1s.append(line)
        else:
            line2s.append(line)

satellites = [Satrec.twoline2rv(line1s[i], line2s[i]) for i in range(len(line1s))]

time_steps = np.arange(0, 86415, 15)/86400
jd_ranges = time_steps + satellites[1].jdsatepoch
jd_bases = np.floor(jd_ranges)+0.5
jd_rems = jd_ranges - jd_bases

def vals(sats, bases, rems): 
    return [[sat.sgp4(base, rem) for (base, rem) in zip(bases, rems)] for sat in  sats]
'''

np.min(timeit.repeat('vals(satellites, jd_bases, jd_rems)', setup=the_setup, number=1, repeat=20))
```
"""

# ╔═╡ 500dee00-7072-11eb-2a44-dd95d512fd0a
begin
	pytime = 1.54  # time on home computer
	md"#### Python time to beat $(round(pytime, digits=2)) seconds."
end


# ╔═╡ de96f62c-7073-11eb-22a8-b525bb1efd7f
bigbr

# ╔═╡ d3cdb9e2-7073-11eb-0753-8bf123599cac
md"""#### But is it Python?

	If your platform supports it, this package compiles the verbatim source code from
	the official C++ version of SGP4...

	Otherwise, a slower but reliable Python implementation of SGP4 is used instead.

##### `sgp4.api.Satrec.sgp4` calls  `sgp4.vallado_cpp.Satrec`
"""

# ╔═╡ 6d23a0cc-7074-11eb-1803-5f9147f47d48
#sgp4py = pyimport("sgp4")

# ╔═╡ 8699174c-7074-11eb-3cf0-e99217589e81
#sgp4py.api.Satrec.sgp4  # Access the python method used by the program

# ╔═╡ af0d99b4-7074-11eb-1818-95ee43a058cb
md"#### Python/C++ time to beat $(round(pytime, digits=2)) seconds."

# ╔═╡ 997eaf48-7074-11eb-0f16-15e7c1604976
bigbr

# ╔═╡ 25eb4620-7120-11eb-362b-3b7ea60280f8
md"### using [SatelliteToolbox](https://github.com/JuliaSpace/SatelliteToolbox.jl/blob/62ee9ecefd91304549c3d3ea6ea82d43ff9eea52/src/submodules/SGP4/sgp4_model.jl)"

# ╔═╡ 770bb998-7720-4e7c-acc3-903583af05c3
sat_url = "https://raw.githubusercontent.com/mihalybaci/pluto_notebooks/main/data/starlink.txt"

# ╔═╡ acf01518-5044-40c5-a53d-3e200ca592a5
download(sat_url, "starlink.txt")

# ╔═╡ a7d4755d-4147-4544-807f-fa309b452076
tles = read_tle("starlink.txt")

# ╔═╡ f0127839-1b9c-4338-adca-e166a3e0d9d3
length(tles)

# ╔═╡ 925da4a3-339e-48ea-a13b-e172cb463fdd
time_steps = 0:15:86400

# ╔═╡ e0e0eb79-49b5-4c8c-826c-8944b38eef0a
function calculate_orbit(tle, time_range)
	orb_init = init_orbit_propagator(Val(:sgp4), tle)
	return propagate!(orb_init, time_range)
end

# ╔═╡ eb6c9594-711f-11eb-15e6-67223aadedd2
all_orbits(tles, time_range, L=length(tles)) = [calculate_orbit(tles[i], time_range) for i = 1:L]  # 1 LOC

# ╔═╡ dbd5e0b8-711f-11eb-3e9b-a1e6a9a02380
bigbr

# ╔═╡ 2e2b882e-657a-11eb-3fd2-833ec80ab780
@benchmark all_orbits(tles, time_steps)

# ╔═╡ 98d06838-6e31-11eb-28b3-3deaea5131c7
bigbr

# ╔═╡ ed97389c-657b-11eb-2a66-85ea207477c4
mtime = 31.06; jtime = 0.525 # ms;

# ╔═╡ 5fd01a92-7070-11eb-31fb-898d900d3b0e
md"##### The Matlab time to beat is $mtime seconds."

# ╔═╡ 7de28764-657a-11eb-3a09-dbfe24cad780
md"
### Runtime on home computer: 
#### Matlab - $mtime s
#### Python/C++ - $(round(pytime, digits=2)) s
#### Julia  - $jtime s
"

# ╔═╡ 6496d06a-657c-11eb-0135-0d8a17125891
br

# ╔═╡ 489343cc-7075-11eb-09c9-8730d3e8949a
md"""
### Julia is  $(round(mtime/jtime, digits=1))x faster than Matlab.
### Julia is $(round(pytime/jtime, digits=1))x faster than PyC++.
"""

# ╔═╡ 1cfbcd5d-fbcc-41d7-896b-5d687ea9f587
br

# ╔═╡ fb3392e9-6870-422d-9dc1-911f207205ff
md"
#### Interesting note: 
##### example runtime, March 2021 - 0.75 s
##### example runtime, July 2021 - $jtime s

##### The code example is $(round(Int, 100*(0.75 - 0.525)/0.75))% faster than when I wrote it!

"

# ╔═╡ 020f402c-cbef-4c8f-8d3b-649c00649d3b
bigbr

# ╔═╡ 5a33f654-657c-11eb-1a9c-1bb3baf532f0
md"### Can Julia do even better? ABSOLUTELY!"

# ╔═╡ cb97ce85-ba76-419d-bc1d-3e63b3b39519
hr

# ╔═╡ add016be-fae2-407d-a45c-10f7ed25aa19
md"""
## Parallel programming

### Parallelizing code *can be* easy.

### Types of parallelism that Julia supports

- synchronous & asynchronous tasks
- multi-threading
- distributed computing (multiple-processing, distributed data)
- GPU computing
"""

# ╔═╡ 245b7dcd-9b6c-43ff-b7ca-8edd81fa3a86
br

# ╔═╡ a8398ca8-657d-11eb-0a10-fd6c26ceeffd
md"""## Step 1 - Rewrite comprehension as a for-loop """

# ╔═╡ 6c4a3ef0-657c-11eb-1117-addb8a66db25
# 7 LOC
function all_orbits_2(tles, time_range, L=length(tles)) 
	all_orbits = []
	for i = 1:L
		push!(all_orbits, calculate_orbit(tles[i], time_range))
	end
	return all_orbits
end

# ╔═╡ 861533e8-657d-11eb-2521-f17727427b00
md"""## Step 2 -  Pre-allocate the array"""

# ╔═╡ cd6f2456-657d-11eb-3ab3-b577f271d547
# 7 LOC
function all_orbits_3(tles, time_range, L=length(tles))
    array = Vector{Any}(undef, L)
    for i in eachindex(array)  # Supports OffsetArrays
        array[i] = calculate_orbit(tles[i], time_range)
    end
    return array
end

# ╔═╡ 0ab6b764-657e-11eb-2aed-b593a642430b
md"""## Step 3 - Add multi-threading"""

# ╔═╡ ce725472-657d-11eb-150d-47449caa17e1
# 7 LOC
function threaded_orbits(tles, time_range, L=length(tles))
    array = Vector{Any}(undef, L)
    Threads.@threads for i in eachindex(array)
        array[i] = calculate_orbit(tles[i], time_range)
    end
    return array
end

# ╔═╡ d9c50951-7623-4729-83d8-dcc351194585
br

# ╔═╡ e23ec8ee-d035-46db-8da3-b04d0fe844f6
nt = Threads.nthreads()  # This checks the number of available threads.

# ╔═╡ 75512cd4-657e-11eb-2640-87279ba81927
@benchmark threaded_orbits(tles, time_steps)  

# ╔═╡ eaef6282-7119-11eb-1530-33b741097913
br

# ╔═╡ 50e3e0be-0d56-4099-93f7-b6ff0bff44c1
jttime = 0.100 # multi-threaded time;

# ╔═╡ 485002ee-657e-11eb-2a1e-4b6ceb4e86b4
md"
#### Run times on home computer:
#### Matlab (1 thread) - $mtime s
#### Python/C++ (1 thread) - $(round(pytime, digits=2)) s
#### Julia (1 thread) - $jtime s
#### Julia ($nt threads) - $jttime s
"

# ╔═╡ 911847b4-7075-11eb-20ef-715b719f94f4
br

# ╔═╡ 7511a470-7075-11eb-123e-eb2c888210ec
md"""
### Final results: 

#### Julia is $(round(mtime/jttime, digits=1))x faster than Matlab.
#### Julia is $(round(pytime/jtime, digits=1))x faster than PyC++.
"""

# ╔═╡ cf952cda-7119-11eb-2236-218a27d8e1ac
hr

# ╔═╡ 1ad3f216-fef7-4b70-9b68-ab1de18c3126
md"""
## Another parallel programming example 

### Let's try the [Julia set](https://en.wikipedia.org/wiki/Julia_set).
"""

# ╔═╡ cc73dec8-2dae-4a68-b6fb-5ae880fedcfd
br

# ╔═╡ 4507ca61-1526-4251-8587-2fe6e80c61e5
md"### Single-threaded version"

# ╔═╡ 09d49654-4d62-4fb3-bfc6-d8585e0f5bb9
function escape(z0, maxiter)
    c = ComplexF64(-0.512511498387847167, 0.521295573094847167)
    z = z0
    for i ∈ 1:maxiter
        abs2(z) > 4f0 && return (i-1) % UInt8
         z = z*z + c
    end
    return maxiter % UInt8
end

# ╔═╡ 3c41c16b-0c36-4745-8229-3907296acd15
function juliaset(;width=600, height=450, maxiter=255)
	real = range(-1.5, 1.5, length=width)
	imag = range(-1, 1, length=height)*im
    result =  zeros(Int, height, width)
	for x = 1:width
		for y = 1:height
			z₀ = real[x] + imag[y]
			result[y, x] = escape(z₀, maxiter)
		end
	end
    return result
end

# ╔═╡ 63e0878c-a238-47d7-b4a2-90f796132071
width = 800; height = 600

# ╔═╡ 26e9fe26-293a-4596-a599-3cae117f111c
js = juliaset(width=width, height=height)

# ╔═╡ 11efd4d9-c7d2-41b3-8ca8-c8d27780e6d9
Gray.((js)/maximum(js))

# ╔═╡ 141d6198-3451-446d-af6e-c2561d27d0ec
jss = @benchmark juliaset(width=width, height=height)

# ╔═╡ 36f7524f-788f-43c5-826b-56789edcd798
bigbr

# ╔═╡ 92848716-1e63-4a92-8df6-e4347c08f339
md"### Multi-threaded"

# ╔═╡ d947d115-6ae8-44aa-8fc8-1d0c35aba81a
function juliaset_threads(;width=600, height=450, maxiter=256)
	real = range(-1.5, 1.5, length=width)
	imag = range(-1, 1, length=height)*im
    result =  zeros(Int, height, width)
	Threads.@threads for x = 1:width
		for y = 1:height
			z₀ = real[x] + imag[y]
			result[y, x] = escape(z₀, maxiter)
		end
	end
    return result
end

# ╔═╡ b6b5d6d2-61af-4c4c-bfc1-dc9401f9320c
jst = @benchmark juliaset_threads(width=width, height=height)

# ╔═╡ e3f3e0f4-9b71-4946-b0f6-06f7dcc4dfb0
bigbr

# ╔═╡ d38a7017-e46f-42e8-9d04-18b6b17fac50
md"### Tasks"

# ╔═╡ 258f1ba0-fcfe-467c-803a-0fd22b4d9317
function juliaset_spawn(;width=600, height=450, maxiter=256)
	real = range(-1.5, 1.5, length=width)
	imag = range(-1, 1, length=height)*im
    result =  zeros(Int, height, width)
	@sync for x = 1:width
		Threads.@spawn for y = 1:height
			z₀ = real[x] + imag[y]
			result[y, x] = escape(z₀, maxiter)
		end
	end
    return result
end

# ╔═╡ 6df77ab4-fc6a-48a4-91bc-7791e22f029c
jsp = @benchmark juliaset_spawn(width=width, height=height)

# ╔═╡ 85486149-41aa-4718-a7cf-8f9935b0a05a
bigbr

# ╔═╡ d8bd9384-1d42-40ba-953f-774c080aa12c
md"""
### Translating the Julia Set to the GPU
"""

# ╔═╡ 2d64436b-7bbb-44a2-8cc3-de84870c3e0a
if has_cuda()
	@terminal CUDA.versioninfo()
else
	md"#### WARNING: CUDA not available!"
end

# ╔═╡ 2f46ddec-3d19-4f65-9d1c-ef853fca945a
function run!(in, out; maxiter=16)
    out .= escape.(in, maxiter)
end

# ╔═╡ e02ec379-f5ad-45e6-87eb-82ee5ac7fe9a
function juliaset_gpu(;width=600, height=450, maxiter=256)
    q =  CuArray([ComplexF64(real, imag) for imag in range(-2.0, 0.5, length=width), real in range(-1.0, 1.0, length=height)])
    result = CuArray(zeros(UInt8, size(q)))
    run!(q, result, maxiter=maxiter)
    return result
end

# ╔═╡ 496a9ed9-d9d4-4836-879f-a4074f7ee64c
if has_cuda()
	jsg = @benchmark juliaset_gpu(width=width, height=height)
	jsgt = round(jsg.times[1]/1e6, digits=2)
else
	jsgt = 1.1 # approx time on a K80
end

# ╔═╡ 7ae1f380-4e59-4b97-9c36-209158bde42e
md"
##### 1-thread: $(round(jss.times[1]/1e6, digits=2)) ms
##### $(Threads.nthreads())-threads: $(round(jst.times[1]/1e6, digits=2)) ms
##### $(width*height)-tasks: $(round(jsp.times[1]/1e6, digits=2)) ms
##### GPU version: $jsgt ms
"

# ╔═╡ 6765d72e-ed52-4f7f-b67d-00a970091040
bigbr

# ╔═╡ 530b4147-bb9c-42d5-ab19-23210d54ce3b
md"""
### Flux.jl CNN with GPU support 
##### (details omitted for clarity)
```
using Flux, Flux.Data.MNIST, Statistics
using Flux: onehotbatch, onecold, logitcrossentropy
using Base.Iterators: partition
using Printf, BSON
using Parameters: @with_kw
****
using CUDA
if has_cuda()
    @info "CUDA is on"
    CUDA.allowscalar(false)
end
****

### do some stuff

train_set, test_set = get_processed_data(args)
model = build_model(args) 
**
train_set = gpu.(train_set)
test_set = gpu.(test_set)
model = gpu(model)
**

### do some stuff 
```

Borrowed from: https://github.com/FluxML/model-zoo/blob/master/vision/mnist/conv.jl
"""

# ╔═╡ 4f6cdd33-3efa-4d39-a88e-49e83f83c838
md"""## "This is the end, my only friend, the end!"

### Any questions?"""

# ╔═╡ Cell order:
# ╠═f85eb8ca-649c-11eb-19bb-99e1a83e459b
# ╠═2055d28c-649d-11eb-3b12-639929fff5fa
# ╠═91f08860-7118-11eb-304f-298cb1a9d953
# ╟─f499ecb4-6492-11eb-19c2-43bda1cf2a0c
# ╟─8363f966-6c8a-11eb-0485-b39bfa77d265
# ╟─050d8af6-921a-11eb-3ae2-23845d02b6a9
# ╟─007fdd68-921a-11eb-1a21-3d505f0541b0
# ╟─d554a44d-7eaf-49ed-a5a3-bf9a2fb38ed7
# ╟─e2b9a78e-9313-11eb-2899-b5354d00b10c
# ╟─b681e152-8e31-11eb-37a1-73d640a225b0
# ╟─47cda722-9187-11eb-3126-f5edb8b1057e
# ╟─492e55c8-9187-11eb-08c1-418da2d63ba1
# ╟─03c3bf38-6493-11eb-1cd2-4bcf96696f89
# ╟─d3220a8c-6495-11eb-0c22-0d1b450c91f1
# ╟─0bd4be8a-6c8c-11eb-0f56-e9c2d10bacaa
# ╟─80745e40-6498-11eb-2f82-d133e2d32f78
# ╟─ea2b7858-649c-11eb-36a8-2f2670063bee
# ╟─482e7128-64c1-11eb-3af8-2dff4ca691c3
# ╟─a2ef89dc-649c-11eb-100f-55274909e1b4
# ╟─ac11c534-649c-11eb-0d82-dff01e7f1cc8
# ╟─8200b8b0-64b3-11eb-30c8-0f043db218d4
# ╟─a107c3ae-751e-11eb-2449-e1a746074ca0
# ╟─91372ae6-751e-11eb-1615-d94fa16a7f4e
# ╟─7123daf8-751e-11eb-1cb0-8b00a6f054ac
# ╟─7dc1f860-751e-11eb-03ff-5f18abfa6ad8
# ╟─a5943e0c-751e-11eb-29b8-af711725dba9
# ╟─02992046-751e-11eb-1e8e-37534d3b339c
# ╟─bd00765a-751e-11eb-3729-5904acfefaff
# ╟─bee68ed2-751e-11eb-3c09-d1a25383b36c
# ╟─a7d1d688-64b2-11eb-3c21-159fe6996ff1
# ╟─9b7ee436-751d-11eb-1ffe-bd3f35127821
# ╟─0dda3e88-7510-11eb-3ebc-310d68675c2d
# ╟─ca6e9678-7118-11eb-25bd-39cd6b1416c3
# ╟─dbbe2972-6c70-11eb-3b23-ab10538061b6
# ╟─85a888f0-6c72-11eb-1f27-3dcdb744e584
# ╟─a77b1794-6c71-11eb-1472-d9b2e129335f
# ╟─88a95a89-7542-4047-b75a-d4d4198c6294
# ╟─5ad51346-b186-4fb1-abe3-b332ca01fbfc
# ╟─a5d7823c-6c72-11eb-1daf-a1e1616ff019
# ╟─8af30d8e-7119-11eb-0ab0-e3528a469764
# ╟─286fb7e8-6496-11eb-1306-b56859f2ee3b
# ╟─3ab45088-6496-11eb-0c8d-b170a971e912
# ╟─fb96aa58-fecf-4973-aa6e-8f3485d4703e
# ╟─9d185a72-649f-11eb-061d-3ba4357d4e4d
# ╠═6a37ffac-713d-11eb-0444-03a10357adb7
# ╟─70efa204-711d-11eb-2373-fd5ed207de9a
# ╟─e213ca9a-7134-11eb-12eb-adeb89716b61
# ╟─b8dbbfa4-64a1-11eb-21f3-bf8d4517e086
# ╠═4dbfbc7e-64a2-11eb-29f0-891d4121fc8f
# ╟─ee7515e0-64a4-11eb-3d94-77b8a34c3f7b
# ╟─d4581d5c-64a3-11eb-0f0f-d9e006e75a06
# ╟─9e6269f0-64a3-11eb-14ce-c1877e9fbc9e
# ╟─98336ce6-7119-11eb-1ac5-f5f3bd8f75da
# ╟─36292f5d-6bfe-415c-a119-35fd12cc4bd4
# ╟─dcbf8055-b94e-457d-a261-02d914235033
# ╠═9376a8b8-0719-4b97-bd1a-f1ffe34b4a87
# ╠═b21b30e3-67e4-423d-9d4e-80c28a1b263e
# ╠═9e3393aa-d6de-47c1-85de-ec8488d34458
# ╟─f9604c02-69b4-4764-bcc5-081c39c0cebb
# ╠═bc64e284-aaf5-43c2-9cc9-a0c352f7044f
# ╠═9960cea7-2e2a-4b7f-aaab-633ff0308bda
# ╟─7bdb090a-50f8-4b86-9d82-77db15939b17
# ╠═1599e255-2467-4dfb-b352-d2b6ad5117b5
# ╟─409ce0d7-8996-4136-9b08-28b7274a3b0c
# ╠═15de8d9c-a1ef-4821-a1dc-52b28a09b889
# ╠═986417d2-768c-4401-ace2-4f340815899e
# ╟─4f10b094-19ba-491c-86ae-c26853149da5
# ╟─05b9366a-64ae-11eb-1535-63b2eb1a237c
# ╟─7fab76be-92e3-11eb-11cc-051b8bd8bbce
# ╟─7bfaadfa-92e3-11eb-39ca-89cb7e4fd8c1
# ╟─010ee5f4-7135-11eb-2987-f34bb67004c1
# ╟─be821d4a-64b3-11eb-0013-39de4b85317c
# ╠═1078b698-64ae-11eb-23b5-59dafc065ec8
# ╠═36f1b350-6c70-11eb-2609-bb5ab899eef5
# ╠═07b47076-6c70-11eb-3e80-b1783abb82fc
# ╠═58995522-99b5-46d6-99d5-2de20db37991
# ╟─89a23598-64af-11eb-2cc6-6556d23893db
# ╟─802f5856-6c70-11eb-2416-6bf168fb3f6a
# ╟─024eb854-92e4-11eb-0ee6-73bc6086aca3
# ╟─10d9e896-92e4-11eb-2fe4-dd2ed7694134
# ╟─f9679ea6-92e3-11eb-0815-dfb76fa6c38c
# ╟─7de2494c-92e4-11eb-0c54-69df9b5a698b
# ╟─39f00350-92e4-11eb-272b-c9913be4e25c
# ╠═5ab88792-92e4-11eb-388d-1f147881b2bf
# ╟─734b4b82-92e4-11eb-0705-c30c20bfc0ef
# ╟─7b133a82-92e4-11eb-1e88-719b4c135b07
# ╟─63838f7a-92e4-11eb-3548-5dcc29652ffe
# ╠═d0f30bea-706f-11eb-15a6-d7ba972ec3d2
# ╠═b5723bfe-706f-11eb-3145-e59fad8e37c2
# ╠═bf3fb88a-706f-11eb-2eff-c78593c02a4a
# ╟─d6717d9e-92e4-11eb-3a23-adae327a1b45
# ╟─c86de822-92e4-11eb-390d-b1675062f70c
# ╠═07124a24-7070-11eb-27aa-bb67c4fb65b3
# ╟─d2bd088a-92e4-11eb-1f59-09fd6b850699
# ╟─10d1a370-7070-11eb-374a-f3d5421d8eb9
# ╟─a70a5e8c-7119-11eb-0ca5-ab74559db699
# ╟─c07d8068-64af-11eb-3ebd-2b8475096673
# ╟─52ceed22-64b4-11eb-2128-89132de079cb
# ╟─ced304c6-64af-11eb-28a9-bd26b77e4b48
# ╟─489df172-6577-11eb-036a-0721f2d5e86a
# ╟─3d05e82a-711f-11eb-2cc6-03e9b45e4d16
# ╟─4f914b28-6577-11eb-307e-d3fcb5d7090b
# ╟─65661654-6577-11eb-3a2a-cd07152d69ee
# ╟─5fd01a92-7070-11eb-31fb-898d900d3b0e
# ╟─4eb669bd-8c69-4f5f-a574-76155df88c67
# ╟─82081be6-7070-11eb-176c-bd1e2329373e
# ╟─500dee00-7072-11eb-2a44-dd95d512fd0a
# ╟─de96f62c-7073-11eb-22a8-b525bb1efd7f
# ╟─d3cdb9e2-7073-11eb-0753-8bf123599cac
# ╟─6d23a0cc-7074-11eb-1803-5f9147f47d48
# ╟─8699174c-7074-11eb-3cf0-e99217589e81
# ╟─af0d99b4-7074-11eb-1818-95ee43a058cb
# ╟─997eaf48-7074-11eb-0f16-15e7c1604976
# ╟─25eb4620-7120-11eb-362b-3b7ea60280f8
# ╠═770bb998-7720-4e7c-acc3-903583af05c3
# ╠═acf01518-5044-40c5-a53d-3e200ca592a5
# ╠═a7d4755d-4147-4544-807f-fa309b452076
# ╠═f0127839-1b9c-4338-adca-e166a3e0d9d3
# ╠═925da4a3-339e-48ea-a13b-e172cb463fdd
# ╠═e0e0eb79-49b5-4c8c-826c-8944b38eef0a
# ╠═eb6c9594-711f-11eb-15e6-67223aadedd2
# ╟─dbd5e0b8-711f-11eb-3e9b-a1e6a9a02380
# ╠═2e2b882e-657a-11eb-3fd2-833ec80ab780
# ╟─98d06838-6e31-11eb-28b3-3deaea5131c7
# ╟─ed97389c-657b-11eb-2a66-85ea207477c4
# ╟─7de28764-657a-11eb-3a09-dbfe24cad780
# ╟─6496d06a-657c-11eb-0135-0d8a17125891
# ╟─489343cc-7075-11eb-09c9-8730d3e8949a
# ╟─1cfbcd5d-fbcc-41d7-896b-5d687ea9f587
# ╟─fb3392e9-6870-422d-9dc1-911f207205ff
# ╟─020f402c-cbef-4c8f-8d3b-649c00649d3b
# ╟─5a33f654-657c-11eb-1a9c-1bb3baf532f0
# ╟─cb97ce85-ba76-419d-bc1d-3e63b3b39519
# ╟─add016be-fae2-407d-a45c-10f7ed25aa19
# ╟─245b7dcd-9b6c-43ff-b7ca-8edd81fa3a86
# ╟─a8398ca8-657d-11eb-0a10-fd6c26ceeffd
# ╠═6c4a3ef0-657c-11eb-1117-addb8a66db25
# ╟─861533e8-657d-11eb-2521-f17727427b00
# ╠═cd6f2456-657d-11eb-3ab3-b577f271d547
# ╟─0ab6b764-657e-11eb-2aed-b593a642430b
# ╠═ce725472-657d-11eb-150d-47449caa17e1
# ╟─d9c50951-7623-4729-83d8-dcc351194585
# ╠═e23ec8ee-d035-46db-8da3-b04d0fe844f6
# ╠═75512cd4-657e-11eb-2640-87279ba81927
# ╟─eaef6282-7119-11eb-1530-33b741097913
# ╟─50e3e0be-0d56-4099-93f7-b6ff0bff44c1
# ╟─485002ee-657e-11eb-2a1e-4b6ceb4e86b4
# ╟─911847b4-7075-11eb-20ef-715b719f94f4
# ╟─7511a470-7075-11eb-123e-eb2c888210ec
# ╟─cf952cda-7119-11eb-2236-218a27d8e1ac
# ╟─1ad3f216-fef7-4b70-9b68-ab1de18c3126
# ╟─cc73dec8-2dae-4a68-b6fb-5ae880fedcfd
# ╟─4507ca61-1526-4251-8587-2fe6e80c61e5
# ╠═09d49654-4d62-4fb3-bfc6-d8585e0f5bb9
# ╠═3c41c16b-0c36-4745-8229-3907296acd15
# ╠═63e0878c-a238-47d7-b4a2-90f796132071
# ╠═26e9fe26-293a-4596-a599-3cae117f111c
# ╠═11efd4d9-c7d2-41b3-8ca8-c8d27780e6d9
# ╠═141d6198-3451-446d-af6e-c2561d27d0ec
# ╟─36f7524f-788f-43c5-826b-56789edcd798
# ╟─92848716-1e63-4a92-8df6-e4347c08f339
# ╠═d947d115-6ae8-44aa-8fc8-1d0c35aba81a
# ╠═b6b5d6d2-61af-4c4c-bfc1-dc9401f9320c
# ╟─e3f3e0f4-9b71-4946-b0f6-06f7dcc4dfb0
# ╟─d38a7017-e46f-42e8-9d04-18b6b17fac50
# ╠═258f1ba0-fcfe-467c-803a-0fd22b4d9317
# ╠═6df77ab4-fc6a-48a4-91bc-7791e22f029c
# ╟─85486149-41aa-4718-a7cf-8f9935b0a05a
# ╟─d8bd9384-1d42-40ba-953f-774c080aa12c
# ╟─2d64436b-7bbb-44a2-8cc3-de84870c3e0a
# ╠═2f46ddec-3d19-4f65-9d1c-ef853fca945a
# ╠═e02ec379-f5ad-45e6-87eb-82ee5ac7fe9a
# ╠═496a9ed9-d9d4-4836-879f-a4074f7ee64c
# ╟─7ae1f380-4e59-4b97-9c36-209158bde42e
# ╟─6765d72e-ed52-4f7f-b67d-00a970091040
# ╟─530b4147-bb9c-42d5-ab19-23210d54ce3b
# ╟─4f6cdd33-3efa-4d39-a88e-49e83f83c838

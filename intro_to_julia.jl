### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ a77b1794-6c71-11eb-1472-d9b2e129335f
begin
	import Pkg# Import the package manager
	Pkg.activate(mktempdir())# Activate the temporary environment
	# Add the packages (downloading them if necessary)
	Pkg.add(["BenchmarkTools", "Conda", "Images", "PyCall", "SatelliteToolbox"])
	# Load the packages
	using BenchmarkTools
	using Conda
	using Images
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

# ╔═╡ e2b9a78e-9313-11eb-2899-b5354d00b10c
md"julialang.org"

# ╔═╡ e9ed1a8e-9313-11eb-3218-ddf15791abc4
md"juliahub.com"

# ╔═╡ edf3cdbc-9313-11eb-2d3d-053249cd8fd1
md"juliacomputing.com"

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

# ╔═╡ 08c78d78-6b04-11eb-3ee2-a9409610de2f
md"""# Learn Julia from the Masters
### Online, instructor-led courses from Julia Computing, Inc.

#### **Introduction to Julia:** TBD, \$250
#### **Introduction to ML and AI:** TBD, \$500
#### **Parallel Computing in Julia:** 8-9 April 2021, \$500

#### [https://juliacomputing.com/training](https://juliacomputing.com/training)
"""

# ╔═╡ 03c3bf38-6493-11eb-1cd2-4bcf96696f89
md"""
# A short list about Julia
- #### Designed from the ground-up for scientific computing
- #### Walks like Python, runs like C
- #### Simple project environment management
- #### Full parallelism (multi-threading, multi-process, HPC)
- #### Bye, bye OOP! Hello Multiple dispatch!
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
load("/home/michael/dev/presentations/numpytimings.png")

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
md"""### A final note on benchmarks
#### Dr. Steven Johnson, MIT Professor, creator of FFTW, and Julia contributor.

##### Excerpt from a [post](https://discourse.julialang.org/t/julias-applicable-context-is-getting-narrower-over-time/55042/40) on  the Julia Discourse forums. 

>It’s impressive that it’s possible to beat optimized C libraries in certain cases with native Julia code, but focusing too much on such cases will often lead people astray...
>
>Fundamentally, the reason Julia exists is not to beat the performance of existing C libraries on existing problems... Julia is attractive for people who need to write new high-performance code to solve new problems, which don’t fit neatly into the boxes provided by existing numpy library functions...
>
>... And the code you write in Julia can at the same time be more flexible (type-generic and composable), allowing greater code re-use.
>
>This is important for those of us who want to work on new problems and to go beyond endlessly recycling the solutions of the past.
"""

# ╔═╡ 8a1ca72c-921f-11eb-022a-e937aac3fb66
br

# ╔═╡ d790b994-921f-11eb-1405-0dcfd94d38e2
md"#### See also: 
##### ['Adventures in Code Generation'](https://www.youtube.com/watch?v=mSgXWpvQEHE&list=PLP8iPy9hna6StY9tIJIUN3F_co9A0zh0H&index=5) metaprogramming presentation from  JuliaCon 2019 on YouTube"

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


$br 


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


##### Quick digression 
##### typing `;` in the REPL* opens `shell` mode
##### typing `?` in the REPL opens the help docs
##### typing `backspace` returns to the `julia` REPL from the other modes

*Read, evaluate, print loop

$br

### Recreating someone else's environment

#### Example using git

```
julia>
# Open Julia REPL and type `;`
shell> git clone https://github.com/my/ClonedRepo.jl
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
md"#### As of Pluto v0.15.0, there is built-in Pluto package management!

#### `using Plots` can now automatically ask to install Plots.jl if it is not found in the environment."

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
	Alien() = new("")  # Inner constructor
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

# ╔═╡ ace5815a-64ae-11eb-2fcd-dbe033e24d64
# This code prints the shell being used|
begin
	path = ccall(:getenv, Cstring, (Cstring,), "SHELL")
	unsafe_string(path) 
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
##### `Conda.pip("install", "sgp4")`

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
	py"""
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

#test = [(base, rem) for (base, rem) in zip(jd_bases, jd_rems)]

def vals(sats, bases, rems): 
    return [[sat.sgp4(base, rem) for (base, rem) in zip(bases, rems)] for sat in  sats]
'''

def the_time():
	return np.min(timeit.repeat('vals(satellites, jd_bases, jd_rems)', setup=the_setup, number=1, repeat=20))"""
	
	pytime = py"the_time"()
	md"#### Python time to beat $(round(pytime, digits=2)) seconds."
end


# ╔═╡ de96f62c-7073-11eb-22a8-b525bb1efd7f
bigbr

# ╔═╡ d3cdb9e2-7073-11eb-0753-8bf123599cac
md"""#### But is it Python?

	If your platform supports it, this package compiles the verbatim source code from
	the official C++ version of SGP4...

	Otherwise, a slower but reliable Python implementation of SGP4 is used instead.
"""

# ╔═╡ 6d23a0cc-7074-11eb-1803-5f9147f47d48
sgp4py = pyimport("sgp4")

# ╔═╡ 8699174c-7074-11eb-3cf0-e99217589e81
sgp4py.api.Satrec.sgp4  # Access the python method used by the program

# ╔═╡ af0d99b4-7074-11eb-1818-95ee43a058cb
md"#### Python/C++ time to beat $(round(pytime, digits=2)) seconds."

# ╔═╡ 997eaf48-7074-11eb-0f16-15e7c1604976
bigbr

# ╔═╡ 25eb4620-7120-11eb-362b-3b7ea60280f8
md"### using [SatelliteToolbox](https://github.com/JuliaSpace/SatelliteToolbox.jl/blob/62ee9ecefd91304549c3d3ea6ea82d43ff9eea52/src/submodules/SGP4/sgp4_model.jl)"

# ╔═╡ 770bb998-7720-4e7c-acc3-903583af05c3
filename = "/home/michael/dev/presentations/sats.txt"

# ╔═╡ a7d4755d-4147-4544-807f-fa309b452076
tles = read_tle(filename)

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
b = @benchmark all_orbits(tles, time_steps)

# ╔═╡ 98d06838-6e31-11eb-28b3-3deaea5131c7
bigbr

# ╔═╡ ed97389c-657b-11eb-2a66-85ea207477c4
mtime = 31.06;

# ╔═╡ 5fd01a92-7070-11eb-31fb-898d900d3b0e
md"##### The Matlab time to beat is $mtime seconds."

# ╔═╡ 7de28764-657a-11eb-3a09-dbfe24cad780
md"
#### Matlab - $mtime s
#### Python/C++ - $(round(pytime, digits=2)) s
#### Julia  - $(round(b.times[1]/1e9, digits=3)) s
"

# ╔═╡ 6496d06a-657c-11eb-0135-0d8a17125891
br

# ╔═╡ 489343cc-7075-11eb-09c9-8730d3e8949a
md"""
### Julia is  $(round(mtime/(b.times[1]/1e9), digits=1))x faster than Matlab.
### Julia is $(round(pytime/(b.times[1]/1e9), digits=1))x faster than PyC++.
"""

# ╔═╡ 1cfbcd5d-fbcc-41d7-896b-5d687ea9f587
br

# ╔═╡ fb3392e9-6870-422d-9dc1-911f207205ff
md"
#### Interesting note: 
##### example runtime, March 2021 - 0.75 s
##### example runtime, July 2021 - $(round(b.times[1]/1e9, digits=2)) s

##### The code example is $(round(Int, 100*(0.75 - (round(b.times[1]/1e9, digits=2)))/0.75))% faster than when I wrote it!

"

# ╔═╡ 020f402c-cbef-4c8f-8d3b-649c00649d3b
bigbr

# ╔═╡ 5a33f654-657c-11eb-1a9c-1bb3baf532f0
md"### Can Julia do even better? ABSOLUTELY!"

# ╔═╡ a8398ca8-657d-11eb-0a10-fd6c26ceeffd
md"""## Step 1 - Use for-loop "long version" """

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

# ╔═╡ 990d362a-92e2-11eb-0289-6d703732f1a0
md"## Multi-threaded runtime"

# ╔═╡ e23ec8ee-d035-46db-8da3-b04d0fe844f6
nt = Threads.nthreads()  # This checks the number of available threads.

# ╔═╡ 75512cd4-657e-11eb-2640-87279ba81927
c = @benchmark threaded_orbits(tles, time_steps)  

# ╔═╡ eaef6282-7119-11eb-1530-33b741097913
br

# ╔═╡ 485002ee-657e-11eb-2a1e-4b6ceb4e86b4
md"
#### Matlab (1 thread) - $mtime s
#### Python/C++ (1 thread) - $(round(pytime, digits=2)) s
#### Julia (1 thread) - $(round(b.times[1]/1e9, digits=3)) s
#### Julia ($nt threads) - $(round(c.times[1]/1e9, digits=3)) s
"

# ╔═╡ 911847b4-7075-11eb-20ef-715b719f94f4
br

# ╔═╡ 7511a470-7075-11eb-123e-eb2c888210ec
md"""
### Final results: 

#### Julia is $(round(mtime/(c.times[1]/1e9), digits=1))x faster than Matlab.
#### Julia is $(round(pytime/(c.times[1]/1e9), digits=1))x faster than PyC++.
"""

# ╔═╡ cf952cda-7119-11eb-2236-218a27d8e1ac
hr

# ╔═╡ b9d7d1fb-10b7-412e-a3fb-002659b02b68
md"## A bit more on parallel programming."

# ╔═╡ aba4031f-3508-4cd6-8414-8f2b99b0fa09
md"### Types of parallelism that Julia supports

- synchronous & asynchronous tasks
- multi-threading
- distributed computing (multiple-processing, distributed data)
- GPU computing
"

# ╔═╡ f5b17782-781c-43a2-89ca-9655906d979b
"""
The Mandelbrot set escape time function
"""
function escapetime(z; maxiter=80)
    c = z
    for n = 1:maxiter
        if abs(z) > 2
            return n-1
        end
        z = z^2 + c
    end
    return maxiter
end

# ╔═╡ e646b05a-c0e6-4768-8062-186492a10ddd
"""
Calculate the escape time for each grid point (pixel)
"""
function mandel(; width=80, height=20, maxiter=60)
    out = zeros(Int, height, width)
    real = range(-2.0, 0.5, length=width)
    imag = range(-1.0, 1.0, length=height)*im
    for x in 1:width
        for y in 1:height
            z = real[x] + imag[y]
            out[y,x] = escapetime(z, maxiter=maxiter)
        end
    end
    return out
end

# ╔═╡ 476a44b3-4969-479c-a7a0-b2b8935f597a
width = 600; height=450; maxiter=600

# ╔═╡ 9187d20e-d25d-432c-a8d1-bbaa7e20342c
Gray.((mandel(width=width, height=height, maxiter=maxiter).%maxiter)./100)

# ╔═╡ 7d38feb3-3f1a-4fbf-b2fc-5458ed411cf1
m = @benchmark mandel(width=width, height=height, maxiter=maxiter)

# ╔═╡ 15d50e5a-8bba-4f83-b297-9df50bf820d7
function mandelthread(; width=80, height=20, maxiter=80)
    out = zeros(Int, height, width)
    real = range(-2.0, 0.5, length=width)
    imag = range(-1.0, 1.0, length=height)*im
    Threads.@threads for x in 1:width
        for y in 1:height
            z = real[x] + imag[y]
            out[y,x] = escapetime(z, maxiter=maxiter)
        end
    end
    return out
end

# ╔═╡ 1995d8cb-6be4-4b90-b9bd-f0d739386850
mt = @benchmark mandelthread(width=width, height=height, maxiter=maxiter)

# ╔═╡ cc73dec8-2dae-4a68-b6fb-5ae880fedcfd
br

# ╔═╡ 6245be94-c0b8-46a2-9b6a-a6fee223edec
function mandelspawn(; width=80, height=20, maxiter=80)
    out = zeros(Int, height, width)
    real = range(-2.0, 0.5, length=width)
    imag = range(-1.0, 1.0, length=height)*im
    @sync for x in 1:width
        Threads.@spawn for y in 1:height
            z = real[x] + imag[y]
            out[y,x] = escapetime(z, maxiter=maxiter)
        end
    end
    return out
end

# ╔═╡ 9bc549fe-1f97-431b-bce8-61ade95b2b1f
ms = @benchmark mandelspawn(width=width, height=height, maxiter=maxiter)

# ╔═╡ 0a38a7fb-f6e8-4531-9f31-a2b4662a2e8a
md"
##### 1-thread: $(round(m.times[1]/1e6, digits=2)) ms
##### $(Threads.nthreads())-threads: $(round(mt.times[1]/1e6, digits=2)) ms
##### $(width*height)-tasks: $(round(ms.times[1]/1e6, digits=2)) ms
"

# ╔═╡ bfe792d6-6fb5-425c-aac4-e6642529ba18
hr

# ╔═╡ 3fdd7452-40d1-41dd-8d50-10b625657931


# ╔═╡ 530b4147-bb9c-42d5-ab19-23210d54ce3b
md"""
## Quick note on using GPUs

#### Flux.jl CNN with GPU support 
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
# ╟─e2b9a78e-9313-11eb-2899-b5354d00b10c
# ╟─e9ed1a8e-9313-11eb-3218-ddf15791abc4
# ╟─edf3cdbc-9313-11eb-2d3d-053249cd8fd1
# ╟─b681e152-8e31-11eb-37a1-73d640a225b0
# ╟─47cda722-9187-11eb-3126-f5edb8b1057e
# ╟─492e55c8-9187-11eb-08c1-418da2d63ba1
# ╟─08c78d78-6b04-11eb-3ee2-a9409610de2f
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
# ╟─8a1ca72c-921f-11eb-022a-e937aac3fb66
# ╟─d790b994-921f-11eb-1405-0dcfd94d38e2
# ╟─ca6e9678-7118-11eb-25bd-39cd6b1416c3
# ╟─dbbe2972-6c70-11eb-3b23-ab10538061b6
# ╟─85a888f0-6c72-11eb-1f27-3dcdb744e584
# ╠═a77b1794-6c71-11eb-1472-d9b2e129335f
# ╟─88a95a89-7542-4047-b75a-d4d4198c6294
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
# ╟─05b9366a-64ae-11eb-1535-63b2eb1a237c
# ╟─7fab76be-92e3-11eb-11cc-051b8bd8bbce
# ╟─7bfaadfa-92e3-11eb-39ca-89cb7e4fd8c1
# ╟─010ee5f4-7135-11eb-2987-f34bb67004c1
# ╟─be821d4a-64b3-11eb-0013-39de4b85317c
# ╠═1078b698-64ae-11eb-23b5-59dafc065ec8
# ╠═36f1b350-6c70-11eb-2609-bb5ab899eef5
# ╠═07b47076-6c70-11eb-3e80-b1783abb82fc
# ╠═ace5815a-64ae-11eb-2fcd-dbe033e24d64
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
# ╠═6d23a0cc-7074-11eb-1803-5f9147f47d48
# ╟─8699174c-7074-11eb-3cf0-e99217589e81
# ╟─af0d99b4-7074-11eb-1818-95ee43a058cb
# ╟─997eaf48-7074-11eb-0f16-15e7c1604976
# ╟─25eb4620-7120-11eb-362b-3b7ea60280f8
# ╠═770bb998-7720-4e7c-acc3-903583af05c3
# ╠═a7d4755d-4147-4544-807f-fa309b452076
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
# ╟─a8398ca8-657d-11eb-0a10-fd6c26ceeffd
# ╠═6c4a3ef0-657c-11eb-1117-addb8a66db25
# ╟─861533e8-657d-11eb-2521-f17727427b00
# ╠═cd6f2456-657d-11eb-3ab3-b577f271d547
# ╟─0ab6b764-657e-11eb-2aed-b593a642430b
# ╠═ce725472-657d-11eb-150d-47449caa17e1
# ╟─d9c50951-7623-4729-83d8-dcc351194585
# ╟─990d362a-92e2-11eb-0289-6d703732f1a0
# ╠═e23ec8ee-d035-46db-8da3-b04d0fe844f6
# ╠═75512cd4-657e-11eb-2640-87279ba81927
# ╟─eaef6282-7119-11eb-1530-33b741097913
# ╟─485002ee-657e-11eb-2a1e-4b6ceb4e86b4
# ╟─911847b4-7075-11eb-20ef-715b719f94f4
# ╟─7511a470-7075-11eb-123e-eb2c888210ec
# ╟─cf952cda-7119-11eb-2236-218a27d8e1ac
# ╟─b9d7d1fb-10b7-412e-a3fb-002659b02b68
# ╟─aba4031f-3508-4cd6-8414-8f2b99b0fa09
# ╠═f5b17782-781c-43a2-89ca-9655906d979b
# ╠═e646b05a-c0e6-4768-8062-186492a10ddd
# ╠═476a44b3-4969-479c-a7a0-b2b8935f597a
# ╠═9187d20e-d25d-432c-a8d1-bbaa7e20342c
# ╠═7d38feb3-3f1a-4fbf-b2fc-5458ed411cf1
# ╠═15d50e5a-8bba-4f83-b297-9df50bf820d7
# ╠═1995d8cb-6be4-4b90-b9bd-f0d739386850
# ╟─cc73dec8-2dae-4a68-b6fb-5ae880fedcfd
# ╠═6245be94-c0b8-46a2-9b6a-a6fee223edec
# ╠═9bc549fe-1f97-431b-bce8-61ade95b2b1f
# ╟─0a38a7fb-f6e8-4531-9f31-a2b4662a2e8a
# ╟─bfe792d6-6fb5-425c-aac4-e6642529ba18
# ╠═3fdd7452-40d1-41dd-8d50-10b625657931
# ╟─530b4147-bb9c-42d5-ab19-23210d54ce3b
# ╟─4f6cdd33-3efa-4d39-a88e-49e83f83c838

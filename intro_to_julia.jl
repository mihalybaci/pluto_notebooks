### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ a77b1794-6c71-11eb-1472-d9b2e129335f
begin
	# Import the package manager
	import Pkg
	# Activate the temporary environment
	Pkg.activate(mktempdir())
	# Add the packages (downloading them if necessary)
	Pkg.add(["BenchmarkTools", "Conda", "Images", "PyCall", "SatelliteToolbox"])
	# Load the packages
	using BenchmarkTools
	using Conda
	using Images
	using PyCall
	using SatelliteToolbox
	using Printf
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

# ╔═╡ 08c78d78-6b04-11eb-3ee2-a9409610de2f
md"""# Learn Julia from the Masters
### Online, instructor-led courses from Julia Computing, Inc.

#### **Introduction to Julia:** TBD, \$250
#### **Introduction to ML and AI:** 11-12 March 2021, \$500
#### **Parallel Computing in Julia:** 8-9 April 2021, \$500

"""

# ╔═╡ 5060703e-6712-11eb-21c7-4f43e45d33d4
md"# JuliaCon 2021

### **Location**: Everywhere on Earth

### **Date**: 28 -- 30 July 2021

### **Cost**: FREE

### **Registration**: https://juliacon.org/2021/"

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

##### In 2017, the Celeste astronomical image analysis project (writtin in Julia) reached 1.54 petaFLOPS on the Knights Landing supercomputer."""

# ╔═╡ 9b7ee436-751d-11eb-1ffe-bd3f35127821
bigbr

# ╔═╡ 0dda3e88-7510-11eb-3ebc-310d68675c2d
md"""### A final note on benchmarks
#### Dr. Steven Johnson, MIT Professor and creator of FFTW

##### Excerpts from a [post](https://discourse.julialang.org/t/julias-applicable-context-is-getting-narrower-over-time/55042/40) on Julia Discourse. 

>It’s impressive that it’s possible to beat optimized C libraries in certain cases with native Julia code, but focusing too much on such cases will often lead people astray...
>
>Fundamentally, the reason Julia exists is not to beat the performance of existing C libraries on existing problems... Julia is attractive for people who need to write new high-performance code to solve new problems, which don’t fit neatly into the boxes provided by existing numpy library functions...
>
>... And the code you write in Julia can at the same time be more flexible (type-generic and composable), allowing greater code re-use.
>
>This is important for those of us who want to work on new problems and to go beyond endlessly recycling the solutions of the past.
"""

# ╔═╡ b5fd4c3e-7118-11eb-2195-f776f9922342
hr

# ╔═╡ 44df4210-6c76-11eb-068c-e94d426035e3
md"## Quick note on using GPUs"

# ╔═╡ f2cb36de-6c76-11eb-08de-4def5529ca57
md"""
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

# ╔═╡ ca6e9678-7118-11eb-25bd-39cd6b1416c3
hr

# ╔═╡ dbbe2972-6c70-11eb-3b23-ab10538061b6
md"## Pkg - the Julia package manager"

# ╔═╡ 4bff941e-6c71-11eb-15aa-95d0764dbd88
md"### Import with `import Pkg` or just type `]` in the REPL*"


# ╔═╡ 519fdc1e-6c71-11eb-3332-9dd6272fb4bb
md"( Quick digression: typing `;` in the REPL opens `shell` mode )"

# ╔═╡ cf3e2392-6c74-11eb-1e8c-9f62f3efc5ea
md"( Quick digression digression: typing `?` in the REPL opens the help docs )"

# ╔═╡ c4439d84-6c72-11eb-362c-f7cc8fbdaf73
br

# ╔═╡ 672d665a-6c8d-11eb-1b0f-db23a6fa9ed7
md"**\*Read, Evaluate, Print Loop**"

# ╔═╡ ea70326a-7118-11eb-0b33-adb80c9d4ee1
hr

# ╔═╡ 92b33b58-6c72-11eb-356f-1721b99b8879
bigbr

# ╔═╡ 8dd23ab2-6c90-11eb-3658-9d598f6b40d8
bigbr

# ╔═╡ a0f3f1ee-6c90-11eb-2ee3-1f577f0480e9
bigbr

# ╔═╡ 85a888f0-6c72-11eb-1f27-3dcdb744e584
md"### How does this work? Let's check the code!"

# ╔═╡ a5d7823c-6c72-11eb-1daf-a1e1616ff019
bigbr

# ╔═╡ e60170ae-6c72-11eb-02a5-a967e5461a44
md"""
### Now say you want to share your big, complex project. 
#### Just send:

1. The source code (ex. MyProjectFile.jl)
2. Project.toml  <-- List of manually added packages
3. Manifest.toml <-- List of automatically added dependencies

##### When `MyProjectFile.jl` is run, `Pkg` will automatically install the files needed to recreate the **exact same original state**. 
##### The environment will be reproducible **indefinitely**.
"""

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

# ╔═╡ 9d185a72-649f-11eb-061d-3ba4357d4e4d
md"""
### Compare with multiple-dispatch

	mutable struct Alien
		planet
		Alien() = new("")
	end

	an_alien = Alien()
	an_alien.planet = "Mars"
	is_evil(p) = rand() < p
	is_evil(obj::Alien) = is_evil(0.5)
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

Watch [The Unreasonable Effectivness of Multiple Dispatch](https://youtu.be/kc9HwsxE1OY) for more information.
"

# ╔═╡ 98336ce6-7119-11eb-1ac5-f5f3bd8f75da
hr

# ╔═╡ 05b9366a-64ae-11eb-1535-63b2eb1a237c
md"""
## Unparalleled Interoperability
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

# ╔═╡ 010ee5f4-7135-11eb-2987-f34bb67004c1
bigbr

# ╔═╡ 3ed06d48-711e-11eb-36a5-6b0d91ec6cef
bigbr

# ╔═╡ be821d4a-64b3-11eb-0013-39de4b85317c
md"### Examples from C"

# ╔═╡ 1078b698-64ae-11eb-23b5-59dafc065ec8
# This code prints the system clock time directly from the C standard library
ccall(:clock, Int32, ())

# ╔═╡ 36f1b350-6c70-11eb-2609-bb5ab899eef5
s = "The Julia programming language rocks!"

# ╔═╡ 07b47076-6c70-11eb-3e80-b1783abb82fc
Int(@ccall strlen(s::Cstring)::Csize_t)

# ╔═╡ ace5815a-64ae-11eb-2fcd-dbe033e24d64
# This code prints the current of SHELL
begin
	path = ccall(:getenv, Cstring, (Cstring,), "SHELL")
	unsafe_string(path) 
end

# ╔═╡ 89a23598-64af-11eb-2cc6-6556d23893db
bigbr

# ╔═╡ 802f5856-6c70-11eb-2416-6bf168fb3f6a
md"### Examples from Python"

# ╔═╡ 9d8f64dc-7070-11eb-0c26-3b2e94d855c3
md"""##### Adding Packages: 
```
using Conda
Conda.add("package")
Conda.pip_interop(true, env)
Conda.pip("install", "package")
```
"""

# ╔═╡ 1aa6ff84-7071-11eb-1f89-19790d2e2d0e
md"#### Note: I *only* use Julia to run my Python environment."

# ╔═╡ d0f30bea-706f-11eb-15a6-d7ba972ec3d2
x = rand(100_000);

# ╔═╡ b5723bfe-706f-11eb-3145-e59fad8e37c2
np = pyimport("numpy");

# ╔═╡ bf3fb88a-706f-11eb-2eff-c78593c02a4a
@benchmark np.sin($x);

# ╔═╡ 65ccb6d2-706e-11eb-0323-13166548094b
md"""
##### Calculate the sine of 10⁵ random numbers

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
##### Runtime: 1104 μs
""";

# ╔═╡ b0d2c860-706e-11eb-362e-dbc1fdfb8025
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

# ╔═╡ c79df056-706e-11eb-0fc8-3308a1a9dae7
md"""##### Runtime: $pysintime μs""";

# ╔═╡ 07124a24-7070-11eb-27aa-bb67c4fb65b3
@benchmark sin.($x);

# ╔═╡ 10d1a370-7070-11eb-374a-f3d5421d8eb9
md"#### Key points:

- There are multiple ways to interact with Python code
- It is possible to time python functions from Julia
- Sine calculations are 33% faster in Julia!
";

# ╔═╡ a3063586-711e-11eb-2302-1701e48cd137
md"""### It also works the other way!
- **pyjulia** - Run Julia within Python
- **JuliaCall** - Run Julia within R
"""

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
### Package Spotlight: SatelliteToolbox"

# ╔═╡ 65661654-6577-11eb-3a2a-cd07152d69ee
md"#### Estimate satellite positions: Matlab vs Julia vs Python
- 196 satellites
- Use the SGP4 propagator
- Time range of 24 hours into the past.
- Estimate the oribital elements and positions every 15 seconds
"

# ╔═╡ 4810c912-711f-11eb-112c-7da761ebebb2
bigbr

# ╔═╡ 4a10470e-711f-11eb-051a-f95adb23ca5b
bigbr

# ╔═╡ 82081be6-7070-11eb-176c-bd1e2329373e
md"""##### The Python version
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
	md"##### Python time to beat $(round(pytime, digits=2)) seconds."
end


# ╔═╡ de96f62c-7073-11eb-22a8-b525bb1efd7f
bigbr

# ╔═╡ d3cdb9e2-7073-11eb-0753-8bf123599cac
md"""#### But is it Python?

	If your platform supports it, this package compiles the verbatim source code from
	the official C++ version of SGP4...

	Otherwise, a slower but reliable Python implementation of SGP4 is used instead.
"""

# ╔═╡ 5156ee2e-7074-11eb-214a-33b40fbcb440
Conda.pip("install", "sgp4")

# ╔═╡ 6d23a0cc-7074-11eb-1803-5f9147f47d48
sgp4py = pyimport("sgp4")

# ╔═╡ 8699174c-7074-11eb-3cf0-e99217589e81
sgp4py.api.Satrec.sgp4  # Access the python method used by the program

# ╔═╡ af0d99b4-7074-11eb-1818-95ee43a058cb
md"##### Python/C++ time to beat $(round(pytime, digits=2)) seconds."

# ╔═╡ 997eaf48-7074-11eb-0f16-15e7c1604976
bigbr

# ╔═╡ 25eb4620-7120-11eb-362b-3b7ea60280f8
md"### using [SatelliteToolbox](https://github.com/JuliaSpace/SatelliteToolbox.jl/blob/62ee9ecefd91304549c3d3ea6ea82d43ff9eea52/src/submodules/SGP4/sgp4_model.jl)"

# ╔═╡ eb6c9594-711f-11eb-15e6-67223aadedd2
begin 
	filename = "/home/michael/dev/presentations/sats.txt"
	tles = read_tle(filename)
	time_steps = 0:15:86400
	
	function calculate_orbit(tle, time_range)
    	orb_init = init_orbit_propagator(Val(:sgp4), tle)
    	return propagate!(orb_init, time_range)
	end
	
	all_orbits(tles, time_range, L=length(tles)) = [calculate_orbit(tles[i], time_range) for i = 1:L]
end

# ╔═╡ dbd5e0b8-711f-11eb-3e9b-a1e6a9a02380
bigbr

# ╔═╡ 2e2b882e-657a-11eb-3fd2-833ec80ab780
b = @benchmark all_orbits(tles, time_steps)

# ╔═╡ 98d06838-6e31-11eb-28b3-3deaea5131c7
bigbr

# ╔═╡ ed97389c-657b-11eb-2a66-85ea207477c4
mtime = 31.06;

# ╔═╡ 5fd01a92-7070-11eb-31fb-898d900d3b0e
md"##### The Matlab runtime to beat is $mtime seconds."

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
### Matlab/Julia = $(round(mtime/(b.times[1]/1e9), digits=1))x!
### PyC++/Julia = $(round(pytime/(b.times[1]/1e9), digits=1))x!
"""

# ╔═╡ 4dc468d0-7075-11eb-2343-b934979ce017
bigbr

# ╔═╡ 5a33f654-657c-11eb-1a9c-1bb3baf532f0
md"### Can Julia do even better? ABSOLUTELY!"

# ╔═╡ a8398ca8-657d-11eb-0a10-fd6c26ceeffd
md"""#### Step 1 - Use for-loop "long version" """

# ╔═╡ 6c4a3ef0-657c-11eb-1117-addb8a66db25
function all_orbits_2(tles, time_range, L=length(tles)) 
	all_orbits = []
	for i = 1:L
		push!(all_orbits, calculate_orbit(tles[i], time_range))
	end
	return all_orbits
end

# ╔═╡ fda71f84-657d-11eb-231b-39069e573811
bigbr

# ╔═╡ 8c290d94-6c7c-11eb-3b21-7b134d30c9ed
bigbr

# ╔═╡ 861533e8-657d-11eb-2521-f17727427b00
md"""#### Step 2 -  Pre-allocate the array"""

# ╔═╡ cd6f2456-657d-11eb-3ab3-b577f271d547
function all_orbits_3(tles, time_range, L=length(tles))
    array = Array{Any, 1}(undef, L)
	
    for i in eachindex(array)  # Supports OffsetArrays
        array[i] = calculate_orbit(tles[i], time_range)
    end
	
    return array
end

# ╔═╡ fadd51ae-657d-11eb-24f4-fb27f55fb4ba
bigbr

# ╔═╡ 8ff76948-6c7c-11eb-1ae1-0721853c17e8
bigbr

# ╔═╡ 0ab6b764-657e-11eb-2aed-b593a642430b
md"""### Step 3 - Add multi-threading"""

# ╔═╡ ee033436-657e-11eb-1074-c56a95eacd10
nt = Threads.nthreads()  # This checks the number of available threads.

# ╔═╡ ce725472-657d-11eb-150d-47449caa17e1
function threaded_orbits(tles, time_range, L=length(tles))
    array = Array{Any, 1}(undef, L)

    Threads.@threads for i in eachindex(array)
        array[i] = calculate_orbit(tles[i], time_range)
    end

    return array
end


# ╔═╡ 951fde7a-6c7c-11eb-26c4-c72635eb55a3
bigbr

# ╔═╡ 9713642c-6c7c-11eb-3c8f-f3c5d4c6cdbd
bigbr

# ╔═╡ 75512cd4-657e-11eb-2640-87279ba81927
c = @benchmark threaded_orbits(tles, time_steps)  # 173.77 ms lowest time

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

#### Matlab/Julia = $(round(mtime/(c.times[1]/1e9), digits=1))x!
#### PyC++/Julia = $(round(pytime/(c.times[1]/1e9), digits=1))x!
"""

# ╔═╡ cf952cda-7119-11eb-2236-218a27d8e1ac
hr

# ╔═╡ d5d30458-7119-11eb-17c1-e92c27e11eb9
md"""# Try Julia today! 
#### https://julialang.org
#### This notebook available here: 
#### https://github.com/mihalybaci/pluto_notebooks
"""

# ╔═╡ Cell order:
# ╠═f85eb8ca-649c-11eb-19bb-99e1a83e459b
# ╠═2055d28c-649d-11eb-3b12-639929fff5fa
# ╠═91f08860-7118-11eb-304f-298cb1a9d953
# ╟─f499ecb4-6492-11eb-19c2-43bda1cf2a0c
# ╟─8363f966-6c8a-11eb-0485-b39bfa77d265
# ╟─08c78d78-6b04-11eb-3ee2-a9409610de2f
# ╟─5060703e-6712-11eb-21c7-4f43e45d33d4
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
# ╟─b5fd4c3e-7118-11eb-2195-f776f9922342
# ╟─44df4210-6c76-11eb-068c-e94d426035e3
# ╟─f2cb36de-6c76-11eb-08de-4def5529ca57
# ╟─ca6e9678-7118-11eb-25bd-39cd6b1416c3
# ╟─dbbe2972-6c70-11eb-3b23-ab10538061b6
# ╟─4bff941e-6c71-11eb-15aa-95d0764dbd88
# ╟─519fdc1e-6c71-11eb-3332-9dd6272fb4bb
# ╟─cf3e2392-6c74-11eb-1e8c-9f62f3efc5ea
# ╟─c4439d84-6c72-11eb-362c-f7cc8fbdaf73
# ╟─672d665a-6c8d-11eb-1b0f-db23a6fa9ed7
# ╟─ea70326a-7118-11eb-0b33-adb80c9d4ee1
# ╟─92b33b58-6c72-11eb-356f-1721b99b8879
# ╟─8dd23ab2-6c90-11eb-3658-9d598f6b40d8
# ╟─a0f3f1ee-6c90-11eb-2ee3-1f577f0480e9
# ╟─85a888f0-6c72-11eb-1f27-3dcdb744e584
# ╠═a77b1794-6c71-11eb-1472-d9b2e129335f
# ╟─a5d7823c-6c72-11eb-1daf-a1e1616ff019
# ╟─e60170ae-6c72-11eb-02a5-a967e5461a44
# ╟─8af30d8e-7119-11eb-0ab0-e3528a469764
# ╟─286fb7e8-6496-11eb-1306-b56859f2ee3b
# ╟─3ab45088-6496-11eb-0c8d-b170a971e912
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
# ╟─010ee5f4-7135-11eb-2987-f34bb67004c1
# ╟─3ed06d48-711e-11eb-36a5-6b0d91ec6cef
# ╟─be821d4a-64b3-11eb-0013-39de4b85317c
# ╠═1078b698-64ae-11eb-23b5-59dafc065ec8
# ╠═36f1b350-6c70-11eb-2609-bb5ab899eef5
# ╠═07b47076-6c70-11eb-3e80-b1783abb82fc
# ╠═ace5815a-64ae-11eb-2fcd-dbe033e24d64
# ╟─89a23598-64af-11eb-2cc6-6556d23893db
# ╟─802f5856-6c70-11eb-2416-6bf168fb3f6a
# ╟─9d8f64dc-7070-11eb-0c26-3b2e94d855c3
# ╟─1aa6ff84-7071-11eb-1f89-19790d2e2d0e
# ╟─d0f30bea-706f-11eb-15a6-d7ba972ec3d2
# ╟─b5723bfe-706f-11eb-3145-e59fad8e37c2
# ╟─bf3fb88a-706f-11eb-2eff-c78593c02a4a
# ╟─65ccb6d2-706e-11eb-0323-13166548094b
# ╟─b0d2c860-706e-11eb-362e-dbc1fdfb8025
# ╟─c79df056-706e-11eb-0fc8-3308a1a9dae7
# ╟─07124a24-7070-11eb-27aa-bb67c4fb65b3
# ╟─10d1a370-7070-11eb-374a-f3d5421d8eb9
# ╟─a3063586-711e-11eb-2302-1701e48cd137
# ╟─a70a5e8c-7119-11eb-0ca5-ab74559db699
# ╟─c07d8068-64af-11eb-3ebd-2b8475096673
# ╟─52ceed22-64b4-11eb-2128-89132de079cb
# ╟─ced304c6-64af-11eb-28a9-bd26b77e4b48
# ╟─489df172-6577-11eb-036a-0721f2d5e86a
# ╟─3d05e82a-711f-11eb-2cc6-03e9b45e4d16
# ╟─4f914b28-6577-11eb-307e-d3fcb5d7090b
# ╟─65661654-6577-11eb-3a2a-cd07152d69ee
# ╟─4810c912-711f-11eb-112c-7da761ebebb2
# ╟─5fd01a92-7070-11eb-31fb-898d900d3b0e
# ╟─4a10470e-711f-11eb-051a-f95adb23ca5b
# ╟─82081be6-7070-11eb-176c-bd1e2329373e
# ╠═500dee00-7072-11eb-2a44-dd95d512fd0a
# ╟─de96f62c-7073-11eb-22a8-b525bb1efd7f
# ╟─d3cdb9e2-7073-11eb-0753-8bf123599cac
# ╠═5156ee2e-7074-11eb-214a-33b40fbcb440
# ╠═6d23a0cc-7074-11eb-1803-5f9147f47d48
# ╠═8699174c-7074-11eb-3cf0-e99217589e81
# ╟─af0d99b4-7074-11eb-1818-95ee43a058cb
# ╟─997eaf48-7074-11eb-0f16-15e7c1604976
# ╟─25eb4620-7120-11eb-362b-3b7ea60280f8
# ╠═eb6c9594-711f-11eb-15e6-67223aadedd2
# ╟─dbd5e0b8-711f-11eb-3e9b-a1e6a9a02380
# ╠═2e2b882e-657a-11eb-3fd2-833ec80ab780
# ╟─98d06838-6e31-11eb-28b3-3deaea5131c7
# ╟─ed97389c-657b-11eb-2a66-85ea207477c4
# ╟─7de28764-657a-11eb-3a09-dbfe24cad780
# ╟─6496d06a-657c-11eb-0135-0d8a17125891
# ╟─489343cc-7075-11eb-09c9-8730d3e8949a
# ╟─4dc468d0-7075-11eb-2343-b934979ce017
# ╟─5a33f654-657c-11eb-1a9c-1bb3baf532f0
# ╟─a8398ca8-657d-11eb-0a10-fd6c26ceeffd
# ╠═6c4a3ef0-657c-11eb-1117-addb8a66db25
# ╟─fda71f84-657d-11eb-231b-39069e573811
# ╟─8c290d94-6c7c-11eb-3b21-7b134d30c9ed
# ╟─861533e8-657d-11eb-2521-f17727427b00
# ╠═cd6f2456-657d-11eb-3ab3-b577f271d547
# ╟─fadd51ae-657d-11eb-24f4-fb27f55fb4ba
# ╟─8ff76948-6c7c-11eb-1ae1-0721853c17e8
# ╟─0ab6b764-657e-11eb-2aed-b593a642430b
# ╠═ee033436-657e-11eb-1074-c56a95eacd10
# ╠═ce725472-657d-11eb-150d-47449caa17e1
# ╟─951fde7a-6c7c-11eb-26c4-c72635eb55a3
# ╟─9713642c-6c7c-11eb-3c8f-f3c5d4c6cdbd
# ╠═75512cd4-657e-11eb-2640-87279ba81927
# ╟─eaef6282-7119-11eb-1530-33b741097913
# ╟─485002ee-657e-11eb-2a1e-4b6ceb4e86b4
# ╟─911847b4-7075-11eb-20ef-715b719f94f4
# ╟─7511a470-7075-11eb-123e-eb2c888210ec
# ╟─cf952cda-7119-11eb-2236-218a27d8e1ac
# ╟─d5d30458-7119-11eb-17c1-e92c27e11eb9

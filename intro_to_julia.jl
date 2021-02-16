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
end

# ╔═╡ f85eb8ca-649c-11eb-19bb-99e1a83e459b
br = HTML("<br>");  # Add a semi-colon to block the output

# ╔═╡ 2055d28c-649d-11eb-3b12-639929fff5fa
bigbr = HTML("<br><br><br><br>");

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
# A short list about [Julia](https://julialang.org)
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
md"#### No packages used, base language features only!"

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

# ╔═╡ a7d1d688-64b2-11eb-3c21-159fe6996ff1
md"""
### petaFLOPS club
- C
- C++
- FORTRAN
- Julia

In 2017, the Celeste astronomical image analysis project (writtin in Julia) reached 1.54 petaFLOPS on the Knights Landing supercomputer in 2017."""

# ╔═╡ a8f57646-6c70-11eb-1172-69e69a59ffbd
bigbr

# ╔═╡ a078a59a-6c70-11eb-22a4-015b619517c9
md"### Stay tuned for a real-life multi-threading example!"

# ╔═╡ 44df4210-6c76-11eb-068c-e94d426035e3
md"## Quick note on using GPUs"

# ╔═╡ badd0e52-6c76-11eb-1b47-3d42daf642ea
md"### What's the difference between training a convolutional neural network on a CPU versus a GPU?"

# ╔═╡ f2cb36de-6c76-11eb-08de-4def5529ca57
md"""
#### Example using Flux.jl with GPU support (details omitted for clarity)
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

# ╔═╡ b365af78-6c71-11eb-0e50-c55ccaa8485c
md"""
## Let's say you want to try this notebook at home. Here are the steps:
1. Download Julia
2. Install Pluto.jl: `import Pkg; Pkg.add("Pluto")`
3. Open Pluto notebooks: `using Pluto; Pluto.run()`
4. Open from file: https://github.com/mihalybaci/pluto\_notebooks/blob/main/intro\_to\_julia.jl
"""

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

When `MyProjectFile.jl` is run, `Pkg` will automatically install the files needed to recreate the **exact same original state**.

#### As long as you have the source code, the Julia version corresponding with the source code, `Project.toml`, and `Manifest.toml`, the environment will be reproducible **indefinitely regardless of package version changes**.
"""

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

# ╔═╡ 1ba529ee-7053-11eb-0dcd-d197d7b5d983
is_evil(p) = rand() < p

# ╔═╡ 26c06b34-7053-11eb-20f7-ff1cb0f8a562
is_evil(0.5)

# ╔═╡ 7e4f505a-64a4-11eb-39fe-cfbceddb100d
br

# ╔═╡ 807a3b42-64a4-11eb-0601-072890f38828
br

# ╔═╡ 821b7614-64a4-11eb-16a9-6b656aed1f8a
br

# ╔═╡ 8375030e-64a4-11eb-0585-e9efffde0a79
br

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

# ╔═╡ 05b9366a-64ae-11eb-1535-63b2eb1a237c
md"""
## Speaking of Python...
### From within Julia is possible to use code from:
 - **C**
 - **FORTRAN**
 - C++
 - Python
 - R
 - Java
 - Matlab
 - Mathematica
"""

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

# ╔═╡ c07d8068-64af-11eb-3ebd-2b8475096673
md"## State-of-the-Art Packages"

# ╔═╡ 52ceed22-64b4-11eb-2128-89132de079cb
md"""
### Noteworthy packages
(all Julia packages end in .jl)
- **Conda, PyCall** -- Python interop
- **IJulia** -- Jupyter notebooks
- **Pluto, PlutoUI** -- Pluto notebooks (use this one)
- **CSV, DataFrames** -- Core dataframes support
- **Plots, Gadfly** -- Plotting
- **Differential Equations** -- State-of-the-art diff eq solvers
"""

# ╔═╡ ced304c6-64af-11eb-28a9-bd26b77e4b48
md"### Check [juliahub.com](https://juliahub.com/ui/Home) for your favorites!"

# ╔═╡ 489df172-6577-11eb-036a-0721f2d5e86a
br

# ╔═╡ 4f914b28-6577-11eb-307e-d3fcb5d7090b
md"
### Package Spotlight: SatelliteToolbox"

# ╔═╡ 2efe693a-6578-11eb-03a9-53286e9939cc
br

# ╔═╡ 65661654-6577-11eb-3a2a-cd07152d69ee
md"#### Estimate satellite positions: Matlab vs Julia vs Python
- 196 satellites
- Use the SGP4 propagator
- Time range of 24 hours into the past.
- Estimate the oribital elements and positions every 15 seconds
"

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

test = [(base, rem) for (base, rem) in zip(jd_bases, jd_rems)]

def vals(sats, bases, rems): 
    return [[sat.sgp4(base, rem) for (base, rem) in zip(bases, rems)] for sat in  sats]

'''

np.min(timeit.repeat('vals(satellites, jd_bases, jd_rems)', setup=the_setup, number=1, repeat=10))
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

test = [(base, rem) for (base, rem) in zip(jd_bases, jd_rems)]

def vals(sats, bases, rems): 
    return [[sat.sgp4(base, rem) for (base, rem) in zip(bases, rems)] for sat in  sats]
'''

def the_time():
	return np.min(timeit.repeat('vals(satellites, jd_bases, jd_rems)', setup=the_setup, number=1, repeat=10))"""
	
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

# ╔═╡ ceea480c-6579-11eb-0552-05d28e60ca9c
filename = "/home/michael/dev/presentations/sats.txt";

# ╔═╡ ff666316-6578-11eb-09f4-170f2dde1be6
tles = read_tle(filename);

# ╔═╡ 394ff24c-7062-11eb-08df-4f4e6d23b902
tles[1]

# ╔═╡ 9704d25c-6579-11eb-32ab-0f7e1a5e1da5
md"#### The two steps of the orbit calculation are initialization and propagation, combined below into a single function."

# ╔═╡ bd8280f0-6579-11eb-2551-8f7d476536c6
function calculate_orbit(tle, time_range)
    orb_init = init_orbit_propagator(Val(:sgp4), tle)
    return propagate!(orb_init, time_range)
end

# ╔═╡ dea30944-6579-11eb-3731-631bfa992cc4
md"#### Run all satellites the easy way (and time it!)"

# ╔═╡ ff50c74e-6579-11eb-1cb2-7598f56c6cf1
all_orbits(tles, time_range, L=length(tles)) = [calculate_orbit(tles[i], time_range) for i = 1:L]

# ╔═╡ 56c4e064-657a-11eb-3a34-3bc05b199dd1
time_steps = 0:15:86400

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
	
    for i = 1:L
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

# ╔═╡ 485002ee-657e-11eb-2a1e-4b6ceb4e86b4
md"
#### Matlab (1 thread) - $mtime s
#### Python/C++ - $(round(pytime, digits=2)) s
#### Julia (1 thread) - $(round(b.times[1]/1e9, digits=3)) s
#### Julia ($nt threads) - $(round(c.times[1]/1e9, digits=3)) s
"

# ╔═╡ 911847b4-7075-11eb-20ef-715b719f94f4
br

# ╔═╡ 7511a470-7075-11eb-123e-eb2c888210ec
md"""
### Final results: 

#### Matlab/Julia(4) = $(round(mtime/(c.times[1]/1e9), digits=1))x!
#### PyC++/Julia(4) = $(round(pytime/(c.times[1]/1e9), digits=1))x!
"""

# ╔═╡ Cell order:
# ╠═f85eb8ca-649c-11eb-19bb-99e1a83e459b
# ╠═2055d28c-649d-11eb-3b12-639929fff5fa
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
# ╟─a7d1d688-64b2-11eb-3c21-159fe6996ff1
# ╟─a8f57646-6c70-11eb-1172-69e69a59ffbd
# ╟─a078a59a-6c70-11eb-22a4-015b619517c9
# ╟─44df4210-6c76-11eb-068c-e94d426035e3
# ╟─badd0e52-6c76-11eb-1b47-3d42daf642ea
# ╟─f2cb36de-6c76-11eb-08de-4def5529ca57
# ╟─dbbe2972-6c70-11eb-3b23-ab10538061b6
# ╟─4bff941e-6c71-11eb-15aa-95d0764dbd88
# ╟─519fdc1e-6c71-11eb-3332-9dd6272fb4bb
# ╟─cf3e2392-6c74-11eb-1e8c-9f62f3efc5ea
# ╟─c4439d84-6c72-11eb-362c-f7cc8fbdaf73
# ╟─672d665a-6c8d-11eb-1b0f-db23a6fa9ed7
# ╟─b365af78-6c71-11eb-0e50-c55ccaa8485c
# ╟─92b33b58-6c72-11eb-356f-1721b99b8879
# ╟─8dd23ab2-6c90-11eb-3658-9d598f6b40d8
# ╟─a0f3f1ee-6c90-11eb-2ee3-1f577f0480e9
# ╟─85a888f0-6c72-11eb-1f27-3dcdb744e584
# ╠═a77b1794-6c71-11eb-1472-d9b2e129335f
# ╟─a5d7823c-6c72-11eb-1daf-a1e1616ff019
# ╟─e60170ae-6c72-11eb-02a5-a967e5461a44
# ╟─286fb7e8-6496-11eb-1306-b56859f2ee3b
# ╟─3ab45088-6496-11eb-0c8d-b170a971e912
# ╟─9d185a72-649f-11eb-061d-3ba4357d4e4d
# ╠═1ba529ee-7053-11eb-0dcd-d197d7b5d983
# ╠═26c06b34-7053-11eb-20f7-ff1cb0f8a562
# ╟─7e4f505a-64a4-11eb-39fe-cfbceddb100d
# ╟─807a3b42-64a4-11eb-0601-072890f38828
# ╟─821b7614-64a4-11eb-16a9-6b656aed1f8a
# ╟─8375030e-64a4-11eb-0585-e9efffde0a79
# ╟─b8dbbfa4-64a1-11eb-21f3-bf8d4517e086
# ╠═4dbfbc7e-64a2-11eb-29f0-891d4121fc8f
# ╟─ee7515e0-64a4-11eb-3d94-77b8a34c3f7b
# ╟─d4581d5c-64a3-11eb-0f0f-d9e006e75a06
# ╟─9e6269f0-64a3-11eb-14ce-c1877e9fbc9e
# ╟─05b9366a-64ae-11eb-1535-63b2eb1a237c
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
# ╠═b0d2c860-706e-11eb-362e-dbc1fdfb8025
# ╟─c79df056-706e-11eb-0fc8-3308a1a9dae7
# ╟─07124a24-7070-11eb-27aa-bb67c4fb65b3
# ╟─10d1a370-7070-11eb-374a-f3d5421d8eb9
# ╟─c07d8068-64af-11eb-3ebd-2b8475096673
# ╟─52ceed22-64b4-11eb-2128-89132de079cb
# ╟─ced304c6-64af-11eb-28a9-bd26b77e4b48
# ╟─489df172-6577-11eb-036a-0721f2d5e86a
# ╟─4f914b28-6577-11eb-307e-d3fcb5d7090b
# ╟─2efe693a-6578-11eb-03a9-53286e9939cc
# ╟─65661654-6577-11eb-3a2a-cd07152d69ee
# ╟─5fd01a92-7070-11eb-31fb-898d900d3b0e
# ╟─82081be6-7070-11eb-176c-bd1e2329373e
# ╟─500dee00-7072-11eb-2a44-dd95d512fd0a
# ╟─de96f62c-7073-11eb-22a8-b525bb1efd7f
# ╟─d3cdb9e2-7073-11eb-0753-8bf123599cac
# ╠═5156ee2e-7074-11eb-214a-33b40fbcb440
# ╠═6d23a0cc-7074-11eb-1803-5f9147f47d48
# ╠═8699174c-7074-11eb-3cf0-e99217589e81
# ╟─af0d99b4-7074-11eb-1818-95ee43a058cb
# ╟─997eaf48-7074-11eb-0f16-15e7c1604976
# ╠═ceea480c-6579-11eb-0552-05d28e60ca9c
# ╠═ff666316-6578-11eb-09f4-170f2dde1be6
# ╠═394ff24c-7062-11eb-08df-4f4e6d23b902
# ╟─9704d25c-6579-11eb-32ab-0f7e1a5e1da5
# ╠═bd8280f0-6579-11eb-2551-8f7d476536c6
# ╟─dea30944-6579-11eb-3731-631bfa992cc4
# ╠═ff50c74e-6579-11eb-1cb2-7598f56c6cf1
# ╠═56c4e064-657a-11eb-3a34-3bc05b199dd1
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
# ╟─485002ee-657e-11eb-2a1e-4b6ceb4e86b4
# ╟─911847b4-7075-11eb-20ef-715b719f94f4
# ╟─7511a470-7075-11eb-123e-eb2c888210ec

### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ c7ed9838-6496-11eb-1d16-6f5d44ba89a9
begin
	# Import the package manager
	import Pkg
	# Activate the temporary environment
	Pkg.activate(mktempdir())
	# Add the packages (downloading them if necessary)
	Pkg.add(["BenchmarkTools", "Images", "PyCall", "SatelliteToolbox"])
	# Load the packages
	using BenchmarkTools
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

# ╔═╡ 5060703e-6712-11eb-21c7-4f43e45d33d4
md"# JuliaCon 2021

### **Location**: Everywhere on Earth

### **Date**: 28 -- 30 July 2021

### **Cost**: FREE

### **Registration**: https://juliacon.org/2021/"

# ╔═╡ 37214cae-6492-11eb-2c62-ddff99867043
md"# Exploring the Julia  Language"

# ╔═╡ 03c3bf38-6493-11eb-1cd2-4bcf96696f89
md"""
## A short list about [Julia](https://julialang.org)
 - Prototyping speed of Python/Matlab, Runtime speeds approaching C
 - Full parallelism (multi-threading, multi-process, HPC-ready)
 - Bye, bye OOP! Hello Multiple dispatch!
 - Designed from the ground-up for scientific computing
 - Unbeatable interoperability
 - Over 4300 registered packages

"""

# ╔═╡ d3220a8c-6495-11eb-0c22-0d1b450c91f1
md"## Walks like Python,Runs like C"

# ╔═╡ 80745e40-6498-11eb-2f82-d133e2d32f78
load("julia_bench.png")

# ╔═╡ ea2b7858-649c-11eb-36a8-2f2670063bee
bigbr

# ╔═╡ 482e7128-64c1-11eb-3af8-2dff4ca691c3
br

# ╔═╡ a2ef89dc-649c-11eb-100f-55274909e1b4
load("benchmarksgame_1.png")

# ╔═╡ ac11c534-649c-11eb-0d82-dff01e7f1cc8
load("benchmarksgame_2.png")

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

# ╔═╡ ace5815a-64ae-11eb-2fcd-dbe033e24d64
# This code prints the current of SHELL
begin
	path = ccall(:getenv, Cstring, (Cstring,), "SHELL")
	unsafe_string(path)  # 
end

# ╔═╡ 89a23598-64af-11eb-2cc6-6556d23893db
bigbr

# ╔═╡ 5d028876-64af-11eb-2d18-b98e8fdb4374
md"### For Python we need to use PyCall"

# ╔═╡ c07d8068-64af-11eb-3ebd-2b8475096673
md"## State-of-the-Art Packages"

# ╔═╡ 52ceed22-64b4-11eb-2128-89132de079cb
md"""
### Noteworthy packages
(all Julia packages end in .jl)
- **PyCall** -- Python interop
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
md"#### Estimate satellite positions: Matlab vs Julia
- 196 satellites
- Use the SGP4 propagator
- Time range of 24 hours into the past.
- Estimate the oribital elements and positions every 15 seconds
"

# ╔═╡ ceea480c-6579-11eb-0552-05d28e60ca9c
filename = "/home/michael/dev/presentations/sats.txt";

# ╔═╡ ff666316-6578-11eb-09f4-170f2dde1be6
tles = read_tle(filename);

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

# ╔═╡ ed97389c-657b-11eb-2a66-85ea207477c4
mtime = 31.06;

# ╔═╡ 7de28764-657a-11eb-3a09-dbfe24cad780
md"
#### Matlab - $mtime s
#### Julia  - $(round(b.times[1]/1e9, digits=3)) s

#### Julia ran $(round(mtime/(b.times[1]/1e9), digits=1))x faster than Matlab!
"

# ╔═╡ 6496d06a-657c-11eb-0135-0d8a17125891
br

# ╔═╡ 5a33f654-657c-11eb-1a9c-1bb3baf532f0
md"### Can we do better? ABSOLUTELY!"

# ╔═╡ a8398ca8-657d-11eb-0a10-fd6c26ceeffd
md"""#### Step 1 - Use for-loop "long version"""

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

# ╔═╡ 0ab6b764-657e-11eb-2aed-b593a642430b
md"""### Step 3 - Add multi-threading"""

# ╔═╡ ee033436-657e-11eb-1074-c56a95eacd10
nt = Threads.nthreads()

# ╔═╡ ce725472-657d-11eb-150d-47449caa17e1
function threaded_orbits(tles, time_range, L=length(tles))
    array = Array{Any, 1}(undef, L)

    Threads.@threads for i in eachindex(array)
        array[i] = calculate_orbit(tles[i], time_range)
    end

    return array
end


# ╔═╡ 75512cd4-657e-11eb-2640-87279ba81927
c = @benchmark threaded_orbits(tles, time_steps)  # 173.77 ms lowest time

# ╔═╡ 485002ee-657e-11eb-2a1e-4b6ceb4e86b4
md"
#### Matlab - $mtime s
#### Julia (1 thread) - $(round(b.times[1]/1e9, digits=3)) s
#### Julia ($nt threads) - $(round(c.times[1]/1e9, digits=3)) s

#### Multi-threaded version is $(round(b.times[1]/c.times[1], digits=1))x faster.
#### Final result: Julia is $(round(mtime/(c.times[1]/1e9), digits=1))x faster than Matlab!
"

# ╔═╡ Cell order:
# ╠═c7ed9838-6496-11eb-1d16-6f5d44ba89a9
# ╠═f85eb8ca-649c-11eb-19bb-99e1a83e459b
# ╠═2055d28c-649d-11eb-3b12-639929fff5fa
# ╟─f499ecb4-6492-11eb-19c2-43bda1cf2a0c
# ╟─5060703e-6712-11eb-21c7-4f43e45d33d4
# ╠═37214cae-6492-11eb-2c62-ddff99867043
# ╟─03c3bf38-6493-11eb-1cd2-4bcf96696f89
# ╟─d3220a8c-6495-11eb-0c22-0d1b450c91f1
# ╟─80745e40-6498-11eb-2f82-d133e2d32f78
# ╟─ea2b7858-649c-11eb-36a8-2f2670063bee
# ╟─482e7128-64c1-11eb-3af8-2dff4ca691c3
# ╟─a2ef89dc-649c-11eb-100f-55274909e1b4
# ╟─ac11c534-649c-11eb-0d82-dff01e7f1cc8
# ╟─8200b8b0-64b3-11eb-30c8-0f043db218d4
# ╟─a7d1d688-64b2-11eb-3c21-159fe6996ff1
# ╟─286fb7e8-6496-11eb-1306-b56859f2ee3b
# ╟─3ab45088-6496-11eb-0c8d-b170a971e912
# ╟─9d185a72-649f-11eb-061d-3ba4357d4e4d
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
# ╠═ace5815a-64ae-11eb-2fcd-dbe033e24d64
# ╟─89a23598-64af-11eb-2cc6-6556d23893db
# ╟─5d028876-64af-11eb-2d18-b98e8fdb4374
# ╟─c07d8068-64af-11eb-3ebd-2b8475096673
# ╟─52ceed22-64b4-11eb-2128-89132de079cb
# ╟─ced304c6-64af-11eb-28a9-bd26b77e4b48
# ╟─489df172-6577-11eb-036a-0721f2d5e86a
# ╟─4f914b28-6577-11eb-307e-d3fcb5d7090b
# ╟─2efe693a-6578-11eb-03a9-53286e9939cc
# ╟─65661654-6577-11eb-3a2a-cd07152d69ee
# ╠═ceea480c-6579-11eb-0552-05d28e60ca9c
# ╠═ff666316-6578-11eb-09f4-170f2dde1be6
# ╟─9704d25c-6579-11eb-32ab-0f7e1a5e1da5
# ╠═bd8280f0-6579-11eb-2551-8f7d476536c6
# ╟─dea30944-6579-11eb-3731-631bfa992cc4
# ╠═ff50c74e-6579-11eb-1cb2-7598f56c6cf1
# ╠═56c4e064-657a-11eb-3a34-3bc05b199dd1
# ╠═2e2b882e-657a-11eb-3fd2-833ec80ab780
# ╟─ed97389c-657b-11eb-2a66-85ea207477c4
# ╟─7de28764-657a-11eb-3a09-dbfe24cad780
# ╟─6496d06a-657c-11eb-0135-0d8a17125891
# ╟─5a33f654-657c-11eb-1a9c-1bb3baf532f0
# ╟─a8398ca8-657d-11eb-0a10-fd6c26ceeffd
# ╠═6c4a3ef0-657c-11eb-1117-addb8a66db25
# ╟─fda71f84-657d-11eb-231b-39069e573811
# ╟─861533e8-657d-11eb-2521-f17727427b00
# ╠═cd6f2456-657d-11eb-3ab3-b577f271d547
# ╟─fadd51ae-657d-11eb-24f4-fb27f55fb4ba
# ╟─0ab6b764-657e-11eb-2aed-b593a642430b
# ╠═ee033436-657e-11eb-1074-c56a95eacd10
# ╠═ce725472-657d-11eb-150d-47449caa17e1
# ╠═75512cd4-657e-11eb-2640-87279ba81927
# ╟─485002ee-657e-11eb-2a1e-4b6ceb4e86b4

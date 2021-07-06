### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ e4f55578-9bb5-11eb-2848-c9331b681a62
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["BenchmarkTools", "Conda", "Images", "PlutoUI", "Profile", "PyCall"])
	using PlutoUI
	using LinearAlgebra	
end

# ╔═╡ 9bc9ce04-4df3-4336-a412-867bf892489e
using BenchmarkTools, Profile

# ╔═╡ a7bd375e-14e9-4971-85b0-a8f49447cc98
using Conda

# ╔═╡ 1ba28924-33dc-458c-96f1-80db64563e15
using PyCall

# ╔═╡ e16506f2-fea3-4678-b95f-3d78da5c7193
using .Threads

# ╔═╡ 2d6cce0d-cf01-4065-8a90-b35f5135ae34
using Images

# ╔═╡ 2e11c9de-677e-4a1d-b6e9-b87421ab4db9
br = HTML("<br>");  # Add a semi-colon to block the output

# ╔═╡ e7fdca5f-a467-4f17-b2e7-2b7365b58fe2
html"<button onclick=present()>Present</button>"

# ╔═╡ 98a65bee-c989-4edb-9f40-4c9962c94a8a
md"""
# Programming for Performance
### Tips and tricks for writing fast code
$br
[https://wiki.python.org/moin/PythonSpeed/PerformanceTips](https://wiki.python.org/moin/PythonSpeed/PerformanceTips)

[https://docs.julialang.org/en/v1/manual/performance-tips/](https://docs.julialang.org/en/v1/manual/performance-tips/)

[Performance Benchmarking in Julia (YouTube)](https://www.youtube.com/watch?v=_yzYLTYZ4eQ)
"""

# ╔═╡ e4c936b0-470f-4e3c-b8aa-09a6e0616d59
md"""## Performance-enhancing Packages

### Python

#### **NumPy** - mostly built on C/C++/FORTRAN libraries
#### **Numba** - JIT compiler, works best with numpy arrays
#### **Dask** - Scalable "big data" framework
#### **Cython** - C-like compiler for Python code

$br
$br

### Julia

#### **StaticArrays** - provides a static-array type
#### **LoopVectorization** - Extra optimizations for loops
#### **MKL/Octavian** - Optimized BLAS libraries
#### **PackageCompiler** - Compile custom sysimages and apps

"""

# ╔═╡ ad8afc2c-60a5-43a9-9896-d1c2d4b653ed
md"""## Measure performance!

### Code introspection can find performance bottlenecks.

#### Python
- timeit (built-in)
- profile (built-in)
- cProfile (built-in)
#### Julia 
- `@time` and `@timev` (built-in)
- Profile.jl (built-in)
- BenchmarkTools.jl
- ProfileViews.jl
- PProf.jl 
- TimerOutputs.jl
- SnoopCompile.jl
"""

# ╔═╡ 593bd30f-c2e3-4502-83d8-2d6ef298f65e
br

# ╔═╡ 6b305828-7991-4648-817c-36aa8b811f21
"""
Extends a matrix according to kernel size when performing a convolution.
"""
function extend_mat(M::AbstractMatrix, i, j)
	rows, cols = size(M)

	return M[(1 ≤ i ≤ rows) ? i : ((i < 1) ? 1 : rows),
		     (1 ≤ j ≤ cols) ? j : ((j < 1) ? 1 : cols)]
end

# ╔═╡ 2fdf8a93-f512-4dd5-9b5a-4f9e1216ca74
"""
Convolve a matrix, M, using a convolution kernel, K.
"""
function convolve_image(M::AbstractMatrix, K::AbstractMatrix)
	rows_m, cols_m = size(M)
	rows_k, cols_k = size(K)
	lr = (rows_k - 1) ÷ 2
	lc = (cols_k - 1) ÷ 2
	new_M = zeros(eltype(M), size(M))
	for j = 1:cols_m
		for i = 1:rows_m
			new_M[i, j] = clamp(sum([extend_mat(M, k, l) for (k, l) in Iterators.product(i-lr:i+lr, j-lc:j+lc)].*K), 0, 1)
		end
	end
	
	return new_M
end

# ╔═╡ 33ba73d8-faea-4684-9d9a-bee9240fc699
image = rand(1000, 1000)  # Create a 1000x1000 matrix of random values [0, 1)

# ╔═╡ cada2776-9cfd-45ac-8c72-682fb70b0c11
kernel = ones(3,3)/9  # Kernel for Gaussian blur

# ╔═╡ 16f22b25-cd38-4546-b709-815848fbabed
@benchmark convolve_image($image, $kernel)

# ╔═╡ 7dfef34c-7221-4055-8de4-46f71ad9d801
br

# ╔═╡ 095acdf2-74e8-458c-94fe-8c335460fa9b
md"""
### Note on benchmark times:

##### There __IS__ a minimum runtime for a given function.
##### There __IS NO__ maximum runtime for a given function.

##### Therefore, the __minimum__ and __median__ times are best for comparisons.
"""

# ╔═╡ 073390d5-0395-44f9-a5f4-f4dccc2a1a37
br

# ╔═╡ a202c13e-e356-4b2d-aeac-f8b68ea4853d
br

# ╔═╡ 8e246e00-c3dd-4456-929e-3069f0940a7e
md"""
### A quick digression on macros

##### Macros "capture" code and transform it in some way.
##### Macros are most useful to get results that would be difficult to achieve with a traditional function."
"""

# ╔═╡ 2dd80ad1-7994-4c90-94c2-a159ce4a80ec
macro only1(code)
	return :( 1 )
end

# ╔═╡ eb2d1dee-b64c-4ff3-bbc9-c40b75926c72
@only1 println("Don't overuse macros!")

# ╔═╡ 4561711e-7c55-458e-baf9-00d03c515f30
@macroexpand @benchmark sin(1)

# ╔═╡ 4e87ab75-cdd5-471b-98de-79a36dfa9fd4
sayhello(name) = println("Hello, ", name, ".")

# ╔═╡ 84ed1cac-31f1-474e-801d-8da6bb069d53
sayhello("Alice")  # Pluto puts STDOUT in the terminal!

# ╔═╡ 17d7e432-829e-4240-be80-2365cb31acfa
br

# ╔═╡ cbd467ad-bdfc-4568-9ce8-cba4c6196ddf
with_terminal() do
    sayhello("Alice")
end

# ╔═╡ 85ce8b95-237d-49ad-af48-b034faa2b74c
macro terminal(stuff)
	quote
		with_terminal() do
			$(esc(stuff))
		end
	end
end

# ╔═╡ ac7b61e6-afe0-4290-9492-6b29e4e312ad
@terminal sayhello("Alice")

# ╔═╡ 0451fba2-52e2-45d9-b005-9019fe5d16ce
br

# ╔═╡ 76746655-4479-4d45-b357-e9c49c5742ec
Profile.clear(); @profile convolve_image(image, kernel);

# ╔═╡ 5b2acdb5-0da7-4bf8-9270-d249ea258659
@terminal Profile.print()

# ╔═╡ 951c9498-c080-48b7-bea7-b9b5e14a518a
md"""
## Avoid Global Variables

### Compilers cannot optimize global variables.

#### Alternatives:
- ##### Include variables as function arguments
- ##### Make globals constant
"""

# ╔═╡ 5932d739-4183-4936-a5ac-a4e82d9164d3
myglobal = rand(1_000_000)

# ╔═╡ 52aba5be-b9c9-478a-8419-b52b3da1159c
function loop_over_global()
    s = 0.0
    for i in myglobal
        s += i
    end
    return s
end

# ╔═╡ 9342ed2f-aeb8-4cea-8603-f55b8a41bdfb
logt = @benchmark loop_over_global()

# ╔═╡ a740d1b4-fc22-40a3-818d-fa1bab61cac7
br

# ╔═╡ 8121837a-20bb-4658-959e-8f9ce74ce99f
const myconst = deepcopy(myglobal)

# ╔═╡ 2f2533f2-ccf5-4e1f-b6d2-21610b2f1f42
function loop_over_const()
    s = 0.0
    for i in myconst
		s += i
    end
    return s
end

# ╔═╡ 90b1c976-44ed-44c2-8a3d-117146c8f8c1
loct = @benchmark loop_over_const()

# ╔═╡ c36532c0-6de8-4a76-a93c-a06ea4c5073f
md"##### global is $(round(logt.times[1]/loct.times[1], digits=2))x slower than const!"

# ╔═╡ ec44412f-f193-4f9a-b5b6-519895a1c0ab
br

# ╔═╡ 4eb7104a-5697-47df-a66e-1ba56e509e26
function loop_over_var(x)
    s = 0.0
    for i in x
        s += i
    end
    return s
end

# ╔═╡ 57c5bf2e-4994-4e7a-9bba-1ba994e07246
lovt = @benchmark loop_over_var($myglobal)

# ╔═╡ f43df4dd-0fc6-448b-af4c-318acb830421
md"##### variable ÷ constant = $(round(lovt.times[1]/loct.times[1], digits=3))"

# ╔═╡ 4af40bd1-10ff-4b3d-a0bc-9af1bc3bbde9
md"""## Write type stable functions

### Variable type changes add computational overhead.
"""

# ╔═╡ 9a45dfe2-6b90-4ad0-874b-046d896a9126
br

# ╔═╡ 577b843e-9cba-4133-a08c-47cec7efc840
md"#### Are the following functions type stable?"

# ╔═╡ e6b6229e-3288-4e68-bd7f-539221d6ac83
pos1(x) = x < 0 ? 0 : x

# ╔═╡ ae07a63f-147a-4ef5-a110-550a400162a6
pos2(x) = x < 0 ? zero(x) : x

# ╔═╡ 45e8c600-9e0d-4e6a-a15c-57a98ef06990
@terminal @code_warntype pos1(1)

# ╔═╡ a61c2e89-c3f1-409d-b647-66fae7e955bd
@terminal @code_warntype pos1(1.0)

# ╔═╡ 234d3e51-6a6f-46d6-ad76-a8b3fe05ccc9
@terminal @code_warntype pos2(1.0)

# ╔═╡ e48bf258-fb6e-477a-94d0-ffde83d583be
br

# ╔═╡ 653409f1-ed1c-4353-bb46-6a212276d9ad
function posrand1(N)
	xs = randn(N)
	for i in eachindex(xs)
		xs[i] = pos1(xs[i])
	end
	return xs
end

# ╔═╡ b214f376-70cd-40a8-9a35-bebdd6b50f73
function posrand2(N)
	xs = randn(N)
	for i in eachindex(xs)
		xs[i] = pos2(xs[i])
	end
	return xs
end

# ╔═╡ 1ba37d04-5887-4330-a3cd-1f199f312608
pr1 = @benchmark posrand1($10_000)

# ╔═╡ c3906d8d-be04-4302-ad19-35ff3fb62606
pr2 = @benchmark posrand2($10_000)

# ╔═╡ 9332ee1e-60cf-48b2-8e26-17ff5b4cfcea
md"#### Type stable is $(round(pr1.times[1]/pr2.times[2], digits=2))x faster than unstable."

# ╔═╡ 3595bc98-54ef-49ea-80c3-87e2d35c80a2
md"""
## Keep functions short

### Compilers can better optimize simple functions.

##### (for Julia users: Make multiple dispatch work for you!)
"""

# ╔═╡ d34e66e4-71cc-474c-b7a3-ef32381f81d7
# Not very "Julian"
function mynorm(A)
    if isa(A, Vector)
        return sqrt(real(dot(A,A)))
    elseif isa(A, Matrix)
        return maximum(svdvals(A))
    else
        error("mynorm: invalid argument")
    end
end

# ╔═╡ eaa94938-fa80-4ea1-82ef-afaf3b8c0cf9
# Very Julian!
begin 
	othernorm(x::Vector) = sqrt(real(dot(x, x)))
	othernorm(A::Matrix) = maximum(svdvals(A))
end

# ╔═╡ ce37fb19-4625-4373-9002-7d82f6649aa5
md"""## Pay attention to matrix memory access order

### Is your language of choice row- or column-major?

#### Row-major: C, C++, Pascal, NumPy*
#### Column-major: FORTRAN, Julia, MATLAB, R
"""

# ╔═╡ 39ee1bdc-abc6-45dd-b47d-a58b37f835a3
function mymulr(A, B)
	m, n  = size(A)
	C = similar(A)
	for i = 1:m
		for j = 1:n
			C[i, j] = A[i, j]*B[i, j]
		end
	end
	return C
end

# ╔═╡ 1b402d87-b739-4772-a770-63a5468c6769
function mymulc(A, B)
	m, n  = size(A)
	C = similar(A)
	for j = 1:n
		for i = 1:m
			C[i, j] = A[i, j]*B[i, j]
		end
	end
	return C
end

# ╔═╡ 0890ab13-b5b8-4f85-a276-cfbb82fcbccf
A = rand(100, 100);

# ╔═╡ b486af2f-fadf-45f7-a642-eb6c3dec125b
B = rand(100, 100);

# ╔═╡ e5514dcd-acda-436f-b1a1-bf7dcd53599d
mmr = @benchmark mymulr($A, $B)

# ╔═╡ c3375081-bfa3-4f3f-a723-e184d66ac662
mmc = @benchmark mymulc($A, $B)

# ╔═╡ 370d0e5d-7b8a-4cdd-b909-10d3b43f82ea
mmp = 100*(mmr.times[1] - mmc.times[1])/mmr.times[1];

# ╔═╡ 4357ddfa-48f9-401f-8e5d-ebd8968f6517
md"""##### Column-wise is $(round(Int, mmp))% faster than row-wise."""

# ╔═╡ c0b8dc5b-2f4b-400c-ba3f-6d315ca1038e
md"""
## Avoid copying data unecessarily

### When possible, use views when slicing.

$br

##### NumPy defaults to views
```
a = np.zeros(5)
b = a[1:3]
b += 2
print(a)  # returns [0 2 2 0 0]
```

##### Julia defaults to copies
```
a = zeros(5)
b = a[1:3]
b .+= 2
println(a)  # returns [0 0 0 0 0]
```

"""

# ╔═╡ bf5a4458-93bd-42ba-a0c0-0f975ceaea34
br

# ╔═╡ 9c8fb109-7abd-4e5d-a6d7-792f0774acee
md"### Operate in-place"

# ╔═╡ cc9cac18-c19c-459a-aa9f-f14ab64632c7
@views function mymulv(A, B)
	_, n  = size(A)
	C = similar(A)
	for j = 1:n
		C[:, j] .= A[:, j].*B[:, j]
	end
	return C
end

# ╔═╡ d77f8656-2b46-46fc-b1f9-e6440a1e9bf4
tinc = @benchmark mymulv($A, $B)

# ╔═╡ 28aed9c5-41bb-4762-b5d3-6e25259fc18c
@views function mymulv!(C, A, B)  # the bang ! signifies a mutating function
	_, n  = size(A)
	for j = 1:n
		C[:, j] .= A[:, j].*B[:, j]
	end
	return C
end

# ╔═╡ 1f532fff-0481-4810-9551-31d9398ba96c
C = similar(A);

# ╔═╡ 8fe865b9-7a44-48ba-8376-8a042a32c93b
tinp = @benchmark mymulv!($C, $A, $B)

# ╔═╡ 86f28fbe-1bbc-45dc-a1fb-f089ecde7093
md"##### In-place version is $(round(tinc.times[1]/tinp.times[1], digits=2))x faster."

# ╔═╡ f2aa4472-a3dd-41fc-b8ce-629e0e8cd71f
md"""
## Pre-allocate arrays

### Mutating array sizes takes time
"""

# ╔═╡ 4ac54663-0e54-4d2b-a8f0-4c91189f4537
function drawhand1(N)
	hand = []
	for n = 1:N
		push!(hand, rand((1:13)))
	end
	return hand
end

# ╔═╡ 6ae90fd4-0655-4c89-b145-3f517fc02f50
cont_any = @benchmark drawhand1($7)

# ╔═╡ ffb22986-48e1-420c-a0f3-1284cea1e85f
br

# ╔═╡ 174a7194-2944-4dfc-bd14-545aeae4fe55
md"#### And avoid abstract containers!"

# ╔═╡ 12faf247-4635-4875-b1ab-443b22c19196
function drawhand2(N)
	hand = Int[]
	for n = 1:N
		push!(hand, rand((1:13)))
	end
	return hand
end

# ╔═╡ ed67c601-16a3-4dbf-a0e9-fd06c8407f81
cont_int = @benchmark drawhand2($7)

# ╔═╡ 23db7332-9d88-445e-aecb-573911f003a0
function drawhand3(N)
	hand = Vector{Int}(undef, N)
	for n in eachindex(hand)
		hand[n] = rand((1:13))
	end
	return hand
end

# ╔═╡ 50527e4d-682d-40aa-b03a-df504065f899
cont_pre = @benchmark drawhand3($7)

# ╔═╡ 54c298f8-92b9-43bf-a18c-362007e98b7d
md"""
#### any = $(round(cont_any.times[1])) ns
#### int = $(round(cont_int.times[1])) ns
#### pre = $(round(cont_pre.times[1])) ns
"""

# ╔═╡ 7605a28e-d632-48b5-8b03-fe0f8c3b66eb
md"""
## Performance annotations

#### "Numba is an open source JIT compiler that translates a subset of Python and NumPy code into fast machine code."
#### Numba uses `@njit` for "just-in-time" compilation.

$br
#### ALL of Julia is JIT compiled.

#### Some examples from Julia
- `@simd` : Single Instruction, Multiple Dispatch
- `@inbounds` : Manually tell the compiler to avoid bounds checking on indices.
- `@fastmath` : Allow floating-point optimizations (results may be differ from IEEE values)
$br
"""

# ╔═╡ 69254f23-5349-4e99-9cdd-23183ad5404d
@noinline function inner(x, y)
    s = zero(eltype(x))
    for i = eachindex(x)
        @inbounds s += x[i]*y[i]
    end
    return s
end

# ╔═╡ 48597433-7a36-4c0e-af41-8ddb3c5db277
@noinline function innersimd(x, y)
    s = zero(eltype(x))
    @simd for i = eachindex(x)
        @inbounds s += x[i] * y[i]
    end
    return s
end

# ╔═╡ 8ae3a333-091f-4cc6-ab7d-52172336404e
xarr, yarr = randn(2048), randn(2048)

# ╔═╡ 75510369-5918-49dd-8c11-0e1140ef56ec
@benchmark inner($xarr, $yarr)  # Home computer - 1.6 μs

# ╔═╡ b5b886f2-84c7-46e1-9951-61a724864d0b
@benchmark innersimd($xarr, $yarr)  # home computer - 193 ns

# ╔═╡ def86580-9e79-4c59-8e25-d5a127f9a687
function timeit(n, reps)
    x = rand(Float32, n)
    y = rand(Float32, n)
    s = zero(Float64)
    time = @elapsed for j in 1:reps
        s += inner(x, y)
    end
    println("GFlop/sec        = ", round(2n*reps / time*1E-9, digits=1))
    time = @elapsed for j in 1:reps
        s += innersimd(x, y)
    end
    println("GFlop/sec (SIMD) = ", round(2n*reps / time*1E-9, digits=1))
end

# ╔═╡ 2e03ea56-1fc0-46ca-b04b-533a1cf1e0cf
@terminal timeit(1000, 1000)

# ╔═╡ 3def55ef-bfa8-491f-b4d9-4a51c75f8bf5
md"""## Vectorize?

### Python and R benefit from vectorization. 
"""

# ╔═╡ f1519cc1-4d8d-458e-947f-cbbdb4bdf82a
function conda_setup()
	with_terminal() do
		Conda.pip_interop(true)
		Conda.pip("install", "numpy")
	end
end

# ╔═╡ 19b23f6b-9c9c-4bc4-9b35-b33202dbfd94
conda_setup()

# ╔═╡ 86f536ec-b796-4384-93b8-d49aa0f9c9b3
begin
py"""
import timeit
import numpy as np

loopset = '''\
import numpy as np

a = np.zeros(100)

def loop(x):
	for i in range(100):
		x[i] = np.sin(i)
	return x
'''

vecset = '''\
import numpy as np

a = np.arange(100)

def vect(x):
    return np.sin(x)
'''


stmnt = '''f(a)'''

def times():
	loop_time = np.min(timeit.repeat('''loop(a)''', setup=loopset, number=1, repeat=1000))*1e6
	vec_time = np.min(timeit.repeat('''vect(a)''', setup=vecset, number=1, repeat=1000))*1e6

	return loop_time, vec_time

times()
"""
times = py"times"();
end

# ╔═╡ 1c351d88-15c8-420e-8391-263a59510d73
md"""
#### The `loop` takes $(round(times[1], digits=2)) μs.
#### The `vect` takes $(round(times[2], digits=2)) μs.
"""

# ╔═╡ 55175908-3256-41dc-8268-cbf37c159123
np = pyimport("numpy")

# ╔═╡ dd16b419-c2f9-4d52-9557-efc9ea52f68c
@benchmark np.sin($(collect(0:99)))

# ╔═╡ adc94746-34dd-4c2e-b5b4-5ca749ba2179
br

# ╔═╡ 419cda5b-2c02-4b8a-9061-52d2c9302314
md"### Julia loops are fast. No vectorization necessary."

# ╔═╡ d7315f87-09fd-4bdc-a0ff-7137740dd323
function foo()
	x = zeros(100)
	for i in eachindex(x)
		x[i] = sin(i)
	end
	return x
end

# ╔═╡ 6d1d57ae-82bc-473e-9da4-8e0f8827eb91
@benchmark foo()

# ╔═╡ 8b083abc-7234-4e7a-86c9-24ed41d53e5c
function bar()
	x = 1:100
	return sin.(x)
end

# ╔═╡ 22a2f880-b517-4771-8865-3dacdd7fcef3
@benchmark bar()

# ╔═╡ e2dbb7eb-f276-41a8-92eb-2b0e83274fca
md"### Note that the Julia loop version is STILL 2x faster than numpy vectorized version."

# ╔═╡ 1c0c5440-40c2-4eda-b1d9-5d7b19e3464e
md"""
## Parallelize Bottlenecks

### Parallelization may lead to significant speedups.
"""

# ╔═╡ 7ab2718c-2698-4163-b6b4-35e89ce9f470
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


# ╔═╡ 81e08ca5-8ad8-4358-892e-eb833057de8f
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

# ╔═╡ 341a36c1-df73-42bd-ab85-4e0edd076a1c
width = 600; height=450; maxiter=600

# ╔═╡ 864b3c20-4421-4c0d-9581-d0ba40fb6be0
Gray.((mandel(width=width, height=height, maxiter=maxiter).%maxiter)./100)

# ╔═╡ 80bc8a7f-aace-45e3-a6b4-d66e230beb12
br

# ╔═╡ 5b1a5fdb-c92e-436e-9f2e-68e6857edf3c
m = @benchmark mandel(width=width, height=height, maxiter=maxiter)

# ╔═╡ 2155050b-708d-4bf1-bbc8-5744461c291c
br

# ╔═╡ 0268ce78-240f-461a-a247-7e594c43a5d2
function mandelthread(; width=80, height=20, maxiter=80)
    out = zeros(Int, height, width)
    real = range(-2.0, 0.5, length=width)
    imag = range(-1.0, 1.0, length=height)*im
    @threads for x in 1:width
        for y in 1:height
            z = real[x] + imag[y]
            out[y,x] = escapetime(z, maxiter=maxiter)
        end
    end
    return out
end

# ╔═╡ ad4e69ab-0693-4a93-baef-4c30dac63468
mt = @benchmark mandelthread(width=width, height=height, maxiter=maxiter)

# ╔═╡ 0a298a61-edf5-401c-bdab-20b38cbb0204
br

# ╔═╡ f0fd40e2-3f36-4f9e-af2a-eccb01a206c0
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

# ╔═╡ 014a4163-f813-4061-8f70-494814e46209
ms = @benchmark mandelspawn(width=width, height=height, maxiter=maxiter)

# ╔═╡ 01c3e62e-2b69-456b-95a1-85aa3057ddff
md"
##### 1-thread: $(round(m.times[1]/1e6, digits=2)) ms
##### $(nthreads())-threads: $(round(mt.times[1]/1e6, digits=2)) ms
##### $(width*height)-tasks: $(round(ms.times[1]/1e6, digits=2)) ms
"

# ╔═╡ d7219e88-d097-465f-876d-2db9d694105a
md"""
## If all else fails, switch languages.
$br
### I recommend Julia.
"""

# ╔═╡ Cell order:
# ╠═e4f55578-9bb5-11eb-2848-c9331b681a62
# ╠═2e11c9de-677e-4a1d-b6e9-b87421ab4db9
# ╟─e7fdca5f-a467-4f17-b2e7-2b7365b58fe2
# ╟─98a65bee-c989-4edb-9f40-4c9962c94a8a
# ╟─e4c936b0-470f-4e3c-b8aa-09a6e0616d59
# ╟─ad8afc2c-60a5-43a9-9896-d1c2d4b653ed
# ╟─593bd30f-c2e3-4502-83d8-2d6ef298f65e
# ╠═9bc9ce04-4df3-4336-a412-867bf892489e
# ╠═6b305828-7991-4648-817c-36aa8b811f21
# ╠═2fdf8a93-f512-4dd5-9b5a-4f9e1216ca74
# ╠═33ba73d8-faea-4684-9d9a-bee9240fc699
# ╠═cada2776-9cfd-45ac-8c72-682fb70b0c11
# ╠═16f22b25-cd38-4546-b709-815848fbabed
# ╟─7dfef34c-7221-4055-8de4-46f71ad9d801
# ╟─095acdf2-74e8-458c-94fe-8c335460fa9b
# ╟─073390d5-0395-44f9-a5f4-f4dccc2a1a37
# ╟─a202c13e-e356-4b2d-aeac-f8b68ea4853d
# ╟─8e246e00-c3dd-4456-929e-3069f0940a7e
# ╠═2dd80ad1-7994-4c90-94c2-a159ce4a80ec
# ╠═eb2d1dee-b64c-4ff3-bbc9-c40b75926c72
# ╠═4561711e-7c55-458e-baf9-00d03c515f30
# ╠═4e87ab75-cdd5-471b-98de-79a36dfa9fd4
# ╠═84ed1cac-31f1-474e-801d-8da6bb069d53
# ╟─17d7e432-829e-4240-be80-2365cb31acfa
# ╠═cbd467ad-bdfc-4568-9ce8-cba4c6196ddf
# ╠═85ce8b95-237d-49ad-af48-b034faa2b74c
# ╠═ac7b61e6-afe0-4290-9492-6b29e4e312ad
# ╟─0451fba2-52e2-45d9-b005-9019fe5d16ce
# ╠═76746655-4479-4d45-b357-e9c49c5742ec
# ╠═5b2acdb5-0da7-4bf8-9270-d249ea258659
# ╟─951c9498-c080-48b7-bea7-b9b5e14a518a
# ╠═5932d739-4183-4936-a5ac-a4e82d9164d3
# ╠═52aba5be-b9c9-478a-8419-b52b3da1159c
# ╠═9342ed2f-aeb8-4cea-8603-f55b8a41bdfb
# ╟─a740d1b4-fc22-40a3-818d-fa1bab61cac7
# ╠═8121837a-20bb-4658-959e-8f9ce74ce99f
# ╠═2f2533f2-ccf5-4e1f-b6d2-21610b2f1f42
# ╠═90b1c976-44ed-44c2-8a3d-117146c8f8c1
# ╟─c36532c0-6de8-4a76-a93c-a06ea4c5073f
# ╟─ec44412f-f193-4f9a-b5b6-519895a1c0ab
# ╠═4eb7104a-5697-47df-a66e-1ba56e509e26
# ╠═57c5bf2e-4994-4e7a-9bba-1ba994e07246
# ╟─f43df4dd-0fc6-448b-af4c-318acb830421
# ╟─4af40bd1-10ff-4b3d-a0bc-9af1bc3bbde9
# ╟─9a45dfe2-6b90-4ad0-874b-046d896a9126
# ╟─577b843e-9cba-4133-a08c-47cec7efc840
# ╠═e6b6229e-3288-4e68-bd7f-539221d6ac83
# ╠═ae07a63f-147a-4ef5-a110-550a400162a6
# ╠═45e8c600-9e0d-4e6a-a15c-57a98ef06990
# ╠═a61c2e89-c3f1-409d-b647-66fae7e955bd
# ╠═234d3e51-6a6f-46d6-ad76-a8b3fe05ccc9
# ╟─e48bf258-fb6e-477a-94d0-ffde83d583be
# ╠═653409f1-ed1c-4353-bb46-6a212276d9ad
# ╠═b214f376-70cd-40a8-9a35-bebdd6b50f73
# ╠═1ba37d04-5887-4330-a3cd-1f199f312608
# ╠═c3906d8d-be04-4302-ad19-35ff3fb62606
# ╟─9332ee1e-60cf-48b2-8e26-17ff5b4cfcea
# ╟─3595bc98-54ef-49ea-80c3-87e2d35c80a2
# ╠═d34e66e4-71cc-474c-b7a3-ef32381f81d7
# ╠═eaa94938-fa80-4ea1-82ef-afaf3b8c0cf9
# ╟─ce37fb19-4625-4373-9002-7d82f6649aa5
# ╠═39ee1bdc-abc6-45dd-b47d-a58b37f835a3
# ╠═1b402d87-b739-4772-a770-63a5468c6769
# ╠═0890ab13-b5b8-4f85-a276-cfbb82fcbccf
# ╠═b486af2f-fadf-45f7-a642-eb6c3dec125b
# ╠═e5514dcd-acda-436f-b1a1-bf7dcd53599d
# ╠═c3375081-bfa3-4f3f-a723-e184d66ac662
# ╟─370d0e5d-7b8a-4cdd-b909-10d3b43f82ea
# ╟─4357ddfa-48f9-401f-8e5d-ebd8968f6517
# ╟─c0b8dc5b-2f4b-400c-ba3f-6d315ca1038e
# ╟─bf5a4458-93bd-42ba-a0c0-0f975ceaea34
# ╟─9c8fb109-7abd-4e5d-a6d7-792f0774acee
# ╠═cc9cac18-c19c-459a-aa9f-f14ab64632c7
# ╠═d77f8656-2b46-46fc-b1f9-e6440a1e9bf4
# ╠═28aed9c5-41bb-4762-b5d3-6e25259fc18c
# ╠═1f532fff-0481-4810-9551-31d9398ba96c
# ╠═8fe865b9-7a44-48ba-8376-8a042a32c93b
# ╟─86f28fbe-1bbc-45dc-a1fb-f089ecde7093
# ╟─f2aa4472-a3dd-41fc-b8ce-629e0e8cd71f
# ╠═4ac54663-0e54-4d2b-a8f0-4c91189f4537
# ╠═6ae90fd4-0655-4c89-b145-3f517fc02f50
# ╟─ffb22986-48e1-420c-a0f3-1284cea1e85f
# ╟─174a7194-2944-4dfc-bd14-545aeae4fe55
# ╠═12faf247-4635-4875-b1ab-443b22c19196
# ╠═ed67c601-16a3-4dbf-a0e9-fd06c8407f81
# ╠═23db7332-9d88-445e-aecb-573911f003a0
# ╠═50527e4d-682d-40aa-b03a-df504065f899
# ╟─54c298f8-92b9-43bf-a18c-362007e98b7d
# ╟─7605a28e-d632-48b5-8b03-fe0f8c3b66eb
# ╠═69254f23-5349-4e99-9cdd-23183ad5404d
# ╠═48597433-7a36-4c0e-af41-8ddb3c5db277
# ╠═8ae3a333-091f-4cc6-ab7d-52172336404e
# ╠═75510369-5918-49dd-8c11-0e1140ef56ec
# ╠═b5b886f2-84c7-46e1-9951-61a724864d0b
# ╠═def86580-9e79-4c59-8e25-d5a127f9a687
# ╠═2e03ea56-1fc0-46ca-b04b-533a1cf1e0cf
# ╟─3def55ef-bfa8-491f-b4d9-4a51c75f8bf5
# ╠═a7bd375e-14e9-4971-85b0-a8f49447cc98
# ╠═f1519cc1-4d8d-458e-947f-cbbdb4bdf82a
# ╠═19b23f6b-9c9c-4bc4-9b35-b33202dbfd94
# ╠═1ba28924-33dc-458c-96f1-80db64563e15
# ╠═86f536ec-b796-4384-93b8-d49aa0f9c9b3
# ╟─1c351d88-15c8-420e-8391-263a59510d73
# ╠═55175908-3256-41dc-8268-cbf37c159123
# ╠═dd16b419-c2f9-4d52-9557-efc9ea52f68c
# ╟─adc94746-34dd-4c2e-b5b4-5ca749ba2179
# ╟─419cda5b-2c02-4b8a-9061-52d2c9302314
# ╠═d7315f87-09fd-4bdc-a0ff-7137740dd323
# ╠═6d1d57ae-82bc-473e-9da4-8e0f8827eb91
# ╠═8b083abc-7234-4e7a-86c9-24ed41d53e5c
# ╠═22a2f880-b517-4771-8865-3dacdd7fcef3
# ╟─e2dbb7eb-f276-41a8-92eb-2b0e83274fca
# ╟─1c0c5440-40c2-4eda-b1d9-5d7b19e3464e
# ╠═e16506f2-fea3-4678-b95f-3d78da5c7193
# ╠═7ab2718c-2698-4163-b6b4-35e89ce9f470
# ╠═81e08ca5-8ad8-4358-892e-eb833057de8f
# ╠═341a36c1-df73-42bd-ab85-4e0edd076a1c
# ╠═2d6cce0d-cf01-4065-8a90-b35f5135ae34
# ╠═864b3c20-4421-4c0d-9581-d0ba40fb6be0
# ╟─80bc8a7f-aace-45e3-a6b4-d66e230beb12
# ╠═5b1a5fdb-c92e-436e-9f2e-68e6857edf3c
# ╟─2155050b-708d-4bf1-bbc8-5744461c291c
# ╠═0268ce78-240f-461a-a247-7e594c43a5d2
# ╠═ad4e69ab-0693-4a93-baef-4c30dac63468
# ╟─0a298a61-edf5-401c-bdab-20b38cbb0204
# ╠═f0fd40e2-3f36-4f9e-af2a-eccb01a206c0
# ╠═014a4163-f813-4061-8f70-494814e46209
# ╟─01c3e62e-2b69-456b-95a1-85aa3057ddff
# ╟─d7219e88-d097-465f-876d-2db9d694105a

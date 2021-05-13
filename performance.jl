### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ e4f55578-9bb5-11eb-2848-c9331b681a62
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["BenchmarkTools", "FFTW", "PlutoUI", "Plots", "Profile", "PyCall"])
end

# ╔═╡ 9bc9ce04-4df3-4336-a412-867bf892489e
using BenchmarkTools, Profile

# ╔═╡ f9eab5cd-258d-4e6c-95bf-8d3f974e76bc
using PlutoUI

# ╔═╡ 8245472b-df47-408a-a2c1-12dddc271eb6
using LinearAlgebra

# ╔═╡ d3f56a61-2745-4e85-8a10-9e2bb027b309
using Plots

# ╔═╡ 1ba28924-33dc-458c-96f1-80db64563e15
using PyCall

# ╔═╡ 2e11c9de-677e-4a1d-b6e9-b87421ab4db9
br = HTML("<br>");  # Add a semi-colon to block the output

# ╔═╡ 6e1c9346-72ac-476a-80bc-a68f52cad0c5
function printit(val)
	io = IOBuffer()
	print(io, val)
	String(take!(io))
end

# ╔═╡ e7fdca5f-a467-4f17-b2e7-2b7365b58fe2
html"<button onclick=present()>Present</button>"

# ╔═╡ 98a65bee-c989-4edb-9f40-4c9962c94a8a
md"""
# Programming for Performance
### Tips and tricks for writing fast code
$br
[https://docs.julialang.org/en/v1/manual/performance-tips/](https://docs.julialang.org/en/v1/manual/performance-tips/)

[Performance Benchmarking in Julia (YouTube)](https://www.youtube.com/watch?v=_yzYLTYZ4eQ)
"""

# ╔═╡ ad8afc2c-60a5-43a9-9896-d1c2d4b653ed
md"""## Measure performance with tools

### Code introspection can find performance bottlenecks.

#### Examples:
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

# ╔═╡ 6b305828-7991-4648-817c-36aa8b811f21
function extend_mat(M::AbstractMatrix, i, j)
	rows, cols = size(M)

	return M[(1 ≤ i ≤ rows) ? i : ((i < 1) ? 1 : rows),
		     (1 ≤ j ≤ cols) ? j : ((j < 1) ? 1 : cols)]
end

# ╔═╡ 2fdf8a93-f512-4dd5-9b5a-4f9e1216ca74
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
image = rand(100, 100)

# ╔═╡ cada2776-9cfd-45ac-8c72-682fb70b0c11
kernel = ones(3,3)/9

# ╔═╡ 16f22b25-cd38-4546-b709-815848fbabed
@benchmark convolve_image($image, $kernel)

# ╔═╡ 095acdf2-74e8-458c-94fe-8c335460fa9b
md"""
### Note on benchmark times:

##### There __IS__ a minimum runtime for a given function.
##### There __IS NOT__ a maximum runtime for a given function.

##### Therefore, the __minimum__ and __median__ times are most accurate for comparison.
"""

# ╔═╡ cab6e9be-ae86-4915-b90e-afc78d9f748a
with_terminal() do
    Profile.print()
end

# ╔═╡ 951c9498-c080-48b7-bea7-b9b5e14a518a
md"""
## Avoid Global Variables

### Compilers cannot optimize mutable global variables.

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

# ╔═╡ ec71a636-66c6-484e-bb0b-19744160ec4f
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
md"##### global is $(round(logt.times[1]/loct.times[1], digits=2))x slower than const."

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
md"##### var to const ratio is $(round(lovt.times[1]/loct.times[1], digits=4))."

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

# ╔═╡ 72f73fce-4e72-4979-bfe0-c93a0caabcd0
with_terminal() do 
	println(@code_warntype pos1(1.0))
end

# ╔═╡ b1567924-6511-4f38-810d-edb2fc41247d
with_terminal() do 
	println(@code_warntype pos2(-1.0))
end

# ╔═╡ 653409f1-ed1c-4353-bb46-6a212276d9ad
function posrand(N)
	xs = randn(N)
	for i in eachindex(xs)
		xs[i] = pos2(xs[i])
	end
	return xs
end

# ╔═╡ 1ba37d04-5887-4330-a3cd-1f199f312608
@benchmark posrand($10_000)

# ╔═╡ 9332ee1e-60cf-48b2-8e26-17ff5b4cfcea
75.216e-6/33.958e-6

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

# ╔═╡ b735ede5-e6d4-48e6-9990-e73a117f6e79
@benchmark mynorm($rand(50, 50))

# ╔═╡ 08728955-3782-46f6-bce1-1ebb1f4db41c
@benchmark othernorm($rand(50, 50))

# ╔═╡ ce37fb19-4625-4373-9002-7d82f6649aa5
md"""## Pay attention to memory access order

### Is your language of choice row- or column-major?

#### Row-major: C/C++, Pascal, NumPy*
#### Column-major: FORTAN, Julia, MATLAB, R
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

# ╔═╡ b486af2f-fadf-45f7-a642-eb6c3dec125b
A = B = rand(100, 100);

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

### Use views for slicing rather than copying data.


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

# ╔═╡ cc9cac18-c19c-459a-aa9f-f14ab64632c7
@views function mymulv(A, B)
	m, n  = size(A)
	C = similar(A)
	for j = 1:n
		C[:, j] .= A[:, j].*B[:, j]
	end
	return C
end

# ╔═╡ d77f8656-2b46-46fc-b1f9-e6440a1e9bf4
@benchmark mymulv($A, $B)

# ╔═╡ 6973d80c-a076-44e1-85e5-68aab6ab7a18
md"### Separate kernel functions"

# ╔═╡ 28aed9c5-41bb-4762-b5d3-6e25259fc18c
@views function mymulv!(C, A, B)
	_, n  = size(A)
	for j = 1:n
		C[:, j] .= A[:, j].*B[:, j]
	end
	return C
end

# ╔═╡ 1f532fff-0481-4810-9551-31d9398ba96c
C = similar(A);

# ╔═╡ 8fe865b9-7a44-48ba-8376-8a042a32c93b
@benchmark mymulv!($C, $A, $B)

# ╔═╡ f2aa4472-a3dd-41fc-b8ce-629e0e8cd71f
md"""
## Pre-allocate arrays

### Functions can be faster for static array sizes.
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
@benchmark drawhand1($7)

# ╔═╡ 174a7194-2944-4dfc-bd14-545aeae4fe55
md"##### And avoid abstract containers!"

# ╔═╡ 12faf247-4635-4875-b1ab-443b22c19196
function drawhand2(N)
	hand = Int[]
	for n = 1:N
		push!(hand, rand((1:13)))
	end
	return hand
end

# ╔═╡ ed67c601-16a3-4dbf-a0e9-fd06c8407f81
@benchmark drawhand2($10_000)

# ╔═╡ 23db7332-9d88-445e-aecb-573911f003a0
function drawhand3(N)
	hand = Vector{Int}(undef, N)
	for n in eachindex(hand)
		hand[n] = rand((1:13))
	end
	return hand
end

# ╔═╡ 50527e4d-682d-40aa-b03a-df504065f899
@benchmark drawhand3($10_000)

# ╔═╡ 7605a28e-d632-48b5-8b03-fe0f8c3b66eb
md"""
## Performance annotations

### Annotations can greatly speed up code. 

#### Some examples from Julia
- `@simd` : Single Instruction, Multiple Dispatch
- `@inbounds` : Manually tell the compiler to avoid bounds checking on indices.
- `@fastmath` : Allow floating-point optimizations (may be different from IEEE values)
$br
#### Python package Numba uses `@jit` to "just-in-time" compile code (Julia's speed derives from JIT compilation).
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
@benchmark inner($xarr, $yarr)

# ╔═╡ b5b886f2-84c7-46e1-9951-61a724864d0b
@benchmark innersimd($xarr, $yarr)

# ╔═╡ ca15416c-a428-4867-8355-b9f254dd3c41
function gflops(n, reps)
    x = rand(Float32, n)
    y = rand(Float32, n)
    s = zero(Float64)
    time1 = @elapsed for j in 1:reps
        s += inner(x, y)
    end

	return 2n*reps / time1*1E-9
end

# ╔═╡ 62fe8831-b642-4320-9750-8dbb2c7d2fbf
function gflopssimd(n, reps)
    x = rand(Float32, n)
    y = rand(Float32, n)
    s = zero(Float64)

	time2 = @elapsed for j in 1:reps
        s += innersimd(x, y)
    end
	return 2n*reps / time2*1E-9
end

# ╔═╡ 052bfbb7-18ae-4a9a-86c2-a07f30dbcfbe
xs = [n for n = 8:32:32*64]

# ╔═╡ 2189672f-49d3-4731-96bc-f09c3c1495fa
repeat = 2000

# ╔═╡ affebc0d-b011-4d88-8cfd-b27980d10415
ys = gflops.(xs, repeat)

# ╔═╡ d1e9259e-d214-4fe4-bc86-faa86344238b
zs = gflopssimd.(xs, repeat)

# ╔═╡ d6de32e4-92d3-4003-9d18-44bb0fd5cce0
begin
	plot(xs, ys, label="no simd", xlabel="Array length", ylabel="GFLOPS", leg=:topleft)
	plot!(xs, zs, label="simd")
end

# ╔═╡ 3def55ef-bfa8-491f-b4d9-4a51c75f8bf5
md"""## Vectorize?

### Python and R benefit from vectorization. 
"""

# ╔═╡ 2030c580-b273-4b69-8eea-69e281ead650
begin 
py"""
import numpy as np

def loop():
	x = np.zeros(100)
	for i in range(100):
		x[i] = np.sin(i)
	return x
"""
@benchmark py"loop"()  # Done within Python: 94 μs
end

# ╔═╡ 8e8fa211-c750-4dac-ab08-5226382b1880
begin 
py"""
import numpy as np

def bar():
	return np.sin(range(100))
"""
@benchmark py"bar"()  # Done within Python: 1.54 μs
end

# ╔═╡ 55175908-3256-41dc-8268-cbf37c159123
np = pyimport("numpy")

# ╔═╡ dd16b419-c2f9-4d52-9557-efc9ea52f68c
@benchmark np.sin($(collect(1:100)))

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

# ╔═╡ Cell order:
# ╠═e4f55578-9bb5-11eb-2848-c9331b681a62
# ╠═2e11c9de-677e-4a1d-b6e9-b87421ab4db9
# ╠═6e1c9346-72ac-476a-80bc-a68f52cad0c5
# ╟─e7fdca5f-a467-4f17-b2e7-2b7365b58fe2
# ╟─98a65bee-c989-4edb-9f40-4c9962c94a8a
# ╟─ad8afc2c-60a5-43a9-9896-d1c2d4b653ed
# ╠═9bc9ce04-4df3-4336-a412-867bf892489e
# ╠═6b305828-7991-4648-817c-36aa8b811f21
# ╠═2fdf8a93-f512-4dd5-9b5a-4f9e1216ca74
# ╠═33ba73d8-faea-4684-9d9a-bee9240fc699
# ╠═cada2776-9cfd-45ac-8c72-682fb70b0c11
# ╠═16f22b25-cd38-4546-b709-815848fbabed
# ╟─095acdf2-74e8-458c-94fe-8c335460fa9b
# ╠═f9eab5cd-258d-4e6c-95bf-8d3f974e76bc
# ╠═cab6e9be-ae86-4915-b90e-afc78d9f748a
# ╟─951c9498-c080-48b7-bea7-b9b5e14a518a
# ╠═5932d739-4183-4936-a5ac-a4e82d9164d3
# ╠═52aba5be-b9c9-478a-8419-b52b3da1159c
# ╠═9342ed2f-aeb8-4cea-8603-f55b8a41bdfb
# ╠═2f2533f2-ccf5-4e1f-b6d2-21610b2f1f42
# ╠═ec71a636-66c6-484e-bb0b-19744160ec4f
# ╠═90b1c976-44ed-44c2-8a3d-117146c8f8c1
# ╟─c36532c0-6de8-4a76-a93c-a06ea4c5073f
# ╠═4eb7104a-5697-47df-a66e-1ba56e509e26
# ╠═57c5bf2e-4994-4e7a-9bba-1ba994e07246
# ╟─f43df4dd-0fc6-448b-af4c-318acb830421
# ╟─4af40bd1-10ff-4b3d-a0bc-9af1bc3bbde9
# ╟─9a45dfe2-6b90-4ad0-874b-046d896a9126
# ╟─577b843e-9cba-4133-a08c-47cec7efc840
# ╠═e6b6229e-3288-4e68-bd7f-539221d6ac83
# ╠═ae07a63f-147a-4ef5-a110-550a400162a6
# ╠═72f73fce-4e72-4979-bfe0-c93a0caabcd0
# ╠═b1567924-6511-4f38-810d-edb2fc41247d
# ╠═653409f1-ed1c-4353-bb46-6a212276d9ad
# ╠═1ba37d04-5887-4330-a3cd-1f199f312608
# ╠═9332ee1e-60cf-48b2-8e26-17ff5b4cfcea
# ╟─3595bc98-54ef-49ea-80c3-87e2d35c80a2
# ╠═8245472b-df47-408a-a2c1-12dddc271eb6
# ╠═d34e66e4-71cc-474c-b7a3-ef32381f81d7
# ╠═eaa94938-fa80-4ea1-82ef-afaf3b8c0cf9
# ╠═b735ede5-e6d4-48e6-9990-e73a117f6e79
# ╠═08728955-3782-46f6-bce1-1ebb1f4db41c
# ╟─ce37fb19-4625-4373-9002-7d82f6649aa5
# ╠═39ee1bdc-abc6-45dd-b47d-a58b37f835a3
# ╠═1b402d87-b739-4772-a770-63a5468c6769
# ╠═b486af2f-fadf-45f7-a642-eb6c3dec125b
# ╠═e5514dcd-acda-436f-b1a1-bf7dcd53599d
# ╠═c3375081-bfa3-4f3f-a723-e184d66ac662
# ╟─370d0e5d-7b8a-4cdd-b909-10d3b43f82ea
# ╟─4357ddfa-48f9-401f-8e5d-ebd8968f6517
# ╟─c0b8dc5b-2f4b-400c-ba3f-6d315ca1038e
# ╠═cc9cac18-c19c-459a-aa9f-f14ab64632c7
# ╠═d77f8656-2b46-46fc-b1f9-e6440a1e9bf4
# ╟─6973d80c-a076-44e1-85e5-68aab6ab7a18
# ╠═28aed9c5-41bb-4762-b5d3-6e25259fc18c
# ╠═1f532fff-0481-4810-9551-31d9398ba96c
# ╠═8fe865b9-7a44-48ba-8376-8a042a32c93b
# ╟─f2aa4472-a3dd-41fc-b8ce-629e0e8cd71f
# ╠═4ac54663-0e54-4d2b-a8f0-4c91189f4537
# ╠═6ae90fd4-0655-4c89-b145-3f517fc02f50
# ╟─174a7194-2944-4dfc-bd14-545aeae4fe55
# ╠═12faf247-4635-4875-b1ab-443b22c19196
# ╠═ed67c601-16a3-4dbf-a0e9-fd06c8407f81
# ╠═23db7332-9d88-445e-aecb-573911f003a0
# ╠═50527e4d-682d-40aa-b03a-df504065f899
# ╟─7605a28e-d632-48b5-8b03-fe0f8c3b66eb
# ╠═69254f23-5349-4e99-9cdd-23183ad5404d
# ╠═48597433-7a36-4c0e-af41-8ddb3c5db277
# ╠═8ae3a333-091f-4cc6-ab7d-52172336404e
# ╠═75510369-5918-49dd-8c11-0e1140ef56ec
# ╠═b5b886f2-84c7-46e1-9951-61a724864d0b
# ╠═ca15416c-a428-4867-8355-b9f254dd3c41
# ╠═62fe8831-b642-4320-9750-8dbb2c7d2fbf
# ╠═052bfbb7-18ae-4a9a-86c2-a07f30dbcfbe
# ╠═2189672f-49d3-4731-96bc-f09c3c1495fa
# ╠═affebc0d-b011-4d88-8cfd-b27980d10415
# ╠═d1e9259e-d214-4fe4-bc86-faa86344238b
# ╠═d3f56a61-2745-4e85-8a10-9e2bb027b309
# ╟─d6de32e4-92d3-4003-9d18-44bb0fd5cce0
# ╟─3def55ef-bfa8-491f-b4d9-4a51c75f8bf5
# ╠═1ba28924-33dc-458c-96f1-80db64563e15
# ╠═2030c580-b273-4b69-8eea-69e281ead650
# ╠═8e8fa211-c750-4dac-ab08-5226382b1880
# ╠═55175908-3256-41dc-8268-cbf37c159123
# ╠═dd16b419-c2f9-4d52-9557-efc9ea52f68c
# ╠═419cda5b-2c02-4b8a-9061-52d2c9302314
# ╠═d7315f87-09fd-4bdc-a0ff-7137740dd323
# ╠═6d1d57ae-82bc-473e-9da4-8e0f8827eb91
# ╠═8b083abc-7234-4e7a-86c9-24ed41d53e5c
# ╠═22a2f880-b517-4771-8865-3dacdd7fcef3

### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 6cfadfea-3fa1-11eb-3530-438864914f83
begin
	# Import the package manager
	import Pkg
	# Activate the temporary environment
	Pkg.activate(mktempdir())
	# Add the packages (downloading them if necessary)
	Pkg.add(["LaTeXStrings", "UnicodePlots"])
	# Load the packages
	using LaTeXStrings, PlutoUI, UnicodePlots
end

# ╔═╡ 93eb7a90-3f8f-11eb-3768-7d5f91009790
html"<button onclick=present()>Present</button>"

# ╔═╡ e9e5a2b6-3f9b-11eb-0118-616e81cfbf81
md"""
# Hello! Bonjour! Hola! 

### Hit the button above to enter presenation mode!

"""

# ╔═╡ 1c30e3a2-3fa1-11eb-3194-1f6670d9f7c6
md"""### Then use the arrows in the lower right to navigate pages."""

# ╔═╡ c26ca968-3f9c-11eb-3354-65af5e81b59c
md"""
## Presentation mode is easy!

### All it does is add extra white space to separate cells IF AND ONLY IF markdown title headings one and two are used.

### Markdown heading one code looks like this:
	
	md"# My Big Title"

### Markdown heading two code looks like this:

	md"## My Medium Title"
"""

# ╔═╡ bc4d34e0-3fa0-11eb-223d-09f004f40991
md"## Large breaks can also be added using this big of code"

# ╔═╡ cf0faa90-3fa0-11eb-077d-b1a2e7a9ddfc
br = HTML("<br>")  # Add a semi-colon to block the output

# ╔═╡ 8f173574-5a6a-11eb-2d37-4fee7981c2d4
br

# ╔═╡ a5e28446-5a6a-11eb-3532-03a8419a2fcd
br

# ╔═╡ 97439f4a-5a6a-11eb-3440-c77c7c9c0003
br

# ╔═╡ 9907544a-5a6a-11eb-0129-393de4a58886
br

# ╔═╡ 9cef13a4-5a6a-11eb-1b57-77919f4e4cd7
br

# ╔═╡ 9f47aa44-5a6a-11eb-2b7a-635f0121ba74
br

# ╔═╡ a2143b66-5a6a-11eb-2b49-73cb27ee8964
br

# ╔═╡ dfc3e0ec-3fa0-11eb-357a-59e1fb6c60f7
md"### Then just type `br` to insert a space in between code blocks.
"

# ╔═╡ d93ded60-3fa0-11eb-0fe2-2f750c480b4e
br

# ╔═╡ 0267753a-3fa1-11eb-2a3a-b1aff4596858
md"### Easy!"

# ╔═╡ 36ec7634-3fa1-11eb-08a6-932e92613c09
md"## Setting up a temporary environment"

# ╔═╡ 49534924-3fa1-11eb-3945-59261dc1fba1
md"### This next little bit of code sets up a new environment, adds packages, and loads them."

# ╔═╡ cb5036f6-3fa1-11eb-3664-7938b880f251
L"""
\text{Yay! Now I\ have fancy } \LaTeX! \text{ Look what I can do}!
"""

# ╔═╡ 6ca9c01c-5a6b-11eb-2f43-d9dabb105f1e
md"**NOTE**: Multiple lines must be wrapped in a function or block."

# ╔═╡ 5a9d3ec8-3fa2-11eb-2c41-c9f4bbd9dc95
L"""
\mathcal{P}(A|B) = \frac{\mathcal{P}(B|A) \times \mathcal{P}{(A)}}{\mathcal{P}(B)}
"""

# ╔═╡ c1826d5c-3fa2-11eb-2f9e-39da3fbb4191
md"""$\text{This is a fun one:}$

$B(\lambda, T) = \frac{2 h c^2}{\lambda^5} \frac{1}{e^{\frac{h c}{\lambda k_B T}} - 1}$
"""

# ╔═╡ 472b155c-5a6b-11eb-2bda-6721369df3f1
md"## Let's plot it!"

# ╔═╡ 015ab8a6-5a6c-11eb-0954-8d5ee5fe3232
md"""
$B(\lambda, T) = \frac{2 h c^2}{\lambda^5} \frac{1}{e^{\frac{h c}{\lambda k_B T}} - 1}$
"""

# ╔═╡ 715a9f32-3fa4-11eb-1cb7-eb104abdfa6b
const h = 6.626e-34

# ╔═╡ a5e49d16-3fa4-11eb-2661-2385ba2cfa3c
const c = 299_792_458.0

# ╔═╡ 13f9ea36-3fa5-11eb-295a-b748e095b188
const k = 1.380649e-23 

# ╔═╡ 5d832150-3fa4-11eb-1a0a-510cd3bf40ab
B(λ, T) = (2.0*h*c^2)/(λ^5) * (ℯ^((h*c)/(λ*k*T)) - 1.0)^(-1)

# ╔═╡ 0b477eb2-3fb4-11eb-381c-8f0697d331c1
B(λ::Array{S, 1} where S <: Real, T::Real) = [(2.0*h*c^2)/(λₙ^5) * (ℯ^((h*c)/(λₙ*k*T)) - 1.0)^(-1) for λₙ in λ]

# ╔═╡ 625e4f60-3fb3-11eb-304e-6dad87c0e279
typeof([1, 3, 5])

# ╔═╡ 8723a768-3fa5-11eb-1d73-f925f8715446
B(4, 400)

# ╔═╡ cd03825e-3fb3-11eb-066f-e1be18fb3f62
B([1,2,3,4,5], 2000)

# ╔═╡ 30e9cdf2-5a6c-11eb-2f74-73c7cfa2e2f3
T = 3000.0  # Temperature of blackbody, in Kelvin

# ╔═╡ 282a717e-5a6c-11eb-18c9-dbea62116003
δ = 1.0e-4

# ╔═╡ 9d37fe0a-5a6c-11eb-0df3-17be21aca9cc
Ts = 3000:100:6000

# ╔═╡ a02c8e5a-5a6c-11eb-37e2-fd0f7b90ddf0
typeof(Ts)

# ╔═╡ c353a0ee-3fb4-11eb-39a2-618ccb1e6654
x = collect(δ:δ:10)

# ╔═╡ c3a52ffa-3fa9-11eb-13a1-c3cb6a308269
md"""
`T = `$(@bind ind Slider(1:length(Ts)))
"""

# ╔═╡ 57e087d6-3fa6-11eb-2036-d7c75208be09
plts = [lineplot(x, B(x.*1.0e-6, Ts[i]), title = "Planck Function: T = $(Ts[ind]) K", name=T, xlim=[0, 5], xlabel = "Wavelength (μm)", ylim = [0, 1e13], ylabel="Spectral Radiance") for i = 1:length(Ts)];

# ╔═╡ c257e374-3fb4-11eb-34af-31e56de36eb5
plts[ind]

# ╔═╡ Cell order:
# ╟─93eb7a90-3f8f-11eb-3768-7d5f91009790
# ╟─e9e5a2b6-3f9b-11eb-0118-616e81cfbf81
# ╟─1c30e3a2-3fa1-11eb-3194-1f6670d9f7c6
# ╟─8f173574-5a6a-11eb-2d37-4fee7981c2d4
# ╟─a5e28446-5a6a-11eb-3532-03a8419a2fcd
# ╟─97439f4a-5a6a-11eb-3440-c77c7c9c0003
# ╟─9907544a-5a6a-11eb-0129-393de4a58886
# ╟─9cef13a4-5a6a-11eb-1b57-77919f4e4cd7
# ╟─9f47aa44-5a6a-11eb-2b7a-635f0121ba74
# ╟─a2143b66-5a6a-11eb-2b49-73cb27ee8964
# ╟─c26ca968-3f9c-11eb-3354-65af5e81b59c
# ╟─bc4d34e0-3fa0-11eb-223d-09f004f40991
# ╠═cf0faa90-3fa0-11eb-077d-b1a2e7a9ddfc
# ╟─dfc3e0ec-3fa0-11eb-357a-59e1fb6c60f7
# ╠═d93ded60-3fa0-11eb-0fe2-2f750c480b4e
# ╟─0267753a-3fa1-11eb-2a3a-b1aff4596858
# ╟─36ec7634-3fa1-11eb-08a6-932e92613c09
# ╟─49534924-3fa1-11eb-3945-59261dc1fba1
# ╠═6cfadfea-3fa1-11eb-3530-438864914f83
# ╟─cb5036f6-3fa1-11eb-3664-7938b880f251
# ╟─6ca9c01c-5a6b-11eb-2f43-d9dabb105f1e
# ╟─5a9d3ec8-3fa2-11eb-2c41-c9f4bbd9dc95
# ╟─c1826d5c-3fa2-11eb-2f9e-39da3fbb4191
# ╟─472b155c-5a6b-11eb-2bda-6721369df3f1
# ╟─015ab8a6-5a6c-11eb-0954-8d5ee5fe3232
# ╠═715a9f32-3fa4-11eb-1cb7-eb104abdfa6b
# ╠═a5e49d16-3fa4-11eb-2661-2385ba2cfa3c
# ╠═13f9ea36-3fa5-11eb-295a-b748e095b188
# ╠═5d832150-3fa4-11eb-1a0a-510cd3bf40ab
# ╠═0b477eb2-3fb4-11eb-381c-8f0697d331c1
# ╠═625e4f60-3fb3-11eb-304e-6dad87c0e279
# ╠═8723a768-3fa5-11eb-1d73-f925f8715446
# ╠═cd03825e-3fb3-11eb-066f-e1be18fb3f62
# ╠═30e9cdf2-5a6c-11eb-2f74-73c7cfa2e2f3
# ╠═282a717e-5a6c-11eb-18c9-dbea62116003
# ╠═9d37fe0a-5a6c-11eb-0df3-17be21aca9cc
# ╠═a02c8e5a-5a6c-11eb-37e2-fd0f7b90ddf0
# ╠═c353a0ee-3fb4-11eb-39a2-618ccb1e6654
# ╟─c3a52ffa-3fa9-11eb-13a1-c3cb6a308269
# ╠═c257e374-3fb4-11eb-34af-31e56de36eb5
# ╠═57e087d6-3fa6-11eb-2036-d7c75208be09

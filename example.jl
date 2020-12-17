### A Pluto.jl notebook ###
# v0.12.17

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
md"### Then use the arrows in the lower right to navigate pages."

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
br = HTML("<br>");

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
md"### This next little bit of code instantiates a new environment, adds the packages, and loads up for us to use"

# ╔═╡ cb5036f6-3fa1-11eb-3664-7938b880f251
L"""
\text{Yay! Now I\ have fancy } \LaTeX! \text{ Look what I can do}!
"""

# ╔═╡ 5a9d3ec8-3fa2-11eb-2c41-c9f4bbd9dc95
L"""
\mathcal{P}(A|B) = \frac{\mathcal{P}(B|A) \times \mathcal{P}{(A)}}{\mathcal{P}(B)}
"""

# ╔═╡ c1826d5c-3fa2-11eb-2f9e-39da3fbb4191
md"""$\text{This is a fun one:}$

$B(\lambda, T) = \frac{2 h c^2}{\lambda^5} \frac{1}{e^{\frac{h c}{\lambda k_B T}} - 1}$

$\text{Let's plot it!}$
"""

# ╔═╡ f74dbc38-3fa3-11eb-2372-37dd294ad846
br

# ╔═╡ 37190530-4075-11eb-1142-69cec1fcc194
md"## Blackbody emission at various temperatures"

# ╔═╡ 2ed78680-4075-11eb-09ee-dfaaae932b35
md"## And here's the code"

# ╔═╡ 8741cd80-4075-11eb-3e36-8179bb0743f1
md"### Define constants"

# ╔═╡ 51dafef0-4075-11eb-3b23-7f8df0595e31
begin
	const h = 6.626e-34
	const c = 299_792_458.0
	const k = 1.380649e-23 
end

# ╔═╡ 74a19570-4075-11eb-26bc-adc983bc0f66
md"### Define first method to work with single values."

# ╔═╡ 5d832150-3fa4-11eb-1a0a-510cd3bf40ab
B(λ::Real, T::Real) = (2.0*h*c^2)/(λ^5) * (ℯ^((h*c)/(λ*k*T)) - 1.0)^(-1)

# ╔═╡ 9c661860-4075-11eb-1e18-ddd47b4a5e56
md"### Define second method to work with arrays of wavelength values."

# ╔═╡ 0b477eb2-3fb4-11eb-381c-8f0697d331c1
B(λ::Array{S, 1} where S <: Real, T::Real) = [(2.0*h*c^2)/(λₙ^5) * (ℯ^((h*c)/(λₙ*k*T)) - 1.0)^(-1) for λₙ in λ]

# ╔═╡ e66ee270-4075-11eb-38cb-7f4088093eaf
# Quick test
B(4, 400)

# ╔═╡ 19390d20-4076-11eb-1260-1b1c1d4eeae8
B([1,2,3,4,5], 2000)

# ╔═╡ c5cdc400-4075-11eb-3b8d-57e109398d53
begin
	# Use base units of microns
	δ = 1.0e-4  # wavelength δ to sample
	T = 3000.0;
	x = collect(δ:δ:10)
	Ts = collect(3000:100:6000)
end

# ╔═╡ 21e85e3e-4075-11eb-2688-9919d6dc6cfb
md"""
`T = `$(@bind ind Slider(1:length(Ts)))
"""

# ╔═╡ 57e087d6-3fa6-11eb-2036-d7c75208be09
plts = [lineplot(x, B(x.*1.0e-6, Ts[i]), title = "Planck Function: T = $(Ts[ind]) K", name=T, xlim=[0, 5], xlabel = "Wavelength (μm)", ylim = [0, 1e13], ylabel="Spectral Radiance") for i = 1:length(Ts)];

# ╔═╡ 1b119320-4075-11eb-1902-39c50540367d
plts[ind]

# ╔═╡ Cell order:
# ╟─93eb7a90-3f8f-11eb-3768-7d5f91009790
# ╟─e9e5a2b6-3f9b-11eb-0118-616e81cfbf81
# ╟─1c30e3a2-3fa1-11eb-3194-1f6670d9f7c6
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
# ╟─5a9d3ec8-3fa2-11eb-2c41-c9f4bbd9dc95
# ╟─c1826d5c-3fa2-11eb-2f9e-39da3fbb4191
# ╟─f74dbc38-3fa3-11eb-2372-37dd294ad846
# ╟─37190530-4075-11eb-1142-69cec1fcc194
# ╟─1b119320-4075-11eb-1902-39c50540367d
# ╟─21e85e3e-4075-11eb-2688-9919d6dc6cfb
# ╟─2ed78680-4075-11eb-09ee-dfaaae932b35
# ╟─8741cd80-4075-11eb-3e36-8179bb0743f1
# ╠═51dafef0-4075-11eb-3b23-7f8df0595e31
# ╟─74a19570-4075-11eb-26bc-adc983bc0f66
# ╠═5d832150-3fa4-11eb-1a0a-510cd3bf40ab
# ╠═e66ee270-4075-11eb-38cb-7f4088093eaf
# ╟─9c661860-4075-11eb-1e18-ddd47b4a5e56
# ╠═0b477eb2-3fb4-11eb-381c-8f0697d331c1
# ╠═19390d20-4076-11eb-1260-1b1c1d4eeae8
# ╠═c5cdc400-4075-11eb-3b8d-57e109398d53
# ╠═57e087d6-3fa6-11eb-2036-d7c75208be09

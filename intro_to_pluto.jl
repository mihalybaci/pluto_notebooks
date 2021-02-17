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
	Pkg.add(["LaTeXStrings", "PlutoUI", "UnicodePlots"])
	# Load the packages
	using LaTeXStrings, PlutoUI, UnicodePlots
end

# ╔═╡ e9e5a2b6-3f9b-11eb-0118-616e81cfbf81
md"""
# Hello!

### You are in "Live" mode. Check out the Live Docs!

### Hit the button below to enter presenation mode!

"""

# ╔═╡ b0fd37bc-6b05-11eb-2aa1-cd07650642a4
html"<button onclick=present()>Present</button>"

# ╔═╡ 1c30e3a2-3fa1-11eb-3194-1f6670d9f7c6
md"""### Then use the arrows in the lower right to navigate pages."""

# ╔═╡ c26ca968-3f9c-11eb-3354-65af5e81b59c
md"""
# Presentation mode is easy!

### It adds extra white space to separate cells when title headings are used.

### Markdown heading one code looks like this:
	
	md"# My Big Title"

### Markdown heading two code looks like this:

	md"## My Medium Title"
"""

# ╔═╡ bc4d34e0-3fa0-11eb-223d-09f004f40991
md"## Add Custom HTML elements"

# ╔═╡ cf0faa90-3fa0-11eb-077d-b1a2e7a9ddfc
br = HTML("<br>")  # Add a semi-colon to block the output

# ╔═╡ 4cd7e03e-712c-11eb-0cef-cd74d8e8e7e2
bigbr = html"<br><br><br><br><br>"

# ╔═╡ 8f173574-5a6a-11eb-2d37-4fee7981c2d4
bigbr

# ╔═╡ d378abac-712c-11eb-3173-4ff0d4c58f13
bigbr

# ╔═╡ 29dee366-712c-11eb-0515-51ba3556185b
hr = html""" <hr style="border: 1px dotted"> """

# ╔═╡ 1e143e04-712d-11eb-1931-197f6f677108
md"""
## Running other people's Pluto notebooks
1. Download Julia 1.5.3
2. Install Pluto.jl: `import Pkg; Pkg.add("Pluto")`
3. Open Pluto notebooks: `using Pluto; Pluto.run()`
4. Open from file: https://computationalthinking.mit.edu/Spring21/notebooks/week0/hw0.jl
"""

# ╔═╡ 49534924-3fa1-11eb-3945-59261dc1fba1
md"#### This next bit sets up a new environment, then adds and loads packages."

# ╔═╡ 091423bc-64b6-11eb-1b90-37c17e1b2c82
md"**NOTE**: Multiple lines must be wrapped in a function or block."

# ╔═╡ e272e400-64b5-11eb-3f79-fd63ec04cd5a
br

# ╔═╡ cb5036f6-3fa1-11eb-3664-7938b880f251
L"""
\text{Yay! Now I\ have fancy } \LaTeX! \text{ Look what I can do}!
"""

# ╔═╡ c1826d5c-3fa2-11eb-2f9e-39da3fbb4191
md"""
$B(\lambda, T) = \frac{2 h c^2}{\lambda^5} \frac{1}{e^{\frac{h c}{\lambda k_B T}} - 1}$
"""

# ╔═╡ 472b155c-5a6b-11eb-2bda-6721369df3f1
md"## Let's plot it!"

# ╔═╡ fb2551b2-64c0-11eb-1daf-958bbf9abd25
md"## How the plot was made"

# ╔═╡ 04dd1ebc-64c1-11eb-2ef8-1daaec31cec5
md"""
$B(\lambda, T) = \frac{2 h c^2}{\lambda^5} \frac{1}{e^{\frac{h c}{\lambda k_B T}} - 1}$
"""

# ╔═╡ e224a7e8-64bc-11eb-061d-5d8c091dbcfa
md"### Define constants"

# ╔═╡ 715a9f32-3fa4-11eb-1cb7-eb104abdfa6b
begin
	const h = 6.626e-34
	const c = 299_792_458.0
	const k = 1.380649e-23 
end

# ╔═╡ 269c78c2-64c1-11eb-04ae-65f97fc2ccb9
br

# ╔═╡ da837690-64bc-11eb-3352-dbb7eaeb2b80
md"### Function for single values"

# ╔═╡ 5d832150-3fa4-11eb-1a0a-510cd3bf40ab
B(λ, T) = (2.0*h*c^2)/(λ^5) * (ℯ^((h*c)/(λ*k*T)) - 1.0)^(-1)

# ╔═╡ 240f23a0-64c1-11eb-240f-ddf837626151
br

# ╔═╡ d09a10ae-64b6-11eb-0d06-1fe595b23728
md"### Extend function to work with arrays"

# ╔═╡ 0b477eb2-3fb4-11eb-381c-8f0697d331c1
B(λ::Array{S, 1} where S <: Real, T::Real) = [B(λₙ, T) for λₙ in λ]

# ╔═╡ 4bac2922-64bb-11eb-34cb-8192fb23e754
br

# ╔═╡ 4e25d4e6-64bb-11eb-1a8a-0b46c403dcb4
md"### Normalize function for plotting"

# ╔═╡ f2dee2b0-64bc-11eb-1002-67aeac0ad9df
normm(A) = A./maximum(A)

# ╔═╡ 624410d2-64bb-11eb-19c9-b12041fe7871
br

# ╔═╡ 508e3558-64ba-11eb-3b75-c5ca81618464
md"### Define temperatue and wavelength ranges"

# ╔═╡ 9d37fe0a-5a6c-11eb-0df3-17be21aca9cc
Ts = 1000:500:20000

# ╔═╡ f0584136-64c0-11eb-3ab3-355b4404b73e
md"""
`T = `$(@bind ind Slider(1:length(Ts)))
"""

# ╔═╡ c353a0ee-3fb4-11eb-39a2-618ccb1e6654
λₛ = collect(0.001:0.001:10).*1.0e-6

# ╔═╡ 57e087d6-3fa6-11eb-2036-d7c75208be09
plts = [lineplot(0.001:0.001:10, normm(B(λₛ, Ts[i])), title = "Planck Function: T = $(Ts[ind]) K", xlim=[0, 1], xlabel = "Wavelength (μm)", ylim = [0, 1], ylabel="Normalized Radiance") for i = 1:length(Ts)];

# ╔═╡ e916502a-64c0-11eb-3ecf-0d5cb5781c3b
plts[ind]

# ╔═╡ Cell order:
# ╟─e9e5a2b6-3f9b-11eb-0118-616e81cfbf81
# ╟─b0fd37bc-6b05-11eb-2aa1-cd07650642a4
# ╟─1c30e3a2-3fa1-11eb-3194-1f6670d9f7c6
# ╟─8f173574-5a6a-11eb-2d37-4fee7981c2d4
# ╟─d378abac-712c-11eb-3173-4ff0d4c58f13
# ╟─c26ca968-3f9c-11eb-3354-65af5e81b59c
# ╟─bc4d34e0-3fa0-11eb-223d-09f004f40991
# ╠═cf0faa90-3fa0-11eb-077d-b1a2e7a9ddfc
# ╠═4cd7e03e-712c-11eb-0cef-cd74d8e8e7e2
# ╠═29dee366-712c-11eb-0515-51ba3556185b
# ╟─1e143e04-712d-11eb-1931-197f6f677108
# ╟─49534924-3fa1-11eb-3945-59261dc1fba1
# ╠═6cfadfea-3fa1-11eb-3530-438864914f83
# ╟─091423bc-64b6-11eb-1b90-37c17e1b2c82
# ╟─e272e400-64b5-11eb-3f79-fd63ec04cd5a
# ╟─cb5036f6-3fa1-11eb-3664-7938b880f251
# ╟─c1826d5c-3fa2-11eb-2f9e-39da3fbb4191
# ╟─472b155c-5a6b-11eb-2bda-6721369df3f1
# ╟─f0584136-64c0-11eb-3ab3-355b4404b73e
# ╟─e916502a-64c0-11eb-3ecf-0d5cb5781c3b
# ╟─fb2551b2-64c0-11eb-1daf-958bbf9abd25
# ╟─04dd1ebc-64c1-11eb-2ef8-1daaec31cec5
# ╟─e224a7e8-64bc-11eb-061d-5d8c091dbcfa
# ╠═715a9f32-3fa4-11eb-1cb7-eb104abdfa6b
# ╟─269c78c2-64c1-11eb-04ae-65f97fc2ccb9
# ╟─da837690-64bc-11eb-3352-dbb7eaeb2b80
# ╠═5d832150-3fa4-11eb-1a0a-510cd3bf40ab
# ╟─240f23a0-64c1-11eb-240f-ddf837626151
# ╟─d09a10ae-64b6-11eb-0d06-1fe595b23728
# ╠═0b477eb2-3fb4-11eb-381c-8f0697d331c1
# ╟─4bac2922-64bb-11eb-34cb-8192fb23e754
# ╟─4e25d4e6-64bb-11eb-1a8a-0b46c403dcb4
# ╠═f2dee2b0-64bc-11eb-1002-67aeac0ad9df
# ╟─624410d2-64bb-11eb-19c9-b12041fe7871
# ╟─508e3558-64ba-11eb-3b75-c5ca81618464
# ╠═9d37fe0a-5a6c-11eb-0df3-17be21aca9cc
# ╠═c353a0ee-3fb4-11eb-39a2-618ccb1e6654
# ╠═57e087d6-3fa6-11eb-2036-d7c75208be09

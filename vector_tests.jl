### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 618ded7c-8810-11eb-2143-f356676abdbd
begin
	# Import the package manager
	import Pkg
	# Activate the temporary environment
	Pkg.activate(mktempdir())
	# Add the packages (downloading them if necessary)
	Pkg.add(["LaTeXStrings", "Plots"])
	# Load the packages
	using LaTeXStrings, LinearAlgebra, Plots
end

# ╔═╡ a6e0d686-880a-11eb-1a2f-dd79e75452d5
function rotate(x⃗, θ)
	cθ = cos(θ)
	sθ = sin(θ)
	return [x⃗[1]*cθ - x⃗[2]*sθ, x⃗[1]*sθ + x⃗[2]*cθ]
end	

# ╔═╡ 65e43572-8800-11eb-3af8-7941758abfe6
md"### For non-steerable dishes pointed to zenith"

# ╔═╡ 2bfb24de-85b8-11eb-25c6-85e79913e833
a⃗ = Vector([3, 3])  # radar site vector

# ╔═╡ 6009acb4-85b8-11eb-0a22-4725486112f9
b⃗ = Vector([5.3, 3.1])  # satellite position vector

# ╔═╡ dfcf6b04-85b9-11eb-2e03-d949fdf874a4
c⃗ = b⃗ - a⃗  # radar to satellite vector

# ╔═╡ 091886a8-85ba-11eb-3560-31ae1e0fecad
ĉ = c⃗/norm(c⃗)  # radar to satellite unit vector

# ╔═╡ 8d167bce-85ba-11eb-29fb-2b2c8d23da61
â = a⃗/norm(a⃗)  # radar site unit vector

# ╔═╡ 26360c40-87f6-11eb-31f0-733ad14cea75
oa⃗ = [0, a⃗[1]], [0, a⃗[2]]  # origin to radar site

# ╔═╡ ff1c5168-87f6-11eb-244f-e1f279a67337
ob⃗ = [0, b⃗[1]], [0, b⃗[2]]  # origin to satellite

# ╔═╡ 235afafc-87f7-11eb-12a1-9deb20552027
a⃗c⃗ = [a⃗[1], a⃗[1]+c⃗[1]], [a⃗[2], a⃗[2] + c⃗[2]]  # radar to satellite 

# ╔═╡ 44a616e2-87f7-11eb-0b66-73c477faf0d3
a⃗â = [a⃗[1], a⃗[1] + â[1]], [a⃗[1], a⃗[1] + â[2]]  # radar unit vector from radar site

# ╔═╡ 5e6c4146-87f7-11eb-3fa3-d9b586923327
a⃗ĉ = [a⃗[1], a⃗[1] +  ĉ[1]], [a⃗[1], a⃗[1] +  ĉ[2]]  # difference vector from radar site

# ╔═╡ c76b8856-880a-11eb-2d3d-57fd1d4cc846
md"### The following is for plotting only"

# ╔═╡ f5ab6d28-87f9-11eb-0e7e-710b5dbe0e49
θ = π/3# deg2rad(42.51044708)  # FOV for viewing satellite

# ╔═╡ 402c5a10-87fa-11eb-315f-dbe63be63817
d̂1 = rotate(â, θ)  # positive rotation (for ploting only)

# ╔═╡ 966ebf1e-87fd-11eb-0515-1db1c77025cd
d̂2 = rotate(â, -θ)  # negative rotation (for ploting only)

# ╔═╡ a67f3b2c-87fd-11eb-2ffd-ff7b316b5a4b
FOV = [a⃗[1] + d̂1[1], a⃗[1], a⃗[1] + d̂2[1]], [a⃗[2] + d̂1[2], a⃗[2], a⃗[2] + d̂2[2]]

# ╔═╡ 6241aeae-8805-11eb-3b3c-35c2deca6354
hl = rotate(â, -π/2)  # left horizon  (for ploting only)

# ╔═╡ 7a308684-8805-11eb-2bb6-33838d04b2fa
hr = rotate(â, π/2)  # right horizon (for ploting only)

# ╔═╡ 84341184-8805-11eb-3a3d-75a6b9f0b70a
horiz = [a⃗[1] - hl[1], a⃗[1], a⃗[1] + hl[1]], [a⃗[2] + hr[2], a⃗[2], a⃗[2] - hr[2]]

# ╔═╡ 8d1ecbbc-85b8-11eb-31a4-0f50ccc2a9bc
begin
	plot(oa⃗, label="a⃗", leg=:topleft)
	plot!(a⃗â, label="â", lw=3, ls=:dash)
	plot!(ob⃗, label="b⃗⃗")
	plot!(a⃗c⃗, label="c⃗")
	plot!(a⃗ĉ, label="ĉ", lw=3, ls=:dash)
	plot!(FOV, label="FOV", lw=3)
	plot!(horiz, label="horizon", c=:darkgray)
	annotate!([
			   (1.8, 2.0, Plots.text("a⃗")),
			   (3.8, 3.8, Plots.text("â")),
			   (3.0, 1.9, Plots.text("b⃗")),
			   (4.7, 3.25, Plots.text("c⃗")),
			   (4.05, 3.07, Plots.text("ĉ")),
			   (3.4, 3.2, Plots.text("β")),
			   (2.85, 3.25, Plots.text("θ")),
			])
end

# ╔═╡ cec1d38e-8810-11eb-19ff-2d6484552071
L"\hat{x} = \frac{\vec{x}}{||x||}"

# ╔═╡ 1c2986b8-8810-11eb-2a61-0bd41d8069ad
L"\vec{c} = \vec{b} - \vec{a}"

# ╔═╡ ecdb2d70-8810-11eb-10a8-89bc06cc7265
L"cos(\beta) = \hat{c}\cdot\hat{a}"

# ╔═╡ 125d3168-8811-11eb-213a-6162b3c90201
L"\textrm{Visibility condition:}~~ cos\left(\frac{\pi}{2} - \theta\right) < cos(\beta)"

# ╔═╡ 7f56e882-87fe-11eb-3fce-517d1a7c436e
md"### Steerable dishes with arbitrary pointing"

# ╔═╡ ec354bc4-87fe-11eb-20a2-cdbce969dee6
δ = -π/6  # Off-zenith angle

# ╔═╡ fb706d86-880c-11eb-35b3-676ce948c32e
ϕ = π/9 # deg2rad(12.51045) # FOV

# ╔═╡ d7b7ea12-87fe-11eb-3e97-b1e7495ccb0f
p⃗ = rotate(a⃗, δ)  # pointing vector

# ╔═╡ 099534c2-87ff-11eb-1751-b5d68202d202
p̂ = p⃗/norm(p⃗) # pointing unit vector

# ╔═╡ 213ab4e4-87ff-11eb-0755-55500df0f115
a⃗p̂ = [a⃗[1], a⃗[1] + p̂[1]], [a⃗[1], a⃗[1] + p̂[2]]  # pointing unit vector from radar site

# ╔═╡ 1cbbd4fa-8801-11eb-1934-e1cb9be870b9
ê1 = rotate(p̂, ϕ)  # positive FOV (for plotting only)

# ╔═╡ 6d0cd152-8801-11eb-2448-6f2d419d6689
ê2 = rotate(p̂, -ϕ)  # negative FOV (for plotting only)

# ╔═╡ bebd3b56-8801-11eb-0975-9f86f71994d0
FOVδ1 = [a⃗[1] + ê1[1], a⃗[1], a⃗[1] + ê2[1]], [a⃗[2] + ê1[2], a⃗[2], a⃗[2] + ê2[2]]

# ╔═╡ 346efcbc-8815-11eb-1c36-ddd213c1d64d
FOVδ2 = [a⃗[1], a⃗[1] + ê2[1]], [a⃗[2], a⃗[2] + ê2[2]]

# ╔═╡ a45f3a30-87fe-11eb-3fd7-bfecd9fe8838
begin
	plot(oa⃗, label="a⃗", leg=:topleft)
	plot!(FOVδ1, label="FOV", lw=3)
	plot!(a⃗â, label="â", ls=:dash)
	plot!(a⃗p̂, label="p̂", lw=3)
	plot!(ob⃗, label="b⃗⃗")
	plot!(a⃗c⃗, label="c⃗")
	plot!(a⃗ĉ, label="ĉ", lw=3, ls=:dash)
	plot!(horiz, label="horizon", c=:darkgray)
	annotate!([
			   (1.8, 2.0, Plots.text("a⃗")),
			   (3.8, 3.8, Plots.text("â")),
			   (3.0, 1.9, Plots.text("b⃗")),
			   (4.7, 3.25, Plots.text("c⃗")),
			   (4.1, 3.07, Plots.text("ĉ")),
			   (4.05, 3.35, Plots.text("p̂")),
			])
end

# ╔═╡ cb0b7f64-880c-11eb-1868-15b287bb6950
begin
	plot(a⃗â, label="â", leg=:bottomleft, ls=:dash)
	plot!(FOVδ2, label="FOV", lw=3)
	plot!(a⃗p̂, label="p̂", lw=3)
	plot!(a⃗ĉ, label="ĉ", lw=3, ls=:dash)
	plot!(horiz, label="horizon", c=:darkgray)
	annotate!([
			   (3.73, 3.74, Plots.text("â")),
			   (4.05, 3.07, Plots.text("ĉ")),
			   (4.05, 3.35, Plots.text("p̂")),
			   (3.2, 3.13, Plots.text("δ")),
			   (3.3, 3.03, Plots.text("ϕ")),
			   (3.45, 3.09, Plots.text("γ")),
			])
end

# ╔═╡ 1678bbbe-8813-11eb-383f-fdbed7524404
L"\vec{p} = R(\delta)\vec{a}"

# ╔═╡ 5e79dc36-8813-11eb-14ca-f96b45a4d139
L"\hat{p} = \frac{\vec{p}}{||p||}"

# ╔═╡ de725702-8812-11eb-2718-858e1c59efca
L"cos(\gamma) = \hat{c}\cdot\hat{p}"

# ╔═╡ 9f4395fc-8812-11eb-364a-6f8ecaef74f7
L"\textrm{Visibility condition:}~~ cos\left(\phi\right) < cos(\gamma)~~??"

# ╔═╡ b1d74c7a-8803-11eb-2ae7-519caaeba288
md"### Try a test"

# ╔═╡ d63ebf76-8803-11eb-0865-afd0513096df
#=
function ground_station_visible(r_e::AbstractVector, rs_e::AbstractVector,
                                θ::Number)
    # Check if the satellite is within the visibility circle of the station.
    dr_e = r_e - rs_e
    cos_beta = dot( dr_e/norm(dr_e), rs_e/norm(rs_e) )

    return cos_beta > cos(π/2-θ)
end
=#
function vizible(satvec, radvec, δ, ϕ)
	
	diff = satvec - radvec
	radrot = rotate(radvec, δ)
	cosγ = dot(diff/norm(diff), radrot/norm(radrot))

#    return cosγ < cos(ϕ)
	return cos(ϕ) < cosγ
end	

# ╔═╡ 5d898e82-880e-11eb-2f4e-0fefa69ef21e
md"##### Example from SatelliteToolbox for largest possible θ"

# ╔═╡ f5b78e5e-8813-11eb-2567-2bbd706b051e
vizible(b⃗, a⃗, 0, ϕ)  # should be false

# ╔═╡ 7c37c4ba-880e-11eb-07e4-9756532c00d0
md"""
##### Test example for off-angle pointing
###### Should be `false` for zenith pointing (δ=0)
###### Should be `true` for δ=π/6 pointing
"""

# ╔═╡ 460da59a-880e-11eb-2646-596a02b5be9d
vizible(b⃗, a⃗, 0, ϕ)  # should be false

# ╔═╡ de854212-880e-11eb-1673-29873c263d58
vizible(b⃗, a⃗, δ, ϕ) #deg2rad(12.51045)) # should be true

# ╔═╡ Cell order:
# ╠═618ded7c-8810-11eb-2143-f356676abdbd
# ╠═a6e0d686-880a-11eb-1a2f-dd79e75452d5
# ╟─65e43572-8800-11eb-3af8-7941758abfe6
# ╠═2bfb24de-85b8-11eb-25c6-85e79913e833
# ╠═6009acb4-85b8-11eb-0a22-4725486112f9
# ╠═dfcf6b04-85b9-11eb-2e03-d949fdf874a4
# ╠═091886a8-85ba-11eb-3560-31ae1e0fecad
# ╠═8d167bce-85ba-11eb-29fb-2b2c8d23da61
# ╠═26360c40-87f6-11eb-31f0-733ad14cea75
# ╠═ff1c5168-87f6-11eb-244f-e1f279a67337
# ╠═235afafc-87f7-11eb-12a1-9deb20552027
# ╠═44a616e2-87f7-11eb-0b66-73c477faf0d3
# ╠═5e6c4146-87f7-11eb-3fa3-d9b586923327
# ╟─c76b8856-880a-11eb-2d3d-57fd1d4cc846
# ╠═f5ab6d28-87f9-11eb-0e7e-710b5dbe0e49
# ╠═402c5a10-87fa-11eb-315f-dbe63be63817
# ╠═966ebf1e-87fd-11eb-0515-1db1c77025cd
# ╠═a67f3b2c-87fd-11eb-2ffd-ff7b316b5a4b
# ╠═6241aeae-8805-11eb-3b3c-35c2deca6354
# ╠═7a308684-8805-11eb-2bb6-33838d04b2fa
# ╠═84341184-8805-11eb-3a3d-75a6b9f0b70a
# ╟─8d1ecbbc-85b8-11eb-31a4-0f50ccc2a9bc
# ╟─cec1d38e-8810-11eb-19ff-2d6484552071
# ╟─1c2986b8-8810-11eb-2a61-0bd41d8069ad
# ╟─ecdb2d70-8810-11eb-10a8-89bc06cc7265
# ╟─125d3168-8811-11eb-213a-6162b3c90201
# ╟─7f56e882-87fe-11eb-3fce-517d1a7c436e
# ╠═ec354bc4-87fe-11eb-20a2-cdbce969dee6
# ╠═fb706d86-880c-11eb-35b3-676ce948c32e
# ╠═d7b7ea12-87fe-11eb-3e97-b1e7495ccb0f
# ╠═099534c2-87ff-11eb-1751-b5d68202d202
# ╠═213ab4e4-87ff-11eb-0755-55500df0f115
# ╠═1cbbd4fa-8801-11eb-1934-e1cb9be870b9
# ╠═6d0cd152-8801-11eb-2448-6f2d419d6689
# ╠═bebd3b56-8801-11eb-0975-9f86f71994d0
# ╠═346efcbc-8815-11eb-1c36-ddd213c1d64d
# ╟─a45f3a30-87fe-11eb-3fd7-bfecd9fe8838
# ╟─cb0b7f64-880c-11eb-1868-15b287bb6950
# ╟─1678bbbe-8813-11eb-383f-fdbed7524404
# ╟─5e79dc36-8813-11eb-14ca-f96b45a4d139
# ╟─de725702-8812-11eb-2718-858e1c59efca
# ╟─9f4395fc-8812-11eb-364a-6f8ecaef74f7
# ╟─b1d74c7a-8803-11eb-2ae7-519caaeba288
# ╠═d63ebf76-8803-11eb-0865-afd0513096df
# ╟─5d898e82-880e-11eb-2f4e-0fefa69ef21e
# ╠═f5b78e5e-8813-11eb-2567-2bbd706b051e
# ╟─7c37c4ba-880e-11eb-07e4-9756532c00d0
# ╠═460da59a-880e-11eb-2646-596a02b5be9d
# ╠═de854212-880e-11eb-1673-29873c263d58

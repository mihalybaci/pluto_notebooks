### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ ec92a444-e23c-11ea-3755-1125e325efb6
begin
	# Import the package manager
	import Pkg
	# Activate the temporary environment
	Pkg.activate(mktempdir())
	# Add the packages (downloading them if necessary)
	Pkg.add(["Images", "ImageMagick", "Plots", "PyCall"])
	# Load the packages
	using Images, ImageMagick
	using PyCall
	using Plots
end

# ╔═╡ 9edb3db4-e2e2-11ea-059a-0f6879b459f0
using Statistics

# ╔═╡ e650c816-e2e5-11ea-1ade-eb3ea781d480
using ArchGDAL

# ╔═╡ f2002ec6-e2da-11ea-3766-170e0b32ca8f
html"""
<style>
pluto-output h2 {
	font-family: juliamono;
}
pluto-output h3 {
	font-family: juliamono;
}
</style>
"""

# ╔═╡ 17b6ac1c-e2db-11ea-36bd-7f653a73c2f0
html"<h1> The cell above shows how to set the default HTML fonts. </h1>"

# ╔═╡ c0c24482-e241-11ea-2acb-e1edafc5c6f6
md"## First let's import our pacakges"

# ╔═╡ cef11e84-e241-11ea-1bfe-7f3054932263
md""" Let's use the md"" syntax to explain the begin/end block"""

# ╔═╡ e8ce0c40-e241-11ea-33b4-338292f18105
md" Multiple calls in one cell need to be wrapped in a begin-end block."

# ╔═╡ f7bd8064-e241-11ea-31e2-e10e82832509
md" We should check our Python version with sys."

# ╔═╡ 4af0cee4-e242-11ea-04fb-09aa46686628
md"pyimport() enabled by the PyCall.jl package let's us import ANY installed Python library"

# ╔═╡ 59f864ee-e240-11ea-23a0-079b73475863
sys = pyimport("sys")

# ╔═╡ c8cd6180-e240-11ea-00eb-13df6b244d60
sys.version

# ╔═╡ 337bfe28-e242-11ea-0761-7354bde8e619
md"Time for some data!"

# ╔═╡ 01bf7fd4-e241-11ea-3f42-6bee5af52256
sarpy = pyimport("sarpy")

# ╔═╡ 6a643d98-331d-11eb-19cd-6b6edabe23ca
sarpy

# ╔═╡ 47c5d102-e241-11ea-01b0-69349d0cca98
sarpy.__version__

# ╔═╡ 0aee9dd0-407a-11eb-387d-f739a5ccfcc1
ENV["HOME"] = "C:\\Users\\michael"

# ╔═╡ a688346e-e241-11ea-079c-5bbb6d3d821f
filename = joinpath(ENV["HOME"], "data/20151027_1027X04_PS0017_PT000002_N03_M1_CH0_OSAPF.ntf")

# ╔═╡ 6a393c8a-e244-11ea-1e6e-f90a6f7e8e9a
md"Now its true! edit back to title for presentation"

# ╔═╡ ba6d2d5e-e241-11ea-3e8b-87c2a002f7ec
isfile(filename)

# ╔═╡ 5725a75c-e242-11ea-3824-f58fabd82c79
md"What happened there? Julia doesn't parse the tilde shorthand, but we have another way to find the home directory."

# ╔═╡ 7b250ba2-e242-11ea-33fa-37454e60802a
md"ENV calls directory to the current user environment and places the variabls in a dictionary"

# ╔═╡ 758113e4-e242-11ea-2104-8f7b32961750
ENV

# ╔═╡ 9e2ba1d8-e242-11ea-00ea-6996c98acbe1
md"Let's find where HOME is."

# ╔═╡ 9b93719e-e242-11ea-1e97-91aec71b9434
ENV["HOME"]

# ╔═╡ c2099f2e-e242-11ea-1874-3305099694d0
md"But if you're not sure what something is called, it is easy to search"

# ╔═╡ d5b7dee6-e242-11ea-0cdf-c194d582297a
begin
	home = Dict()
	julia = Dict()
	for (key, value) in ENV
		println(key)
		if occursin("home", lowercase(key))
			home[key] = value
		end
		if occursin("julia", lowercase(key))
			julia[key] = value
		end
	end
home
julia
end

# ╔═╡ f3a54aa0-e243-11ea-29d0-9d143227778c
md"While we're at it, let's see what Julia environment variables are set. (edit above)"

# ╔═╡ 32da4d2e-e244-11ea-17ff-833317d84499
md"Now we can joinpath() properly, let's go back up!"

# ╔═╡ 2fe2bc5a-e244-11ea-3ca7-8d7417b66092
md" And we're back!"

# ╔═╡ eb9b92be-e244-11ea-2f96-5f92e90deeae
md" Let's open our data and take a look."

# ╔═╡ abc607d0-e246-11ea-1bb8-af0e2c56eae0
data = sarpy.io.complex.open(filename)

# ╔═╡ 1ff9efe2-e245-11ea-102f-f5905a1419ac
cf = pyimport("sarpy.io.complex")

# ╔═╡ bbe65b06-e246-11ea-2707-e904de3da92c
other_data = cf.open(filename)

# ╔═╡ c5311ef6-e246-11ea-0ddf-79d6b9f98445
metadata = data.sicd_meta

# ╔═╡ f202d3da-e247-11ea-0fdd-1fa52a07e7fa
metadata.ImageData

# ╔═╡ 9cffdcc8-e249-11ea-0389-dd930b0b911e
darray = data((0, 3975, 1), (0, 6724, 1))

# ╔═╡ 3bacca0e-3338-11eb-20bb-2b7a7e8ef5a0
maximum(real(darray))

# ╔═╡ 0e1f64c6-e2dd-11ea-0d8e-03390f741996
cmod = log10.(sqrt.(real(darray).^2 .+ imag(darray).^2)); # The colon suppresses the output

# ╔═╡ e7a7eae4-e2e0-11ea-3907-138aa024af05
norm = (cmod .- minimum(cmod)) / (maximum(cmod) - minimum(cmod));

# ╔═╡ a8e75038-e2e2-11ea-15ed-e9002a47342f
mean(norm)

# ╔═╡ eb9a60cc-e2e1-11ea-1d53-5ff23a877e7e
Gray.(norm)

# ╔═╡ dbe638e8-e2e3-11ea-1296-fd98d6688a96
i = findall(cmod .< 0)  # get all the indices where cmod is negative

# ╔═╡ 4d5f1728-e2e5-11ea-039d-675b123fe875
begin
	cmodnew = copy(cmod);
	cmodnew[i] .= 0
end

# ╔═╡ 931ecad8-e2e5-11ea-0d3a-bf7026063b1c
minimum(cmodnew)

# ╔═╡ 6e302fb4-e2e5-11ea-26e7-65ca57d4946f
newnorm = cmodnew / maximum(cmodnew);

# ╔═╡ 6a6af864-e2e5-11ea-2252-530b6f4d1801
maximum(newnorm)

# ╔═╡ ac4eaa8c-e2e5-11ea-15c1-e1f5155b706f
Gray.(newnorm)

# ╔═╡ c4a2e4e0-e2e5-11ea-1677-2dfb5ad5e8c1
md"## Can this be done without sarpy? Sure!"

# ╔═╡ d9ca02ea-e2e5-11ea-2b38-e35244afe1f4
md"We'll use GDAL and the ArchGDAL.jl package instead."

# ╔═╡ 586ed10e-e2e9-11ea-3de6-55b88a3e8298
function nitf_io(infile)

  ArchGDAL.read(infile) do dataset
    number_rasters = (ArchGDAL.nraster(dataset))
    width = ArchGDAL.width(dataset)
    height = ArchGDAL.height(dataset)

    band1 = ArchGDAL.getband(dataset,1)
    band2 = ArchGDAL.getband(dataset, 2)
    img_real = ArchGDAL.read(band1)
    img_complex = ArchGDAL.read(band2)
    meta = ArchGDAL.metadata(dataset)
    return (img_real, img_complex, meta)
  end  # read
end  # nitf_io

# ╔═╡ 6e2dcf90-e2e9-11ea-1585-eb64a978166a
real_img, complex_img, meta = nitf_io(filename);

# ╔═╡ 39cfb52c-33f4-11eb-2aaf-bdd4a185eb3f
real_img

# ╔═╡ 62434564-33f4-11eb-04e7-27c2f43b0dd5
complex_img

# ╔═╡ 749b8eda-e2e9-11ea-2b42-4de85579b06b
meta

# ╔═╡ 7d6b6684-e2e9-11ea-0cd4-25b7a0e6faf8
norm_img = log10.(sqrt.(real_img.^2 + complex_img.^2))

# ╔═╡ 17f56890-4081-11eb-36fc-e9a013dc9be5
norm_img[(norm_img .< 0)] .= 0

# ╔═╡ 8b84cd60-4080-11eb-0692-3d12551ef123
minimum(norm_img), maximum(norm_img)

# ╔═╡ c5933202-e2e9-11ea-3a19-ed13ed0c8ffe
scaled_img = (norm_img .- minimum(norm_img)) / (maximum(norm_img) - minimum(norm_img)) * 1.0

# ╔═╡ e17848a2-3322-11eb-0ec0-578a0a1d4c1b
minimum(scaled_img), maximum(scaled_img)

# ╔═╡ 4d59a368-e2ef-11ea-18de-95700e8682a8
gray_img = Gray.(scaled_img)

# ╔═╡ d959a368-e2ec-11ea-02ab-87ae4c1e36af
md"Let's make sure sarpy and ArchGDAL give equivalent results."

# ╔═╡ 31da77c0-e2ea-11ea-212f-d91025986cbc
md"GDAL/nitf_io skips the complex component. And our complex modulus removes the negative values"

# ╔═╡ 6bc13048-e2ef-11ea-2ec0-21f4f11bae64
norm[1:2, 1:2]

# ╔═╡ 72219e08-e2ef-11ea-3a24-153ede4eba55
norm == scaled_img

# ╔═╡ f50a3f02-e2ef-11ea-12bd-2db1fbdc639b
md"Why false? Flip rows/cols with transpose"

# ╔═╡ 23836796-e2f0-11ea-0d54-a9f160be27c1
norm == scaled_img'  # The apostrophe ' is shortand for transpose(matrix)

# ╔═╡ 3ce7ce5c-e2f0-11ea-1675-3f9da8f6d3c9
transpose(norm) == scaled_img

# ╔═╡ 44b4a8e8-4066-11eb-1567-f36a35aa9a68
gray_img'

# ╔═╡ 56fc2bc6-e2ff-11ea-271e-9392b82085a6
md""" The time comparision to open and normalize the SAR image above takes 1.2 seconds in pure Julia with ArchGDAL, and it takes 1.1 seconds in pure Python with sarpy. But why?  "Julia is faster", remember? """

# ╔═╡ 9d8a80e2-e2ff-11ea-3596-2f59f9f12188
md""" Here is the Julia code:
```
	function nitf_io(infile)
	  	ArchGDAL.read(infile) do dataset
	    	band1 = ArchGDAL.getband(dataset,1)
    		band2 = ArchGDAL.getband(dataset, 2)
    		real_img = ArchGDAL.read(band1)
    		complex_img = ArchGDAL.read(band2)
    		meta = ArchGDAL.metadata(dataset)
	    	img = log10.(sqrt.(real_img.^2 + complex_img.^2));
    		scaled = (img .- minimum(img)) / (maximum(img) - minimum(img)) * 255.0;
		    return (scaled, meta)
		end
	end
```
"""

# ╔═╡ 06eba11a-e300-11ea-2ed9-ed5d0afa7caf
md""" Here is the Python code:
```
def nitf_io(filename):
    sicd = cf.open(filename)
    meta = sicd.sicd_meta
    darray = sicd((0, 3975, 1), (0, 6724, 1))
    img = np.log10(np.sqrt(np.real(darray)**2 + np.imag(darray)**2))
    scaled = (img - np.min(img)) / (np.max(img) - np.min(img)) * 255.0
    return (scaled, meta)
```
"""

# ╔═╡ Cell order:
# ╟─f2002ec6-e2da-11ea-3766-170e0b32ca8f
# ╟─17b6ac1c-e2db-11ea-36bd-7f653a73c2f0
# ╟─c0c24482-e241-11ea-2acb-e1edafc5c6f6
# ╟─cef11e84-e241-11ea-1bfe-7f3054932263
# ╟─e8ce0c40-e241-11ea-33b4-338292f18105
# ╠═ec92a444-e23c-11ea-3755-1125e325efb6
# ╟─f7bd8064-e241-11ea-31e2-e10e82832509
# ╟─4af0cee4-e242-11ea-04fb-09aa46686628
# ╠═59f864ee-e240-11ea-23a0-079b73475863
# ╠═c8cd6180-e240-11ea-00eb-13df6b244d60
# ╟─337bfe28-e242-11ea-0761-7354bde8e619
# ╠═01bf7fd4-e241-11ea-3f42-6bee5af52256
# ╠═6a643d98-331d-11eb-19cd-6b6edabe23ca
# ╠═47c5d102-e241-11ea-01b0-69349d0cca98
# ╠═0aee9dd0-407a-11eb-387d-f739a5ccfcc1
# ╠═a688346e-e241-11ea-079c-5bbb6d3d821f
# ╟─6a393c8a-e244-11ea-1e6e-f90a6f7e8e9a
# ╠═ba6d2d5e-e241-11ea-3e8b-87c2a002f7ec
# ╟─5725a75c-e242-11ea-3824-f58fabd82c79
# ╟─7b250ba2-e242-11ea-33fa-37454e60802a
# ╠═758113e4-e242-11ea-2104-8f7b32961750
# ╠═9e2ba1d8-e242-11ea-00ea-6996c98acbe1
# ╠═9b93719e-e242-11ea-1e97-91aec71b9434
# ╟─c2099f2e-e242-11ea-1874-3305099694d0
# ╠═d5b7dee6-e242-11ea-0cdf-c194d582297a
# ╟─f3a54aa0-e243-11ea-29d0-9d143227778c
# ╟─32da4d2e-e244-11ea-17ff-833317d84499
# ╟─2fe2bc5a-e244-11ea-3ca7-8d7417b66092
# ╠═eb9b92be-e244-11ea-2f96-5f92e90deeae
# ╠═abc607d0-e246-11ea-1bb8-af0e2c56eae0
# ╠═1ff9efe2-e245-11ea-102f-f5905a1419ac
# ╠═bbe65b06-e246-11ea-2707-e904de3da92c
# ╠═c5311ef6-e246-11ea-0ddf-79d6b9f98445
# ╠═f202d3da-e247-11ea-0fdd-1fa52a07e7fa
# ╠═9cffdcc8-e249-11ea-0389-dd930b0b911e
# ╠═3bacca0e-3338-11eb-20bb-2b7a7e8ef5a0
# ╠═0e1f64c6-e2dd-11ea-0d8e-03390f741996
# ╠═e7a7eae4-e2e0-11ea-3907-138aa024af05
# ╠═9edb3db4-e2e2-11ea-059a-0f6879b459f0
# ╠═a8e75038-e2e2-11ea-15ed-e9002a47342f
# ╠═eb9a60cc-e2e1-11ea-1d53-5ff23a877e7e
# ╠═dbe638e8-e2e3-11ea-1296-fd98d6688a96
# ╠═4d5f1728-e2e5-11ea-039d-675b123fe875
# ╠═931ecad8-e2e5-11ea-0d3a-bf7026063b1c
# ╠═6e302fb4-e2e5-11ea-26e7-65ca57d4946f
# ╠═6a6af864-e2e5-11ea-2252-530b6f4d1801
# ╠═ac4eaa8c-e2e5-11ea-15c1-e1f5155b706f
# ╟─c4a2e4e0-e2e5-11ea-1677-2dfb5ad5e8c1
# ╟─d9ca02ea-e2e5-11ea-2b38-e35244afe1f4
# ╠═e650c816-e2e5-11ea-1ade-eb3ea781d480
# ╠═586ed10e-e2e9-11ea-3de6-55b88a3e8298
# ╠═6e2dcf90-e2e9-11ea-1585-eb64a978166a
# ╠═39cfb52c-33f4-11eb-2aaf-bdd4a185eb3f
# ╠═62434564-33f4-11eb-04e7-27c2f43b0dd5
# ╠═749b8eda-e2e9-11ea-2b42-4de85579b06b
# ╠═7d6b6684-e2e9-11ea-0cd4-25b7a0e6faf8
# ╠═17f56890-4081-11eb-36fc-e9a013dc9be5
# ╠═8b84cd60-4080-11eb-0692-3d12551ef123
# ╠═c5933202-e2e9-11ea-3a19-ed13ed0c8ffe
# ╠═e17848a2-3322-11eb-0ec0-578a0a1d4c1b
# ╠═4d59a368-e2ef-11ea-18de-95700e8682a8
# ╠═d959a368-e2ec-11ea-02ab-87ae4c1e36af
# ╟─31da77c0-e2ea-11ea-212f-d91025986cbc
# ╠═6bc13048-e2ef-11ea-2ec0-21f4f11bae64
# ╠═72219e08-e2ef-11ea-3a24-153ede4eba55
# ╟─f50a3f02-e2ef-11ea-12bd-2db1fbdc639b
# ╠═23836796-e2f0-11ea-0d54-a9f160be27c1
# ╠═3ce7ce5c-e2f0-11ea-1675-3f9da8f6d3c9
# ╠═44b4a8e8-4066-11eb-1567-f36a35aa9a68
# ╟─56fc2bc6-e2ff-11ea-271e-9392b82085a6
# ╟─9d8a80e2-e2ff-11ea-3596-2f59f9f12188
# ╟─06eba11a-e300-11ea-2ed9-ed5d0afa7caf

### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 153e0e2c-c87b-11eb-119a-3bc65dbfe8c1
begin
	# Only necessary if using from github
	tmpdir = mktempdir()
	import Pkg; Pkg.activate(tmpdir)
	Pkg.add(["CodecZlib", "Mmap"])
	using CodecZlib
	using Mmap
	# These are required for the analysis
	Pkg.add(["CSV", "DataFrames", "Gadfly", "PlutoUI"])
	using CSV
	using DataFrames
	using Gadfly
	using PlutoUI
end

# ╔═╡ 8237eb9e-597d-4d4d-bac3-55b7a29bd93b
md"# Explore the Kaggle Olympic Data"

# ╔═╡ 57368d51-8aa9-4f95-b6b4-886eed1c8972
md"[https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results)"

# ╔═╡ 5a5feabb-f942-4a07-8d7a-8505d81cec28
md"### Setup the environment"

# ╔═╡ bfafb008-26cc-426a-a16e-c929704e2785
md"This setup is only necessary to ensure the code runs out-of-the-box via github. It is possible se a more standard setup for additional exploration. (see comments)"

# ╔═╡ 932a4e97-0481-4e18-9724-abf017d83659
md"### Get the data"

# ╔═╡ 62f623de-fa9d-41df-92aa-e348d14e700f
athfile = joinpath(tmpdir, "athlete_events.csv.gz")

# ╔═╡ b3d8adfa-156c-4084-8a75-98e50447ab7e
nocfile = joinpath(tmpdir, "noc_regions.csv.gz")

# ╔═╡ 4f427db8-cf03-4a6e-b46a-4921d9b0dc69
begin
	download("https://github.com/mihalybaci/pluto_notebooks/blob/main/data/athlete_events.csv.gz?raw=true", athfile)
	download("https://github.com/mihalybaci/pluto_notebooks/blob/main/data/noc_regions.csv.gz?raw=true", nocfile)
end

# ╔═╡ 2729b4b4-bf14-4a3f-a526-727b60824d6c
md"### Read the Data"

# ╔═╡ 036155da-c7c1-4aad-b790-ab6b0da4a6fc
md"
#### To run uncompressed csv files use the syntax
##### `df = CSV.File(file) |> DataFrame`
"

# ╔═╡ 3b1cd2fa-3e87-4c67-8c94-b68b6b419ded
athletes = CSV.File(transcode(GzipDecompressor, Mmap.mmap(athfile))) |> DataFrame

# ╔═╡ 67e587fd-2b24-47ce-b8dc-19da29c04b65
regions = CSV.File(transcode(GzipDecompressor, Mmap.mmap(nocfile))) |> DataFrame

# ╔═╡ 775d6a30-2f85-4104-bdad-33ce7f4cb4f4
md"### Begin data exploration"

# ╔═╡ 55a9203a-8b99-42e6-bf9a-8a965876a826
propertynames(athletes)

# ╔═╡ 98a2da66-41da-4321-938a-e913cc8cb339
athletes.:Year

# ╔═╡ b20a5523-cecc-4271-b9cd-01f03f3b0741
athletes_per_season = combine(groupby(athletes, [:Year, :Season]), nrow => :count)

# ╔═╡ f723195e-7520-45c1-8b7c-c58ea590dfdd
p = let
	all = layer(athletes_per_season, x=:Year, y=:count, color=:Season, label=:Season)
	coords = Coord.cartesian(xmin=1895, xmax=2021, ymin=2.5, ymax=4.3)
	guides = (Guide.title("Athletes per Olympic Games"),
		      Guide.xlabel("Year"), 
			  Guide.ylabel("Number of Athletes"),
			  )
	plot(all, coords, Scale.y_log10(format=:plain), guides...)
end

# ╔═╡ e685aa0e-cd82-463d-b94d-64150181fc21
total_athletes_event = combine(groupby(athletes, [:Event]), nrow => :count)

# ╔═╡ ef8e9df3-7051-46bf-8af0-316ff797622f
sort(total_athletes_event, :count, rev=true)

# ╔═╡ a5656cdf-c114-4ba8-9b0e-cc41771647c4
md""" With 5733 total players across all modern Olympics, men's football (soccer) "wins the gold" for most participants. The most competed individual sport is men's cycling with 2947 riders.""" 

# ╔═╡ 8ed90dc8-e4f2-4593-9a86-24204518e45e
filter(row -> row.Event == "Aeronautics Mixed Aeronautics", athletes)

# ╔═╡ bb25b79c-e502-489a-801f-a0e518898535
md"""In 1936, Herman Schreiber was the only person to ever to compete in "mixed aeronautics". He won the gold. """

# ╔═╡ e81c7532-a6f9-4f7d-a619-a96075a54e2f


# ╔═╡ Cell order:
# ╟─8237eb9e-597d-4d4d-bac3-55b7a29bd93b
# ╟─57368d51-8aa9-4f95-b6b4-886eed1c8972
# ╟─5a5feabb-f942-4a07-8d7a-8505d81cec28
# ╟─bfafb008-26cc-426a-a16e-c929704e2785
# ╠═153e0e2c-c87b-11eb-119a-3bc65dbfe8c1
# ╟─932a4e97-0481-4e18-9724-abf017d83659
# ╠═62f623de-fa9d-41df-92aa-e348d14e700f
# ╠═b3d8adfa-156c-4084-8a75-98e50447ab7e
# ╠═4f427db8-cf03-4a6e-b46a-4921d9b0dc69
# ╟─2729b4b4-bf14-4a3f-a526-727b60824d6c
# ╟─036155da-c7c1-4aad-b790-ab6b0da4a6fc
# ╠═3b1cd2fa-3e87-4c67-8c94-b68b6b419ded
# ╠═67e587fd-2b24-47ce-b8dc-19da29c04b65
# ╟─775d6a30-2f85-4104-bdad-33ce7f4cb4f4
# ╠═55a9203a-8b99-42e6-bf9a-8a965876a826
# ╠═98a2da66-41da-4321-938a-e913cc8cb339
# ╠═b20a5523-cecc-4271-b9cd-01f03f3b0741
# ╠═f723195e-7520-45c1-8b7c-c58ea590dfdd
# ╠═e685aa0e-cd82-463d-b94d-64150181fc21
# ╠═ef8e9df3-7051-46bf-8af0-316ff797622f
# ╟─a5656cdf-c114-4ba8-9b0e-cc41771647c4
# ╠═8ed90dc8-e4f2-4593-9a86-24204518e45e
# ╟─bb25b79c-e502-489a-801f-a0e518898535
# ╠═e81c7532-a6f9-4f7d-a619-a96075a54e2f

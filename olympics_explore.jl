### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 153e0e2c-c87b-11eb-119a-3bc65dbfe8c1
begin
	import Pkg; Pkg.activate(".");
	Pkg.add(["CSV", "DataFrames", "Gadfly", "PlutoUI"])
	using CSV
	using DataFrames
	using Gadfly
	using PlutoUI
end

# ╔═╡ 3b1cd2fa-3e87-4c67-8c94-b68b6b419ded
athletes = DataFrame(CSV.File("athlete_events.csv"))

# ╔═╡ 67e587fd-2b24-47ce-b8dc-19da29c04b65
regions = DataFrame(CSV.File("noc_regions.csv"))

# ╔═╡ 55a9203a-8b99-42e6-bf9a-8a965876a826
propertynames(athletes)

# ╔═╡ 98a2da66-41da-4321-938a-e913cc8cb339
athletes.:Year

# ╔═╡ a0549f0d-9646-47de-aad2-ebb63f532e06
athletes_per_year = combine(groupby(athletes, :Year), nrow => :count)

# ╔═╡ 73c64613-c293-46d6-a517-a429c17faab6
o = 24  # split into summer/winter every 2 years

# ╔═╡ 818c27c8-7c04-4880-9b98-865e270e7b74
winter_games = athletes_per_year[o:2:end, :] 

# ╔═╡ fd96ce88-d066-4dc8-8787-a89978f818ed
summer_games = athletes_per_year[o+1:2:end, :]

# ╔═╡ daa6b390-008d-45f1-bd93-dbc68e24845d
combined = DataFrame(Year=summer_games.:Year, count=(summer_games.:count + winter_games.:count))

# ╔═╡ f723195e-7520-45c1-8b7c-c58ea590dfdd
p = let
	all = layer(athletes_per_year[1:o-1, :], x=:Year, y=:count)
	ws = layer(combined, x=:Year, y=:count)
	winter = layer(winter_games, x=:Year, y=:count, color=[colorant"red"])
	summer = layer(summer_games, x=:Year, y=:count, color=[colorant"green"])
	plot(all, ws, winter, summer, Guide.xlabel("length"), Guide.ylabel("width"), 		Guide.title("Athletes per Olympic Games"), Guide.manual_color_key("",["Summer+Winter", "Winter-only", "Summer-only"],
                            [Gadfly.current_theme().default_color, "red", "green"]))
end

# ╔═╡ Cell order:
# ╠═153e0e2c-c87b-11eb-119a-3bc65dbfe8c1
# ╠═3b1cd2fa-3e87-4c67-8c94-b68b6b419ded
# ╠═67e587fd-2b24-47ce-b8dc-19da29c04b65
# ╠═55a9203a-8b99-42e6-bf9a-8a965876a826
# ╠═98a2da66-41da-4321-938a-e913cc8cb339
# ╠═a0549f0d-9646-47de-aad2-ebb63f532e06
# ╠═73c64613-c293-46d6-a517-a429c17faab6
# ╠═818c27c8-7c04-4880-9b98-865e270e7b74
# ╠═fd96ce88-d066-4dc8-8787-a89978f818ed
# ╠═daa6b390-008d-45f1-bd93-dbc68e24845d
# ╠═f723195e-7520-45c1-8b7c-c58ea590dfdd

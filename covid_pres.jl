### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 907776a8-648e-11eb-00c2-4d1e34a543e0
begin
	# Import the package manager
	import Pkg
	# Activate the temporary environment
	Pkg.activate(mktempdir())
	# Add the packages (downloading them if necessary)
	Pkg.add(["CSV", "DataFrames", "Dates", "Plots", "PlutoUI", "VegaLite", "VegaDatasets"])
	# Load the packages
	using CSV 
	using DataFrames
	using Dates
	using Plots
	using PlutoUI
	using Statistics
	using VegaLite: @vlplot
	using VegaDatasets
end

# ╔═╡ 11b6f756-921a-11eb-1623-7d59b0eacc37
br = HTML("<br>");  # Add a semi-colon to block the output

# ╔═╡ 869489e0-8d61-11eb-158a-b72ed06a72bc
html"<button onclick=present()>Present</button>"

# ╔═╡ 0466536c-8d60-11eb-26a3-b3ee18f9def3
md"# JuliaCon 2021

### **Location**: Everywhere on Earth

### **Date**: 28 -- 30 July 2021

### **Cost**: FREE

### **Registration**: https://juliacon.org/2021/"

# ╔═╡ 040cf9c2-8e30-11eb-2ada-cfd94f33f549
md"""
# Julia v1.6 was released on March 25ᵗʰ!
### Notable updates
_____________________
#### Parallel precompilation*
#### Pre-compilation at install, not first run
#### Reduced recompilation
#### Reduced compiled latency
#### Faster binary loading
#### Improved networking features*
"""

# ╔═╡ e9e23032-8d60-11eb-2398-f91242fb3c17
md"# Learning Data Science in Julia"

# ╔═╡ 2ae29774-8d64-11eb-2b5f-439867054365
md"
### From Julia Academy [(http://juliaacademy.com)](http://juliaacademy.com): 
#### Introduction to DataFrames.jl
#### Julia for Data Science
#### Foundations of Machine Learning
#### Deep Learning with Flux
#### The World of Machine Learning with Knet
"

# ╔═╡ 3c4cac24-8d63-11eb-206c-751e06065314
html"""<hr style="border: 1px dashed">"""

# ╔═╡ 0cbf869c-8d64-11eb-2cf1-8d9691e28094
md"### Data Science Hackers webbook: 
#### [https://datasciencejuliahackers.com/](https://datasciencejuliahackers.com/)"

# ╔═╡ ebb3989e-2b43-11eb-1b42-355ccf52223d
md"# Exploring COVID Cases with Julia"

# ╔═╡ eded10b2-9219-11eb-22f1-fd73bea5058a
br

# ╔═╡ 940b688c-9219-11eb-0f5b-e7248ace8146
md"#### All notebooks available at 
#### [https://github.com/mihalybaci/pluto_notebooks](https://github.com/mihalybaci/pluto_notebooks)"

# ╔═╡ 5b065066-8d61-11eb-370b-317f5e1dcfb0
md"## Load environment, get data, set up functions"

# ╔═╡ 31ee5dc6-2903-11eb-1a98-63b264ae3e60
us_url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"

# ╔═╡ 47d408a4-2903-11eb-34ef-85edab54f790
pwd()

# ╔═╡ 37df93dc-2903-11eb-06ab-ebb0c6134ea7
download(us_url, "covid_confirmed_us.csv")

# ╔═╡ 6fe736cc-2903-11eb-0fe3-899e79473814
covid_confirmed_us = CSV.read("covid_confirmed_us.csv", DataFrame)

# ╔═╡ ee3dad02-2904-11eb-254d-b3be41e3ca62
states = unique(covid_confirmed_us.Province_State)

# ╔═╡ fbc65be0-2a71-11eb-245d-9f57dc0c8d3b
function get_dates(covid_data, sym)
	if sym == :str
		dates = String.(names(covid_data))[12:end]
	elseif sym == :date
		dateformat = Dates.DateFormat("m/d/Y")
		dates = parse.(Date, String.(names(covid_data))[12:end], dateformat) + Year(2000)
	end
	return dates
end	

# ╔═╡ bdf5c960-2b3c-11eb-1f90-39ff304637cb
dates = get_dates(covid_confirmed_us, :date);

# ╔═╡ cdf108f6-2a70-11eb-0cb7-6311491140ca
function by_state(state, us_data)
	state_df = covid_confirmed_us[covid_confirmed_us.Province_State .== state, :]
	dates_string = get_dates(covid_confirmed_us, :str)
	dates_fmt = get_dates(covid_confirmed_us, :date)
	cases_date = [sum(state_df[:, dates_string[i]]) for i = 1:length(dates_string)]
	return DataFrame(:Date => dates_fmt, :Cases => cases_date)
end

# ╔═╡ bc8516b4-2d88-11eb-3057-2b764954891c
md"## View Cases by State"

# ╔═╡ b30ff62e-2d85-11eb-224d-d5f27e7551cc
md"""### Choose States
$(@bind the_states MultiSelect(vcat([""], states)))
"""

# ╔═╡ d7b24d3e-2b3b-11eb-022f-7bb38bdcc775
md"""### Chose Attributes
**Show** = $(@bind what_to_plot Select(["Total", "Daily"], default="Total"))
**Scale =** $(@bind plot_scale Select(["linear", "log"], default="linear"))
**Smoothing** $(@bind smooth Select(["1", "2", "3", "4", "5", "6" ,"7"], default="1"))
**Legend =** $(@bind leg_pos Select(["topleft", "topright", "bottomleft", "bottomright", "outertopleft", "outertopright", "outerbottomleft", "outerbottomright"], default="topleft"))

**Start date** $(@bind start_ind Slider(1:length(dates), default=1)) 
"""

# ╔═╡ 75d1293c-2b40-11eb-20f7-f3ea15093f20
md"""**End date** 
$(@bind stop_ind Slider(start_ind:length(dates), default=length(dates)))"""

# ╔═╡ 532f0cf2-921a-11eb-1004-c71928b38711
difference(data) = [data[i] - data[i-1] for i = 2:length(data)];

# ╔═╡ 5803b06e-921a-11eb-33d1-d5350e6549ba
boxcar(data, N::Int) = (N > 1) ? [mean(data[i-N:i]) for i = N+1:length(data)] : data;

# ╔═╡ 5ae28a58-921a-11eb-20f9-f54f015ff652
MyType = Union{T, Missing} where T <: Real;  # Use MyType to Allow Missing Values

# ╔═╡ 52c3d7fa-3644-11eb-2d71-653aef1e09b1
state_cases_all = [by_state(the_states[n], covid_confirmed_us) for n = 1:length(the_states)];  # Separating these to reduce the computations when interacting with the plot

# ╔═╡ 238ce10a-364b-11eb-24de-b11a4bebde06
state_cases_range = [state_cases_all[i][start_ind:stop_ind, :] for i = 1:length(state_cases_all)];

# ╔═╡ b0745148-2a68-11eb-084c-310c312b32ad
let
	if what_to_plot == "Total"
		the_title = "Total Confrimed COVID-19 Cases"
	elseif what_to_plot == "Daily"
		the_title = "Daily Reported Cases"
	end
	
	stats_for_states = [describe(state_cases_range[i]) for i = 								1:length(state_cases_range)];

	mins = [stats_for_states[i].min[2] for i = 1:length(stats_for_states)]
	maxs = [stats_for_states[i].max[2] for i = 1:length(stats_for_states)]

	ylimits = [(0 < length(mins)) ? minimum(mins) : 1,
			   (0 < length(maxs)) ? maximum(maxs) : 2]
	
	state_plots = plot(title = the_title, yscale = Symbol(plot_scale), 
		legend = Symbol(leg_pos))

	for n = 1:length(the_states)
		state_data = copy(state_cases_range[n])  # Necessary to avoid overwriting data
		# For special case of American Samoa with zero reported cases
		if sum(state_data.Cases) == 0  && plot_scale == "log"
			xdata = state_data.Date
			ydata = ones(length(xdata))
		elseif what_to_plot == "Total"
			if plot_scale == "log"
				replace!(allowmissing!(state_data, :Cases).Cases, 0 => missing)
			end
			xdata, ydata = state_data.Date, state_data.Cases
		elseif what_to_plot =="Daily"
			ydata = MyType[boxcar(difference(state_data.Cases), parse(Int, 							smooth))...]
			ylimits = [minimum(ydata), maximum(ydata)]
			if plot_scale == "log"
				ydata[(ydata .≤ 0)] .= missing
			end
			xdata = state_data.Date[end-length(ydata)+1:end]
		end
		state_plots = plot!(xdata, ydata, label="$(the_states[n])")
	end
	
	if plot_scale == "log"
		ylimits[1] = (ylimits[1] ≤ 0) ? 1 : ylimits[1]
		ylimits[2] = (ylimits[2] ≤ 0) ? 2 : ylimits[2]
	end

	plot(state_plots, ylimit=ylimits, ylabel="Cases")
end

# ╔═╡ cb24dd58-2d88-11eb-23ab-59a1a869132c
md"## View Cases by County"

# ╔═╡ e8a18338-2d8b-11eb-0ce6-2d4c7f9f20bd
function by_county(county, state, us_data)
	county_df = covid_confirmed_us[(covid_confirmed_us.Province_State .== state ) .& (covid_confirmed_us.Admin2 .== county), :]
	dates_string = get_dates(covid_confirmed_us, :str)
	dates_fmt = get_dates(covid_confirmed_us, :date)
	cases_date = [county_df[1, dates_string[i]] for i = 1:length(dates_string)]
	return DataFrame(:Date => dates_fmt, :Cases => cases_date)
end;

# ╔═╡ df792c14-2d88-11eb-3286-5f53f927e546
md"### Pick a State"

# ╔═╡ e77f6cca-2d88-11eb-3edd-c9ee58cc52b7
md"""
$(@bind a_state Select(vcat([""], states)))
"""

# ╔═╡ b9ea336c-2d88-11eb-093c-7ba8f8ca1c7d
begin
	counties = string.(covid_confirmed_us.Admin2[covid_confirmed_us.Province_State .== a_state])
	md"""### Choose Counties
$(@bind the_counties MultiSelect(vcat([""], counties)))
"""
end

# ╔═╡ d01a0bec-2d8a-11eb-2b2b-87753a9aa8be
md"""### Chose Attributes
**Show** = $(@bind what_to_plot2 Select(["Total", "Daily"], default="Total"))
**Scale =** $(@bind plot_scale2 Select(["linear", "log"], default="linear"))
**Smoothing** $(@bind smooth2 Select(["1", "2", "3", "4", "5", "6" ,"7"], default="1"))
**Legend =** $(@bind leg_pos2 Select(["topleft", "topright", "bottomleft", "bottomright"], default="topleft"))

**As =** $(@bind count_ratio Select(["Count", "Ratio"], default="Total"))
**Include State?** $(@bind show_state Select(["Yes", "No"], default="No"))

**Start date** $(@bind start_ind2 Slider(1:length(dates), default=1)) 
"""

# ╔═╡ df95c908-2d8a-11eb-3471-dd1d200869a4
md"""**End date** 
$(@bind stop_ind2 Slider(start_ind:length(dates), default=length(dates)))"""

# ╔═╡ 48536d04-364d-11eb-20a7-4f4a766800fd
county_state_all = by_state(a_state, covid_confirmed_us);

# ╔═╡ 0a654a7c-364c-11eb-3849-3b00f67f8704
county_state_range = county_state_all[start_ind2:stop_ind2, :];

# ╔═╡ 0e5fa0e8-2d94-11eb-266a-a71e73886f8d
county_cases_all = [by_county(the_counties[n], a_state, covid_confirmed_us) for n = 1:length(the_counties)];

# ╔═╡ a84aa814-364b-11eb-0e4d-9748b8b24a12
county_cases_range = [county_cases_all[n][start_ind2:stop_ind2, :] for n = 1:length(county_cases_all)];

# ╔═╡ b79fefdc-2d8a-11eb-1cf1-f5c70aca7988
let
	if what_to_plot2 == "Total"
		the_title = "COVID-19 Cases for $a_state counties"
	elseif what_to_plot2 == "Daily"
		the_title = "Daily Reported Cases"
	end
	county_plots = plot(title = the_title, yscale = Symbol(plot_scale2), 
		legend = Symbol(leg_pos2))

	if show_state == "Yes"
		xstate = county_state_range.Date
		ystate = county_state_range.Cases

		if what_to_plot2 == "Daily"
			ystate = boxcar(difference(county_state_range.Cases), parse(Int, 							smooth2))
			xstate = county_state_range.Date[end-length(ystate)+1:end]
		end
		
		if count_ratio == "Ratio"
			ystate = (0 < maximum(ystate)) ? ystate/maximum(ystate) : ystate
		end

		ystate = MyType[ystate...]

		if plot_scale2 == "log"
			ystate[(ystate .≤ 0)] .= missing
		end
		county_plots = plot!(xstate, ystate, c="Gray", label=a_state, ls=:dash)
	end	

	for n = 1:length(the_counties)
		# Filter by county AND state since county names can be duplicated.
		county_data = copy(county_cases_range[n])
		# For special case of American Samoa with zero reported cases
		if sum(county_data.Cases) == 0  && plot_scale2 == "log"
			xdata = county_data.Date
			ydata = ones(length(xdata))
		elseif what_to_plot2 == "Total"
			xdata = copy(county_data.Date)
			ydata = copy(county_data.Cases)
		elseif what_to_plot2 =="Daily"
			ydata = difference(county_data.Cases)
			xdata = county_data.Date[end-length(ydata)+1:end]
		end
		
		if count_ratio == "Ratio"
			ydata /= (0 < maximum(ydata)) ? maximum(ydata) : 1
		end
		
		ydata = MyType[ydata...]
		if plot_scale2 == "log"
			ydata[(ydata .≤ 0)] .= missing
		end
		ydata = boxcar(ydata, parse(Int, smooth2))
		xdata = county_data.Date[end-length(ydata)+1:end]

		
		county_plots = plot!(xdata, ydata, label="$(the_counties[n])")
	end
	
	y_label = (count_ratio == "Count") ? "Number of Cases" : "Percentage of Maximum"
	plot(county_plots, xlabel="Date", ylabel=y_label)
end

# ╔═╡ 0896dc34-365f-11eb-25c7-bd720f55b31d
md"# Some maps!"

# ╔═╡ eddf43c0-776a-11eb-0521-336765a7a312
md"### All maps use the VegaLite package"

# ╔═╡ 1ce84bf0-365f-11eb-252c-197607715a76
us10m = dataset("us-10m");

# ╔═╡ 5728b2e0-38a9-11eb-2dad-3503868cdf35
alt_names = [replace(name, "/" => "_") for name in names(covid_confirmed_us)[12:end]];

# ╔═╡ cafbdd70-38a0-11eb-03a4-1124bfdd9dc3
function date_frame(dataframe)
	dct = Dict()
	for (i, name) in enumerate(names(dataframe))
		if i < 12
			dct[name] = dataframe[:, i]
		else
			alt_name = replace(name, "/" => "_")
			cases = Float64.(dataframe[:, i])
			cases[(cases .==0)] .= 1
			dct[alt_name] = log10.(cases)
		end
	end
	
	return DataFrame(dct)
end;

# ╔═╡ 3649c522-776b-11eb-171b-3bfd793616b4
date_data = date_frame(covid_confirmed_us);

# ╔═╡ 6331c9b2-3892-11eb-10b4-d7309d028703
function usa_plot(the_data, column)
	@vlplot(width=500, height=300) +
	@vlplot(
		mark={
			:geoshape,
			fill=:white,
			stroke=:darkgray
		},
		data={
			values=us10m,
			format={
				type=:topojson,
				feature=:states
			}
		},
		projection={type=:albersUsa}
	) +
	@vlplot(
		:geoshape,
		width=500, height=300,
		data={
			values=us10m,
			format={
				type=:topojson,
				feature=:counties
			}
		},
		transform=[{
			lookup=:id,
			from={
				data=the_data,
				key=:FIPS,
				fields=[column]
			}
		}],
		projection={
			type=:albersUsa
		},
		color={column*":q",
			scale={domain=[0, 5], scheme="reds"}}
	)
end;

# ╔═╡ e0d58c2a-6491-11eb-0d32-e5d18873d26a
md"### WARNING: UPDATING THIS MAP IS A BIT SLOW!"

# ╔═╡ 70e8bcb8-3965-11eb-000c-55bbe767b98f
md"""
**Date** $(@bind ind_usa Slider(1:(length(date_data[1,12:end])), default=(length(date_data[1, 12:end])))) 
""";

# ╔═╡ 540552aa-38b1-11eb-0d10-47125198dd3c
usa_plot(date_data, alt_names[end])

# ╔═╡ a59fc2c0-8d62-11eb-33b4-05ee116a0be4
function select_states(data, states)
	indices = zeros(Int, length(date_data.Province_State))
	for state in states
		indices += date_data.Province_State .== state
	end
	@assert unique(indices) ∈ ([0], [1], [0, 1], [1, 0])  " If an index ∉ (0, 1), then something is wrong"
	
	return Bool.(indices)
end;

# ╔═╡ f34335d4-38b7-11eb-338f-19d210a15f60
md"""### States to Map
$(@bind states_to_map MultiSelect(vcat([""], states)))
"""

# ╔═╡ 791350fa-38b7-11eb-1431-cba8440b6af2
md"""### $([states_to_map[i]*",   " for i = 1:length(states_to_map)]...) """

# ╔═╡ 5aafc1c0-38a8-11eb-13b1-350b67a918e4
md"""
**Date** $(@bind ind Slider(1:(length(date_data[1,12:end])), default=length(date_data[1,12:end]))) 
"""

# ╔═╡ 31629ca8-38a9-11eb-156b-21ce93990fbc
function show_map(the_data, column)
	@vlplot(width=500, height=300) +
	@vlplot(
		mark={:geoshape,
			  stroke=:darkgray
			  },
		data={
			values=us10m,
			format={
				type=:topojson,
				feature=:counties
			}
		},
		transform=[{
			lookup=:id,
			from={
				data=the_data,
				key=:FIPS,
				fields=[column]
			}
		}],
		color={column*":q",
			scale={domain=[0, 5], scheme="reds"}}
	)
end;

# ╔═╡ 209630d6-38a9-11eb-18ec-855a833905b3
show_map(date_data[select_states(date_data, states_to_map), :], alt_names[ind])

# ╔═╡ Cell order:
# ╠═11b6f756-921a-11eb-1623-7d59b0eacc37
# ╟─869489e0-8d61-11eb-158a-b72ed06a72bc
# ╟─0466536c-8d60-11eb-26a3-b3ee18f9def3
# ╠═040cf9c2-8e30-11eb-2ada-cfd94f33f549
# ╟─e9e23032-8d60-11eb-2398-f91242fb3c17
# ╟─2ae29774-8d64-11eb-2b5f-439867054365
# ╟─3c4cac24-8d63-11eb-206c-751e06065314
# ╟─0cbf869c-8d64-11eb-2cf1-8d9691e28094
# ╟─ebb3989e-2b43-11eb-1b42-355ccf52223d
# ╟─eded10b2-9219-11eb-22f1-fd73bea5058a
# ╟─940b688c-9219-11eb-0f5b-e7248ace8146
# ╟─5b065066-8d61-11eb-370b-317f5e1dcfb0
# ╠═907776a8-648e-11eb-00c2-4d1e34a543e0
# ╠═31ee5dc6-2903-11eb-1a98-63b264ae3e60
# ╠═47d408a4-2903-11eb-34ef-85edab54f790
# ╠═37df93dc-2903-11eb-06ab-ebb0c6134ea7
# ╠═6fe736cc-2903-11eb-0fe3-899e79473814
# ╠═ee3dad02-2904-11eb-254d-b3be41e3ca62
# ╠═fbc65be0-2a71-11eb-245d-9f57dc0c8d3b
# ╠═bdf5c960-2b3c-11eb-1f90-39ff304637cb
# ╠═cdf108f6-2a70-11eb-0cb7-6311491140ca
# ╟─bc8516b4-2d88-11eb-3057-2b764954891c
# ╟─b30ff62e-2d85-11eb-224d-d5f27e7551cc
# ╟─d7b24d3e-2b3b-11eb-022f-7bb38bdcc775
# ╟─75d1293c-2b40-11eb-20f7-f3ea15093f20
# ╟─b0745148-2a68-11eb-084c-310c312b32ad
# ╟─532f0cf2-921a-11eb-1004-c71928b38711
# ╟─5803b06e-921a-11eb-33d1-d5350e6549ba
# ╟─5ae28a58-921a-11eb-20f9-f54f015ff652
# ╟─52c3d7fa-3644-11eb-2d71-653aef1e09b1
# ╟─238ce10a-364b-11eb-24de-b11a4bebde06
# ╟─cb24dd58-2d88-11eb-23ab-59a1a869132c
# ╟─e8a18338-2d8b-11eb-0ce6-2d4c7f9f20bd
# ╟─df792c14-2d88-11eb-3286-5f53f927e546
# ╟─e77f6cca-2d88-11eb-3edd-c9ee58cc52b7
# ╟─b9ea336c-2d88-11eb-093c-7ba8f8ca1c7d
# ╟─d01a0bec-2d8a-11eb-2b2b-87753a9aa8be
# ╟─df95c908-2d8a-11eb-3471-dd1d200869a4
# ╟─b79fefdc-2d8a-11eb-1cf1-f5c70aca7988
# ╟─48536d04-364d-11eb-20a7-4f4a766800fd
# ╟─0a654a7c-364c-11eb-3849-3b00f67f8704
# ╟─0e5fa0e8-2d94-11eb-266a-a71e73886f8d
# ╟─a84aa814-364b-11eb-0e4d-9748b8b24a12
# ╟─0896dc34-365f-11eb-25c7-bd720f55b31d
# ╟─eddf43c0-776a-11eb-0521-336765a7a312
# ╟─1ce84bf0-365f-11eb-252c-197607715a76
# ╟─5728b2e0-38a9-11eb-2dad-3503868cdf35
# ╟─cafbdd70-38a0-11eb-03a4-1124bfdd9dc3
# ╟─3649c522-776b-11eb-171b-3bfd793616b4
# ╟─6331c9b2-3892-11eb-10b4-d7309d028703
# ╟─e0d58c2a-6491-11eb-0d32-e5d18873d26a
# ╟─70e8bcb8-3965-11eb-000c-55bbe767b98f
# ╟─540552aa-38b1-11eb-0d10-47125198dd3c
# ╟─a59fc2c0-8d62-11eb-33b4-05ee116a0be4
# ╟─f34335d4-38b7-11eb-338f-19d210a15f60
# ╟─791350fa-38b7-11eb-1431-cba8440b6af2
# ╟─5aafc1c0-38a8-11eb-13b1-350b67a918e4
# ╟─209630d6-38a9-11eb-18ec-855a833905b3
# ╟─31629ca8-38a9-11eb-156b-21ce93990fbc

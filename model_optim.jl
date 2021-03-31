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

# ╔═╡ f33c2974-17ab-11eb-12e7-a521d49103c4
begin
	using BenchmarkTools
	using CSV
	using LaTeXStrings
	using NearestNeighbors
	using Plots
	using PlutoUI
	using Random
end

# ╔═╡ ba50154e-7b56-11eb-04be-a91d7f4a5706
br = html"<br>";

# ╔═╡ c19579a2-7b56-11eb-127b-097cebc46537
bigbr = html"<br><br><br><br><br>";

# ╔═╡ f2e4f634-7b56-11eb-2fba-15b44cd41c47
html"<button onclick=present()>Present</button>"

# ╔═╡ 94ab7fa2-8d5f-11eb-3786-dba45227791e
md"""# Modeling and Optimization
### An epidemic example"""

# ╔═╡ dc15c564-7b53-11eb-301f-f921cb788603
md"""
## Want all the details?

#### This talk is based on the free, online course "Computational Thinking with Julia" available from [juliaacademy.com](https://www.juliaacademy.com)

$br

#### Lecture notes and problem sets (.ipynb and .pdf) are available at [https://github.com/mitmath/6S083/](https://github.com/mitmath/6S083/)

$br

#### An updated and expanded version of the course called "Introduction to Computational Thinking" is available at [https://computationalthinking.mit.edu/Spring21/](https://computationalthinking.mit.edu/Spring21/)

"""


# ╔═╡ 6a5213e8-8d5e-11eb-0d2f-71e54e83af0b
br

# ╔═╡ 46386db8-8d5e-11eb-3880-e1f69327f17e
md"## Further reading:"

# ╔═╡ 5c91bfae-8d60-11eb-3dfa-fdf2fc83859d
br

# ╔═╡ 5e88ab08-8d60-11eb-396e-39185e93bad5
md"#### [Algorithms for Optimization](https://algorithmsbook.com/optimization/) by Kochenderfer & Wheeler"

# ╔═╡ 4b092114-8d60-11eb-3d24-6d496ab4bdd4
br

# ╔═╡ 4c1f75c6-8d60-11eb-1a7f-7b9b19fdd5c8
md"#### [Algorithms for Decision Making](https://algorithmsbook.com/) by Kochenderfer, Wheeler, & Wray"

# ╔═╡ a2ceea4e-9226-11eb-1a73-09c47e408423
md"# The Procedure
### 1. Develop a computer model to simulate reality
### 2. Establish a theoretical foundation to explain results
### 3. Compare the computer model to the theory
"

# ╔═╡ 458054f8-72ba-11eb-2ce0-bb9a3dd9b68c
md"""# The Random Walk Model

#### Let N "agents" randomly move within a square of side L.
$br
#### For true "agent-based modeling" (ABM), use [Agents.jl](https://juliadynamics.github.io/Agents.jl/stable/examples/zombies/).
"""

# ╔═╡ c7e7d416-72ba-11eb-09cb-6180a237f2ac
md"## First define the walkers and their methods."

# ╔═╡ 352d2586-72bf-11eb-2cc8-07f1740b207a
md"""#### Use an "enumerated type" to keep track of infection status"""

# ╔═╡ 6bd8530c-72bb-11eb-1013-13c4695b89af
@enum InfectionStatus S I R

# ╔═╡ 6d4079b6-72db-11eb-0519-81eca7d185e0
"""
Initialize arrays of walkers and their statuses

	N - number of agents per cluster
	centers - Center points of clusters, Tuple of tuples
	L - Box size for simulation
"""
function initialize(N, L, rng)
	positions = rand(rng, 1-L:L-1, (2, N))  # Spread agents out across board
	positions = positions .+ (rand(rng, 2, N) .- 0.5)  # Give each agent a unique pos
	
	states = [S for i = 1:N]
	states[1] = I
	return positions, states
end;

# ╔═╡ a652d51c-72bf-11eb-1ce4-277f7c2ea32d
"""
Walk a single point by a random amount.
"""
function walk(x, y, L, rng)
	i = randn(rng)
	j = randn(rng)
	
	# move walkers by random amount
	x += i
	y += j
	
	# if the posision exceeds the boundary L, then move back
	if L ≤ abs(x)  || L ≤ abs(y)
		x -= i
		y -= j
	end
	
	return x, y
end	;

# ╔═╡ dc1f7df6-72df-11eb-0212-5d77bc8ae246
"""
Walk method that accepts a 1x2 array or a 2-tuple as input.
"""
walk(array::Union{Array, Tuple}, L, rng) = walk(array[1], array[2], L, rng);

# ╔═╡ 5ae3d010-72d6-11eb-2583-292e42886b87
"""
Get the trajectory of a random walker over N time steps.
"""
function trajectory(N, L=200, rng=MersenneTwister(convert(Int, 1e9*time())))
	# Pre-allocate array for efficiency
	path = Array{Tuple{Float64, Float64}, 1}(undef, N)
	# Start at the origin
	path[1] = (0.0, 0.0)
	# Do the walk
	for i = 2:N
		path[i] = walk(path[i-1], L, rng)
	end
	return path
end;

# ╔═╡ 01925350-72c3-11eb-026b-679e68973606
# Make an array of 10 walkers
walkers = [trajectory(20_000) for i in 1:10]

# ╔═╡ 3e506536-7b59-11eb-1bdc-3be5fb62a168
bigbr

# ╔═╡ 46d83f4e-7b59-11eb-07b4-a7c7cac59ade
bigbr

# ╔═╡ 82cb35e4-7b57-11eb-3e69-55f9803d13d6
@bind step_number Slider(1:length(walkers[1]), default=1, show_value=true)

# ╔═╡ 6b0724b6-72c1-11eb-0d96-b3b344d646a7
function plot_walk(N)
	pp = plot(xlim=[-200, 200], ylim=[-200, 200], legend=false)
	for i=1:length(walkers)
		pp = plot!(walkers[i][1:N], alpha=0.8)
	end
	pp = hline!([0], ls=:dash, c="gray", label="")
	pp = vline!([0], ls=:dash, c="gray", label="")
	return pp
end;

# ╔═╡ 858f2db0-7b57-11eb-174f-c16acfa1b790
plot_walk(step_number)

# ╔═╡ 6638c06c-72d9-11eb-0f72-1904ce49ac88
md"""## The Simulation"""

# ╔═╡ 9c865320-72d7-11eb-3bd6-47b5decdb246
md"""### Define close contacts using NearestNeighbors.jl"""

# ╔═╡ c92f4c7a-398b-11eb-3776-87cf0abec89e
"""
Convenience function combining `BallTee` creation and `inrange` functions.
"""
encounters(contacts, individual, radius) = inrange(BallTree(contacts), individual, radius);

# ╔═╡ ece3bdba-7b67-11eb-0e44-6993ed69ccc1
bigbr

# ╔═╡ 6a6fcf2c-72d9-11eb-063e-3d9f52711834
md"### step! sweep! sim!"

# ╔═╡ f109842e-7b67-11eb-0e92-ab3578c6fdc7
md"
#### One `step!` moves one agent in one time step.
#### One `sweep!` moves all agents *on average* in one time `step`
#### One `simulation` is a series of time `sweep`s
"

# ╔═╡ 64444a58-3989-11eb-20fd-df6a47321efa
function step!(positions, states, N, L, pᵢ, pᵣ, radius, rng::MersenneTwister)
	# Pick an agent at random
	i = rand(rng, 1:N)
	# Give infected agents a chance to recover before infecting others
	if states[i] == I
		if rand(rng) ≤ pᵣ
			states[i] = R
		end
	end
	
	# Move the agent to a new location
	xy = walk(positions[:, i], L, rng)
	positions[1, i]  = xy[1]
	positions[2, i]  = xy[2]
	
	# If the agent is still infected
	if states[i] == I
		# Determine close contacts
		contacts = encounters(positions, positions[:, i], radius)
		# Remove self
		contacts = contacts[(contacts .≠ i)]
		# For each contact, 
		for contact in contacts
			# Give a chance to infect if susceptible
			if states[contact] == S
				if rand(rng) ≤ pᵢ
					states[contact] = I
				end
			end
		end
	end
	
	return positions, states
end;

# ╔═╡ b2b8410a-0fbb-11eb-1b3f-bf2c759c8ffb
function sweep!(positions, states, N, L, pᵢ, pᵣ, radius, rng::MersenneTwister)
	for n = 1:N
		step!(positions, states, N, L, pᵢ, pᵣ, radius, rng)
	end
	return positions, states
end;

# ╔═╡ dfd3da3c-398c-11eb-108a-c169d4bdcc57
function simulation(Sw, N, L, pᵢ, pᵣ, radius, rng=MersenneTwister(convert(Int, 1e9*time())))
	system = Dict(
		  "S" => Sw,  # Number of sweeps ("days")
		  "N" => N,  # Number of agents
		  "L" => L,  # Length of bounding box for agents
		  "pᵢ" => pᵢ,  # Infection probability
		  "pᵣ" => pᵣ,  # Recovery probability
		  "positions" => [],  # Positions per sweep
		  "states" => [],  # States per sweep
		  "susceptible" => Int[],  # Number of susceptible agents at step n
		  "infected" => Int[],	# Number of infected agents at step n
		  "recovered" => Int[])  # Number of recovered agents at step n
	
	
	positions, states = initialize(N, L, rng)
	# Large sim threshold for saving movement history
	thresh = 1e5
	if Sw*N < thresh
		push!(system["positions"], deepcopy(positions))
	end
	push!(system["states"], deepcopy(states))
	push!(system["susceptible"], sum(states .== S))
	push!(system["infected"], sum(states .== I))
	push!(system["recovered"], sum(states .== R))
	
	for n=2:Sw
		sweep!(positions, states, N, L, pᵢ, pᵣ, radius, rng)
		if Sw*N < thresh
			push!(system["positions"], deepcopy(positions))
		end
		push!(system["states"], deepcopy(states))
		push!(system["susceptible"], sum(states .== S))
		push!(system["infected"], sum(states .== I))
		push!(system["recovered"], sum(states .== R))
	end
	return system
end;

# ╔═╡ 1d4cb604-72ea-11eb-1631-2f5d2e055818
md"#### Visualize it"

# ╔═╡ 1867b196-72e7-11eb-3f1e-bd594cddad9d
med_sim = simulation(100, 800, 20, 0.3, 0.05, 1);

# ╔═╡ 0bcfcffe-3a3e-11eb-13b2-a93b5c4c9653
begin 
	md"""$(@bind sweep_number Slider(1:med_sim["S"], show_value=true))"""
end

# ╔═╡ 28cb215c-3986-11eb-013b-ed83b172d97e
# Plot agents with boundary of length L
function visualize_agents(sim, i)
	L = sim["L"]
	positions = sim["positions"][i]
	states = sim["states"][i]
	susceptible = positions[:, (states .== S)]
	infected =  positions[:, (states .== I)]
	recovered = positions[:, (states .== R)]
	p = scatter(title="Day: $sweep_number", xlim=[-L, L], ylim=[-L, L], aspect_ratio=:equal, xticks=false, yticks=false)
	p = scatter!(susceptible[1, :], susceptible[2, :], label="S", c="#4083D8")
	p = scatter!(infected[1, :], infected[2, :], c="#CB3C33", label="I")
	p = scatter!(recovered[1, :], recovered[2, :], c="#389826", label="R")
	return p
end;

# ╔═╡ 698747d2-0fbc-11eb-360f-1774d82c00e5
visualize_agents(med_sim, sweep_number)

# ╔═╡ 36fc32ea-9168-11eb-1185-9196b86e1609
bigbr

# ╔═╡ 0a4e8eee-760d-11eb-06cf-6388515c468a
# "Big" Simulation parameters
begin
	days = 500
	N = 1500
	boxsize = 30 
	prob_i = 0.1
	prob_r = 0.02
	cluster_rad = 2.5
end;

# ╔═╡ 449afdf0-72e9-11eb-0325-efc576e32526
sim = simulation(days, N, boxsize, prob_i, prob_r, cluster_rad)

# ╔═╡ bb0a0974-179a-11eb-2a23-ef7be76655eb
begin
	plot(1:length(sim["susceptible"]), sim["susceptible"], label="S", ylim=[0, sim["susceptible"][1]+1])
	plot!(1:length(sim["susceptible"]), sim["infected"], label="I")
	plot!(1:length(sim["susceptible"]), sim["recovered"], label="R")
end

# ╔═╡ 691fe0b2-7540-11eb-2707-2548cba441c7
md"## The SIR Model"

# ╔═╡ 485a165c-7542-11eb-1776-b973ccd87f0f
md"""
### Has three states:

- **Susceptible**
- **Infectious**
- **Recovered**

#### The time evolution of these states can be described by a set of ordinary differential equations.
"""

# ╔═╡ 1754f54c-75ea-11eb-3558-2b311eb561c0
L"""\frac{dS}{dt} = - \beta S(t) I(t)"""

# ╔═╡ 1d7d0290-75ea-11eb-051a-736b4813aef8
L"\frac{dI}{dt} = \beta S(t) I(t) - \gamma I(t)"

# ╔═╡ 1e512082-75ea-11eb-38fc-1988c2c1d176
L"\frac{dR}{dt} = \gamma I(t)"

# ╔═╡ 4cac5810-9229-11eb-1cda-1107a10c503d
br

# ╔═╡ a11a8682-75ec-11eb-2135-c18b7de74385
md"#### The approximate solution can be taken in small time steps."

# ╔═╡ d241978c-7d21-11eb-029f-0bb0e363de66
L"""S(t+h) ≈ S(t) - h\beta S(t) I(t)"""

# ╔═╡ d842a876-7d21-11eb-1c10-27bae0905a44
L"I(t+h) \approx I(t) + h[\beta S(t) I(t) - \gamma I(t)]"

# ╔═╡ d874d0c4-7d21-11eb-3b3b-b3dbfb9728cb
L"R(t+h) \approx (t) + h \gamma I(t)"

# ╔═╡ d0408486-75ea-11eb-054f-056cc79390ee
"""
Get the approximate solution to the SIR ODE equations.
"""
function euler_SIR(S₀, I₀, R₀, β, γ, h, T)
	# get the total number of timesteps to use
	n = ceil(Int, T/h)
	# Pre-allocate the arrays
	t = collect(1:h:n)
	
	S = Array{Float64, 1}(undef, n)
	I = Vector{Float64}(undef, n)
	R = zeros(Float64, n)
	
	S[1] = S₀
	I[1] = I₀
	R[1] = R₀

	for i = 1:(n-1)
		t[i+1] = t[i] + h
		S[i+1] = S[i] - h*(β*S[i]*I[i])
		I[i+1] = I[i] + h*(β*S[i]*I[i] - γ*I[i])
		R[i+1] = R[i] + h*γ*I[i]
	end
	return [t, S, I, R]
end;

# ╔═╡ 81c13822-75eb-11eb-2183-090a781e367b
test = euler_SIR(0.9999, 0.0001, 0.0, 0.2, 0.01, 1, 500)

# ╔═╡ 866ea8d2-75eb-11eb-2594-992b2af15e35
begin
	plot(test[1], test[2], label="S")
	plot!(test[1], test[3], label="I")
	plot!(test[1], test[4], label="R")
end

# ╔═╡ c82bfd82-7542-11eb-1193-435166ed8a81
md"## Optimizing with Gradient Descent"

# ╔═╡ f0f84a72-9162-11eb-101a-179c2dddcdf0
plot(x -> ((x+1)^4 - 4(x + 1)^3), label="error", xlabel="β (parameter to optimize)", ylabel="error = model(β) - data")

# ╔═╡ b12c2ea8-9168-11eb-042f-81dbc757bbeb
md"### Use derivatives of a function to find its mininmum."

# ╔═╡ a71cabe0-9163-11eb-1c79-6108da9a4290
bigbr

# ╔═╡ af6f8702-7540-11eb-1271-bfd9d4afa42d
md"####  The derivative of a function can be approximated as:"

# ╔═╡ 12870ad0-75ee-11eb-1e13-654d35359428
L"\frac{df}{dx}(a) \approx \frac{f(a + h) - f(a)}{h}"

# ╔═╡ 5103060e-9169-11eb-3f86-272318c0b136
f(x) = x^3 - x^2 + x - 1

# ╔═╡ 6275ec82-75ee-11eb-0ea2-a3eb39fa0c04
deriv(f, a, h=1.0e-5) = (f(a+h) - f(a))/h  # Forward difference

# ╔═╡ 657d23ce-75ee-11eb-0447-2d7ba11c1571
function tangent_line(f, x, a; h=1.0e-5)
	# y = m*(x-a) + b(a) <- equation of line through a
	df = x -> deriv(f, a, h)  # for all values of x, input deriv at `a`
	b = f(a)  # y-intercept at a
	m = df(a) # slope at a

	return m*(x-a) + b # Equation of line at a
end

# ╔═╡ a3b1c458-75ee-11eb-31ad-09abd945b620
md"""`a = ` $(@bind a Slider(-5:5, show_value=true))"""

# ╔═╡ 7dcd8ba2-75ee-11eb-22f6-898ad6add9db
begin
	plot(x -> f(x), -5, 5, lw=3, xlim=[-5, 5], ylim=[-150, 150], leg=false)
	plot!(x -> tangent_line(f, x, a), a-3, a+3, lw=3)
end

# ╔═╡ e4af1a0a-915f-11eb-09da-57d648aa3417
bigbr

# ╔═╡ c6df1a2c-75f6-11eb-0f8e-15a967788eee
md"### Extending to 2-D with the gradient, ∇"

# ╔═╡ 73fd539e-915f-11eb-2837-5bfaa12049b3
md"#### For a function `g(x, y)`, the gradient is a vector of partial derivatives with respect to `x` and `y`."

# ╔═╡ 0d2b0c28-9160-11eb-1b20-71af6757416e
L"g(x,y ) = x^2 + y^3"

# ╔═╡ 2bae88b4-9160-11eb-26f1-e1266a03270a
L"\frac{\partial g}{\partial x} = 2x"

# ╔═╡ 3f26e620-9160-11eb-3fdb-49332323f5e6
L"\frac{\partial g}{\partial y} = 3y"

# ╔═╡ ca8c7736-9160-11eb-3ec2-d9e12752a23b
L"""
∇g(x, y)  = 
\left( \begin{array}\\
	\partial g / \partial x \\
	\partial g / \partial y \\
\end{array} \right) 
= 
\left( \begin{array}\\
	2x \\
	3y \\
\end{array} \right)"""

# ╔═╡ 7d2f31e8-9160-11eb-2c44-7b0c5cd39e29
L"""
∇g(2, 5)  =
\left( \begin{array}\\
	2(2) \\
	3(5) \\
\end{array} \right) 
= 
\left( \begin{array}\\
	4 \\
	75 \\
\end{array} \right)"""

# ╔═╡ 13b86c3c-9162-11eb-0688-a5caef011929
br

# ╔═╡ d660d484-9169-11eb-135d-6d9348176a6b
g(x, y) = x^2 + y^3;

# ╔═╡ d39dae70-9169-11eb-2611-8d442626fdcb
dx(f, a, b; h= 1e-5) = deriv(x -> f(x, b), a, h);

# ╔═╡ dacd5748-9169-11eb-154c-2fca8f14bdc0
dy(f, a, b; h= 1e-5) = deriv(y -> f(a, y), b, h);

# ╔═╡ e217db6a-9169-11eb-297b-a3934b4860c0
gradient(f, a, b; h=1e-5) = [dx(f, a, b, h=h), dy(f, a, b, h=h)];

# ╔═╡ 7aeb967a-75f8-11eb-2fec-9b79a3734348
gradient(g, 2, 5)

# ╔═╡ 82783666-9162-11eb-172d-2517d782894f
bigbr

# ╔═╡ ba86d0d8-75f8-11eb-3457-019339561059
md"### Gradient descent optimization in 1-D"

# ╔═╡ c88d1eb4-75f8-11eb-29f2-178865e25eb0
function descent_1d(f, x0, η=0.01; max_iter=100_000)
	# Calculate the derivative of the input function
	df = y -> deriv(f, y)
	
	# x-values of the descent
	x = Float64[x0]
	
	count = 1  # Set a counter to help break the loop
	while count < max_iter
		# Chaning the sign of η simplifies the code later
		ξ = (0 < df(x[end])) ? -η : η
		
		# Trying to get around inflection point problem
		# by computing ahead in batches
		xᵢ = [x[end] + n*ξ for n = 1:5]  # next 10 points
		fxᵢ = f.(xᵢ)  # Calculate the function value for the points
		dfdxᵢ = abs.(df.(xᵢ))  # Calculate the derivatives for the points
		
		# Find the index of the minimum value  of the derivative
		min_ind = findfirst(dfdxᵢ .== minimum(dfdxᵢ))  # Min dfdx index
		
		# Add x values to the array up to the minimum df/dx value
		x = vcat(x, xᵢ[1:min_ind])
		
		# If the smallest value of f(x) is not at the end,
		# then the minimum has already been reached.
		fxᵢ[end] ≠ minimum(fxᵢ) && break
		
		count += 1
	end
	
	return x
end;

# ╔═╡ 5bbba006-9164-11eb-1f6f-8762cfd135dc
bigbr

# ╔═╡ 38691de8-75fa-11eb-0b3c-ff6427df8d4a
md"#### Let's try it out!"

# ╔═╡ 3f45b004-75fa-11eb-246f-73182d510a89
foo(x) = x^4 + 3x^3 + 5;

# ╔═╡ 21115a44-75f9-11eb-326b-91bc23064b90
begin
	x0_field = @bind x0 NumberField(-3.5:0.1:1.5, default=1)
	md"x₀ = $x0_field"
end

# ╔═╡ 9847c3fe-917a-11eb-180b-49f8fa486d76
x_descent = descent_1d(foo, x0)

# ╔═╡ 9d5f9ee8-917a-11eb-1e68-e3cece06b8b6
y_descent = foo.(x_descent)

# ╔═╡ 2de39a6e-75f9-11eb-0098-d3f3cc369efa
begin
	index_slider = @bind index Slider(1:1:length(x_descent), default=1)
	md"index = 1 $index_slider $(length(x_descent))"
end

# ╔═╡ 221f3866-75f9-11eb-1d2c-79e44eebc3a1
begin
	plot(foo, -3.5, 1.5, xlim=[-3.5, 1.5], leg=false, title="step = $index")
	scatter!([x_descent[index]], [y_descent[index]])
end

# ╔═╡ c47173e6-9164-11eb-1897-05182261851c
bigbr

# ╔═╡ 2b13bf12-7600-11eb-0f5c-3fb76a34af90
md"## Carl Friedrich Gauss walks into a bar..."

# ╔═╡ 4ea28a4e-7600-11eb-0e1e-ada97a4cba0f
md"### and tries to fit his data."

# ╔═╡ 92acd926-9165-11eb-042f-d1f742c9bf97
br

# ╔═╡ ada96fa0-9179-11eb-264b-571b2f6dd0ac
L" \mathcal{G} = \frac{A}{\sigma \sqrt{2\pi}}e^{\frac{-(x - \mu)^2}{2\sigma^2}}"

# ╔═╡ 6ec67e5a-7600-11eb-2e6f-bb7650fbf871
gaussian(x, μ=0, σ=1) = 50/(σ*√(2π))*ℯ^(-(x - μ)^2/(2σ^2));

# ╔═╡ ec31f8a0-7600-11eb-0e5b-d38b05a8772a
noisy_gaussian(x, μ=0, σ=1) = gaussian(x, μ, σ) + randn();

# ╔═╡ c4d2223a-9165-11eb-3953-9f23146c774b
bigbr

# ╔═╡ e0d16f0a-917a-11eb-32e2-297a85124a92
md"### Gradient descent optimization in 2-D"

# ╔═╡ d7eab534-917a-11eb-1936-9fb9b2705e08
function gradient_descent_2d(f, x0, y0; n=100_000)
	# Define the step size
	η = 1.0e-4
	# Pre-allocate an array of ones (will be overwritten)
	descent = ones(Float64, (n, 2))
	# Add the starting point to the first array entry
	descent[1, :] = [x0, y0]
	# This step avoids cyclic references (a Pluto thing)
	max_i = copy(n)
	# Loop through until the minimum is found
	# OR max iterations is reached
	for i=1:n-1
		# Calculate the gradient of the point
		grad = gradient(f, descent[i, :]...)
		# For each direction (x, y)
		for j=1:2
			if grad[j] == 0  # If the grad is zero, 
				descent[i+1, j] = descent[i, j]  # Just add the point
			elseif grad[j] > 0   # If the grad is +, 
				descent[i+1, j] = descent[i, j] - η  # Then step backward
			elseif grad[j] < 0  # If the grad is -, 
				descent[i+1, j] = descent[i, j] + η  # Then step forward
			end
		end
		
		if i > 2
			# If the point tries to oscillate back-and-forth,
			# then it's a minimum, so quit.
			pos1 = descent[i, :]  # Current position
			pos2 = descent[i-2, :]  # Position two steps ago
			if pos1 == pos2  # If they're equal,
				max_i = i-2  # then the minimum has been reached
				break        # so quit.
			end
		end
	end
	return descent[1:max_i, :]
end;

# ╔═╡ 3589da38-7607-11eb-1cd9-c178c8ecfc2c
md"""### Use gradient descent to "learn" μ and σ"""

# ╔═╡ 1d026a02-7607-11eb-0b9a-5f113d78191e
mu = 5; sigma = 0.6;

# ╔═╡ 610a5a56-7d1f-11eb-2640-996b4131e9cb
xg = -10:0.005:10

# ╔═╡ fff36d3e-7600-11eb-3649-bd84517626df
yg = gaussian.(xg, mu, sigma)

# ╔═╡ bc658bac-7601-11eb-25e5-2b15e6248e13
begin
	xng = sort(collect(0:1:10) .+ (rand(11)*2 .- 1))
	yng = noisy_gaussian.(xng, mu, sigma)
end

# ╔═╡ 8a4ed8f4-7600-11eb-189f-910c126095fb
begin
	plot(xg, yg, xlims=[-1, 10], label="Ideal")
	plot!(xng, yng, m=:o, label="noisy")
end

# ╔═╡ f264b596-9165-11eb-0fd0-838b9d17c173
bigbr

# ╔═╡ 6c82fc2c-7602-11eb-385b-7fb9c47899fc
md"#### The `loss` function measures how much the model deviates from the data."

# ╔═╡ 54a06472-7603-11eb-1e2e-6d0f4e3af5a4
loss(μ=0, σ=1) = log(sum((gaussian.(xng, μ, σ) .- yng).^2));  # Log of sum squared error

# ╔═╡ 6e366d08-9179-11eb-0de7-d18b4714a7d9
xμ = -2:0.1:10;

# ╔═╡ 79798d96-9179-11eb-0867-cddafee4503f
yσ = 0.2:0.1:6.0;

# ╔═╡ 802d09ec-9179-11eb-1ebf-2d54dcf7d0db
z(b, a) = loss(a, b)

# ╔═╡ 89d1742e-9179-11eb-0e0d-f302bfe075b5
br

# ╔═╡ 68d91fa6-9179-11eb-17ac-a9c479d0b68b
plot(yσ, xμ, (xμ, yσ) -> z(xμ, yσ), st=[:surface], camera=(45, 50), leg=false, xlabel="σ", ylabel="μ", zlabel="loss", title=""" "Loss Landscape" """)

# ╔═╡ 9491e9b6-9179-11eb-1b5d-fbf4a993283f
bigbr

# ╔═╡ 21ea259e-7604-11eb-02a2-15e8005c3d7a
md"####  Passing `loss` into `gradient_descent` selects parameters that drive it towards zero."


# ╔═╡ d0935c4e-7606-11eb-183b-af331fe9b4aa
params = gradient_descent_2d(loss, 0, 1);

# ╔═╡ eadafe8a-7607-11eb-1e1d-832cfebb14e6
md"""
step = $(@bind asd Slider(1:1:size(params)[1], default=1, show_value=true))
"""

# ╔═╡ d7278d86-9176-11eb-06c7-37ef9484ea20
begin
	p1 = contour(xμ, yσ, (xμ, yσ) -> loss(xμ, yσ), levels=35, leg=false, xlabel="μ", ylabel="σ", title="""Loss "landscape" """)
	p1 = plot!(params[1:asd, 1], params[1:asd, 2], lw=2, c=:magenta)
	p1 = scatter!([params[asd, 1]], [params[asd, 2]], marker = (:diamond, 5, 1.0, :cyan, stroke(1, 1.0, :black, :dot)))
	
	p2 = plot(xg, yg, xlim=[-5, 10], ylim=[-1, 35], label=false,title="""μ=$(rpad(round(params[asd, 1], digits=2), 4, "0")) | σ=$(rpad(round(params[asd, 2], digits=2), 4, "0"))""")
	p2 = plot!(xng, yng, m=:o, label=false)
	p2 = plot!(xg, gaussian.(xg, params[asd, 1], params[asd, 2]), label="Model")
	plot(p1, p2, layout=(1,2))
end

# ╔═╡ 8b755e6e-7609-11eb-1ae4-c19d51adb5f1
md"## How does our SIR model measure up?"

# ╔═╡ 169140fa-760a-11eb-3010-3f2eb843939b
md"### Need to redo the loss function"

# ╔═╡ 219f71c4-760a-11eb-0efd-5fff8a2f64af
sse(x_data, x_theory) = sum((x_theory .- x_data).^2);  # Sum of squared error

# ╔═╡ 28c32aae-760a-11eb-0f2e-d128cef6301a
function loss_sir(β, γ) 
	model_values = euler_SIR(0.9999, 0.0001, 0.0, β, γ, 1, length(sim["susceptible"]))
	
	# One loss value for each state
	Lₛ = sse(sim["susceptible"], model_values[2])
	Lᵢ = sse(sim["infected"], model_values[3])
	Lᵣ = sse(sim["recovered"], model_values[4])
	
	return Lₛ + 4*Lᵢ + Lᵣ  # Put the most weight on the infectious curve
end;

# ╔═╡ 7e2fc4de-9167-11eb-2db4-3f956e99f12c
bigbr

# ╔═╡ b9b7db2c-760a-11eb-164c-addf3f1b5b84
begin
	beta_field = @bind beta NumberField(0:0.1:1.0, default=0.1)
	gamma_field = @bind gamma NumberField(0:0.01:0.1, default=0.0)
	md"β = $beta_field γ = $gamma_field"
end

# ╔═╡ 9ecf5452-760a-11eb-159f-1d234fca5850
ode_params = gradient_descent_2d(loss_sir, beta, gamma, n=10_000)

# ╔═╡ b6a82d60-760a-11eb-3c48-ad0d4eccf2d2
begin
	md"step = 1 $(@bind ind Slider(1:1:size(ode_params)[1], default=1)) $(size(ode_params)[1])"
end

# ╔═╡ af78c1e2-760a-11eb-1bcd-8d60b4cf80cf
ode_descent = euler_SIR(0.9999, 0.0001, 0.0, ode_params[ind, 1], ode_params[ind, 2], 1, length(sim["susceptible"]))*N;

# ╔═╡ b15c217c-760a-11eb-2de8-eb47264ab173
begin
	plot(ode_descent[1], sim["susceptible"], lw=3, label="S", title="""Descent step: $(lpad(ind, 4, " "))""")
	plot!(ode_descent[1], sim["infected"], lw=3, label="I")
	plot!(ode_descent[1], sim["recovered"], lw=3, label="R")
	plot!(ode_descent[1], ode_descent[2], lw=2, ls=:dash, label="S fit")
	plot!(ode_descent[1], ode_descent[3], lw=2, ls=:dash, label="I fit")
	plot!(ode_descent[1], ode_descent[4], lw=2, ls=:dash, label="R fit")	
end

# ╔═╡ b8272854-7b90-11eb-0f89-a931c35bfdc6
md"""
### Fit Parameters
#### β = $(rpad(round(ode_params[ind, 1], digits=4), 6, "0"))
#### γ =  $(rpad(round(ode_params[ind, 2], digits=4), 6, "0"))
"""

# ╔═╡ Cell order:
# ╠═f33c2974-17ab-11eb-12e7-a521d49103c4
# ╠═ba50154e-7b56-11eb-04be-a91d7f4a5706
# ╠═c19579a2-7b56-11eb-127b-097cebc46537
# ╠═f2e4f634-7b56-11eb-2fba-15b44cd41c47
# ╟─94ab7fa2-8d5f-11eb-3786-dba45227791e
# ╟─dc15c564-7b53-11eb-301f-f921cb788603
# ╟─6a5213e8-8d5e-11eb-0d2f-71e54e83af0b
# ╟─46386db8-8d5e-11eb-3880-e1f69327f17e
# ╟─5c91bfae-8d60-11eb-3dfa-fdf2fc83859d
# ╟─5e88ab08-8d60-11eb-396e-39185e93bad5
# ╟─4b092114-8d60-11eb-3d24-6d496ab4bdd4
# ╟─4c1f75c6-8d60-11eb-1a7f-7b9b19fdd5c8
# ╟─a2ceea4e-9226-11eb-1a73-09c47e408423
# ╟─458054f8-72ba-11eb-2ce0-bb9a3dd9b68c
# ╟─c7e7d416-72ba-11eb-09cb-6180a237f2ac
# ╟─352d2586-72bf-11eb-2cc8-07f1740b207a
# ╠═6bd8530c-72bb-11eb-1013-13c4695b89af
# ╠═6d4079b6-72db-11eb-0519-81eca7d185e0
# ╠═a652d51c-72bf-11eb-1ce4-277f7c2ea32d
# ╠═dc1f7df6-72df-11eb-0212-5d77bc8ae246
# ╠═5ae3d010-72d6-11eb-2583-292e42886b87
# ╠═01925350-72c3-11eb-026b-679e68973606
# ╟─3e506536-7b59-11eb-1bdc-3be5fb62a168
# ╟─46d83f4e-7b59-11eb-07b4-a7c7cac59ade
# ╟─858f2db0-7b57-11eb-174f-c16acfa1b790
# ╟─82cb35e4-7b57-11eb-3e69-55f9803d13d6
# ╟─6b0724b6-72c1-11eb-0d96-b3b344d646a7
# ╟─6638c06c-72d9-11eb-0f72-1904ce49ac88
# ╟─9c865320-72d7-11eb-3bd6-47b5decdb246
# ╠═c92f4c7a-398b-11eb-3776-87cf0abec89e
# ╟─ece3bdba-7b67-11eb-0e44-6993ed69ccc1
# ╟─6a6fcf2c-72d9-11eb-063e-3d9f52711834
# ╟─f109842e-7b67-11eb-0e92-ab3578c6fdc7
# ╠═64444a58-3989-11eb-20fd-df6a47321efa
# ╠═b2b8410a-0fbb-11eb-1b3f-bf2c759c8ffb
# ╠═dfd3da3c-398c-11eb-108a-c169d4bdcc57
# ╟─1d4cb604-72ea-11eb-1631-2f5d2e055818
# ╟─28cb215c-3986-11eb-013b-ed83b172d97e
# ╠═1867b196-72e7-11eb-3f1e-bd594cddad9d
# ╟─0bcfcffe-3a3e-11eb-13b2-a93b5c4c9653
# ╟─698747d2-0fbc-11eb-360f-1774d82c00e5
# ╟─36fc32ea-9168-11eb-1185-9196b86e1609
# ╠═0a4e8eee-760d-11eb-06cf-6388515c468a
# ╠═449afdf0-72e9-11eb-0325-efc576e32526
# ╟─bb0a0974-179a-11eb-2a23-ef7be76655eb
# ╟─691fe0b2-7540-11eb-2707-2548cba441c7
# ╟─485a165c-7542-11eb-1776-b973ccd87f0f
# ╟─1754f54c-75ea-11eb-3558-2b311eb561c0
# ╟─1d7d0290-75ea-11eb-051a-736b4813aef8
# ╟─1e512082-75ea-11eb-38fc-1988c2c1d176
# ╟─4cac5810-9229-11eb-1cda-1107a10c503d
# ╟─a11a8682-75ec-11eb-2135-c18b7de74385
# ╟─d241978c-7d21-11eb-029f-0bb0e363de66
# ╟─d842a876-7d21-11eb-1c10-27bae0905a44
# ╟─d874d0c4-7d21-11eb-3b3b-b3dbfb9728cb
# ╠═d0408486-75ea-11eb-054f-056cc79390ee
# ╠═81c13822-75eb-11eb-2183-090a781e367b
# ╟─866ea8d2-75eb-11eb-2594-992b2af15e35
# ╟─c82bfd82-7542-11eb-1193-435166ed8a81
# ╟─f0f84a72-9162-11eb-101a-179c2dddcdf0
# ╟─b12c2ea8-9168-11eb-042f-81dbc757bbeb
# ╟─a71cabe0-9163-11eb-1c79-6108da9a4290
# ╟─af6f8702-7540-11eb-1271-bfd9d4afa42d
# ╟─12870ad0-75ee-11eb-1e13-654d35359428
# ╠═5103060e-9169-11eb-3f86-272318c0b136
# ╠═6275ec82-75ee-11eb-0ea2-a3eb39fa0c04
# ╠═657d23ce-75ee-11eb-0447-2d7ba11c1571
# ╟─7dcd8ba2-75ee-11eb-22f6-898ad6add9db
# ╟─a3b1c458-75ee-11eb-31ad-09abd945b620
# ╟─e4af1a0a-915f-11eb-09da-57d648aa3417
# ╟─c6df1a2c-75f6-11eb-0f8e-15a967788eee
# ╟─73fd539e-915f-11eb-2837-5bfaa12049b3
# ╟─0d2b0c28-9160-11eb-1b20-71af6757416e
# ╟─2bae88b4-9160-11eb-26f1-e1266a03270a
# ╟─3f26e620-9160-11eb-3fdb-49332323f5e6
# ╟─ca8c7736-9160-11eb-3ec2-d9e12752a23b
# ╟─7d2f31e8-9160-11eb-2c44-7b0c5cd39e29
# ╟─13b86c3c-9162-11eb-0688-a5caef011929
# ╠═d660d484-9169-11eb-135d-6d9348176a6b
# ╠═d39dae70-9169-11eb-2611-8d442626fdcb
# ╠═dacd5748-9169-11eb-154c-2fca8f14bdc0
# ╠═e217db6a-9169-11eb-297b-a3934b4860c0
# ╠═7aeb967a-75f8-11eb-2fec-9b79a3734348
# ╟─82783666-9162-11eb-172d-2517d782894f
# ╟─ba86d0d8-75f8-11eb-3457-019339561059
# ╠═c88d1eb4-75f8-11eb-29f2-178865e25eb0
# ╟─5bbba006-9164-11eb-1f6f-8762cfd135dc
# ╟─38691de8-75fa-11eb-0b3c-ff6427df8d4a
# ╠═3f45b004-75fa-11eb-246f-73182d510a89
# ╠═9847c3fe-917a-11eb-180b-49f8fa486d76
# ╠═9d5f9ee8-917a-11eb-1e68-e3cece06b8b6
# ╟─221f3866-75f9-11eb-1d2c-79e44eebc3a1
# ╟─21115a44-75f9-11eb-326b-91bc23064b90
# ╟─2de39a6e-75f9-11eb-0098-d3f3cc369efa
# ╟─c47173e6-9164-11eb-1897-05182261851c
# ╟─2b13bf12-7600-11eb-0f5c-3fb76a34af90
# ╟─4ea28a4e-7600-11eb-0e1e-ada97a4cba0f
# ╟─92acd926-9165-11eb-042f-d1f742c9bf97
# ╟─ada96fa0-9179-11eb-264b-571b2f6dd0ac
# ╠═6ec67e5a-7600-11eb-2e6f-bb7650fbf871
# ╠═ec31f8a0-7600-11eb-0e5b-d38b05a8772a
# ╟─c4d2223a-9165-11eb-3953-9f23146c774b
# ╟─e0d16f0a-917a-11eb-32e2-297a85124a92
# ╠═d7eab534-917a-11eb-1936-9fb9b2705e08
# ╟─3589da38-7607-11eb-1cd9-c178c8ecfc2c
# ╠═1d026a02-7607-11eb-0b9a-5f113d78191e
# ╠═610a5a56-7d1f-11eb-2640-996b4131e9cb
# ╠═fff36d3e-7600-11eb-3649-bd84517626df
# ╠═bc658bac-7601-11eb-25e5-2b15e6248e13
# ╟─8a4ed8f4-7600-11eb-189f-910c126095fb
# ╟─f264b596-9165-11eb-0fd0-838b9d17c173
# ╟─6c82fc2c-7602-11eb-385b-7fb9c47899fc
# ╠═54a06472-7603-11eb-1e2e-6d0f4e3af5a4
# ╠═6e366d08-9179-11eb-0de7-d18b4714a7d9
# ╠═79798d96-9179-11eb-0867-cddafee4503f
# ╠═802d09ec-9179-11eb-1ebf-2d54dcf7d0db
# ╟─89d1742e-9179-11eb-0e0d-f302bfe075b5
# ╟─68d91fa6-9179-11eb-17ac-a9c479d0b68b
# ╟─9491e9b6-9179-11eb-1b5d-fbf4a993283f
# ╟─21ea259e-7604-11eb-02a2-15e8005c3d7a
# ╠═d0935c4e-7606-11eb-183b-af331fe9b4aa
# ╟─d7278d86-9176-11eb-06c7-37ef9484ea20
# ╟─eadafe8a-7607-11eb-1e1d-832cfebb14e6
# ╟─8b755e6e-7609-11eb-1ae4-c19d51adb5f1
# ╟─169140fa-760a-11eb-3010-3f2eb843939b
# ╠═219f71c4-760a-11eb-0efd-5fff8a2f64af
# ╠═28c32aae-760a-11eb-0f2e-d128cef6301a
# ╠═9ecf5452-760a-11eb-159f-1d234fca5850
# ╟─af78c1e2-760a-11eb-1bcd-8d60b4cf80cf
# ╟─7e2fc4de-9167-11eb-2db4-3f956e99f12c
# ╟─b15c217c-760a-11eb-2de8-eb47264ab173
# ╟─b8272854-7b90-11eb-0f89-a931c35bfdc6
# ╟─b6a82d60-760a-11eb-3c48-ad0d4eccf2d2
# ╟─b9b7db2c-760a-11eb-164c-addf3f1b5b84

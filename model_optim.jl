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
	using Tables
end

# ╔═╡ 1b06c2c0-72ba-11eb-0e6b-4915c70eb1b8
md"""# Modeling and Optimization
### A COVID epidemic example (obviously)"""

# ╔═╡ 458054f8-72ba-11eb-2ce0-bb9a3dd9b68c
md"## The Random Walk"

# ╔═╡ c7e7d416-72ba-11eb-09cb-6180a237f2ac
md"### First define the walkers and their methods."

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
function initialize(N, L)
	positions = rand(1-L:L-1, (2, N))  # Spread agents out across board
	positions = positions .+ (rand(2, N) .- 0.5)  # Give each agent a unique pos
	
	states = [S for i = 1:N]
	states[1] = I
	return positions, states
end

# ╔═╡ a652d51c-72bf-11eb-1ce4-277f7c2ea32d
function walk(x, y, L)
	i, j = randn(2)

	if abs(x + i) ≤ L && abs(y + j) ≤ L
		x += i
		y += j
	end
	
	return x, y
end	

# ╔═╡ dc1f7df6-72df-11eb-0212-5d77bc8ae246
walk(array::Array, L) = walk(array[1], array[2], L)

# ╔═╡ 5ae3d010-72d6-11eb-2583-292e42886b87
function trajectory(N)
	L = 200
	path = Array{Tuple{Float64, Float64}, 1}(undef, N)
	path[1] = (0.0, 0.0)
	for i = 2:N
		path[i] = walk(path[i-1]..., L)
	end
	return path
end

# ╔═╡ 01925350-72c3-11eb-026b-679e68973606
walkers = [trajectory(10_000) for i in 1:10]

# ╔═╡ c705b79e-72c3-11eb-25a9-9dcee69b9ae7
@bind step_number Slider(1:10_000, default=1, show_value=true)

# ╔═╡ 6b0724b6-72c1-11eb-0d96-b3b344d646a7
begin
	pp = plot(xlim=[-200, 200], ylim=[-200, 200], legend=false)
	for i=1:length(walkers)
		pp = plot!(walkers[i][1:step_number], alpha=0.8)
	end
	pp = hline!([0], ls=:dash, c="gray", label="")
	pp = vline!([0], ls=:dash, c="gray", label="")
	pp
end

# ╔═╡ 6638c06c-72d9-11eb-0f72-1904ce49ac88
md"""## The Simulation"""

# ╔═╡ 9c865320-72d7-11eb-3bd6-47b5decdb246
md"""### Define close contacts"""

# ╔═╡ c92f4c7a-398b-11eb-3776-87cf0abec89e
encounters(contacts, individual, radius) = inrange(BallTree(contacts), individual, radius)

# ╔═╡ 6a6fcf2c-72d9-11eb-063e-3d9f52711834
md"### step! sweep! sim!"

# ╔═╡ 64444a58-3989-11eb-20fd-df6a47321efa
function step!(positions, states, N, L, pᵢ, pᵣ, radius)
	# Pick an agent at random
	i = rand(1:N)
	# Give infected agents a chance to recover before infecting others
	if (states[i] == I)
		if rand() ≤ pᵣ
			states[i] = R
		end
	end
	
	# Move the agent to a new location
	positions[:, i]  .= walk(positions[:, i], L)
	
	# If the agent is still infected
	if states[i] == I
		# Determine close contacts
		contacts = encounters(positions, positions[:, i], radius)
		# Remove self
		contacts = contacts[(contacts .≠ i)]
		# For each contact, 
		for contact in contacts
			if states[contact] == S
				if rand() ≤ pᵢ
					states[contact] = I
				end
			end
		end
	end
	
	return positions, states
end	

# ╔═╡ b2b8410a-0fbb-11eb-1b3f-bf2c759c8ffb
function sweep!(positions, states, N, L, pᵢ, pᵣ, radius)
	for n = 1:N
		step!(positions, states, N, L, pᵢ, pᵣ, radius)
	end
	return positions, states
end

# ╔═╡ dfd3da3c-398c-11eb-108a-c169d4bdcc57
function simulation(Sw, N, L, pᵢ, pᵣ, radius)
	system = Dict(
		  "S" => Sw,  # Number of sweeps ("days")
		  "N" => N,  # Number of agents per cluster
		  "L" => L,  # Length of bounding box for agents
		  "pᵢ" => pᵢ,  # Infection probability
		  "pᵣ" => pᵣ,  # Recovery probability
		  "positions" => [],  # Positions per sweep
		  "states" => [],  # States per sweep
		  "susceptible" => Int[],
		  "infected" => Int[],
		  "recovered" => Int[])
	
	
	positions, states = initialize(N, L)
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
		sweep!(positions, states, N, L, pᵢ, pᵣ, radius)
		if Sw*N < thresh
			push!(system["positions"], deepcopy(positions))
		end
		push!(system["states"], deepcopy(states))
		push!(system["susceptible"], sum(states .== S))
		push!(system["infected"], sum(states .== I))
		push!(system["recovered"], sum(states .== R))
	end
	return system
end

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
end

# ╔═╡ 698747d2-0fbc-11eb-360f-1774d82c00e5
visualize_agents(med_sim, sweep_number)

# ╔═╡ 0a4e8eee-760d-11eb-06cf-6388515c468a
N = 1500

# ╔═╡ 449afdf0-72e9-11eb-0325-efc576e32526
sim = simulation(300, N, 25, 0.3, 0.03, 1.5)

# ╔═╡ bb0a0974-179a-11eb-2a23-ef7be76655eb
begin
	plot(1:length(sim["susceptible"]), sim["susceptible"], label="S", ylim=[0, sim["susceptible"][1]+1])
	plot!(1:length(sim["susceptible"]), sim["infected"], label="I")
	plot!(1:length(sim["susceptible"]), sim["recovered"], label="R")
end

# ╔═╡ 691fe0b2-7540-11eb-2707-2548cba441c7
md"## Modeling the problem"

# ╔═╡ 485a165c-7542-11eb-1776-b973ccd87f0f
md"""
### The SIR model

#### It has three states:

- **Susceptible**
- **Infectious**
- **Recovered**

#### During an epidemic, the time evolution of these states can be described by a set of ordinary differential equations.
"""

# ╔═╡ 1754f54c-75ea-11eb-3558-2b311eb561c0
L"""\frac{dS}{dt} = - \beta S(t) I(t)"""

# ╔═╡ 1d7d0290-75ea-11eb-051a-736b4813aef8
L"\frac{dI}{dt} = \beta S(t) I(t) - \gamma I(t)"

# ╔═╡ 1e512082-75ea-11eb-38fc-1988c2c1d176
L"\frac{dR}{dt} = \gamma I(t)"

# ╔═╡ a11a8682-75ec-11eb-2135-c18b7de74385
md"#### The approximate solution can be taken in small time steps."

# ╔═╡ d0408486-75ea-11eb-054f-056cc79390ee
function euler_SIR(S₀, I₀, R₀, β, γ, h, T)
	# get the total number of timesteps to use
	n = ceil(Int, T/h)
	# Pre-allocate the arrays
	t = collect(1:h:n)
	S = zeros(Float64, n)
	I = zeros(Float64, n)
	R = zeros(Float64, n)
	S[1] = S₀
	I[1] = I₀
	R[1] = R₀
	# Instead of x_(n+1) = x_n + h*f(x_n)
	# use       x_n = x_(n-1) + h*f(x_(n-1)) for the loop
	for i = 1:(n-1)
		t[i+1] = t[i] + h
		S[i+1] = S[i] - h*(β*S[i]*I[i])
		I[i+1] = I[i] + h*(β*S[i]*I[i] - γ*I[i])
		R[i+1] = R[i] + h*γ*I[i]
	end
	return t, S, I, R
end

# ╔═╡ 81c13822-75eb-11eb-2183-090a781e367b
test = euler_SIR(0.99999, 0.00001, 0.0, 0.1, 0.01, 1, 1000)

# ╔═╡ 866ea8d2-75eb-11eb-2594-992b2af15e35
begin
	plot(test[1], test[2], label="S")
	plot!(test[1], test[3], label="I")
	plot!(test[1], test[4], label="R")
end

# ╔═╡ c82bfd82-7542-11eb-1193-435166ed8a81
md"## Gradient Descent"

# ╔═╡ af6f8702-7540-11eb-1271-bfd9d4afa42d
md"####  The derivative of a function can be approximated as:"

# ╔═╡ 12870ad0-75ee-11eb-1e13-654d35359428
L"\frac{df}{dx}(a) \approx \frac{f(a + h) - f(a)}{h}"

# ╔═╡ 6275ec82-75ee-11eb-0ea2-a3eb39fa0c04
function deriv(f, a, h=1.0e-5)
	df = (f(a+h) - f(a))/h
	return df
end

# ╔═╡ 657d23ce-75ee-11eb-0447-2d7ba11c1571
function tangent_line(f, x, a; h=1.0e-5)
	# y = mx+b = m*(x-0)+b(0)  <- equation of line through zero
	# y = m*(x-a) + b(a) <- equation of line through a
	df = x -> deriv(f, a, h)  # for all values of x, input deriv at `a`
	b = f(a)  # y-intercept at a
	m = df(a) # slope at a

	return m*(x-a) + b # Equation of line at a
end

# ╔═╡ bf20b7f0-75ee-11eb-3a2a-8dd725cc6a28
f(x) = x^3 - x^2 + x - 1

# ╔═╡ a3b1c458-75ee-11eb-31ad-09abd945b620
md"""`a = ` $(@bind a html"<input type=range min=-5 max=5>")"""

# ╔═╡ 7dcd8ba2-75ee-11eb-22f6-898ad6add9db
begin
	plot(x -> f(x), -5, 5, lw=3, xlim=[-5, 5], ylim=[-150, 150], leg=false)
	plot!(x -> tangent_line(f, x, a), a-3, a+3, lw=3)
end

# ╔═╡ c6df1a2c-75f6-11eb-0f8e-15a967788eee
md"### Extending to two-dimensions"

# ╔═╡ 02a249b4-75f7-11eb-3520-db02e9eeec02
dx(f, a, b; h= 1e-5) = deriv(x -> f(x, b), a, h)

# ╔═╡ 068a4d8e-75f7-11eb-0bb2-7f12a4119695
dy(f, a, b; h= 1e-5) = deriv(y -> f(a, y), b, h)

# ╔═╡ 1b87e428-75f7-11eb-3b3f-218496b54845
g(x, y) = x^2 + y^3 

# ╔═╡ 2c792fda-75f7-11eb-168e-a769cb09480b
dx(g, 2, 5)  # dg/dx = 2x -> dg/dx(2) = 4

# ╔═╡ 42983676-75f7-11eb-1017-3fab9bfba287
dy(g, 2, 5, h=1e-9)  # dg/dy = 3y^2 -> dg/dy(5) = 75

# ╔═╡ 0f864310-75f8-11eb-3789-3f118e9a8e9b
md"#### The gradient is the vector of the derivatives."

# ╔═╡ 29163be6-75f8-11eb-1ba6-d94211437e41
gradient(f, a, b; h=1e-5) = [dx(f, a, b, h=h), dy(f, a, b, h=h)]

# ╔═╡ 7aeb967a-75f8-11eb-2fec-9b79a3734348
gradient(g, 2, 5)

# ╔═╡ ba86d0d8-75f8-11eb-3457-019339561059
md"### Gradient descent optimization in 1-D"

# ╔═╡ c88d1eb4-75f8-11eb-29f2-178865e25eb0
function descent_1d(f, x0, η=0.01)
	# Calculate the derivative of the input function
	df = y -> deriv(f, y)
	
	# x-values of the descent
	x = Float64[x0]
	
	count = 1  # Set a counter to help break the loop
	while count < 100_000
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
end

# ╔═╡ 38691de8-75fa-11eb-0b3c-ff6427df8d4a
md"##### Let's try it out!"

# ╔═╡ 3f45b004-75fa-11eb-246f-73182d510a89
g1d(x) = x^4 + 3x^3 + 5

# ╔═╡ 21115a44-75f9-11eb-326b-91bc23064b90
begin
	x0_field = @bind x0 NumberField(-3:0.1:1.5, default=1)
	md"x₀ = $x0_field"
end

# ╔═╡ 51f98a34-75fa-11eb-2992-6fb91830f8c0
x_descent = descent_1d(g1d, x0)

# ╔═╡ 56666116-75fa-11eb-2ae7-279570158261
y_descent = g1d.(x_descent)

# ╔═╡ 2de39a6e-75f9-11eb-0098-d3f3cc369efa
begin
	index_slider = @bind index Slider(1:1:length(x_descent), default=1)
	md"index = 1 $index_slider $(length(x_descent))"
end

# ╔═╡ 221f3866-75f9-11eb-1d2c-79e44eebc3a1
begin
	plot(g1d, -3, 1.5, xlim=[-3.5, 1.5], leg=false, title="step = $index")
	scatter!([x_descent[index]], [y_descent[index]])
end

# ╔═╡ 93d0392c-75fb-11eb-33f3-77556669c206
md"### Gradient descent optimization in 2-D"

# ╔═╡ d97332f4-75fb-11eb-30c8-8d35b8ed912b
# The Himmelblau Function
h(x, y) = (x^2 + y -11)^2 + (x + y^2 -7)^2

# ╔═╡ eaba5fb0-75fb-11eb-0ec3-631c70bc88b4
x = y = range(-5, stop=5, step=0.1)

# ╔═╡ efd120bc-75fb-11eb-2e97-41e4142a13c7
plot(x, y, (x,y) -> h(x, y), st=[:surface], camera=(75, 40))

# ╔═╡ b4c2719a-75fb-11eb-22ee-55c9086e1bc3
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
end

# ╔═╡ 125e7092-75fc-11eb-3fb9-696de0f9f5a2
begin
	xi_field = @bind xi NumberField(-3:0.1:3.0, default=0)
	yi_field = @bind yi NumberField(-3:0.1:3.0, default=0)
	md"x₀ = $xi_field y₀ = $yi_field"
end

# ╔═╡ c31cbe30-75fb-11eb-234c-138aee6e47d3
himgrad = gradient_descent_2d(h, xi, yi)

# ╔═╡ 162402aa-75fc-11eb-1121-c3e764476b6f
begin
	n_slider = @bind n Slider(1:1:size(himgrad)[1], default=1)
	md"index = 1 $n_slider $(size(himgrad)[1])"
end

# ╔═╡ 0b9e2630-75fc-11eb-065e-3d1026f16048
begin
	contour(x, y, (x,y) -> h(x, y), levels=60, title="Step number: $n", leg=false)
	plot!(himgrad[1:n, 1], himgrad[1:n, 2], lw=2, c=:magenta)
	scatter!([himgrad[n, 1]], [himgrad[n, 2]], marker = (:diamond, 5, 1.0, :cyan, stroke(1, 1.0, :black, :dot)))
end

# ╔═╡ 2b13bf12-7600-11eb-0f5c-3fb76a34af90
md"## Optimization"

# ╔═╡ 4ea28a4e-7600-11eb-0e1e-ada97a4cba0f
md"### Carl Friedrich Gauss walks into a bar...

### ...and tries to fit his data.
"

# ╔═╡ 6ec67e5a-7600-11eb-2e6f-bb7650fbf871
gaussian(x; A=50, μ=0, σ=1) = A/(σ*√(2π))*ℯ^(-(x - μ)^2/(2σ^2))

# ╔═╡ ec31f8a0-7600-11eb-0e5b-d38b05a8772a
noisy_gaussian(x; A=50, μ=0, σ=1) = gaussian(x, A=A, μ=μ, σ=σ) + randn()

# ╔═╡ 3589da38-7607-11eb-1cd9-c178c8ecfc2c
md"""#### Try to "learn" these paramters"""

# ╔═╡ 1d026a02-7607-11eb-0b9a-5f113d78191e
mu = 5; sigma = 0.6

# ╔═╡ fff36d3e-7600-11eb-3649-bd84517626df
begin
	xg = 0:0.005:10
	yg = gaussian.(xg, μ=mu, σ=sigma)
end

# ╔═╡ bc658bac-7601-11eb-25e5-2b15e6248e13
begin 
	xng = collect(0:1:10) .+ rand(11)
	yng = noisy_gaussian.(xng, μ=mu, σ=sigma)
end

# ╔═╡ 8a4ed8f4-7600-11eb-189f-910c126095fb
begin
	plot(xg, yg)
	plot!(xng, yng, m=:o)
end

# ╔═╡ 6c82fc2c-7602-11eb-385b-7fb9c47899fc
md"""### The `loss` and best fit

#### The `loss` function is measure of how far the model is away from the ideal solution.
"""

# ╔═╡ 54a06472-7603-11eb-1e2e-6d0f4e3af5a4
loss(μ=0, σ=1) = sum((gaussian.(xng, μ=μ, σ=σ) .- yng).^2)  # Total squared error

# ╔═╡ 21ea259e-7604-11eb-02a2-15e8005c3d7a
md"####  Passing `loss` into `gradient_descent` selects parameters that drive it to zero (or so we hope)."


# ╔═╡ d0935c4e-7606-11eb-183b-af331fe9b4aa
params = gradient_descent_2d(loss, 0, 1);

# ╔═╡ eadafe8a-7607-11eb-1e1d-832cfebb14e6
md"step = $(@bind asd Slider(1:1:size(params)[1], default=1))"

# ╔═╡ e4663cea-7607-11eb-2443-b3ffd77ab200
begin
	plot(xg, yg, ylim=[0, 35], label="μ=$(rpad(round(mu, digits=2), 4, '0')) | σ=$(rpad(round(sigma, digits=2), 4, '0'))")
	plot!(xng, yng, ylim=[0, 35], m=:o, label="μ=$(rpad(round(mu, digits=2), 4, '0')) | σ=$(rpad(round(sigma, digits=2), 4, '0'))")
	plot!(xg, gaussian.(xg, A=50, μ=params[asd, 1], σ=params[asd, 2]), label="μ=$(round(params[asd, 1], digits=2)) | σ=$(round(params[asd, 2], digits=2))")
end

# ╔═╡ 8b755e6e-7609-11eb-1ae4-c19d51adb5f1
md"## How does our SIR model measure up?"

# ╔═╡ 169140fa-760a-11eb-3010-3f2eb843939b
md"### Need to redo the loss function"

# ╔═╡ 219f71c4-760a-11eb-0efd-5fff8a2f64af
tse(x_data, x_theory) = sum((x_theory .- x_data).^2)

# ╔═╡ 28c32aae-760a-11eb-0f2e-d128cef6301a
function loss_sir(β, γ) 
	starting_solution = euler_SIR(0.9999, 0.0001, 0.0, β, γ, 1, length(sim["susceptible"]))

	Lₛ = tse(sim["susceptible"], starting_solution[2])
	Lᵢ = tse(sim["infected"], starting_solution[3])
	Lᵣ = tse(sim["recovered"], starting_solution[4])
	
	return Lₛ + 4*Lᵢ + Lᵣ
end

# ╔═╡ fec7fa4a-760c-11eb-1e50-274f6ad70cb5
length(sim["susceptible"])

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
ode_descent = euler_SIR(0.9999, 0.0001, 0.0, ode_params[ind, 1], ode_params[ind, 2], 1, length(sim["susceptible"])).*N

# ╔═╡ b15c217c-760a-11eb-2de8-eb47264ab173
begin
	plot(ode_descent[1], sim["susceptible"], lw=3, label="S", title="Descent step: $ind")
	plot!(ode_descent[1], sim["infected"], lw=3, label="I")
	plot!(ode_descent[1], sim["recovered"], lw=3, label="R")
	plot!(ode_descent[1], ode_descent[2], lw=2, ls=:dash, label="S fit")
	plot!(ode_descent[1], ode_descent[3], lw=2, ls=:dash, label="I fit")
	plot!(ode_descent[1], ode_descent[4], lw=2, ls=:dash, label="R fit")
	
end

# ╔═╡ Cell order:
# ╠═f33c2974-17ab-11eb-12e7-a521d49103c4
# ╟─1b06c2c0-72ba-11eb-0e6b-4915c70eb1b8
# ╟─458054f8-72ba-11eb-2ce0-bb9a3dd9b68c
# ╟─c7e7d416-72ba-11eb-09cb-6180a237f2ac
# ╟─352d2586-72bf-11eb-2cc8-07f1740b207a
# ╠═6bd8530c-72bb-11eb-1013-13c4695b89af
# ╠═6d4079b6-72db-11eb-0519-81eca7d185e0
# ╠═a652d51c-72bf-11eb-1ce4-277f7c2ea32d
# ╠═dc1f7df6-72df-11eb-0212-5d77bc8ae246
# ╠═5ae3d010-72d6-11eb-2583-292e42886b87
# ╠═01925350-72c3-11eb-026b-679e68973606
# ╟─6b0724b6-72c1-11eb-0d96-b3b344d646a7
# ╟─c705b79e-72c3-11eb-25a9-9dcee69b9ae7
# ╟─6638c06c-72d9-11eb-0f72-1904ce49ac88
# ╟─9c865320-72d7-11eb-3bd6-47b5decdb246
# ╠═c92f4c7a-398b-11eb-3776-87cf0abec89e
# ╟─6a6fcf2c-72d9-11eb-063e-3d9f52711834
# ╠═64444a58-3989-11eb-20fd-df6a47321efa
# ╠═b2b8410a-0fbb-11eb-1b3f-bf2c759c8ffb
# ╠═dfd3da3c-398c-11eb-108a-c169d4bdcc57
# ╟─1d4cb604-72ea-11eb-1631-2f5d2e055818
# ╠═28cb215c-3986-11eb-013b-ed83b172d97e
# ╠═1867b196-72e7-11eb-3f1e-bd594cddad9d
# ╟─0bcfcffe-3a3e-11eb-13b2-a93b5c4c9653
# ╠═698747d2-0fbc-11eb-360f-1774d82c00e5
# ╠═0a4e8eee-760d-11eb-06cf-6388515c468a
# ╠═449afdf0-72e9-11eb-0325-efc576e32526
# ╠═bb0a0974-179a-11eb-2a23-ef7be76655eb
# ╟─691fe0b2-7540-11eb-2707-2548cba441c7
# ╟─485a165c-7542-11eb-1776-b973ccd87f0f
# ╟─1754f54c-75ea-11eb-3558-2b311eb561c0
# ╟─1d7d0290-75ea-11eb-051a-736b4813aef8
# ╟─1e512082-75ea-11eb-38fc-1988c2c1d176
# ╟─a11a8682-75ec-11eb-2135-c18b7de74385
# ╠═d0408486-75ea-11eb-054f-056cc79390ee
# ╟─81c13822-75eb-11eb-2183-090a781e367b
# ╠═866ea8d2-75eb-11eb-2594-992b2af15e35
# ╟─c82bfd82-7542-11eb-1193-435166ed8a81
# ╟─af6f8702-7540-11eb-1271-bfd9d4afa42d
# ╟─12870ad0-75ee-11eb-1e13-654d35359428
# ╠═6275ec82-75ee-11eb-0ea2-a3eb39fa0c04
# ╠═657d23ce-75ee-11eb-0447-2d7ba11c1571
# ╠═bf20b7f0-75ee-11eb-3a2a-8dd725cc6a28
# ╟─7dcd8ba2-75ee-11eb-22f6-898ad6add9db
# ╟─a3b1c458-75ee-11eb-31ad-09abd945b620
# ╟─c6df1a2c-75f6-11eb-0f8e-15a967788eee
# ╠═02a249b4-75f7-11eb-3520-db02e9eeec02
# ╠═068a4d8e-75f7-11eb-0bb2-7f12a4119695
# ╠═1b87e428-75f7-11eb-3b3f-218496b54845
# ╠═2c792fda-75f7-11eb-168e-a769cb09480b
# ╠═42983676-75f7-11eb-1017-3fab9bfba287
# ╟─0f864310-75f8-11eb-3789-3f118e9a8e9b
# ╠═29163be6-75f8-11eb-1ba6-d94211437e41
# ╠═7aeb967a-75f8-11eb-2fec-9b79a3734348
# ╟─ba86d0d8-75f8-11eb-3457-019339561059
# ╠═c88d1eb4-75f8-11eb-29f2-178865e25eb0
# ╟─38691de8-75fa-11eb-0b3c-ff6427df8d4a
# ╠═3f45b004-75fa-11eb-246f-73182d510a89
# ╠═51f98a34-75fa-11eb-2992-6fb91830f8c0
# ╠═56666116-75fa-11eb-2ae7-279570158261
# ╟─221f3866-75f9-11eb-1d2c-79e44eebc3a1
# ╟─21115a44-75f9-11eb-326b-91bc23064b90
# ╟─2de39a6e-75f9-11eb-0098-d3f3cc369efa
# ╟─93d0392c-75fb-11eb-33f3-77556669c206
# ╠═d97332f4-75fb-11eb-30c8-8d35b8ed912b
# ╠═eaba5fb0-75fb-11eb-0ec3-631c70bc88b4
# ╠═efd120bc-75fb-11eb-2e97-41e4142a13c7
# ╠═b4c2719a-75fb-11eb-22ee-55c9086e1bc3
# ╠═c31cbe30-75fb-11eb-234c-138aee6e47d3
# ╠═0b9e2630-75fc-11eb-065e-3d1026f16048
# ╟─125e7092-75fc-11eb-3fb9-696de0f9f5a2
# ╟─162402aa-75fc-11eb-1121-c3e764476b6f
# ╟─2b13bf12-7600-11eb-0f5c-3fb76a34af90
# ╟─4ea28a4e-7600-11eb-0e1e-ada97a4cba0f
# ╠═6ec67e5a-7600-11eb-2e6f-bb7650fbf871
# ╠═ec31f8a0-7600-11eb-0e5b-d38b05a8772a
# ╟─3589da38-7607-11eb-1cd9-c178c8ecfc2c
# ╠═1d026a02-7607-11eb-0b9a-5f113d78191e
# ╠═fff36d3e-7600-11eb-3649-bd84517626df
# ╠═bc658bac-7601-11eb-25e5-2b15e6248e13
# ╠═8a4ed8f4-7600-11eb-189f-910c126095fb
# ╟─6c82fc2c-7602-11eb-385b-7fb9c47899fc
# ╠═54a06472-7603-11eb-1e2e-6d0f4e3af5a4
# ╟─21ea259e-7604-11eb-02a2-15e8005c3d7a
# ╠═d0935c4e-7606-11eb-183b-af331fe9b4aa
# ╠═e4663cea-7607-11eb-2443-b3ffd77ab200
# ╟─eadafe8a-7607-11eb-1e1d-832cfebb14e6
# ╟─8b755e6e-7609-11eb-1ae4-c19d51adb5f1
# ╟─169140fa-760a-11eb-3010-3f2eb843939b
# ╠═219f71c4-760a-11eb-0efd-5fff8a2f64af
# ╠═28c32aae-760a-11eb-0f2e-d128cef6301a
# ╠═9ecf5452-760a-11eb-159f-1d234fca5850
# ╠═af78c1e2-760a-11eb-1bcd-8d60b4cf80cf
# ╠═fec7fa4a-760c-11eb-1e50-274f6ad70cb5
# ╟─b15c217c-760a-11eb-2de8-eb47264ab173
# ╟─b6a82d60-760a-11eb-3c48-ad0d4eccf2d2
# ╟─b9b7db2c-760a-11eb-164c-addf3f1b5b84

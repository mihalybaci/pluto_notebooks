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

# ╔═╡ b270ab9c-13c6-11eb-242c-bf9d2137f241
begin
	using BenchmarkTools
	using CSV
	using Plots
	using PlutoUI
	using Tables
end

# ╔═╡ 932601dc-13c2-11eb-1f66-01fa74189e55
md"# Problem Set 5"

# ╔═╡ 0f0c0b16-13c3-11eb-266d-4b88ac30bc27
md"### Exercise 1 - Simple Euler Method Integration"

# ╔═╡ 64eb33d6-13c3-11eb-3189-5793967ab489
md"""
dS = -βSI

dI = βSI - γI

dR = γI
"""

# ╔═╡ 666fd5f6-13c6-11eb-35e8-070f7bba560e
zeros(Float64, 3000)

# ╔═╡ 17c4f52c-13c3-11eb-2cfc-791ef6999208
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

# ╔═╡ ac38ec5e-13c5-11eb-374a-0dfd77c8b064
test = euler_SIR(0.9999, 0.0001, 0.0, 0.1, 0.01, 1, 2000)

# ╔═╡ ad16fbd8-13c6-11eb-121e-49acc919f808
begin
	plot(test[1], test[2], label="S")
	plot!(test[1], test[3], label="I")
	plot!(test[1], test[4], label="R")
end

# ╔═╡ 2bb288c0-13c9-11eb-046d-25ecbf7f09c1
md"### Exercise 2 - Numerical Derivatives"

# ╔═╡ edf1b9e2-1455-11eb-30d0-a7a4dd82017c
function deriv(f, a, h=1.0e-5)
	df = (f(a+h) - f(a))/h
	return df
end

# ╔═╡ b86e9df2-1456-11eb-0bf5-ebbd3e4d21a0
md"Test the deriv function with the function:

	f(x) = x³ - x² + x - 1
	f'(x) = 3x² - 2x + 1
"

# ╔═╡ ffd87c12-1456-11eb-28c0-e16664ec937e
f(x) = x^3 - x^2 + x - 1

# ╔═╡ 0edc7874-1457-11eb-155a-b3a7547343bd
df(x) = 3*x^2 - 2*x + 1

# ╔═╡ af0afbb4-1458-11eb-0287-03b943df59a1
function tangent_line(f, x, a; h=1.0e-5)
	# y = mx+b = m*(x-0)+b(0)  <- equation of line through zero
	# y = m*(x-a) + b(a) <- equation of line through a
	df = x -> deriv(f, a, h)  # for all values of x, input deriv at `a`
	b = f(a)  # y-intercept at a
	m = df(a) # slope at a

	return m*(x-a) + b # Equation of line at a
end

# ╔═╡ 3a47e6ac-1458-11eb-24b3-c98a54cf6faf
md"""
`a = ` $(@bind a html"<input type=range min=-5 max=5>")
"""

# ╔═╡ a8938ad2-1465-11eb-1863-455ac7888628
dx(f, a, b) = deriv(x -> f(x, b), a)

# ╔═╡ 931ab97a-1468-11eb-2d51-2ba4041073ed
dy(f, a, b) = deriv(y -> f(a, y), b)

# ╔═╡ f6971dd6-1468-11eb-3641-2f0589424e54
#Create a function f
f(x, y) = x^2 + y

# ╔═╡ 2aa2815e-1457-11eb-3aeb-25a1d9fff6a7
begin
	plot(x -> f(x), -5, 5, lw=3, xlim=[-5, 5], ylim=[-150, 150], leg=false)
#	plot!(x -> df(x), -5, 5, lw=3)
#	plot!(x -> deriv(f, x), -5, 5, lw=3, ls=:dash)
	plot!(x -> tangent_line(f, x, a), a-3, a+3, lw=3)
end

# ╔═╡ 82cb9070-1469-11eb-0e10-714be2ee6b88
dx(f, 3, 10)  # df/dx = 2x + y -> f'(3, 10) = 16

# ╔═╡ 3b6b542a-1469-11eb-0877-6da140a862ab
dy(f, 3, 10)  # df/dy = x -> f'(3, 10) = 3

# ╔═╡ 5a7c1924-146a-11eb-016c-57aee44b7192
gradient(f, a, b) = [dx(f, a, b), dy(f, a, b)]

# ╔═╡ 7b581fc4-146a-11eb-0251-57124f8344a7
gradient(f, 3, 10)

# ╔═╡ b420bb68-146a-11eb-2348-5b9fb30fdee9
md"### Exercise 3 - gradient descent"

# ╔═╡ 4116e1e6-1524-11eb-12b9-232f82139a35
begin
	func(x) = x^3
	dfunc = x -> deriv(func, x)
	ddfunc = x -> deriv(dfunc, x)
	xf = -3:0.1:1
	plot(xf, func.(xf), xlim=[-3, 1.0], ylim=[-10, 10], label="g")
	plot!(xf, dfunc.(xf), label="g'")
	plot!(xf, ddfunc.(xf), label="g''")
	hline!([0], ls=:dash, label="")
	vline!([-2.07], ls=:dash, label="")
	vline!([-0.7], ls=:dash, label="")
	vline!([0], label="", ls=:dash)
end

# ╔═╡ c48bca10-146a-11eb-03de-dd48117efc79
function gradient_descent_1d(f, x0; η = 0.01, ϵ = 0.1)
	df = x -> deriv(f, x)  # First derivative
	df2 = x -> deriv(df, x)  # Second derivative
	
	descent = Float64[x0] # x-values of the descent
	
	count = 1  # Set a counter to help break the loop
	max_count = 300
	while true
		grad = df(descent[end])
		grad2 = df2(descent[end])

		
	
		
		if grad > 0
			push!(descent, descent[end] - η)
		elseif grad < 0
			push!(descent, descent[end] + η)
		end

		
		if max_count < length(descent)
			break
		end
			
		count += 1
		if max_count < count
			break
		end
		

	end
	
	return descent
end

# ╔═╡ f26b43e4-1540-11eb-1808-51a8f0fae5fb
ff = [1 2 3]

# ╔═╡ f65ff2dc-153c-11eb-13bd-896803e5ff43
function descent_1d(f, x0; η = 0.01, ϵ = 0.1)
	df = y -> deriv(f, y)  # First derivative
	d2f = y -> deriv(df, y)  # Second derivative
	
	x = Float64[x0] # x-values of the descent
	
	count = 1  # Set a counter to help break the loop
	while count < 1000
		# Chaning the sign of η simplifies the code later
		ξ = (0 < df(x[end])) ? -η : η
		
		# Trying to get around inflection point problem
		# by computing ahead in batches
		xᵢ = [x[end] + n*ξ for n = 1:10]  # next n points
		fxᵢ = f.(xᵢ)
		dfdxᵢ = abs.(df.(xᵢ))  # Next n 1st derivatives
	
		min_ind = findfirst(dfdxᵢ .== minimum(dfdxᵢ))  # Min dfdx index

		x = vcat(x, xᵢ[1:min_ind])  # Push values to descent
		
		# If the smallest value of f(x) is not at the end,
		# then the minimum has already been reached.
		fxᵢ[end] ≠ minimum(fxᵢ) && break
	end
	
	return x
end

# ╔═╡ dea7a792-1489-11eb-3836-19adda218314
begin
	x0_field = @bind x0 NumberField(-3:0.1:1.5, default=1)
	md"x₀ = $x0_field"
end

# ╔═╡ c38c0754-148a-11eb-2083-6b24bbd810f0
begin
	g(x) = x^4 + 3x^3 + 5
	x_descent = descent_1d(g, x0)
	y_descent = g.(x_descent)
end

# ╔═╡ f43f2b74-148a-11eb-024a-6571ec216e5a
begin
	index_slider = @bind index Slider(1:1:length(x_descent), default=1)
	md"index = 1 $index_slider $(length(x_descent))"
end

# ╔═╡ e0471592-146b-11eb-179d-d764dca90469
begin
	plot(g, -3, 1.5, xlim=[-3.5, 1.5], leg=false, title="step = $index")
	scatter!([x_descent[index]], [y_descent[index]])
end

# ╔═╡ 48ca6118-1477-11eb-348b-611e1beefd0d
function gradient_descent_2d(f, x0, y0; n=100_000)
	η = 1.0e-4
	descent = ones(Float64, (n, 2))
	descent[1, :] = [x0, y0]
	max_i = copy(n)
	for i=1:n-1
		grad = gradient(f, descent[i, :]...)
		for j=1:length(grad)
			if grad[j] == 0
				descent[i+1, j] = descent[i, j]
			elseif grad[j] > 0 
				descent[i+1, j] = descent[i, j] - η
			elseif grad[j] < 0
				descent[i+1, j] = descent[i, j] + η
			end
		end
		if i > 2
			# If trying to return to the same position,
			# then quit
			pos1 = descent[i, :]
			pos2 = descent[i-2, :]
			if pos1 == pos2
				max_i = i-2
				break
			end
		end
	end
	return descent[1:max_i, :]
end

# ╔═╡ 738fc4a4-1546-11eb-3271-1578f2d1265c
begin
	xi_field = @bind xi NumberField(-3:0.1:3.0, default=0)
	yi_field = @bind yi NumberField(-3:0.1:3.0, default=0)
	md"x₀ = $xi_field y₀ = $yi_field"
end

# ╔═╡ ffdea222-1546-11eb-3c41-bffc390d4f6d
begin
	# The Himmelblau Function
	h(x, y) = (x^2 + y -11)^2 + (x + y^2 -7)^2
	x = y = range(-5, stop=5, step=0.1)
	himgrad = gradient_descent_2d(h, xi, yi)
end

# ╔═╡ a48419fa-1476-11eb-1967-054f755d2d83
plot(x, y, (x,y) -> h(x, y), st=[:surface], camera=(75, 40))

# ╔═╡ f9fb23d6-1478-11eb-0743-b760008a479f
begin
	n_slider = @bind n Slider(1:1:size(himgrad)[1], default=1)
	md"index = 1 $n_slider $(size(himgrad)[1])"
end

# ╔═╡ 7a1a3a32-1476-11eb-11fd-571ed9798e80
begin
	contour(x, y, (x,y) -> h(x, y), levels=60, title="Step number: $n", leg=false)
	annotate!(himgrad[n, 1], himgrad[n, 2], "x")
end

# ╔═╡ ee1237e8-1479-11eb-374b-27fc10dee9ef
md"### Exercise 4"

# ╔═╡ 9eb06c22-154d-11eb-32e8-d71664f8db18
function read_the_data()
	xs = Float64[]
	ys = Float64[]
	for row in CSV.File("../problem_sets/some_data.csv", header=["x", "y"], skipto=2)
		push!(xs, row.x)
		push!(ys, row.y)
	end
	return xs, ys
end

# ╔═╡ a1328e48-154e-11eb-173d-ff4d780d9eee
xs, ys = read_the_data()

# ╔═╡ eac7df74-154f-11eb-2f26-bf437213840a
gaussian(x, μ=0, σ=1) = 1/(σ*√(2π))*ℯ^(-(x - μ)^2/(2σ^2))

# ╔═╡ ef632360-154f-11eb-2640-07c309711ce9
loss(μ=0, σ=1) = sum((gaussian.(xs, μ, σ) .- ys).^2) # Hardcoded data!

# ╔═╡ 75518548-1550-11eb-1ced-8501d0d5572c
params = gradient_descent_2d(loss, 0, 1)

# ╔═╡ 18edee94-1551-11eb-06e6-59fb5f372cd9
begin
	param_slider = @bind ps Slider(1:1:size(params)[1], default=1)
	md"index = 1 $param_slider $(size(params)[1])"
end

# ╔═╡ 9cb869e6-154e-11eb-0341-2d84eb4bfad3
begin
	plot(xs, ys, m=:o)
	plot!(xs, gaussian.(xs, params[ps, 1], params[ps, 2]))
end

# ╔═╡ 0c11ac0e-1553-11eb-0487-37dcdd220eea
md"### Additional test"

# ╔═╡ d0fc591e-1551-11eb-1383-8bdeb62d1a0c
xg = -8:0.01:17

# ╔═╡ e464a7de-1551-11eb-13c5-1d4c4dbe5408
yg = gaussian.(xg, 4, 3)

# ╔═╡ 14fda26e-1553-11eb-2af4-1360e87e0a2d
loss2(μ=0, σ=1) = sum((gaussian.(xg, μ, σ) .- yg).^2) # Hardcoded data!

# ╔═╡ 22b70800-1553-11eb-1a24-8932bd366f76
us = gradient_descent_2d(loss2, 0, 1)

# ╔═╡ 5be28f06-1552-11eb-3baa-4185bbec9426
begin
	md"step = $(@bind asd Slider(1:1:size(us)[1], default=1))"
end

# ╔═╡ f84b0a22-1551-11eb-28f2-c1068b246681
begin
	plot(xg, yg, ylim=[0, 0.5], label="μ=4.00 | σ=3.00")
	plot!(xg, gaussian.(xg, us[asd, 1], us[asd, 2]), label="μ=$(round(us[asd, 1], digits=2)) | σ=$(round(us[asd, 2], digits=2))")
end

# ╔═╡ b1bc3afe-1551-11eb-0e28-c1072fd06f96
md"### Exercise 5"

# ╔═╡ ba87d922-184e-11eb-1e83-6da642950441
begin
	sir_data = zeros(Float64, 2000, 4)
	csv_file = CSV.File("ps5_ex5.csv", header=["t", "s", "i", "r"], skipto=2)
	for (i, row) in enumerate(csv_file)
		sir_data[i, 1] = row.t
		sir_data[i, 2] = row.s/4999
		sir_data[i, 3] = row.i/4999
		sir_data[i, 4] = row.r/4999
	end
end

# ╔═╡ 60740e08-1851-11eb-3ade-b3036aeab1e4
mse(x_data, x_theory) = sum((x_theory .- x_data).^2)

# ╔═╡ 212f63c8-184c-11eb-0d10-87f03d76c258
function loss_sir(β, γ) 
	new_solution = euler_SIR(0.9999, 0.0001, 0.0, β, γ, 1, 2000)

	Lₛ = mse(sir_data[:, 2], new_solution[2])
	Lᵢ = mse(sir_data[:, 3], new_solution[3])
	Lᵣ = mse(sir_data[:, 4], new_solution[4])
	
	return Lₛ + 4*Lᵢ + Lᵣ
end

# ╔═╡ eda3e39c-1852-11eb-3964-2175ddedeec2
begin
	beta_field = @bind beta NumberField(0:0.1:1.0, default=0.1)
	gamma_field = @bind gamma NumberField(0:0.01:0.1, default=0.0)
	md"β = $beta_field γ = $gamma_field"
end

# ╔═╡ cfd32330-1859-11eb-1f23-cd3f12d7c602
ode_params = gradient_descent_2d(loss_sir, beta, gamma, n=1000)

# ╔═╡ ddc18458-1854-11eb-31dc-3134b1a624ff
begin
	md"step = 1 $(@bind ind Slider(1:1:size(ode_params)[1], default=1)) $(size(ode_params)[1])"
end

# ╔═╡ e87ad310-1859-11eb-16a5-61b8cc94783a
ode_descent = euler_SIR(0.9999, 0.0001, 0.0, ode_params[ind, 1], ode_params[ind, 2], 1, 2000)

# ╔═╡ e0087386-1852-11eb-1b83-3f1755fcdf36
begin
	plot(sir_data[:, 1], sir_data[:, 2], lw=3, label="S", title="Descent step: $ind")
	plot!(sir_data[:, 1], sir_data[:, 3], lw=3, label="I")
	plot!(sir_data[:, 1], sir_data[:, 4], lw=3, label="R")
	plot!(ode_descent[1], ode_descent[2], lw=2, ls=:dash, label="S fit")
	plot!(ode_descent[1], ode_descent[3], lw=2, ls=:dash, label="I fit")
	plot!(ode_descent[1], ode_descent[4], lw=2, ls=:dash, label="R fit")
	
end

# ╔═╡ Cell order:
# ╟─932601dc-13c2-11eb-1f66-01fa74189e55
# ╠═b270ab9c-13c6-11eb-242c-bf9d2137f241
# ╟─0f0c0b16-13c3-11eb-266d-4b88ac30bc27
# ╟─64eb33d6-13c3-11eb-3189-5793967ab489
# ╠═666fd5f6-13c6-11eb-35e8-070f7bba560e
# ╠═17c4f52c-13c3-11eb-2cfc-791ef6999208
# ╠═ac38ec5e-13c5-11eb-374a-0dfd77c8b064
# ╠═ad16fbd8-13c6-11eb-121e-49acc919f808
# ╟─2bb288c0-13c9-11eb-046d-25ecbf7f09c1
# ╠═edf1b9e2-1455-11eb-30d0-a7a4dd82017c
# ╟─b86e9df2-1456-11eb-0bf5-ebbd3e4d21a0
# ╠═ffd87c12-1456-11eb-28c0-e16664ec937e
# ╠═0edc7874-1457-11eb-155a-b3a7547343bd
# ╠═af0afbb4-1458-11eb-0287-03b943df59a1
# ╟─2aa2815e-1457-11eb-3aeb-25a1d9fff6a7
# ╟─3a47e6ac-1458-11eb-24b3-c98a54cf6faf
# ╠═a8938ad2-1465-11eb-1863-455ac7888628
# ╠═931ab97a-1468-11eb-2d51-2ba4041073ed
# ╠═f6971dd6-1468-11eb-3641-2f0589424e54
# ╠═82cb9070-1469-11eb-0e10-714be2ee6b88
# ╠═3b6b542a-1469-11eb-0877-6da140a862ab
# ╠═5a7c1924-146a-11eb-016c-57aee44b7192
# ╠═7b581fc4-146a-11eb-0251-57124f8344a7
# ╟─b420bb68-146a-11eb-2348-5b9fb30fdee9
# ╠═4116e1e6-1524-11eb-12b9-232f82139a35
# ╠═c48bca10-146a-11eb-03de-dd48117efc79
# ╠═f26b43e4-1540-11eb-1808-51a8f0fae5fb
# ╠═f65ff2dc-153c-11eb-13bd-896803e5ff43
# ╠═c38c0754-148a-11eb-2083-6b24bbd810f0
# ╟─e0471592-146b-11eb-179d-d764dca90469
# ╠═dea7a792-1489-11eb-3836-19adda218314
# ╟─f43f2b74-148a-11eb-024a-6571ec216e5a
# ╠═48ca6118-1477-11eb-348b-611e1beefd0d
# ╠═a48419fa-1476-11eb-1967-054f755d2d83
# ╠═ffdea222-1546-11eb-3c41-bffc390d4f6d
# ╠═7a1a3a32-1476-11eb-11fd-571ed9798e80
# ╠═738fc4a4-1546-11eb-3271-1578f2d1265c
# ╠═f9fb23d6-1478-11eb-0743-b760008a479f
# ╟─ee1237e8-1479-11eb-374b-27fc10dee9ef
# ╠═9eb06c22-154d-11eb-32e8-d71664f8db18
# ╠═a1328e48-154e-11eb-173d-ff4d780d9eee
# ╠═eac7df74-154f-11eb-2f26-bf437213840a
# ╠═ef632360-154f-11eb-2640-07c309711ce9
# ╠═75518548-1550-11eb-1ced-8501d0d5572c
# ╠═9cb869e6-154e-11eb-0341-2d84eb4bfad3
# ╠═18edee94-1551-11eb-06e6-59fb5f372cd9
# ╟─0c11ac0e-1553-11eb-0487-37dcdd220eea
# ╠═d0fc591e-1551-11eb-1383-8bdeb62d1a0c
# ╠═e464a7de-1551-11eb-13c5-1d4c4dbe5408
# ╟─14fda26e-1553-11eb-2af4-1360e87e0a2d
# ╠═22b70800-1553-11eb-1a24-8932bd366f76
# ╟─f84b0a22-1551-11eb-28f2-c1068b246681
# ╟─5be28f06-1552-11eb-3baa-4185bbec9426
# ╟─b1bc3afe-1551-11eb-0e28-c1072fd06f96
# ╠═ba87d922-184e-11eb-1e83-6da642950441
# ╠═60740e08-1851-11eb-3ade-b3036aeab1e4
# ╠═212f63c8-184c-11eb-0d10-87f03d76c258
# ╠═cfd32330-1859-11eb-1f23-cd3f12d7c602
# ╠═e87ad310-1859-11eb-16a5-61b8cc94783a
# ╟─e0087386-1852-11eb-1b83-3f1755fcdf36
# ╟─ddc18458-1854-11eb-31dc-3134b1a624ff
# ╟─eda3e39c-1852-11eb-3964-2175ddedeec2

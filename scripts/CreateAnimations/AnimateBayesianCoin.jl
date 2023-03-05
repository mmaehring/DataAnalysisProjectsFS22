# Animate 
begin
    using DrWatson
end

begin
    @quickactivate "DataAnalysisProjectsFS22"
    using Plots, Distributions, Random
end


function data_gen(flips; sed = 3)
    ## Data generation
    #=
    	H -> 1
    	T -> 0
    =#
    Random.seed!(sed)
    predetermined_flips = [1, 1, 0, 1]
    randomized_flips = []

    if flips >= 5
        coin_tosser = Bernoulli(0.25)
        randomized_flips = [rand(coin_tosser) for i in 0:(flips-5)]
    end

    all_flips = vcat(predetermined_flips, randomized_flips)
    if flips <= 4
        all_flips = predetermined_flips[1:flips]
    end
    numheads = sum(all_flips)

    ## Bayesian model
    Uniform_p(x) = pdf(Uniform(), x)
    Normal_p(x) = ifelse(0 <= x <= 1, pdf(Normal(0.5, 0.05), x), 0)

    # prob({data}| H, I) 
    distr(x) = x^(numheads) * (1 - x)^(flips - numheads)
    posterior_U(x) = Uniform_p(x) .* distr(x)
    posterior_N(x) = Normal_p(x) .* distr(x)

    best_estimate = numheads / flips
    best_estimate_error = sqrt(best_estimate * (1 - best_estimate) / flips)

    ## Plotting
    xvec = 0:0.001:1
    yvec_U = posterior_U.(BigFloat.(xvec))
    yvec_U = yvec_U ./ maximum(yvec_U)
    yvec_N = posterior_N.(BigFloat.(xvec))
    yvec_N = yvec_N ./ maximum(yvec_N)

    return xvec, yvec_U, yvec_N, best_estimate, best_estimate_error
end

begin
    anim = @animate for flips in vcat(0:4, [2^i for i in 3:1:12])
        xvec, yvec_U, yvec_N, best_estimate, best_estimate_error = data_gen(flips)
        yvec = yvec_U
        # yvec = yvec_N

        plt = plot(xvec, yvec, label="",
            xlabel="Bias-weighting for heads H",
            ylabel="Posterior: prob(H|{data}, I)",
            xlims=(0.0, 1.0), ylims=(0.0, 1.2),
            xticks=0:0.1:1,
            minorgrid=true,
            legend=:topleft,
            dpi=350,
            framestyle = :box,
        )
        if flips > 0
            annotate!(0.1, 1.125, 
            text("Best estimate of probability to get heads: $(round(best_estimate, digits=2)) ± $(round(best_estimate_error, digits=2)),  flips:  $(flips)", :left, 9))
        else
            annotate!(0.1, 1.125, text("Prior before acquiring data", :left, 9))
        end
    end

    fps_num = 0.5
    gif(anim, plotsdir("Animations") * "\\PosteriorCoin_Uniform_$(fps_num).gif"; fps=fps_num)
    # gif(anim, plotsdir("Animations") * "\\PosteriorCoin_Normal_$(fps_num).gif"; fps=fps_num)
end

using Lux
using Random
using Optimisers
using Printf


# pseudo random number generator
# rng = Random.default_rng()
# Random.seed!(rng, 0)

# x = rand(rng, Float32, 5, 3)

# Creates a pseudo random number generator and seeds it.
rng = Xoshiro(0)

# if we use rng without replicating it, everytime we use it will mutate the state
randn(Lux.replicate(rng), 3, 4)

# Linear Regression using Lux
model = Dense(10 => 5)
ps, st = Lux.setup(rng, model)

n_samples = 20
x_dim = 10
y_dim = 5

# Generate random W and b
W = randn(rng, Float32, y_dim, x_dim)
b = randn(rng, Float32, y_dim)

# generate samples with additional noise
x_samples = randn(rng, Float32, x_dim, n_samples)
y_samples = W * x_samples .+ b .+ 0.01f0 .* randn(rng, Float32, y_dim, n_samples)

lossfn = MSELoss()
lossfn(W * x_samples .+ b, y_samples)
println("Loss with ground truth parameters $(lossfn(W*x_samples.+b, y_samples))")

function train_model!(model, ps, st, opt, nepochs::Int)
    tstate = Lux.Training.TrainState(model, ps, st, opt)
    for i in 1:nepochs
        grads, loss, _, tstate = Lux.Training.single_train_step!(
            AutoZygote(), lossfn, (x_samples, y_samples), tstate)
        if i % 1000 == 1 || i == nepochs
            @printf "Loss Value after %6d iterations: %.8f\n" i loss
        end
    end
    return tstate.model, tstate.parameters, tstate.states
end

model, ps, st = train_model!(model, ps, st, Descent(0.01f0), 10000)

println("Loss Value after training: ", lossfn(first(model(x_samples, ps, st)), y_samples))
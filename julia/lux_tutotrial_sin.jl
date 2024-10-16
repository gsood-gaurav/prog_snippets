using Lux
using Random
using Zygote
using Distributions
using Statistics
using Optimisers
using Makie
using GLMakie
Makie.inline!(true)
fig = Figure()
N_SAMPLES = 200
LAYERS = [1, 10, 10, 10, 1]
LEARNING_RATE = 0.1
N_EPOCHS = 30_000

# Pseudo Random Number generator
rng = Xoshiro(42)

x_samples = rand(
    rng,
    Uniform(0, 2*π),
    (1, N_SAMPLES),
)

y_noise = rand(
    rng,
    Normal(0.0, 0.3),
    (1, N_SAMPLES)
)

y_samples = sin.(x_samples) .+ y_noise
scatter(x_samples[:], y_samples[:], label="data")
# Model Architecture
# Here Lux just specifies Architecture and doesn't store any state or parameters.
# `model` is a pure function.
model = Chain(
    [Dense(fan_in => fan_out, Lux.sigmoid) for (fan_in, fan_out) in zip(LAYERS[1:end-2], LAYERS[2:end-1])]...,
    Dense(LAYERS[end-1] => LAYERS[end])
)

# Iniitalize the parameters (and also layer state only relevant  if neural network have stateful layers e.g BatchNorm)
parameters, layer_states = Lux.setup(rng, model)

# as discussed in Lux parameters and layer_state are not part of the Architecture.
# PyTorch, TensorFlow has parameters and layer_states as part of Architecture
# Though recent version of PyTorch also comes in functinal sytle similar to JAX 
# Calling the model on input updates the layer_state, but parameters are unchanged which gets updated during backpropo
y_inital_prediction, layer_states = model(x_samples, parameters, layer_states)
scatter(x_samples[:], y_inital_prediction[:])
# Loss function
function loss_fn(p, ls)
    y_prediction, new_ls = model(x_samples, p, ls)
    loss = 0.5 * mean((y_prediction .- y_samples).^2)

    return loss, new_ls
end

opt = Descent(LEARNING_RATE)
opt_state = Optimisers.setup(opt, parameters)

# Train Loop
loss_history = []
for epoch in 1:N_EPOCHS
    (loss, layer_states), back = pullback(loss_fn, parameters, layer_states)
    grad, _ = back((1.0, nothing))

    opt_state, parameters = Optimisers.update(opt_state, parameters, grad)
    push!(loss_history, loss)

    if epoch % 100 == 0
        println("Epoch: $epoch, Loss: $loss")
    end
end

plot(loss_history)

# Plot final y_prediction
y_final_prediction, layer_states = model(x_samples, parameters, layer_states)
scatter!(x_samples[:], y_samples[:])
scatter!(x_samples[:], y_final_prediction[:]) 
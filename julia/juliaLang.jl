### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ ff46a647-ba07-4072-904a-1a070457290a
begin
	using Random
	using Flux
	using Metal
end

# ╔═╡ 1f263388-7435-11ef-256d-7d6898c3e9ea
md"""
# Julia Type System
Types are categorized into
- Static Type System where type should be known before execution of the program.
- Dynamic Types where the types are not known until run time when actual values are manipulated
- Object Oriented Programming allows some flexibility where actual type may not known till run time using Parent and Dervied classes.
- The ability to write code that can operate on different types is called polymorphism
- All code in dynamic typing is polymorphic.
- Static Typing using type annotations can be of great assitance in generating efficient code, but also it enables **method dispatch**
- Julia type system is **dynamic, nominative, parameteric**
- _Nominative type system_ refers to fact that relationship between types are explictly declared rather than implied by compatible structure
- There is no distinction between first object and non-object values. All values in Julia are true objects having a type that belongs to single fully connected type graph, all nodes of which are equally first class as types.
- All objects are _instance of_ and all types are _subtypes_ of `Any` type
- **Looks like in Julia everything is an object: there are values that are objects, then there are types which are also objects**
- **Type{T}** abstract type has only one instance i.e. `T` itself. Without type parameter `T` `Type` is an abstract type which has all types as its instances. An object like `1`, `"hi"` which is not a type is not an instance of `Type`
"""

# ╔═╡ 1b9cff33-96b9-467e-bb77-4168d6592e88
begin
	function check_first_class_citizen(x)
		println(typeof(x))
	end
	check_first_class_citizen(Float64)
end

# ╔═╡ edfdcc31-3e63-4259-becf-62b986ba14b9
begin
 	println(1+2.5::AbstractFloat)
	function foo()
		x = 1 # can't assign x to a string but can assign a type which can be converted using convert
		# x has type Float64
		# Applies to whole current scope even before declaration
		local x::Float64
		x
	end
	typeof(foo())
	foo()
	# x::Int = 4
end

# ╔═╡ ed338482-103c-4ac8-92c4-72dbefa0b789
begin
	x::String = "hi"
	function bar()
		x = 24.0
	end
	bar()
end

# ╔═╡ 2df00108-1a20-4188-a49e-e0c531421ec0
begin
	Float64<:AbstractFloat # `<:` is subtype of relationship
	Float64::DataType # `::` is instance of relationship
	2::Int
	Any::DataType
	2::Number
end

# ╔═╡ ee981bf0-3df0-4eab-8d32-24b2e5898f50
begin
	function baz(x::Int, y::Number)
		return x
	end
	function baz(x::Int, y::Number)
		return x
	end
	baz(2, 3)
end

# ╔═╡ 00156900-a631-4ae7-ab42-6cd0e6fb8b90
begin
	struct Car
		brand::String
		price::Float64
	end
	c1 = Car("BMW", 1.2)
	c2 = Car("Audi", 1.5)
	cars = [c1, c2]
	typeof(cars)
	cars[1] === c1
	
end

# ╔═╡ adb39bc8-5df9-4053-9394-5b569aa67b5f
md"""
## Various Types
- Primitive Types
- Composite Types
- Mutable Composite types
- Declared Types
- Parametric Types
	- Prametric Composite Types
	- Parametric Abstract Types
	- Parametric Primitive Types
"""

# ╔═╡ 4852b97d-122e-4a69-8fbf-c8206d401d27
begin
	struct Point{T}
		x::T
		y::T
	end
	Point{Int} <: Point
	Point{Int} :: DataType
end

# ╔═╡ bff53901-a9c4-4df1-bd3f-de681409fbca
begin
	x1::Array{Float64, 1} = [1.0, 2.0]
	Array{Float64, 1} <: Array{T, 1} where T
	typeof(Union{Real, String}), typeof(Union{Real, T} where T)
end

# ╔═╡ 674429ea-c3b2-497d-9927-84dfddbbb2b3
Union{Real, String} <: Union{Real, T} where T

# ╔═╡ 116e5019-f41e-4a6f-b48b-17eceb1b61ec
md"""
## Immutability in Julia
"""

# ╔═╡ 77189e35-e93a-4fbe-a00e-46530152d5fa
begin
	struct TestImmutability
		foo::Int
		bar::Vector
	end
	ti = TestImmutability(1, [1,2])
	ti.bar[1] = 4
	println(ti)
end

# ╔═╡ d5633c31-b628-4758-abed-05cade4188b4
md"""
## `Type{T}` selectors
"""

# ╔═╡ 63f60b83-3239-4c57-b770-788b276d2a5c
begin
	function test_Type_T(::Type{Int})
		return "Testing Type{T}..."
	end
	test_Type_T(Int)
	println(1 isa Int)
	println(Float64 isa Type{Float64})
	println(Float64 isa Type)
	println(Type{Float64} isa Type)
	println(1 isa Type)
	println(Type isa DataType)
	println(Float64 isa DataType)
end

# ╔═╡ 89a47e19-6781-4fa4-9140-3317da3409e2
begin
	struct WrapType{T}
		x::T
	end
	WrapType{Float64}(2.0)
	typeof(WrapType(2.0))
	WrapType(Float64)
	WrapType(::Type{T}) where T = WrapType{Type{T}}(T)
	WrapType(Float64)
end

# ╔═╡ 0196f532-a122-4e74-b2e6-0998c469d4e6
begin
	function test_instance_relation(x::Type{T} where T)
		println(x)
	end
	test_instance_relation(Float64)
end

# ╔═╡ 0a0db7bf-7ca3-4698-b901-797438f3e5b6
begin 
	abstract type AbstractArray{T, N} end
	AbstractArray{T, N} where T where N <: AbstractArray
	meltype(::Type{<:AbstractArray{T}})  where {T}= T
	meltype(AbstractArray{Float64})
end

# ╔═╡ 1a4dc22c-d74e-42c9-8bbb-d00d08d8f735
begin
	function test_parameter_name(::Float64)
		println("Testing...")
	end
	function test12(::Array{Array{T, 1} where T, 1})
		print("Inside...")
	end
	# ::Array{Array{T, 1}, 1} where T
	[[1,2],["hi", "hola"]]::Array{Array{T, 1} where T, 1}
end

# ╔═╡ 920e8aec-b541-41c3-a3c8-29920cf3fb6d
md"""
# Scope In Julia
- Two main _local_ and _global_ scope
- Hard scope and Soft scope
- `if` and `begin` doesnt introduce scope
- Lexical Scoping meaning function's scope doesn't inherit from where it is called but from the scope in which function was defined.
- Lexical Scope means what a variable in a paritcular piece of code refers to can be deduced from the code in which it appears alone and doesnt depend on how the program executes.
- A scope nested inside outer scope can see variables in outer scope.
- Each module introduces a global scope. there is no encompassing global scope. A module is a _namespace_ as well as first class _data structure_
- A outer scope variable can be written and read in inner scopes--unless there is local variable of same name that shadows the outer variable. That is true even if outer local is declared after an inner block.
- **If you assign to existing local it will always update that local, we have to explicitly declare a new variable with same name and `local` keyword if we want to refer to new variable with same name. This is different in python where assignment inside the inner scope automatically creates new local variable.**
"""

# ╔═╡ 4b9ea4fc-ae68-4fad-9d1c-45c40759fd0f
begin
	function test_scope()
	end
end

# ╔═╡ 93b18889-76e0-42ce-a16c-0987dd41c968
md"""
## Constructors
- Constructors are functions that create new objects i.e. instances of composite types.
- Type Objects construct as constructors, they create instancs of themselves when applied to an argument tuple as a function.
- Invariants must be enforces, either by checking arguments or transforming them
- **Outer Constructors** Additional constructor methods declared as normal methods are called Outer constructor methods.
- Outer Constructor can create objects by calling already provided constructor methods
- **Inner Constructor** methods allows enforcing invariants and creation of self referential structures
- If any inner constructor is porvided no default constructor is provided
"""

# ╔═╡ e741878d-5624-4141-b8b2-9b8824c89376
begin
	# Outer Construtor Example
	struct ConstFoo
		bar
		baz
	end
	ConstFoo(1, 2)
	ConstFoo(x) = ConstFoo(x, x)
	ConstFoo(3)

	struct OrderedPair
		x::Int
		y::Int
		OrderedPair(x, y) = x > y ? error("Out of Order") : new(x, y)
	end
	OrderedPair(3, 4)
end

# ╔═╡ 1c23e673-ed44-4b5b-a895-0a7b7bc018bf
md"""
## Function-like objects
Methods are associated with types, so it is possible to make any arbitrary Julia object "callable" by adding methods to its type. (Such "callable" objects are sometimes called functors)
"""

# ╔═╡ 750413d6-209a-4c81-95c8-2d032074cd8f
begin
	struct Polynomial{T}
		coeffs::Vector{T}
	end
	function (p::Polynomial)(x)
		v = p.coeffs[end]
		for i = (length(p.coeffs)-1):-1:1
			v = v*x + p.coeffs[i]
		end
		return v
	end
	(p::Polynomial)() = p(5)
end

# ╔═╡ 501823b0-d723-440c-8828-b51f4342c8cc
begin
	p = Polynomial([1,10,100])
	(p::Polynomial)()
end

# ╔═╡ 1598c701-f96d-4647-a5cf-e6aff99d969a
md"""
# Anonymous functions
"""

# ╔═╡ 5b594164-efb5-461b-aa8f-6c750c70b31e
begin
	println(map(x->x^2, [1,2,3]))
	f = x->x^2
	println(f(2))
end

# ╔═╡ d24ca48f-0720-4d79-ae25-695c712ef1ac
md"""
# Read a file into a `String`

"""

# ╔═╡ 0a02a2a0-39ac-407a-9c58-d8d3fb46a0a0
# text = open(io->read(io, String), "file.txt")	

# ╔═╡ e68ca4e8-6c22-41b5-b2c6-ce8df3030d55
md"""
# Set Operation
"""

# ╔═╡ 9838810a-d431-44fb-9497-d583b88bcb52
begin
	@show eset = Set("How are you")
	@show ecoll = collect(eset)
	@show scoll = sort(ecoll)
	@show join(scoll)
end

# ╔═╡ 7fc9e70b-1ce6-494d-8a35-8c8ef0c7a235
md"""
# Dictionaries
"""

# ╔═╡ 9d0fe00a-e17e-43c1-9499-7b245acb6cd7
begin
	eDict =Dict([(1, 2), [3, 4]])
end

# ╔═╡ 8262367c-698f-4b43-b371-0b873f4e3f4b
md"""
# List Comprehension
"""

# ╔═╡ 202c7e65-e400-4f47-a060-23154ad078e7
begin
	@show eListComp = [(k,v) for (k,v) in enumerate("how")]
	pairs(eDict)
end

# ╔═╡ 097afd29-a7f7-4197-b4c5-34fbd671fbeb
join(collect(['h', 'a', 't']))

# ╔═╡ 0c813570-d015-4fe4-83ea-938677e2c10f
md"""
# Arrays
"""

# ╔═╡ ccc4fe06-42d7-4a82-91bc-585f0a9148ad
md"""
# Flux
"""

# ╔═╡ 4a2c5932-54aa-48ea-8e7c-5bacfb081ea5
begin
	# We can define neural network layer as regular julia structs
	struct Affine
		W
		b
	end
	Affine(inp::Int, out::Int) = Affine(randn(out, inp), randn(out))
	function (m::Affine)(x)
		m.W * x .+ m.b
	end
	l = Affine(3, 2)
	l(randn(3))
	# TO train a layer follow the below statement
	Flux.@layer Affine
	# by default all the fields in `Affine` type are collected as its parameters
	@show Flux.trainable(l)
	# If we need to hold other metadata as layers which doesn't need training we can
	# overload the `trainable` function. The below overloading will cause the the parameter `b` not to be collected as part of trainable parameters. Only the fields returned by `trainable` will be seen by `Flux.setup` and `Flux.update!`. But all fields will be seen by `gpu` or similar function. THe exact same method of trainable can also be defined using the macro, for convenience 
	"Flux.@layer Affine trainable=(W,)"
	Flux.trainable(l::Affine) = (; W=l.W)
	@show Flux.trainable(l)
	l |> gpu
	
end

# ╔═╡ 31c0fa13-09de-4022-aba7-1c8bec2d2c3e
Flux.GPU_BACKEND

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Flux = "587475ba-b771-5e3f-ad9e-33799f191a9c"
Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
Flux = "~0.14.15"
Metal = "~1.1.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "fe1c385a0023d55da5be0716f6c286450573f1c2"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Atomix]]
deps = ["UnsafeAtomics"]
git-tree-sha1 = "c06a868224ecba914baa6942988e2f2aade419be"
uuid = "a9b6321e-bd34-4604-b9c9-b65b8de01458"
version = "0.1.0"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables"]
git-tree-sha1 = "7aa7ad1682f3d5754e3491bb59b8103cae28e3a3"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.40"

    [deps.BangBang.extensions]
    BangBangChainRulesCoreExt = "ChainRulesCore"
    BangBangDataFramesExt = "DataFrames"
    BangBangStaticArraysExt = "StaticArrays"
    BangBangStructArraysExt = "StructArrays"
    BangBangTypedTablesExt = "TypedTables"

    [deps.BangBang.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.ChainRules]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Distributed", "GPUArraysCore", "IrrationalConstants", "LinearAlgebra", "Random", "RealDot", "SparseArrays", "SparseInverseSubset", "Statistics", "StructArrays", "SuiteSparse"]
git-tree-sha1 = "291821c1251486504f6bae435227907d734e94d2"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.66.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "9b1ca1aa6ce3f71b3d1840c538a8210a043625eb"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.8.2"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

    [deps.CompositionsBase.weakdeps]
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.ContextVariablesX]]
deps = ["Compat", "Logging", "UUIDs"]
git-tree-sha1 = "25cc3803f1030ab855e383129dcd3dc294e322cc"
uuid = "6add18c4-b38d-439d-96f6-d6bc489c04c5"
version = "0.1.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.FLoops]]
deps = ["BangBang", "Compat", "FLoopsBase", "InitialValues", "JuliaVariables", "MLStyle", "Serialization", "Setfield", "Transducers"]
git-tree-sha1 = "ffb97765602e3cbe59a0589d237bf07f245a8576"
uuid = "cc61a311-1640-44b5-9fba-1b764f453329"
version = "0.2.1"

[[deps.FLoopsBase]]
deps = ["ContextVariablesX"]
git-tree-sha1 = "656f7a6859be8673bf1f35da5670246b923964f7"
uuid = "b9860ae5-e623-471e-878b-f6a53c775ea6"
version = "0.1.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

    [deps.FillArrays.weakdeps]
    PDMats = "90014a1f-27ba-587c-ab20-58faa44d9150"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.Flux]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Functors", "LinearAlgebra", "MLUtils", "MacroTools", "NNlib", "OneHotArrays", "Optimisers", "Preferences", "ProgressLogging", "Random", "Reexport", "SparseArrays", "SpecialFunctions", "Statistics", "Zygote"]
git-tree-sha1 = "a5475163b611812d073171583982c42ea48d22b0"
uuid = "587475ba-b771-5e3f-ad9e-33799f191a9c"
version = "0.14.15"

    [deps.Flux.extensions]
    FluxAMDGPUExt = "AMDGPU"
    FluxCUDAExt = "CUDA"
    FluxCUDAcuDNNExt = ["CUDA", "cuDNN"]
    FluxMetalExt = "Metal"

    [deps.Flux.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
    cuDNN = "02a925ec-e4fe-4b08-9a7e-0d78e3d38ccd"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.Functors]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d3e63d9fa13f8eaa2f06f64949e2afc593ff52c2"
uuid = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
version = "0.4.10"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "68e8ff56a4a355a85d2784b94614491f8c900cde"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "10.1.0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "ec632f177c0d990e64d955ccc1b8c04c485a0950"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.6"

[[deps.GPUCompiler]]
deps = ["ExprTools", "InteractiveUtils", "LLVM", "Libdl", "Logging", "Scratch", "TimerOutputs", "UUIDs"]
git-tree-sha1 = "1600477fba37c9fc067b9be21f5e8101f24a8865"
uuid = "61eb1bfa-7361-4325-ad38-22787b887f55"
version = "0.26.4"

[[deps.IRTools]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "950c3717af761bc3ff906c2e8e52bd83390b6ec2"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.14"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "be3dc50a92e5a386872a493a10050136d4703f9b"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.1"

[[deps.JuliaVariables]]
deps = ["MLStyle", "NameResolution"]
git-tree-sha1 = "49fb3cb53362ddadb4415e9b73926d6b40709e70"
uuid = "b14d175d-62b4-44ba-8fb7-3064adc8c3ec"
version = "0.2.4"

[[deps.KernelAbstractions]]
deps = ["Adapt", "Atomix", "InteractiveUtils", "LinearAlgebra", "MacroTools", "PrecompileTools", "Requires", "SparseArrays", "StaticArrays", "UUIDs", "UnsafeAtomics", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "db02395e4c374030c53dc28f3c1d33dec35f7272"
uuid = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
version = "0.9.19"

    [deps.KernelAbstractions.extensions]
    EnzymeExt = "EnzymeCore"

    [deps.KernelAbstractions.weakdeps]
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Preferences", "Printf", "Requires", "Unicode"]
git-tree-sha1 = "839c82932db86740ae729779e610f07a1640be9a"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "6.6.3"

    [deps.LLVM.extensions]
    BFloat16sExt = "BFloat16s"

    [deps.LLVM.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"

[[deps.LLVMDowngrader_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML", "Zlib_jll"]
git-tree-sha1 = "5e1965206f3b43d6c89d18fcd4f26808f1bf317c"
uuid = "f52de702-fb25-5922-94ba-81dd59b07444"
version = "0.1.0+2"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "88b916503aac4fb7f701bb625cd84ca5dd1677bc"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.29+0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibMPDec_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6eaa22a233f28bc5d6092f3f8e685f85080fba11"
uuid = "7106de7a-f406-5ef1-84f7-3345f7341bd2"
version = "2.5.1+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[deps.MLUtils]]
deps = ["ChainRulesCore", "Compat", "DataAPI", "DelimitedFiles", "FLoops", "NNlib", "Random", "ShowCases", "SimpleTraits", "Statistics", "StatsBase", "Tables", "Transducers"]
git-tree-sha1 = "b45738c2e3d0d402dffa32b2c1654759a2ac35a4"
uuid = "f1d291b0-491e-4a28-83b9-f70985020b54"
version = "0.4.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Metal]]
deps = ["Adapt", "Artifacts", "CEnum", "CodecBzip2", "ExprTools", "GPUArrays", "GPUCompiler", "KernelAbstractions", "LLVM", "LLVMDowngrader_jll", "LinearAlgebra", "ObjectFile", "ObjectiveC", "Preferences", "Printf", "Python_jll", "Random", "Reexport", "Requires", "SHA", "StaticArrays", "UUIDs"]
git-tree-sha1 = "b5bf24e5ef1492a69ed9d64f93853bb17c1fdf39"
uuid = "dde4c033-4e86-420c-a63e-0dd931031962"
version = "1.1.0"

    [deps.Metal.extensions]
    BFloat16sExt = "BFloat16s"
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.Metal.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "629afd7d10dbc6935ec59b32daeb33bc4460a42e"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.4"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NNlib]]
deps = ["Adapt", "Atomix", "ChainRulesCore", "GPUArraysCore", "KernelAbstractions", "LinearAlgebra", "Pkg", "Random", "Requires", "Statistics"]
git-tree-sha1 = "e0cea7ec219ada9ac80ec2e82e374ab2f154ae05"
uuid = "872c559c-99b0-510c-b3b7-b6c96a88d5cd"
version = "0.9.16"

    [deps.NNlib.extensions]
    NNlibAMDGPUExt = "AMDGPU"
    NNlibCUDACUDNNExt = ["CUDA", "cuDNN"]
    NNlibCUDAExt = "CUDA"
    NNlibEnzymeCoreExt = "EnzymeCore"

    [deps.NNlib.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    cuDNN = "02a925ec-e4fe-4b08-9a7e-0d78e3d38ccd"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NameResolution]]
deps = ["PrettyPrint"]
git-tree-sha1 = "1a0fa0e9613f46c9b8c11eee38ebb4f590013c5e"
uuid = "71a1bf82-56d0-4bbc-8a3c-48b961074391"
version = "0.1.5"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.ObjectFile]]
deps = ["Reexport", "StructIO"]
git-tree-sha1 = "195e0a19842f678dd3473ceafbe9d82dfacc583c"
uuid = "d8793406-e978-5875-9003-1fc021f44a92"
version = "0.4.1"

[[deps.ObjectiveC]]
deps = ["CEnum", "Libdl", "Preferences"]
git-tree-sha1 = "911629e704cdb7e3b6a5e30faaaadb10eba1f2ad"
uuid = "e86c9b32-1129-44ac-8ea0-90d5bb39ded9"
version = "2.1.1"

[[deps.OneHotArrays]]
deps = ["Adapt", "ChainRulesCore", "Compat", "GPUArraysCore", "LinearAlgebra", "NNlib"]
git-tree-sha1 = "963a3f28a2e65bb87a68033ea4a616002406037d"
uuid = "0b1bfda6-eb8a-41d2-88d8-f5af5cad476f"
version = "0.2.5"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+1"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optimisers]]
deps = ["ChainRulesCore", "Functors", "LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "6572fe0c5b74431aaeb0b18a4aa5ef03c84678be"
uuid = "3bd65402-5787-11e9-1adc-39752487f4e2"
version = "0.3.3"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.PrettyPrint]]
git-tree-sha1 = "632eb4abab3449ab30c5e1afaa874f0b98b586e4"
uuid = "8162dcfd-2161-5ef2-ae6c-7681170c5f98"
version = "0.2.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressLogging]]
deps = ["Logging", "SHA", "UUIDs"]
git-tree-sha1 = "80d919dee55b9c50e8d9e2da5eeafff3fe58b539"
uuid = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
version = "0.1.4"

[[deps.Python_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "JLLWrappers", "LibMPDec_jll", "Libdl", "Libffi_jll", "OpenSSL_jll", "SQLite_jll", "XZ_jll", "Zlib_jll"]
git-tree-sha1 = "da243e7064d1be1fea4be656bfda5f6ca949471a"
uuid = "93d3a430-8e7c-50da-8e8d-3dfcfb3baf05"
version = "3.10.14+0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SQLite_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "004fffbe2711abdc7263a980bbb1af9620781dd9"
uuid = "76ed43ae-9a5d-5a62-8c75-30186b810ce8"
version = "3.45.3+0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.ShowCases]]
git-tree-sha1 = "7f534ad62ab2bd48591bdeac81994ea8c445e4a5"
uuid = "605ecd9f-84a6-4c9e-81e2-4798472b76a3"
version = "0.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SparseInverseSubset]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "52962839426b75b3021296f7df242e40ecfc0852"
uuid = "dc90abb0-5640-4711-901d-7e5b23a2fada"
version = "0.1.2"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2f5d4697f21388cbe1ff299430dd169ef97d7e14"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.4.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "f4dc295e983502292c4c3f951dbb4e985e35b3be"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.18"
weakdeps = ["Adapt", "GPUArraysCore", "SparseArrays", "StaticArrays"]

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = "GPUArraysCore"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

[[deps.StructIO]]
deps = ["Test"]
git-tree-sha1 = "010dc73c7146869c042b49adcdb6bf528c12e859"
uuid = "53d494c1-5632-5724-8f4c-31dff12d585f"
version = "0.3.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "3a6f063d690135f5c1ba351412c82bae4d1402bf"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.25"

[[deps.TranscodingStreams]]
git-tree-sha1 = "5d54d076465da49d6746c647022f3b3674e64156"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.8"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "ConstructionBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "3064e780dbb8a9296ebb3af8f440f787bb5332af"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.80"

    [deps.Transducers.extensions]
    TransducersBlockArraysExt = "BlockArrays"
    TransducersDataFramesExt = "DataFrames"
    TransducersLazyArraysExt = "LazyArrays"
    TransducersOnlineStatsBaseExt = "OnlineStatsBase"
    TransducersReferenceablesExt = "Referenceables"

    [deps.Transducers.weakdeps]
    BlockArrays = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    LazyArrays = "5078a376-72f3-5289-bfd5-ec5146d43c02"
    OnlineStatsBase = "925886fa-5bf2-5e8e-b522-a9147a512338"
    Referenceables = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnsafeAtomics]]
git-tree-sha1 = "6331ac3440856ea1988316b46045303bef658278"
uuid = "013be700-e6cd-48c3-b4a1-df204f14c38f"
version = "0.2.1"

[[deps.UnsafeAtomicsLLVM]]
deps = ["LLVM", "UnsafeAtomics"]
git-tree-sha1 = "323e3d0acf5e78a56dfae7bd8928c989b4f3083e"
uuid = "d80eeb9a-aca5-4d75-85e5-170c8b632249"
version = "0.1.3"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "GPUArrays", "GPUArraysCore", "IRTools", "InteractiveUtils", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "PrecompileTools", "Random", "Requires", "SparseArrays", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "19c586905e78a26f7e4e97f81716057bd6b1bc54"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.6.70"

    [deps.Zygote.extensions]
    ZygoteColorsExt = "Colors"
    ZygoteDistancesExt = "Distances"
    ZygoteTrackerExt = "Tracker"

    [deps.Zygote.weakdeps]
    Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
    Distances = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "27798139afc0a2afa7b1824c206d5e87ea587a00"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.5"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═ff46a647-ba07-4072-904a-1a070457290a
# ╠═1f263388-7435-11ef-256d-7d6898c3e9ea
# ╠═1b9cff33-96b9-467e-bb77-4168d6592e88
# ╠═edfdcc31-3e63-4259-becf-62b986ba14b9
# ╠═ed338482-103c-4ac8-92c4-72dbefa0b789
# ╠═2df00108-1a20-4188-a49e-e0c531421ec0
# ╠═ee981bf0-3df0-4eab-8d32-24b2e5898f50
# ╠═00156900-a631-4ae7-ab42-6cd0e6fb8b90
# ╠═adb39bc8-5df9-4053-9394-5b569aa67b5f
# ╠═4852b97d-122e-4a69-8fbf-c8206d401d27
# ╠═bff53901-a9c4-4df1-bd3f-de681409fbca
# ╠═674429ea-c3b2-497d-9927-84dfddbbb2b3
# ╠═116e5019-f41e-4a6f-b48b-17eceb1b61ec
# ╠═77189e35-e93a-4fbe-a00e-46530152d5fa
# ╠═d5633c31-b628-4758-abed-05cade4188b4
# ╠═63f60b83-3239-4c57-b770-788b276d2a5c
# ╠═89a47e19-6781-4fa4-9140-3317da3409e2
# ╠═0196f532-a122-4e74-b2e6-0998c469d4e6
# ╠═0a0db7bf-7ca3-4698-b901-797438f3e5b6
# ╠═1a4dc22c-d74e-42c9-8bbb-d00d08d8f735
# ╠═920e8aec-b541-41c3-a3c8-29920cf3fb6d
# ╠═4b9ea4fc-ae68-4fad-9d1c-45c40759fd0f
# ╠═93b18889-76e0-42ce-a16c-0987dd41c968
# ╠═e741878d-5624-4141-b8b2-9b8824c89376
# ╠═1c23e673-ed44-4b5b-a895-0a7b7bc018bf
# ╠═750413d6-209a-4c81-95c8-2d032074cd8f
# ╠═501823b0-d723-440c-8828-b51f4342c8cc
# ╠═1598c701-f96d-4647-a5cf-e6aff99d969a
# ╠═5b594164-efb5-461b-aa8f-6c750c70b31e
# ╟─d24ca48f-0720-4d79-ae25-695c712ef1ac
# ╠═0a02a2a0-39ac-407a-9c58-d8d3fb46a0a0
# ╠═e68ca4e8-6c22-41b5-b2c6-ce8df3030d55
# ╠═9838810a-d431-44fb-9497-d583b88bcb52
# ╠═7fc9e70b-1ce6-494d-8a35-8c8ef0c7a235
# ╠═9d0fe00a-e17e-43c1-9499-7b245acb6cd7
# ╠═8262367c-698f-4b43-b371-0b873f4e3f4b
# ╠═202c7e65-e400-4f47-a060-23154ad078e7
# ╠═097afd29-a7f7-4197-b4c5-34fbd671fbeb
# ╠═0c813570-d015-4fe4-83ea-938677e2c10f
# ╠═ccc4fe06-42d7-4a82-91bc-585f0a9148ad
# ╠═4a2c5932-54aa-48ea-8e7c-5bacfb081ea5
# ╠═31c0fa13-09de-4022-aba7-1c8bec2d2c3e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002

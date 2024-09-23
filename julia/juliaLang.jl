### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

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

# ╔═╡ Cell order:
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

# Check difference between a macro and function

function exfunc()
    (println("this is function for testing expressions"))
    Expr(:call, *, 2, 3)
    end
    
macro exmacro()
    :(println("this is macro for testing expressions"))
    Expr(:call, :*, 2, 3)
end

# println(@exmacro)
# println(exfunc())

# Test macros with args
macro macro_with_args(name)
    println("hey")
    println(typeof(name))
    :(println("My name is ", name ))
end

# @macro_with_args("Gaurav")
# macroexpand(Main, :(macro_with_args("hi")))

struct MyNum
    a::Float64
end

Base::sin(x::MyNum) = MyNum(sin(x.a))

mn = MyNum(1.0)
println(mn)

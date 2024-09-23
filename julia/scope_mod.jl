# Testing Scoping in Julia

x = 2
y = 100

struct TestStruct
    x::Int
    y::String
end

function scope_test(y)
    global x
    println(x)
    x = 34
    println(x)
    function inner_func(z)
        local x = 100
        println(x)
    end
    inner_func(233)
    println(x)
end

# ts = TestStruct(1, "hi")
# scope_test(45)

function test_hard_scope()    
    function func_loop(j)
        s += j
    end
    s = 0
    for i =1:10
        func_loop(i)
    end
    return s
end

println(test_hard_scope())

for i in 1:10
    local x = 0
    x += i
end
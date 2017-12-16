function isNative()
    return native ~= nil
end

function log(value)
    if isNative() then
        native.log(value)
    else
        print(value)
    end
end

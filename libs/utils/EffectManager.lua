local EffectManager = {}

EffectManager.easeInSin = function (t, b, c, d)
    return -c * math.cos(t/d * (math.pi/2)) + c + b
end

EffectManager.easeOutSin = function (t, b, c, d)
    return c * math.sin(t/d * (math.pi/2)) + b
end

EffectManager.easeInExpo = function (t, b, c, d)
    return c * math.pow( 2, 10 * (t/d - 1) ) + b
end

EffectManager.easeOutExpo = function (t, b, c, d)
    return c * ( -math.pow( 2, -10 * t/d ) + 1 ) + b
end

return  EffectManager
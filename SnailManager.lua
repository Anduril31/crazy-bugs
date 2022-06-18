local SnailManager = {}

 -- Snail
 function SnailManager.createSnail(x, y, minX, maxX)
    snail = {}
    snail.refy = y
    snail.img = love.graphics.newImage("Images/snail.png")
    snail.w = snail.img:getWidth()
    snail.h = snail.img:getHeight()
    snail.x = x - snail.w/SCALE
    snail.minX = minX
    snail.maxX = maxX
    snail.y = y/SCALE
    snail.dir = 'left'
    snail.deform = "more"
    snail.scale = {}
    snail.scale.x = SCALE
    snail.scale.y = SCALE
    snail.scale.scaleModifier = 0.1
    snail.scale.scaleVelocity = 0.1
    snail.speed = 10

    function snail.update(dt)
        if (snail.deform == 'more') then
            if snail.scale.y <= SCALE + snail.scale.scaleModifier then
                snail.scale.y = snail.scale.y + dt * snail.scale.scaleVelocity
            else 
                snail.scale.y = SCALE + snail.scale.scaleModifier
                snail.deform = 'less'
            end
        end
        if (snail.deform == 'less') then
            if snail.scale.y > SCALE then
                snail.scale.y = snail.scale.y - dt * snail.scale.scaleVelocity
            else 
                snail.scale.y = SCALE
                snail.deform = 'more'
            end
        end
        snail.y = (snail.refy-snail.h/SCALE) + (snail.h - (snail.h * snail.scale.y))
   
        if (snail.dir == 'right') then
            if(snail.x < snail.maxX) then
                snail.x = snail.x + dt* snail.speed
            else
                snail.scale.x = snail.scale.x * -1
                snail.x = snail.maxX -- - snail.w/SCALE
                snail.dir = 'left'
            end
        end
        if (snail.dir == 'left') then
            if(snail.x > snail.minX) then
                snail.x = snail.x - dt* snail.speed
            else
                snail.scale.x = snail.scale.x * -1
                snail.x = snail.minX --+ snail.w/SCALE
                snail.dir = 'right'
            end
        end
    end

    function snail.draw()
        love.graphics.draw(
            snail.img, 
            snail.x, 
            snail.y,
            0,
            snail.scale.x,
            snail.scale.y,
            snail.w/2
        )
    end

    return snail
 end
 


return SnailManager
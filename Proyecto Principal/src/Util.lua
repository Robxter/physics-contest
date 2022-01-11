--[[
    Global Helper Aditional Functions v1

    -- some functions like table.slice and Generate Quads are taken from Colton Ogden's Util Lib

]]

-- function for setup global collisions
function setupGlobalCollisions(roof, floor, left_wall, right_wall)
    local collisions = {
        top = top or 0,
        floor = floor or WINDOW_HEIGHT,
        left = left_wall or 0,
        right = right_wall or WINDOW_WIDTH
    }

    return collisions
end

-- function for slicing tables to a defined first and last index... useful to stop indexing a table at some point
function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

-- Generating quads from an image giving it the tile width and height you want it to chop from a image, like a slicer
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end
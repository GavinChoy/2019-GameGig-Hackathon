function collide(x1, y1, x2, y2)
    return x1 - x2 < 30 and x2 - x1 < 60 and y1 - y2 < 30 and y2 - y1 < 60
end
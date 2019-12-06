function collide(x1, y1, x2, y2)
    return x1 - x2 < 10 and x2 - x1 < 10 and y1 - y2 < 10 and y2 - y1 < 10
end
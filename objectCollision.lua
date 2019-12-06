--    Game to ride a bicycle through a crowd of pedestrians safely
--    Copyright (C) 2019  Gavin Choy and Hui Taou Kok
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <https://www.gnu.org/licenses/>.

-- function to determine if there is a collision between two objects
-- returns true if object positions are within a range of each other
function collide(x1, y1, x2, y2)
    return x1 - x2 < 30 and x2 - x1 < 60 and y1 - y2 < 30 and y2 - y1 < 60
end
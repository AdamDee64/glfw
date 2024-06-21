package main 

import "vendor:OpenGL"


Rect :: struct {
    x : i32,
    y : i32,
    width : i32,
    height : i32
}

draw_rect :: proc (using rect : Rect) -> [12]f32{
    screen_w :i32 = 512
    screen_h :i32 = 512

    x_range := f32(screen_w >> 1)
    y_range := f32(screen_h >> 1)

    rectangle := [12]f32 {
        (-x_range + f32(x + width)) / x_range,  (y_range - f32(y)) / y_range, 0.0,  // top right
        (-x_range + f32(x + width)) / x_range,  (y_range - f32(y + height)) / y_range, 0.0,  // bottom right
        (-x_range + f32(x)) / x_range,  (y_range - f32(y + height)) / y_range, 0.0, // bottom left
        (-x_range + f32(x)) / x_range,  (y_range - f32(y)) / y_range, 0.0,   // top left 
    }



    return rectangle
}
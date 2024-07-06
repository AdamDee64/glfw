package main 

import gl "vendor:OpenGL"


Rect :: struct {
    x : i32,
    y : i32,
    width : i32,
    height : i32
}

triangle := [18]f32 {
	0.5, -0.5, 0.0,  1.0, 0.0, 0.0,   // bottom right
	-0.5, -0.5, 0.0,  0.0, 1.0, 0.0,   // bottom left
	0.0,  0.5, 0.0,  0.0, 0.0, 1.0    // top 
}

rect : Rect = {20, 20, 472, 472}

rectangle := draw_rect(rect)

rect_i := [6]u32 {  
	0, 1, 3,   
	1, 2, 3    
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

load_shapes :: proc (){


	gl.BindVertexArray(VAO[0])

	gl.BindBuffer(gl.ARRAY_BUFFER, VBO[0])


	gl.BufferData(gl.ARRAY_BUFFER, size_of(rectangle), &rectangle, gl.STATIC_DRAW)
	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, EBO[0])
	gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(rectangle), &rect_i, gl.STATIC_DRAW)
    
    

	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), uintptr(0))
	gl.EnableVertexAttribArray(0)


	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	gl.BindVertexArray(0)

}
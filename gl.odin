package main

import gl "vendor:OpenGL"
import "core:fmt"

BUFFER_SIZE :: 16

VBO : [BUFFER_SIZE]u32
VAO : [BUFFER_SIZE]u32 
EBO : [BUFFER_SIZE]u32

init :: proc(){

// arrays for buffer object IDs. 

    VBO_ptr : [^]u32 = raw_data(VBO[:]) // for odin compatibility with c type array pointers 
    VAO_ptr : [^]u32 = raw_data(VAO[:])
    EBO_ptr : [^]u32 = raw_data(EBO[:])

	gl.GenBuffers(BUFFER_SIZE, VBO_ptr) // buffers share the same counter. this will be labelled 1-5
    gl.GenBuffers(BUFFER_SIZE, EBO_ptr) // 6 - 10, note there is no 0. 
	gl.GenVertexArrays(BUFFER_SIZE, VAO_ptr) 

	gl.ClearColor(0.2, 0.3, 0.3, 1.0)

    gl.PolygonMode(gl.FRONT_AND_BACK, gl.FILL)

}

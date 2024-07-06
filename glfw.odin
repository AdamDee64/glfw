package main

import "core:fmt"
import "core:c"
import "core:math"

import gl "vendor:OpenGL"
import "vendor:glfw"

WIDTH :: 800
HEIGHT :: 600
TITLE :: "Hello OpenGL"

running : b32 = true


main :: proc() {

	window := create_window(WIDTH, HEIGHT, TITLE)

	default_shader := load_shaders("", "./shaders/default.glsl")
	shader_program := load_shaders("./shaders/vs.glsl", "./shaders/fs.glsl")

	init()
	load_shapes()
	
	for (!glfw.WindowShouldClose(window) && running) {

		update()

		draw()

		glfw.SwapBuffers((window))

		glfw.PollEvents()
	}

	glfw.DestroyWindow(window)
	exit()
}


update :: proc(){

	

}

draw :: proc(){
	
	gl.Clear(gl.COLOR_BUFFER_BIT)

	// Own drawing code here

	gl.UseProgram(3)

	gl.BindVertexArray(1)

	gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, rawptr(uintptr(0)))
	

}

exit :: proc(){
	
	glfw.Terminate()
}

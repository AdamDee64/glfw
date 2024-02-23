package main

import "core:fmt"
import "core:c"
import "core:math"

import gl "vendor:OpenGL"
import "vendor:glfw"


// ---- DEBUG ----
draw_triangle := true
wireframe := false
// ---------------

PROGRAM_NAME :: "Hello OpenGL"

GL_MAJOR_VERSION : c.int : 3
GL_MINOR_VERSION :: 3

running : b32 = true

vertex_shader_src := file_to_cstring("./shaders/vs.glsl")
fragment_shader_src := file_to_cstring("./shaders/fs.glsl")

VBO : u32
VAO : u32
EBO : u32
shader_program : u32

// hello triangle
triangle := [9]f32 {
	-0.5, -0.5, 0.0,
	0.5, -0.5, 0.0,
	0.0,  0.5, 0.0
}

rectangle := [12]f32 {
	0.5,  0.5, 0.0,  // top right
	0.5, -0.5, 0.0,  // bottom right
	-0.5, -0.5, 0.0,  // bottom left
	-0.5,  0.5, 0.0   // top left 
}

rect_i := [6]u32 {  
	0, 1, 3,   
	1, 2, 3    
}

main :: proc() {

	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.VERSION_MAJOR,GL_MAJOR_VERSION) 
	glfw.WindowHint(glfw.VERSION_MINOR,GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE,glfw.OPENGL_CORE_PROFILE)
	
	if(glfw.Init() != b32(true)){
		fmt.println("Failed to initialize GLFW")
		return
	}

	defer glfw.Terminate()
	window := glfw.CreateWindow(512, 512, PROGRAM_NAME, nil, nil)
	defer glfw.DestroyWindow(window)

	if window == nil {
		fmt.println("Unable to create window")
		return
	}

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1)

	glfw.SetKeyCallback(window, key_callback)
	glfw.SetFramebufferSizeCallback(window, size_callback)

	gl.load_up_to(int(GL_MAJOR_VERSION), GL_MINOR_VERSION, glfw.gl_set_proc_address) 

	init()
	
	for (!glfw.WindowShouldClose(window) && running) {

		update()
		draw()

		glfw.SwapBuffers((window))
		glfw.PollEvents()
	}

	exit()
}


init :: proc(){

	load_shaders(&vertex_shader_src, &fragment_shader_src)

	gl.GenBuffers(1, &VBO)
	gl.GenVertexArrays(1, &VAO)
	if(!draw_triangle){
		gl.GenBuffers(1, &EBO)
	}

	gl.BindVertexArray(VAO)

	gl.BindBuffer(gl.ARRAY_BUFFER, VBO)


	if (draw_triangle) {
		// triangle
		gl.BufferData(gl.ARRAY_BUFFER, size_of(triangle), &triangle, gl.STATIC_DRAW)
	} else {
		// rectangle
		gl.BufferData(gl.ARRAY_BUFFER, size_of(rectangle), &rectangle, gl.STATIC_DRAW)
		gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, EBO)
		gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(rectangle), &rect_i, gl.STATIC_DRAW)
	}

	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), uintptr(0))
	gl.EnableVertexAttribArray(0)

	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	gl.BindVertexArray(0)

}

update :: proc(){

	if wireframe {
		gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)
	} else {
		gl.PolygonMode(gl.FRONT_AND_BACK, gl.FILL)
	}

}

draw :: proc(){
	gl.ClearColor(0.2, 0.3, 0.3, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT)

	// Own drawing code here


	gl.UseProgram(shader_program)

	time_value := glfw.GetTime()
	green_value : f32 = f32(math.sin(time_value)) / 2.0 + 0.5
	vertex_color_location := gl.GetUniformLocation(shader_program, "our_color")
	gl.Uniform4f(vertex_color_location, 0.0, green_value, 0.0, 1.0)



	gl.BindVertexArray(VAO)

	if(draw_triangle) {
		gl.DrawArrays(gl.TRIANGLES, 0, 3)
	} else {//														  v what is this? v  ¯\_(ツ)_/¯
		gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, rawptr(uintptr(0)))
	}	

}

exit :: proc(){
	// Own termination code here
}

key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	if key == glfw.KEY_ESCAPE {
		running = false
	}
	if (key == glfw.KEY_X  && action == glfw.RELEASE) {
		wireframe = !wireframe
	}

}

size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}

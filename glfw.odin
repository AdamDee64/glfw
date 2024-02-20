package main

import "core:fmt"
import "core:c"
import "core:os"
import str "core:strings"

import gl "vendor:OpenGL"
import "vendor:glfw"

file_to_cstring :: proc(file : string) -> cstring {
	// TODO - add error checking and move this procedure to it's own file
	input, open_err := os.open(file)
   u8_stream, read_err := os.read_entire_file_from_handle(input)
	os.close(input)
	odin_string, clone_err := str.clone_from_bytes(u8_stream)
	res, cstring_err := str.clone_to_cstring(odin_string)
	return res
}

PROGRAM_NAME :: "Program"

GL_MAJOR_VERSION : c.int : 3
GL_MINOR_VERSION :: 3

running : b32 = true

vertex_shader_src := file_to_cstring("./shaders/vs.glsl")
fragment_shader_src := file_to_cstring("./shaders/fs.glsl")

VBO : u32
VAO : u32
shader_program : u32

// hello triangle
triangle := [9]f32 {
	-0.5, -0.5, 0.0,
	0.5, -0.5, 0.0,
	0.0,  0.5, 0.0
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

		glfw.PollEvents()
		
		update()
		draw()

		glfw.SwapBuffers((window))
	}

	exit()
}


init :: proc(){

	shader_success : i32
	vertex_shader := gl.CreateShader(gl.VERTEX_SHADER)
	gl.ShaderSource(vertex_shader, 1, &vertex_shader_src, nil)
	gl.CompileShader(vertex_shader)

	gl.GetShaderiv(vertex_shader, gl.COMPILE_STATUS, &shader_success)

	// TODO: make this into procedure since it's repeated 3 times. 
	// Possibly make this entire shader loader into it's own procedure
	if(shader_success == 0){
		a : [^]u8
		log : [512]u8
		a = raw_data(log[:])
		// this function requires an array pointer with a reserved amount of space to mimic how it's done in C
		// this is how it's done in Odin.
		gl.GetShaderInfoLog(vertex_shader, 512, nil, a)
		log_string, clone_err := str.clone_from_bytes(log[:])
		fmt.print(log_string)
		
	}

	fragment_shader := gl.CreateShader(gl.FRAGMENT_SHADER)
	gl.ShaderSource(fragment_shader, 1, &fragment_shader_src, nil)
	gl.CompileShader(fragment_shader)

	gl.GetShaderiv(fragment_shader, gl.COMPILE_STATUS, &shader_success)
	if(shader_success == 0){
		a : [^]u8
		log : [512]u8
		a = raw_data(log[:])
		
		gl.GetShaderInfoLog(fragment_shader, 512, nil, a)
		log_string, clone_err := str.clone_from_bytes(log[:])
		fmt.print(log_string)
	}

	
	shader_program = gl.CreateProgram()
	gl.AttachShader(shader_program, vertex_shader)
	gl.AttachShader(shader_program, fragment_shader)
	gl.LinkProgram(shader_program)
	gl.GetProgramiv(shader_program, gl.LINK_STATUS, &shader_success)

	if(shader_success == 0){
		a : [^]u8
		log : [512]u8
		a = raw_data(log[:])
		
		gl.GetShaderInfoLog(shader_program, 512, nil, a)
		log_string, clone_err := str.clone_from_bytes(log[:])
		fmt.print(log_string)
	}

	gl.DeleteShader(vertex_shader)
	gl.DeleteShader(fragment_shader)


	gl.GenBuffers(1, &VBO)
	gl.GenVertexArrays(1, &VAO)

	gl.BindVertexArray(VAO)

	gl.BindBuffer(gl.ARRAY_BUFFER, VBO)
	gl.BufferData(gl.ARRAY_BUFFER, size_of(triangle), &triangle, gl.STATIC_DRAW)

	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), uintptr(0))
	gl.EnableVertexAttribArray(0)

	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	gl.BindVertexArray(0)

}

update :: proc(){
	// Own update code here
}

draw :: proc(){
	gl.ClearColor(0.2, 0.3, 0.3, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT)

	// Own drawing code here


	gl.UseProgram(shader_program)
	gl.BindVertexArray(VAO)
	gl.DrawArrays(gl.TRIANGLES, 0, 3)

}

exit :: proc(){
	// Own termination code here
}


key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	if key == glfw.KEY_ESCAPE {
		running = false
	}
}

size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}

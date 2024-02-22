package main

import "core:os"
import "core:fmt"
import str "core:strings"

import gl "vendor:OpenGL"


file_to_cstring :: proc(file : string) -> cstring {
   input, open_err := os.open(file)
   if open_err != 0 {
      fmt.print("Odin package os.Errno :", open_err, ": failure while attempting to open file", file, "\n")
   }
	u8_stream, read_success := os.read_entire_file_from_handle(input)
   if !read_success {
      fmt.print("os.read_entire_file_from_handle failure on loading file", file, "\n")
   }
	os.close(input)
	odin_string, clone_err := str.clone_from_bytes(u8_stream)
   if clone_err != nil {
      fmt.print("Runtime Allocator Error :", clone_err, "on cloning u8 array to string\n")
   }   
	res, cstring_err := str.clone_to_cstring(odin_string)
   if cstring_err != nil {
      fmt.print("Runtime Allocator Error :", cstring_err, "on cloning string to cstring\n")
   }   
   return res
}


load_shaders :: proc(vs_src : [^]cstring, fs_src : [^]cstring) {

	shader_success : i32
	vertex_shader := gl.CreateShader(gl.VERTEX_SHADER)
	gl.ShaderSource(vertex_shader, 1, vs_src, nil)
	gl.CompileShader(vertex_shader)

	gl.GetShaderiv(vertex_shader, gl.COMPILE_STATUS, &shader_success)

	if(shader_success == 0){
      // this function requires an array pointer with a reserved amount of space to mimic how it's done in C
		log : [512]u8                 // create a buffer for a C-like string. 
		a : [^]u8 = raw_data(log[:])  // create a pointer to the data

		gl.GetShaderInfoLog(vertex_shader, 512, nil, a)       // pass the pointer to the function 
		log_string, clone_err := str.clone_from_bytes(log[:]) // turn the u8 stream into an Odin string
		fmt.print(log_string)                                 // print the log with the populated data
	}

	fragment_shader := gl.CreateShader(gl.FRAGMENT_SHADER)
	gl.ShaderSource(fragment_shader, 1, fs_src, nil)
	gl.CompileShader(fragment_shader)

	gl.GetShaderiv(fragment_shader, gl.COMPILE_STATUS, &shader_success)
	if(shader_success == 0){
		log : [512]u8           
		a : [^]u8 = raw_data(log[:])
		
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
		log : [512]u8           
		a : [^]u8 = raw_data(log[:])
		
		gl.GetShaderInfoLog(shader_program, 512, nil, a)
		log_string, clone_err := str.clone_from_bytes(log[:])
		fmt.print(log_string)
	}

	gl.DeleteShader(vertex_shader)
	gl.DeleteShader(fragment_shader)

}
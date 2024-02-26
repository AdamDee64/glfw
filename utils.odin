package main

import "core:os"
import "core:fmt"
import str "core:strings"

import gl "vendor:OpenGL"


file_to_cstring :: proc(file : string) -> cstring {
   u8_data, success := os.read_entire_file(file)
	if success {
		c_string, cstring_err := str.clone_to_cstring(string(u8_data))
		if cstring_err != nil {
			fmt.print("Runtime Allocator Error :", cstring_err, "on cloning to cstring\n")
		}  else {
			return c_string
		}
	} else {
		fmt.print("Could not open file:", file, "\n")
	}

   return cstring("")
}

log_shader_success :: proc(shader_id : u32, shader_success : i32) {
	if(shader_success == 0){
		log : [512]u8               
		ptr : [^]u8 = raw_data(log[:])  
		length : i32
		gl.GetShaderInfoLog(shader_id, 512, &length, ptr)    
		fmt.print("OpenGL Shader Error:",string(log[:length]))                              
	}
}

load_shaders :: proc(vs_src : [^]cstring, fs_src : [^]cstring) {

	shader_success : i32
	
	vertex_shader := gl.CreateShader(gl.VERTEX_SHADER)
	gl.ShaderSource(vertex_shader, 1, vs_src, nil)
	gl.CompileShader(vertex_shader)
	gl.GetShaderiv(vertex_shader, gl.COMPILE_STATUS, &shader_success)
	log_shader_success(vertex_shader, shader_success)

	fragment_shader := gl.CreateShader(gl.FRAGMENT_SHADER)
	gl.ShaderSource(fragment_shader, 1, fs_src, nil)
	gl.CompileShader(fragment_shader)
	gl.GetShaderiv(fragment_shader, gl.COMPILE_STATUS, &shader_success)
	log_shader_success(fragment_shader, shader_success)
	
	shader_program = gl.CreateProgram()
	gl.AttachShader(shader_program, vertex_shader)
	gl.AttachShader(shader_program, fragment_shader)
	gl.LinkProgram(shader_program)
	gl.GetProgramiv(shader_program, gl.LINK_STATUS, &shader_success)
	log_shader_success(shader_program, shader_success)

	gl.DeleteShader(vertex_shader)
	gl.DeleteShader(fragment_shader)

}
package main

import "core:fmt"
import "core:c"
import "core:math"

import gl "vendor:OpenGL"
import "vendor:glfw"

create_window :: proc(width : i32, height : i32, title : cstring) -> glfw.WindowHandle {

    GL_MAJOR_VERSION : c.int : 3
    GL_MINOR_VERSION :: 3

    glfw.WindowHint(glfw.RESIZABLE, 1)
    glfw.WindowHint(glfw.VERSION_MAJOR,GL_MAJOR_VERSION) 
    glfw.WindowHint(glfw.VERSION_MINOR,GL_MINOR_VERSION)
    glfw.WindowHint(glfw.OPENGL_PROFILE,glfw.OPENGL_CORE_PROFILE)

    if(glfw.Init() != b32(true)){
        fmt.println("Failed to initialize GLFW")
    }

    // window := glfw.CreateWindow(width, height, title, glfw.GetPrimaryMonitor(), nil) // this will start program in full screen (linux)
    window := glfw.CreateWindow(width, height, title, nil, nil)


    if window == nil {
        fmt.println("Unable to create window")
        glfw.Terminate()
        running = false
        return window
    }

    glfw.MakeContextCurrent(window)
    glfw.SwapInterval(1)

    glfw.SetKeyCallback(window, key_callback)
    glfw.SetFramebufferSizeCallback(window, size_callback)

    gl.load_up_to(int(GL_MAJOR_VERSION), GL_MINOR_VERSION, glfw.gl_set_proc_address) 

    return window
}



key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	if key == glfw.KEY_ESCAPE {
		running = false
	}

}

size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}

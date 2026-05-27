add_executable(devshell)
target_sources(devshell PRIVATE
    main.cpp
)

target_compile_definitions(devshell PRIVATE -DUNICODE -D_UNICODE)
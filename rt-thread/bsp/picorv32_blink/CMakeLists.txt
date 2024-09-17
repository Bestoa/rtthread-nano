cmake_minimum_required (VERSION 3.1)

ENABLE_LANGUAGE(ASM)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv)
SET(CMAKE_CROSSCOMPILING 1)

set(LINKR_FILE ../drivers/linker_scripts/link.lds)

set(CMAKE_C_FLAGS "-MD -Os -Wall -march=rv32im -mabi=ilp32" )

set(CMAKE_ASM_FLAGS "-nostdlib -march=rv32im -mabi=ilp32" )
set(LD_FLAGS "-ffunction-sections  -nostartfiles -Wl,--gc-sections")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(ENABLE_EXPORTS  True)

set(PROJECT_NAME rt-thread)

set(BIN_TARGET ${PROJECT_NAME}.bin)
set(HEX_TARGET ${PROJECT_NAME}.hex)
set(MAP_TARGET ${PROJECT_NAME}.map)
set(LSS_TARGET ${PROJECT_NAME}.asm)
set(TMP_TARGET ${PROJECT_NAME}.tmp)

set(RISCV_SRC 
   libraries/start.S
   drivers/board.c
   applications/main.c
   ../../libcpu/risc-v/picorv32/interrupt_gcc.S
   ../../libcpu/risc-v/picorv32/interrupt.c
   ../../libcpu/risc-v/picorv32/context_gcc.S
   ../../libcpu/risc-v/picorv32/cpuport.c
   ../../components/finsh/cmd.c
   ../../components/finsh/msh.c
   ../../components/finsh/shell.c
   ../../src/clock.c
   ../../src/components.c
   ../../src/cpu.c
   ../../src/idle.c
   ../../src/ipc.c
   ../../src/irq.c
   ../../src/kservice.c
   ../../src/mem.c
   ../../src/memheap.c
   ../../src/mempool.c
   ../../src/object.c
   ../../src/scheduler.c
   ../../src/slab.c
   ../../src/thread.c
   ../../src/timer.c
   )

# create binary & hex files and show size of resulting firmware image

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

set(HAVE_FLAG_SEARCH_PATHS_FIRST 0)
set(CMAKE_ASM_LINK_FLAGS "")
set(CMAKE_C_LINK_FLAGS "")
set(CMAKE_CXX_LINK_FLAGS "")

project (${PROJECT_NAME})

include_directories(../../libcpu/risc-v/picorv32
                    ../../include/
                    ../../components/finsh/
                    ../../include/libc/
                    ./)

add_executable(${PROJECT_NAME}.elf ${RISCV_SRC})

target_link_libraries(${PROJECT_NAME}.elf PRIVATE  -T${LINKR_FILE} ${LD_FLAGS},-Map=${MAP_TARGET},--print-memory-usage)

if (NOT APPLE)
# Remove option -rdynamic which is a bug
add_custom_command(TARGET ${PROJECT_NAME}.elf PRE_BUILD
        COMMAND sed -i 's/-rdynamic//g' CMakeFiles/${PROJECT_NAME}.elf.dir/link.txt
)
endif()

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${BIN_TARGET}
        COMMAND ${CMAKE_OBJCOPY} -O verilog ${PROJECT_NAME}.elf ${TMP_TARGET}
        COMMAND ${CMAKE_OBJDUMP} -S -D -x ${PROJECT_NAME}.elf > ${LSS_TARGET}
        COMMENT "Generating ${HEX_TARGET}, ${BIN_TARGET}"
)

        .include "clock.inc"
        .include "string.inc"
        .include "utils.inc"
        .include "zeropage.inc"
        .include "tty.inc"
        .include "lcd.inc"
        .include "modem.inc"
        .include "blink.inc"
        .include "core.inc"
        .include "menu.inc"
        .include "parse.inc"
        .include "macros.inc"

        .export _run_shell
        .import init_basic
        .import os_version
        .import _run_monitor
        .import __ROM_START__
        .import __ROM_LAST__
        .import __ROM_SIZE__
        .import __USERRAM_START__
        .import __USERRAM_LAST__
        .import __USERRAM_SIZE__
        .import __SYS_RAM_START__
        .import __SYS_RAM_LAST__
        .import __SYS_RAM_SIZE__
        .import __CODE_SIZE__
        .import __DATA_SIZE__
        .import __RODATA_SIZE__
        .import __RODATA_PA_SIZE__
        .import __SYSCALLS_SIZE__
        .import __VECTORS_SIZE__
        .import __VIA1_START__
        .import __VIA2_START__
        .import __ACIA_START__

        .code
_run_shell:
        lda #(TTY_CONFIG_INPUT_SERIAL | TTY_CONFIG_OUTPUT_SERIAL)
        jsr _tty_init

        ; Display banner
        writeln_tty #msgemptyline
        writeln_tty #banner1
        writeln_tty #banner2
        writeln_tty #banner3
        writeln_tty #banner4
        writeln_tty #banner5
        writeln_tty #banner6
        writeln_tty #msgemptyline

        ; Display hello messages
        writeln_tty #os_version
        writeln_tty #msghello2
        writeln_tty #msghello3

        register_system_break #system_break_handler

main_loop:
        run_menu #menu, #os1prompt
        rts

_process_load:
        writeln_tty #msgload
@receive_file:
        jsr _modem_receive
        cmp #(MODEM_RECEIVE_FAILED)
        beq @receive_file
        rts

_process_run:
        writeln_tty #msgrun
        jsr $1000
        jsr _deregister_user_irq
        jsr _deregister_user_break
        rts

_process_led:
        sta tokens_pointer
        stx tokens_pointer+1

        strgettoken tokens_pointer, 1
        copy_ptr ptr1, param_pointer

        parse_onoff param_pointer
        bcc @error
        cmp #$00
        beq @turn_off
        lda #(BLINK_LED_ON)
        jsr _blink_led
        rts
@turn_off:
        lda #(BLINK_LED_OFF)
        jsr _blink_led
        rts
@error:
        writeln_tty #lederror
        rts

_process_monitor:
        writeln_tty #msgmonitor
        jsr _run_monitor
        rts

_process_basic:
        writeln_tty #msgbasic
        jmp init_basic
        rts

_process_info:
        writeln_tty #msginfo
        write_tty #clock_msg1
        ldx #$00
        lda #(clock_mhz)
        jsr _tty_write_dec
        writeln_tty #clock_msg2
        jsr _tty_send_newline

        write_tty #rom_msg
        write_tty #mem_msg1
        write_tty_address #__ROM_START__
        write_tty #mem_msg2
        write_tty_dec #(__CODE_SIZE__+__DATA_SIZE__+__RODATA_SIZE__+__RODATA_PA_SIZE__+__SYSCALLS_SIZE__+__VECTORS_SIZE__)
        write_tty #out_of_msg
        write_tty_dec #(__ROM_SIZE__)
        writeln_tty #bytes_msg

        write_tty #system_ram_msg
        write_tty #mem_msg1
        write_tty_address #__SYS_RAM_START__
        write_tty #mem_msg2
        write_tty_dec #(__SYS_RAM_LAST__-__SYS_RAM_START__)
        write_tty #out_of_msg
        write_tty_dec #__SYS_RAM_SIZE__
        writeln_tty #bytes_msg

        write_tty #user_ram_msg
        write_tty #mem_msg1
        write_tty_address #__USERRAM_START__
        write_tty #mem_msg2
        write_tty_dec #(__USERRAM_LAST__-__USERRAM_START__)
        write_tty #out_of_msg
        write_tty_dec #__USERRAM_SIZE__
        writeln_tty #bytes_msg

        jsr _tty_send_newline

        write_tty #rom_code_msg
        write_tty_dec #(__CODE_SIZE__)
        writeln_tty #bytes_msg

        write_tty #rom_data_msg
        write_tty_dec #(__DATA_SIZE__+__RODATA_SIZE__+__RODATA_PA_SIZE__)
        writeln_tty #bytes_msg

        write_tty #syscalls_msg
        write_tty_dec #(__SYSCALLS_SIZE__)
        writeln_tty #bytes_msg

        jsr _tty_send_newline

        write_tty #via1_addr_msg
        write_tty_address #__VIA1_START__
        jsr _tty_send_newline
        write_tty #via2_addr_msg
        write_tty_address #__VIA2_START__
        jsr _tty_send_newline
        write_tty #acia_addr_msg
        write_tty_address #__ACIA_START__
        jsr _tty_send_newline
        rts

system_break_handler:
        writeln_tty #msgemptyline
        writeln_tty #msgemptyline
        writeln_tty #msgemptyline
        writeln_tty #msgsystembreak
        jsr _strobe_led
        jmp main_loop

        .segment "BSS"
tokens_pointer:
        .res 2
param_pointer:
        .res 2

        .segment "RODATA"
banner1:.asciiz "  ___  ____  _ _   _           _"
banner2:.asciiz " / _ \|  _ \(_) | | |         | |"
banner3:.asciiz "| (_) | |_) |_| |_| |     __ _| |__  ___   ___ __ _"
banner4:.asciiz " > _ <|  _ <| | __| |    / _` | '_ \/ __| / __/ _` |"
banner5:.asciiz "| (_) | |_) | | |_| |___| (_| | |_) \__ \| (_| (_| |"
banner6:.asciiz " \___/|____/|_|\__|______\__,_|_.__/|___(_)___\__,_|"
msghello2:
        .asciiz "Spark64 OS for 65C02 (c) 2023 Rob Prouse"
msghello3:
        .asciiz "HELP to list commands"
msgload:
        .asciiz "Initiating load..."
msgrun:
        .asciiz "Running program..."
msgmonitor:
        .asciiz "Running monitor..."
msgbasic:
        .asciiz "Running MS BASIC..."
msginfo:
        .asciiz "Spark64 System Info"
clock_msg1:
        .asciiz "System clock "
clock_msg2:
        .asciiz "MHz"
rom_msg:
        .asciiz "ROM"
system_ram_msg:
        .asciiz "System RAM"
user_ram_msg:
        .asciiz "User RAM"
mem_msg1:
        .asciiz " at addr: 0x"
mem_msg2:
        .asciiz ", used: "
out_of_msg:
        .asciiz " out of "
bytes_msg:
        .asciiz " bytes."
rom_code_msg:
        .asciiz "ROM code uses "
rom_data_msg:
        .asciiz "ROM data uses "
syscalls_msg:
        .asciiz "SYSCALLS table uses "
via1_addr_msg:
        .asciiz "VIA1 addr: 0x"
via2_addr_msg:
        .asciiz "VIA2 addr: 0x"
acia_addr_msg:
        .asciiz "ACIA addr: 0x"
os1prompt:
        .asciiz "Spark64>"
msgemptyline:
        .byte $00
lederror:
        .asciiz "Invalid params"
msgsystembreak:
        .asciiz "System break initiated, returning to shell..."
menu:
        menuitem load_cmd,    1, load_desc,    _process_load
        menuitem run_cmd,     1, run_desc,     _process_run
        menuitem monitor_cmd, 1, monitor_desc, _process_monitor
        menuitem basic_cmd,   1, basic_desc,   _process_basic
        menuitem led_cmd,     2, led_desc,     _process_led
        menuitem info_cmd,    1, info_desc,    _process_info
        endmenu

load_cmd:
        .asciiz "LOAD"
load_desc:
        .asciiz "LOAD         - load app using XMODEM"
run_cmd:
        .asciiz "RUN"
run_desc:
        .asciiz "RUN          - run loaded app"
basic_cmd:
        .asciiz "BASIC"
basic_desc:
        .asciiz "BASIC        - run MS BASIC"
monitor_cmd:
        .asciiz "MON"
monitor_desc:
        .asciiz "MON          - run monitor program"
led_cmd:
        .asciiz "LED"
led_desc:
        .asciiz "LED <on|off> - toggle onboard LED"
info_cmd:
        .asciiz "INFO"
info_desc:
        .asciiz "INFO         - display system info"
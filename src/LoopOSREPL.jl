module LoopOSREPL

using ReplMaker
using LoopOS: listen, InputPeripheral, state
import Base.take!

struct REPLInput <: InputPeripheral
    c::Channel{String}
end

take!(::REPLInput) = take!(REPL.c)
state(::REPLInput) = "REPLModule.REPL"

const REPL = REPLInput(Channel{String}(10))
listen(REPL)

repl_parse(s) = put!(REPL.c, string(strip("""$s""")))

atreplinit() do _
    ReplMaker.initrepl(
        repl_parse,
        prompt_text="> ",
        prompt_color=:light_cyan,
        start_key="\\C-g",
        mode_name="God",
    )
    write(stdin.buffer, "\x07")
end

end

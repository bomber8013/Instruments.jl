#Macros to make it easier to write drivers for SCPI instruments

macro scpifloat(name, instrType, scpiStr, scale, units)
	setterFunc = symbol(string(name)*"!")
	setterProto = :($(setterFunc)(instr::$instrType, val::Real))
	setterBody = :(write(instr, $scpiStr * " $val"))
	setter = Expr(:function, esc(setterProto), esc(setterBody))
	getCmd = scpiStr*"?"
	getterProto = :($name(instr::$instrType))
	getterBody = :(query(instr, $getCmd))
	getter = Expr(:function, esc(getterProto), esc(getterBody))
	Expr(:block, setter, getter)
end

macro scpibool(name, instrType, scpiStr)
	setterFunc = symbol(string(name)*"!")
	setterProto = :($(setterFunc)(instr::$instrType, val::Bool))
	setterBody = :(write(instr, $scpiStr * " " * string(int(val)) ))
	setter = Expr(:function, esc(setterProto), esc(setterBody))
	getCmd = scpiStr*"?"
	getterProto = :($name(instr::$instrType))
	getterBody = :(bool(int(query(instr, $getCmd))))
	getter = Expr(:function, esc(getterProto), esc(getterBody))
	Expr(:block, setter, getter)
end

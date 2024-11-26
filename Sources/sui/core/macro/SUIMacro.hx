package sui.core.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;

using sui.core.macro.MacroExt;

class SUIMacro {
	static function generateSetter(field:Field, varType:Null<ComplexType>):Field {
		var variableRef = field.name.resolve();
		var setterBody = macro {
			var __from__ = $variableRef;
			$variableRef = v;
			for (f in __from__.listeners)
				f(v);
			return $variableRef;
		};
		return {
			pos: Context.currentPos(),
			name: 'set_${field.name}',
			access: [APrivate],
			meta: [],
			kind: FieldType.FFun({
				ret: varType,
				params: [],
				expr: setterBody,
				args: [
					{
						value: null,
						type: varType,
						opt: false,
						name: "v"
					}
				]
			}),
			doc: ""
		};
		return null;
	}

	public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();

		for (field in fields) {
			for (meta in field.meta) {
				if (meta.name == "bindable") {
					switch (field.kind) {
						case FVar(varType, e):
							field.meta.push({name: ":isVar", pos: Context.currentPos()});
							field.kind = FieldType.FProp("default", "set", varType, e);
							fields.push(generateSetter(field, varType));
						case _:
							null;
					}
				}
			}
		}

		return fields;
	}
}

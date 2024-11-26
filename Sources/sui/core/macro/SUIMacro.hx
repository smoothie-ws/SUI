package sui.core.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;

using sui.core.macro.MacroExt;
using sui.core.utils.StringExt;

class SUIMacro {
	public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();

		for (field in fields)
			if (field.meta != null)
				for (meta in field.meta)
					if (meta.name == "bindable")
						switch (field.kind) {
							case FVar(varType, e):
								field.meta.push({name: ":isVar", pos: Context.currentPos()});
								// make variable be property
								field.kind = FieldType.FProp("default", "set", varType, e);
								// add variable listener
								fields.push({
									pos: Context.currentPos(),
									name: 'on${field.name.capitalize()}Changed',
									kind: FFun({
										args: [],
										expr: macro null
									}),
									access: [ADynamic, APublic]
								});
								// add variable setter
								var variableRef = field.name.resolve();
								var listenerRef = 'on${field.name.capitalize()}Changed'.resolve();

								var setterBody = macro {
									var from = $variableRef;
									$variableRef = v;
									if ($variableRef != from) {
										$listenerRef();
									}
									return $variableRef;
								};
								fields.push({
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
								});
							case _:
								null;
						}

		return fields;
	}
}

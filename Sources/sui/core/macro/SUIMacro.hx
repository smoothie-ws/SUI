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
				for (meta in field.meta) {
					if (meta.name == "readonly")
						switch (field.kind) {
							case FVar(varType, e):
								field.meta.push({name: ":isVar", pos: Context.currentPos()});
								field.kind = FProp("default", "never", varType, e);
							case _:
								null;
						}
					if (meta.name == "observable")
						switch (field.kind) {
							case FVar(varType, e):
								field.meta.push({name: ":isVar", pos: Context.currentPos()});
								field.kind = FProp("default", "set", varType, e);

								var listenersName = '${field.name}Listeners';
								fields.push({
									pos: Context.currentPos(),
									name: listenersName,
									access: [APrivate],
									kind: FVar(macro :Array<$varType->Void>, macro [])
								});

								var listenersRef = listenersName.resolve();
								fields.push({
									pos: Context.currentPos(),
									name: 'add${field.name.capitalize()}Listener',
									kind: FFun({
										ret: macro :Int,
										args: [
											{
												name: 'f',
												type: macro :$varType->Void,
												opt: false
											}
										],
										expr: macro {
											$listenersRef.push($i{'f'});
											return $listenersRef.length - 1;
										}
									}),
									access: [ADynamic, APublic]
								});

								fields.push({
									pos: Context.currentPos(),
									name: 'remove${field.name.capitalize()}Listener',
									kind: FFun({
										args: [
											{
												name: 'listenerID',
												type: macro :Int,
												opt: false
											}
										],
										expr: macro {
											$listenersRef.splice(listenerID, 1);
										}
									}),
									access: [ADynamic, APublic]
								});

								var variableRef = field.name.resolve();
								var setterBody = macro {
									var from = $variableRef;
									$variableRef = v;
									for (f in $listenersRef)
										f(v);
									return $variableRef;
								};
								fields.push({
									pos: Context.currentPos(),
									name: 'set_${field.name}',
									access: [APrivate],
									meta: [],
									kind: FFun({
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
				}

		return fields;
	}
}

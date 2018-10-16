package tempest.manager
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;

	import tempest.common.keyboard.KeyCodes;
	import tempest.common.keyboard.vo.HotkeyData;

	public class KeyboardManager
	{
		public static var ctrlKey:Boolean=false;
		public static var shiftKey:Boolean=false;
		public static var altKey:Boolean=false;
		private static var downkey_cache:Array=[];
		private static var downkeys:Vector.<int>=new Vector.<int>();
		private static var hotkeys:Object={};
		private static var signals:InteractiveObjectSignalSet=null;

		public static function init(stage:Stage):void
		{
			signals=new InteractiveObjectSignalSet(stage);
			signals.keyDown.add(onKeyDown);
			signals.keyUp.add(onKeyUp);
		}

		/**
		 * 注册热键
		 * @param name 热键名
		 * @param keys 组合键
		 * @param handler 处理函数
		 * @param ctrl
		 * @param alt
		 * @param shift
		 */
		public static function addHotkey(name:String, keys:Array, handler:Function, ctrl:Boolean=false, alt:Boolean=false, shift:Boolean=false, needKeys:Boolean=false):void
		{
			keys.sort(Array.NUMERIC);
			var keysString:String=createKeyString(keys.join("+"), ctrl, alt, shift);
			if (hotkeys.hasOwnProperty(keysString))
			{
				throw new Error(keysString + "-重复注册热键");
			}
			if (hasHotkey(name))
			{
				throw new Error(keysString + "-重复注册热键名");
			}
			hotkeys[keysString]=new HotkeyData(name, keys, keysString, handler, needKeys);
			trace("注册热键  name:{0} key:{1}", name, keysString);
		}

		/**
		 * 注册一组热键
		 * @param prefix 命名前缀
		 * @param keys 热键数组
		 * @param handler
		 * @param ctrl
		 * @param alt
		 * @param shift
		 * @param needKeys
		 */
		public static function addHotkeyGroup(prefix:String, keys:Array, handler:Function, ctrl:Boolean=false, alt:Boolean=false, shift:Boolean=false, needKeys:Boolean=true):void
		{
			if (keys && keys.length != 0)
			{
				keys.forEach(function(element:int, index:int, arr:Array):void
				{
					addHotkey(prefix + element, [element], handler, ctrl, alt, shift, needKeys);
				});
			}
		}

		/**
		 * 移除热键
		 * @param name 热键名
		 */
		public static function removeHotkey(name:String):void
		{
			var hotKey:HotkeyData;
			for each (hotKey in hotkeys)
			{
				if (hotKey.name == name)
				{
					hotkeys[hotKey.keyString]=null;
					delete hotkeys[hotKey.keyString];
					trace("移除热键:{0}", name);
					break;
				}
			}
		}

		/**
		 * 移除一组热键
		 * @param prefix
		 * @param keys
		 */
		public static function removeHotkeyGroup(prefix:String, keys:Array):void
		{
			if (keys && keys.length != 0)
			{
				keys.forEach(function(element:int, index:int, arr:Array):void
				{
					removeHotkey(prefix + element);
				});
			}
		}

		/**
		 * 移除所有热键
		 */
		public static function removeAllHotkey():void
		{
			hotkeys={};
			trace("移除所有热键");
		}
		private static var _keyEnale:Boolean=true;
		/**
		 *
		 */
		private static var _except:Array=null;

		/**
		 * 禁用键盘
		 * @param except 禁用忽略列表
		 *
		 */
		public static function disable(except:Array=null):void
		{
			_except=except;
			_keyEnale=false;
			trace("禁用热键");
		}

		/**
		 * 启用键盘
		 */
		public static function enable():void
		{
			_keyEnale=true;
			_except=null;
			downkeys.length=0;
			downkey_cache.length=0;
			trace("启用热键");
		}

		/**
		 * 是否注册热键
		 * @param name 热键名
		 * @return
		 */
		public static function hasHotkey(name:String):Boolean
		{
			var hotKey:HotkeyData;
			for each (hotKey in hotkeys)
			{
				if (hotKey.name == name)
				{
					return true;
				}
			}
			return false;
		}

		private static function onKeyDown(e:KeyboardEvent):void
		{
			if (_keyEnale && !(e.keyCode == 18 || e.keyCode == 16 || e.keyCode == 17 || e.keyCode == 229 || (e.eventPhase != 2 && (e.target is TextField) && (e.target.type == TextFieldType.INPUT))))
			{
				onKeyUse(e.keyCode);
			}
			else if (_except != null && _except.indexOf(e.keyCode) != -1)
			{
				onKeyUse(e.keyCode);
			}
			if (e.keyCode == KeyCodes.SHIFT.keyCode)
			{
				shiftKey=true;
			}
			if (e.keyCode == KeyCodes.CONTROL.keyCode)
			{
				ctrlKey=true;
			}
		}

		/**
		 *
		 * @param keyCode
		 *
		 */
		private static function onKeyUse(keyCode:uint):void
		{
			if (!Boolean(downkey_cache[keyCode]))
			{
				downkey_cache[keyCode]=true;
				downkeys.push(keyCode);
			}
		}

		private static function createKeyString(keyString:String, ctrl:Boolean=false, alt:Boolean=false, shift:Boolean=false):String
		{
			var str:String="";
			if (ctrl)
			{
				str+="ctrl+";
			}
			if (alt)
			{
				str+="alt+";
			}
			if (shift)
			{
				str+="shift+";
			}
			str+=keyString;
			return (str);
		}

		private static function onKeyUp(e:KeyboardEvent):void
		{
			if ((!_keyEnale && (_except != null && _except.indexOf(e.keyCode) != -1)) || _keyEnale && !(e.keyCode == 18 || e.keyCode == 16 || e.keyCode == 17))
			{
				onKeyUse(e.keyCode);
				if (!(e.eventPhase != 2 && (e.target is TextField) && (e.target.type == TextFieldType.INPUT)))
				{
					downkeys.sort(Array.NUMERIC);
					var keysString:String=createKeyString(downkeys.join("+"), e.ctrlKey, e.altKey, e.shiftKey);
					if (hotkeys.hasOwnProperty(keysString))
					{
						hotkeys[keysString].execute();
					}
				}
			}
			downkey_cache.length=0;
			downkeys.length=0;
			if (e.keyCode == KeyCodes.SHIFT.keyCode)
			{
				shiftKey=false;
			}
			if (e.keyCode == KeyCodes.CONTROL.keyCode)
			{
				ctrlKey=false;
			}
		}
	}
}



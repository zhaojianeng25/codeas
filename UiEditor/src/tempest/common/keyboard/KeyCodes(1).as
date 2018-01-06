package tempest.common.keyboard
{
	import flash.utils.Dictionary;

	public class KeyCodes
	{
		/**
		 *
		 * @default
		 */
		public static const INVALID:KeyCodes=new KeyCodes(0);
		/**
		 *
		 * @default
		 */
		public static const BACKSPACE:KeyCodes=new KeyCodes(8);
		/**
		 *
		 * @default
		 */
		public static const TAB:KeyCodes=new KeyCodes(9);
		/**
		 *
		 * @default
		 */
		public static const ENTER:KeyCodes=new KeyCodes(13);
		/**
		 *
		 * @default
		 */
		public static const COMMAND:KeyCodes=new KeyCodes(15);
		/**
		 *
		 * @default
		 */
		public static const SHIFT:KeyCodes=new KeyCodes(16);
		/**
		 *
		 * @default
		 */
		public static const CONTROL:KeyCodes=new KeyCodes(17);
		/**
		 *
		 * @default
		 */
		public static const ALT:KeyCodes=new KeyCodes(18);
		/**
		 *
		 * @default
		 */
		public static const PAUSE:KeyCodes=new KeyCodes(19);
		/**
		 *
		 * @default
		 */
		public static const CAPS_LOCK:KeyCodes=new KeyCodes(20);
		/**
		 *
		 * @default
		 */
		public static const ESCAPE:KeyCodes=new KeyCodes(27);
		/**
		 *
		 * @default
		 */
		public static const SPACE:KeyCodes=new KeyCodes(32);
		/**
		 *
		 * @default
		 */
		public static const PAGE_UP:KeyCodes=new KeyCodes(33);
		/**
		 *
		 * @default
		 */
		public static const PAGE_DOWN:KeyCodes=new KeyCodes(34);
		/**
		 *
		 * @default
		 */
		public static const END:KeyCodes=new KeyCodes(35);
		/**
		 *
		 * @default
		 */
		public static const HOME:KeyCodes=new KeyCodes(36);
		/**
		 *
		 * @default
		 */
		public static const LEFT:KeyCodes=new KeyCodes(37);
		/**
		 *
		 * @default
		 */
		public static const UP:KeyCodes=new KeyCodes(38);
		/**
		 *
		 * @default
		 */
		public static const RIGHT:KeyCodes=new KeyCodes(39);
		/**
		 *
		 * @default
		 */
		public static const DOWN:KeyCodes=new KeyCodes(40);
		/**
		 *
		 * @default
		 */
		public static const INSERT:KeyCodes=new KeyCodes(45);
		/**
		 *
		 * @default
		 */
		public static const DELETE:KeyCodes=new KeyCodes(46);
		/**
		 *
		 * @default
		 */
		public static const ZERO:KeyCodes=new KeyCodes(48);
		/**
		 *
		 * @default
		 */
		public static const ONE:KeyCodes=new KeyCodes(49);
		/**
		 *
		 * @default
		 */
		public static const TWO:KeyCodes=new KeyCodes(50);
		/**
		 *
		 * @default
		 */
		public static const THREE:KeyCodes=new KeyCodes(51);
		/**
		 *
		 * @default
		 */
		public static const FOUR:KeyCodes=new KeyCodes(52);
		/**
		 *
		 * @default
		 */
		public static const FIVE:KeyCodes=new KeyCodes(53);
		/**
		 *
		 * @default
		 */
		public static const SIX:KeyCodes=new KeyCodes(54);
		/**
		 *
		 * @default
		 */
		public static const SEVEN:KeyCodes=new KeyCodes(55);
		/**
		 *
		 * @default
		 */
		public static const EIGHT:KeyCodes=new KeyCodes(56);
		/**
		 *
		 * @default
		 */
		public static const NINE:KeyCodes=new KeyCodes(57);
		/**
		 *
		 * @default
		 */
		public static const A:KeyCodes=new KeyCodes(65);
		/**
		 *
		 * @default
		 */
		public static const B:KeyCodes=new KeyCodes(66);
		/**
		 *
		 * @default
		 */
		public static const C:KeyCodes=new KeyCodes(67);
		/**
		 *
		 * @default
		 */
		public static const D:KeyCodes=new KeyCodes(68);
		/**
		 *
		 * @default
		 */
		public static const E:KeyCodes=new KeyCodes(69);
		/**
		 *
		 * @default
		 */
		public static const F:KeyCodes=new KeyCodes(70);
		/**
		 *
		 * @default
		 */
		public static const G:KeyCodes=new KeyCodes(71);
		/**
		 *
		 * @default
		 */
		public static const H:KeyCodes=new KeyCodes(72);
		/**
		 *
		 * @default
		 */
		public static const I:KeyCodes=new KeyCodes(73);
		/**
		 *
		 * @default
		 */
		public static const J:KeyCodes=new KeyCodes(74);
		/**
		 *
		 * @default
		 */
		public static const K:KeyCodes=new KeyCodes(75);
		/**
		 *
		 * @default
		 */
		public static const L:KeyCodes=new KeyCodes(76);
		/**
		 *
		 * @default
		 */
		public static const M:KeyCodes=new KeyCodes(77);
		/**
		 *
		 * @default
		 */
		public static const N:KeyCodes=new KeyCodes(78);
		/**
		 *
		 * @default
		 */
		public static const O:KeyCodes=new KeyCodes(79);
		/**
		 *
		 * @default
		 */
		public static const P:KeyCodes=new KeyCodes(80);
		/**
		 *
		 * @default
		 */
		public static const Q:KeyCodes=new KeyCodes(81);
		/**
		 *
		 * @default
		 */
		public static const R:KeyCodes=new KeyCodes(82);
		/**
		 *
		 * @default
		 */
		public static const S:KeyCodes=new KeyCodes(83);
		/**
		 *
		 * @default
		 */
		public static const T:KeyCodes=new KeyCodes(84);
		/**
		 *
		 * @default
		 */
		public static const U:KeyCodes=new KeyCodes(85);
		/**
		 *
		 * @default
		 */
		public static const V:KeyCodes=new KeyCodes(86);
		/**
		 *
		 * @default
		 */
		public static const W:KeyCodes=new KeyCodes(87);
		/**
		 *
		 * @default
		 */
		public static const X:KeyCodes=new KeyCodes(88);
		/**
		 *
		 * @default
		 */
		public static const Y:KeyCodes=new KeyCodes(89);
		/**
		 *
		 * @default
		 */
		public static const Z:KeyCodes=new KeyCodes(90);
		/**
		 *
		 * @default
		 */
		public static const LEFTB:KeyCodes=new KeyCodes(219);
		/**
		 *
		 * @default
		 */
		public static const NUM0:KeyCodes=new KeyCodes(96);
		/**
		 *
		 * @default
		 */
		public static const NUM1:KeyCodes=new KeyCodes(97);
		/**
		 *
		 * @default
		 */
		public static const NUM2:KeyCodes=new KeyCodes(98);
		/**
		 *
		 * @default
		 */
		public static const NUM3:KeyCodes=new KeyCodes(99);
		/**
		 *
		 * @default
		 */
		public static const NUM4:KeyCodes=new KeyCodes(100);
		/**
		 *
		 * @default
		 */
		public static const NUM5:KeyCodes=new KeyCodes(101);
		/**
		 *
		 * @default
		 */
		public static const NUM6:KeyCodes=new KeyCodes(102);
		/**
		 *
		 * @default
		 */
		public static const NUM7:KeyCodes=new KeyCodes(103);
		/**
		 *
		 * @default
		 */
		public static const NUM8:KeyCodes=new KeyCodes(104);
		/**
		 *
		 * @default
		 */
		public static const NUM9:KeyCodes=new KeyCodes(105);
		/**
		 *
		 * @default
		 */
		public static const MULTIPLY:KeyCodes=new KeyCodes(106);
		/**
		 *
		 * @default
		 */
		public static const ADD:KeyCodes=new KeyCodes(107);
		/**
		 *
		 * @default
		 */
		public static const NUMENTER:KeyCodes=new KeyCodes(108);
		/**
		 *
		 * @default
		 */
		public static const SUBTRACT:KeyCodes=new KeyCodes(109);
		/**
		 *
		 * @default
		 */
		public static const DECIMAL:KeyCodes=new KeyCodes(110);
		/**
		 *
		 * @default
		 */
		public static const DIVIDE:KeyCodes=new KeyCodes(111);
		/**
		 *
		 * @default
		 */
		public static const F1:KeyCodes=new KeyCodes(112);
		/**
		 *
		 * @default
		 */
		public static const F2:KeyCodes=new KeyCodes(113);
		/**
		 *
		 * @default
		 */
		public static const F3:KeyCodes=new KeyCodes(114);
		/**
		 *
		 * @default
		 */
		public static const F4:KeyCodes=new KeyCodes(115);
		/**
		 *
		 * @default
		 */
		public static const F5:KeyCodes=new KeyCodes(116);
		/**
		 *
		 * @default
		 */
		public static const F6:KeyCodes=new KeyCodes(117);
		/**
		 *
		 * @default
		 */
		public static const F7:KeyCodes=new KeyCodes(118);
		/**
		 *
		 * @default
		 */
		public static const F8:KeyCodes=new KeyCodes(119);
		/**
		 *
		 * @default
		 */
		public static const F9:KeyCodes=new KeyCodes(120);
		// F10 is considered 'reserved' by Flash
		/**
		 *
		 * @default
		 */
		public static const F11:KeyCodes=new KeyCodes(122);
		/**
		 *
		 * @default
		 */
		public static const F12:KeyCodes=new KeyCodes(123);
		/**
		 *
		 * @default
		 */
		public static const NUM_LOCK:KeyCodes=new KeyCodes(144);
		/**
		 *
		 * @default
		 */
		public static const SCROLL_LOCK:KeyCodes=new KeyCodes(145);
		/**
		 *
		 * @default
		 */
		public static const COLON:KeyCodes=new KeyCodes(186);
		/**
		 *
		 * @default
		 */
		public static const PLUS:KeyCodes=new KeyCodes(187);
		/**
		 *
		 * @default
		 */
		public static const COMMA:KeyCodes=new KeyCodes(188);
		/**
		 *
		 * @default
		 */
		public static const MINUS:KeyCodes=new KeyCodes(189);
		/**
		 *
		 * @default
		 */
		public static const PERIOD:KeyCodes=new KeyCodes(190);
		/**
		 *
		 * @default
		 */
		public static const BACKSLASH:KeyCodes=new KeyCodes(191);
		/**
		 *
		 * @default
		 */
		public static const TILDE:KeyCodes=new KeyCodes(192);
		/**
		 *
		 * @default
		 */
		public static const LEFT_BRACKET:KeyCodes=new KeyCodes(219);
		/**
		 *
		 * @default
		 */
		public static const SLASH:KeyCodes=new KeyCodes(220);
		/**
		 *
		 * @default
		 */
		public static const RIGHT_BRACKET:KeyCodes=new KeyCodes(221);
		/**
		 *
		 * @default
		 */
		public static const QUOTE:KeyCodes=new KeyCodes(222);
		/**
		 *
		 * @default
		 */
		public static const MOUSE_BUTTON:KeyCodes=new KeyCodes(253);
		/**
		 *
		 * @default
		 */
		public static const MOUSE_X:KeyCodes=new KeyCodes(254);
		/**
		 *
		 * @default
		 */
		public static const MOUSE_Y:KeyCodes=new KeyCodes(255);
		/**
		 *
		 * @default
		 */
		public static const MOUSE_WHEEL:KeyCodes=new KeyCodes(256);
		/**
		 *
		 * @default
		 */
		public static const MOUSE_HOVER:KeyCodes=new KeyCodes(257);

		/**
		 * A dictionary mapping the string names of all the keys to the InputKey they represent.
		 */
		public static function get staticTypeMap():Dictionary
		{
			if (!_typeMap)
			{
				_typeMap=new Dictionary();
				_typeMap["BACKSPACE"]=BACKSPACE;
				_typeMap["TAB"]=TAB;
				_typeMap["ENTER"]=ENTER;
				_typeMap["RETURN"]=ENTER;
				_typeMap["SHIFT"]=SHIFT;
				_typeMap["COMMAND"]=COMMAND;
				_typeMap["CONTROL"]=CONTROL;
				_typeMap["ALT"]=ALT;
				_typeMap["OPTION"]=ALT;
				_typeMap["ALTERNATE"]=ALT;
				_typeMap["PAUSE"]=PAUSE;
				_typeMap["CAPS_LOCK"]=CAPS_LOCK;
				_typeMap["ESCAPE"]=ESCAPE;
				_typeMap["SPACE"]=SPACE;
				_typeMap["SPACE_BAR"]=SPACE;
				_typeMap["PAGE_UP"]=PAGE_UP;
				_typeMap["PAGE_DOWN"]=PAGE_DOWN;
				_typeMap["END"]=END;
				_typeMap["HOME"]=HOME;
				_typeMap["LEFT"]=LEFT;
				_typeMap["UP"]=UP;
				_typeMap["RIGHT"]=RIGHT;
				_typeMap["DOWN"]=DOWN;
				_typeMap["LEFT_ARROW"]=LEFT;
				_typeMap["UP_ARROW"]=UP;
				_typeMap["RIGHT_ARROW"]=RIGHT;
				_typeMap["DOWN_ARROW"]=DOWN;
				_typeMap["INSERT"]=INSERT;
				_typeMap["DELETE"]=DELETE;
				_typeMap["ZERO"]=ZERO;
				_typeMap["ONE"]=ONE;
				_typeMap["TWO"]=TWO;
				_typeMap["THREE"]=THREE;
				_typeMap["FOUR"]=FOUR;
				_typeMap["FIVE"]=FIVE;
				_typeMap["SIX"]=SIX;
				_typeMap["SEVEN"]=SEVEN;
				_typeMap["EIGHT"]=EIGHT;
				_typeMap["NINE"]=NINE;
				_typeMap["0"]=ZERO;
				_typeMap["1"]=ONE;
				_typeMap["2"]=TWO;
				_typeMap["3"]=THREE;
				_typeMap["4"]=FOUR;
				_typeMap["5"]=FIVE;
				_typeMap["6"]=SIX;
				_typeMap["7"]=SEVEN;
				_typeMap["8"]=EIGHT;
				_typeMap["9"]=NINE;
				_typeMap["NUMBER_0"]=ZERO;
				_typeMap["NUMBER_1"]=ONE;
				_typeMap["NUMBER_2"]=TWO;
				_typeMap["NUMBER_3"]=THREE;
				_typeMap["NUMBER_4"]=FOUR;
				_typeMap["NUMBER_5"]=FIVE;
				_typeMap["NUMBER_6"]=SIX;
				_typeMap["NUMBER_7"]=SEVEN;
				_typeMap["NUMBER_8"]=EIGHT;
				_typeMap["NUMBER_9"]=NINE;
				_typeMap["A"]=A;
				_typeMap["B"]=B;
				_typeMap["C"]=C;
				_typeMap["D"]=D;
				_typeMap["E"]=E;
				_typeMap["F"]=F;
				_typeMap["G"]=G;
				_typeMap["H"]=H;
				_typeMap["I"]=I;
				_typeMap["J"]=J;
				_typeMap["K"]=K;
				_typeMap["L"]=L;
				_typeMap["M"]=M;
				_typeMap["N"]=N;
				_typeMap["O"]=O;
				_typeMap["P"]=P;
				_typeMap["Q"]=Q;
				_typeMap["R"]=R;
				_typeMap["S"]=S;
				_typeMap["T"]=T;
				_typeMap["U"]=U;
				_typeMap["V"]=V;
				_typeMap["W"]=W;
				_typeMap["X"]=X;
				_typeMap["Y"]=Y;
				_typeMap["Z"]=Z;
				_typeMap["LEFTB"]=LEFTB;
				_typeMap["NUM0"]=NUM0;
				_typeMap["NUM1"]=NUM1;
				_typeMap["NUM2"]=NUM2;
				_typeMap["NUM3"]=NUM3;
				_typeMap["NUM4"]=NUM4;
				_typeMap["NUM5"]=NUM5;
				_typeMap["NUM6"]=NUM6;
				_typeMap["NUM7"]=NUM7;
				_typeMap["NUM8"]=NUM8;
				_typeMap["NUM9"]=NUM9;
				_typeMap["NUMPAD_0"]=NUM0;
				_typeMap["NUMPAD_1"]=NUM1;
				_typeMap["NUMPAD_2"]=NUM2;
				_typeMap["NUMPAD_3"]=NUM3;
				_typeMap["NUMPAD_4"]=NUM4;
				_typeMap["NUMPAD_5"]=NUM5;
				_typeMap["NUMPAD_6"]=NUM6;
				_typeMap["NUMPAD_7"]=NUM7;
				_typeMap["NUMPAD_8"]=NUM8;
				_typeMap["NUMPAD_9"]=NUM9;
				_typeMap["MULTIPLY"]=MULTIPLY;
				_typeMap["ASTERISK"]=MULTIPLY;
				_typeMap["NUMMULTIPLY"]=MULTIPLY;
				_typeMap["NUMPAD_MULTIPLY"]=MULTIPLY;
				_typeMap["ADD"]=ADD;
				_typeMap["NUMADD"]=ADD;
				_typeMap["NUMPAD_ADD"]=ADD;
				_typeMap["SUBTRACT"]=SUBTRACT;
				_typeMap["NUMSUBTRACT"]=SUBTRACT;
				_typeMap["NUMPAD_SUBTRACT"]=SUBTRACT;
				_typeMap["DECIMAL"]=DECIMAL;
				_typeMap["NUMDECIMAL"]=DECIMAL;
				_typeMap["NUMPAD_DECIMAL"]=DECIMAL;
				_typeMap["DIVIDE"]=DIVIDE;
				_typeMap["NUMDIVIDE"]=DIVIDE;
				_typeMap["NUMPAD_DIVIDE"]=DIVIDE;
				_typeMap["NUMENTER"]=NUMENTER;
				_typeMap["NUMPAD_ENTER"]=NUMENTER;
				_typeMap["F1"]=F1;
				_typeMap["F2"]=F2;
				_typeMap["F3"]=F3;
				_typeMap["F4"]=F4;
				_typeMap["F5"]=F5;
				_typeMap["F6"]=F6;
				_typeMap["F7"]=F7;
				_typeMap["F8"]=F8;
				_typeMap["F9"]=F9;
				_typeMap["F11"]=F11;
				_typeMap["F12"]=F12;
				_typeMap["NUM_LOCK"]=NUM_LOCK;
				_typeMap["SCROLL_LOCK"]=SCROLL_LOCK;
				_typeMap["COLON"]=COLON;
				_typeMap["SEMICOLON"]=COLON;
				_typeMap["PLUS"]=PLUS;
				_typeMap["EQUAL"]=PLUS;
				_typeMap["COMMA"]=COMMA;
				_typeMap["LESS_THAN"]=COMMA;
				_typeMap["MINUS"]=MINUS;
				_typeMap["UNDERSCORE"]=MINUS;
				_typeMap["PERIOD"]=PERIOD;
				_typeMap["GREATER_THAN"]=PERIOD;
				_typeMap["BACKSLASH"]=BACKSLASH;
				_typeMap["QUESTION_MARK"]=BACKSLASH;
				_typeMap["TILDE"]=TILDE;
				_typeMap["BACK_QUOTE"]=TILDE;
				_typeMap["LEFT_BRACKET"]=LEFT_BRACKET;
				_typeMap["LEFT_BRACE"]=LEFT_BRACKET;
				_typeMap["SLASH"]=SLASH;
				_typeMap["FORWARD_SLASH"]=SLASH;
				_typeMap["PIPE"]=SLASH;
				_typeMap["RIGHT_BRACKET"]=RIGHT_BRACKET;
				_typeMap["RIGHT_BRACE"]=RIGHT_BRACKET;
				_typeMap["QUOTE"]=QUOTE;
				_typeMap["MOUSE_BUTTON"]=MOUSE_BUTTON;
				_typeMap["MOUSE_X"]=MOUSE_X;
				_typeMap["MOUSE_Y"]=MOUSE_Y;
				_typeMap["MOUSE_WHEEL"]=MOUSE_WHEEL;
				_typeMap["MOUSE_HOVER"]=MOUSE_HOVER;
			}
			return _typeMap;
		}

		/**
		 * Converts a key code to the string that represents it.
		 */
		public static function codeToString(value:int):String
		{
			var tm:Dictionary=staticTypeMap;
			for (var name:String in tm)
			{
				if (staticTypeMap[name.toUpperCase()].keyCode == value)
					return name.toUpperCase();
			}
			return null;
		}

		/**
		 * Converts the name of a key to the keycode it represents.
		 */
		public static function stringToCode(value:String):int
		{
			if (!staticTypeMap[value.toUpperCase()])
				return 0;
			return staticTypeMap[value.toUpperCase()].keyCode;
		}

		/**
		 * Converts the name of a key to the InputKey it represents.
		 */
		public static function stringToKey(value:String):KeyCodes
		{
			return staticTypeMap[value.toUpperCase()];
		}
		private static var _typeMap:Dictionary=null;

		/**
		 * The key code that this wraps.
		 */
		public function get keyCode():int
		{
			return _keyCode;
		}

		/**
		 *
		 * @param keyCode
		 */
		public function KeyCodes(keyCode:int=0)
		{
			_keyCode=keyCode;
		}
		private var _keyCode:int=0;
	}
}

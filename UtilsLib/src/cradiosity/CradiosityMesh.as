package cradiosity
{
	import flash.events.Event;
	
	import pack.Prefab;
	
	public class CradiosityMesh extends Prefab
	{
//		环境光亮度 0.25    //Ambient_light_intensity
//		阴影精度 1.0   Shadow_precision
//		patch精度0.25 	patch_precision
//		光线传递次数 1    patch_num
//		开启AO false     //openAO
//		AO范围 0.1      //Ao_Range
//		AO强度 0.1      //strength
		
		


		private var _Ambient_light_intensity:Number;
		private var _Ambient_light_Size:Number;
	    
		private var _Shadow_precision:Number;
		private var _patch_precision:Number;
		private var _patch_num:Number;
		private var _openAo:Boolean;
		private var _Ao_Range:Number;
		private var _Ao_strength:Number;

		
		


		public function CradiosityMesh()
		{
			super();
		}


		


		public function get Ambient_light_intensity():Number
		{
			return _Ambient_light_intensity;
		}
		[Editor(type="ColorPick",Label="环境光亮度",sort="0.5",Category="属性",Tip="范围")]
		public function set Ambient_light_intensity(value:Number):void
		{
			_Ambient_light_intensity = value;
			change()
		}
		public function get Ambient_light_Size():Number
		{
			return _Ambient_light_Size;
		}
		[Editor(type="Number",Label="环境光亮度",Step="0.01",sort="2",MinNum="0",MaxNum="20",Category="属性",Tip="环境光亮度")]
		public function set Ambient_light_Size(value:Number):void
		{
			_Ambient_light_Size = value;
			change()
		}

		public function get Shadow_precision():Number
		{
			return _Shadow_precision;
		}
		[Editor(type="Number",Label="阴影精度",Step="0.01",sort="2",MinNum="0",MaxNum="10",Category="显示",Tip="摩擦系数")]
		public function set Shadow_precision(value:Number):void
		{
			_Shadow_precision = value;
			change()
		}

		public function get patch_precision():Number
		{
			return _patch_precision;
		}
		[Editor(type="Number",Label="patch精度0",Step="0.01",sort="3",MinNum="0",MaxNum="10",Category="显示",Tip="摩擦系数")]
		public function set patch_precision(value:Number):void
		{
			_patch_precision = value;
			change()
		}

		public function get patch_num():Number
		{
			return _patch_num;
		}
		[Editor(type="Number",Label="光线传递次数",Step="1",sort="4",MinNum="1",MaxNum="10",Category="显示",Tip="摩擦系数")]
		public function set patch_num(value:Number):void
		{
			_patch_num = value;
			change()
		}


		public function get openAo():Boolean
		{
			return _openAo;
		}
		[Editor(type="ComboBox",Label="开启AO",sort="5",Category="显示",Data="{name:false,data:false}{name:true,data:true}",Tip="")]
		public function set openAo(value:Boolean):void
		{
			_openAo = value;
			change();
		}
		
		
		public function get Ao_Range():Number
		{
			return _Ao_Range;
		}
		[Editor(type="Number",Label="AO范围",Step="0.01",sort="6",MinNum="0",MaxNum="1",Category="显示",Tip="摩擦系数")]
		public function set Ao_Range(value:Number):void
		{
			_Ao_Range = value;
			change()
		}

		public function get Ao_strength():Number
		{
			return _Ao_strength;
		}
		[Editor(type="Number",Label="AO强度",Step="0.01",sort="7",MinNum="0",MaxNum="1",Category="显示",Tip="摩擦系数")]
		public function set Ao_strength(value:Number):void
		{
			_Ao_strength = value;
			change()
		}

		
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
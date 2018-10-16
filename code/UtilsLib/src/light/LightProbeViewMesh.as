package light
{
	import interfaces.ITile;
	
	import pack.ModePropertyMesh;
	
	public class LightProbeViewMesh extends ModePropertyMesh implements ITile
	{
		private var _isUse:Boolean

		public function LightProbeViewMesh()
		{
			super();
		}
		

		public function get isUse():Boolean
		{
			return _isUse;
		}
		[Editor(type="ComboBox",Label="是否起用",sort="10",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set isUse(value:Boolean):void
		{
			if(value!=_isUse){
				_isUse = value;
				this.change();
			}
			
			
		}

	}
}
package _Pan3D.display3D.lightProbe
{
	import flash.display3D.Context3D;
	
	import PanV2.xyzmove.lineTriV2.LineTri3DMultipleTriSprite;
	
	import _Pan3D.display3D.Display3DMaterialSprite;
	
	public class Display3DLightProbeSprite extends Display3DMaterialSprite
	{
		private var _ballItem:Vector.<Display3DLightProbeItemSprite>

		private var _lineSprite:LineTri3DMultipleTriSprite
		public function Display3DLightProbeSprite(context:Context3D)
		{
			super(context);
			
			_lineSprite=new LineTri3DMultipleTriSprite(_context3D)
		}



		public function get lineSprite():LineTri3DMultipleTriSprite
		{
			return _lineSprite;
		}

		public function set lineSprite(value:LineTri3DMultipleTriSprite):void
		{
			_lineSprite = value;
		}

		public function get ballItem():Vector.<Display3DLightProbeItemSprite>
		{
			return _ballItem;
		}

		public function set ballItem(value:Vector.<Display3DLightProbeItemSprite>):void
		{
			_ballItem = value;
		}

		override public function update() : void {
			if(!_visible){
				return 
			}
			for(var i:uint=0;_ballItem&&i<_ballItem.length;i++)
			{
				_ballItem[i].update()
			}
			
			_lineSprite.update()
		}
		override public function updataPos():void{
			this._absoluteX = this._x;
			this._absoluteY = this._y;
			this._absoluteZ = this._z;
			updatePosMatrix();
			
			_lineSprite.posMatrix=this.posMatrix

		}

	}
}
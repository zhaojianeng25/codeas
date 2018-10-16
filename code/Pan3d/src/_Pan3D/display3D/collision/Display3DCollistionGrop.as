package _Pan3D.display3D.collision
{
	import flash.geom.Matrix3D;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.display3D.model.Display3DModelSprite;
	
	import _me.Scene_data;

	public class Display3DCollistionGrop
	{
		private var _collisionItem:Vector.<CollisionVo>;
		private var _prentModel:Display3DModelSprite;
		//private var _tempSprite:Display3DCollisionSprite
		private var _item:Vector.<Display3DCollisionSprite>
		public function Display3DCollistionGrop()
		{
		}

		public function get item():Vector.<Display3DCollisionSprite>
		{
			return _item;
		}

		public function set item(value:Vector.<Display3DCollisionSprite>):void
		{
			_item = value;
		}

		public function set prentModel(value:Display3DModelSprite):void
		{
			_prentModel = value;
		}

		public function set collisionItem(value:Vector.<CollisionVo>):void
		{
			_collisionItem = value;
			_item=new Vector.<Display3DCollisionSprite>
			for(var i:uint=0;_collisionItem&&i<_collisionItem.length;i++){
				var _tempSprite:Display3DCollisionSprite=new Display3DCollisionSprite(Scene_data.context3D);
				_tempSprite.collisionVo=value[i];
				_item.push(_tempSprite)
			}
			this.update()
			
		}
		public function update():void
		{
			for(var i:uint=0;i<_item.length;i++){
				_item[i].prentMatrx3D=this._prentModel.posMatrix;
				_item[i].update();
			}
		
		}

		public function clear():void
		{
			_item=new Vector.<Display3DCollisionSprite>;
			_collisionItem=null;
			
		}
	}
}
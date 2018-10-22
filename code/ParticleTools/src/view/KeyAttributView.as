package view
{
	import flash.geom.Vector3D;
	
	import _Pan3D.particle.Display3DParticle;
	
	import _me.Scene_data;
	
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.base.TooXyzPosData;
	import xyz.draw.TooXyzMoveData;
	
	public class KeyAttributView  extends BaseReflectionView
	{
		public var obj:Object = new Object;
		public function KeyAttributView()
		{
			super();
			this.creat(pan3dMenu());
			this.refreshView();
		}
		public function setData($value:ParticleItem):void
		{
			_particleItem=$value;
			showXyzMove()
		
		}
		private function showXyzMove():void
		{
			if(this._particleItem&&this._particleItem.display3D){
				var $sprite:Display3DParticle=this._particleItem.display3D
				if(isUseReturn($sprite.particleType)){
					return;
				}

				var $xyzPosData:TooXyzMoveData=new TooXyzMoveData
				$xyzPosData.dataItem=new Vector.<TooXyzPosData>;
				$xyzPosData.modelItem=new Array
				
				var k:TooXyzPosData=new TooXyzPosData;
				k.x=$sprite.center.x/10
				k.y=$sprite.center.y/10
				k.z=$sprite.center.z/10
				k.scale_x=1
				k.scale_y=1
				k.scale_z=1
				k.angle_x=$sprite.rotationX
				k.angle_y=$sprite.rotationY
				k.angle_z=$sprite.rotationZ
				$xyzPosData.dataItem.push(k)
				$xyzPosData.modelItem.push($sprite)
				
				$xyzPosData.fun=xyzBfun
				$xyzPosData.isCenten=true
				MoveScaleRotationLevel.getInstance().xyzMoveData=$xyzPosData
				
			}
			
			
		}
		private function xyzBfun($XyzMoveData:xyz.draw.TooXyzMoveData):void
		{
			if(_particleItem&&$XyzMoveData.modelItem.length==1){
				var $TooXyzPosData:TooXyzPosData=$XyzMoveData.dataItem[0];
				var $sprite:Display3DParticle=$XyzMoveData.modelItem[0];
				 if($sprite.particleType==3||$sprite.particleType==14){
				 	return ;
				 }

				_particleItem.display3D.center.x=$TooXyzPosData.x*10
				_particleItem.display3D.center.y=$TooXyzPosData.y*10
				_particleItem.display3D.center.z=$TooXyzPosData.z*10
					
				_particleItem.display3D.rotationX=$TooXyzPosData.angle_x
				_particleItem.display3D.rotationY=$TooXyzPosData.angle_y
				_particleItem.display3D.rotationZ=$TooXyzPosData.angle_z
		
				this.refreshView();
				applyData()
		
			}
			
		}
		private var _particleItem:ParticleItem;
		

		private function pan3dMenu():Array
		{
			var ary:Array =
				[
					{Type:ReflectionData.Vec3,Label:"位置:",GetFun:getPostion,SetFun:setPostion,Category:"属性"},
					{Type:ReflectionData.Vec3,Label:"旋转:",GetFun:getRotation,SetFun:setRotation,Category:"属性"},
					{Type:ReflectionData.Number,Label:"时间长度:",GetFun:getLife,SetFun:setLife,Category:"时间",MaxNum:50000,MinNum:-1,Step:1},
				]
			
			return ary;
		}
		public function getLife():Number{
			if(_particleItem){
				_lifeNum= _particleItem.timeline.getLastTime();
			}
			return _lifeNum
		}
		private var _lifeNum:int=0
		public function setLife(value:Number):void{
			_lifeNum=value
			if(_particleItem){
				_particleItem.timeline.setLastTime(_lifeNum);
			}
		}
		public function getRotation():Vector3D{
	
			var pos:Vector3D=new Vector3D
			if(_particleItem){
				pos.x=_particleItem.display3D.rotationX
				pos.y=_particleItem.display3D.rotationY
				pos.z=_particleItem.display3D.rotationZ
				
			}
			return pos;
		}
		public function setRotation(value:Vector3D):void{
			if(_particleItem){
				_particleItem.display3D.rotationX=value.x
				_particleItem.display3D.rotationY=value.y
				_particleItem.display3D.rotationZ=value.z
				
			}
			showXyzMove()
			applyData()
		}
		public function getPostion():Vector3D{
			
			var pos:Vector3D=new Vector3D
			if(_particleItem){
				pos.x=_particleItem.display3D.center.x
				pos.y=_particleItem.display3D.center.y
				pos.z=_particleItem.display3D.center.z
				
			}
			return pos;
		}
		private function isUseReturn($type:Number):Boolean
		{
			if($type==3||$type==14){
				return true
			}else{
			
				return false
			}
			
		}
		public function setPostion(value:Vector3D):void{
			
			if(_particleItem){
				if(isUseReturn(_particleItem.display3D.particleType)){
					return 
				}
				_particleItem.display3D.center.x=value.x
				_particleItem.display3D.center.y=value.y
				_particleItem.display3D.center.z=value.z
		
	
			}
			showXyzMove()
			applyData()
		}
		public function applyData():void
		{
			if(_particleItem){
				
				
				_particleItem.display3D.x = _particleItem.display3D.center.x;
				_particleItem.display3D.y = _particleItem.display3D.center.y;
				_particleItem.display3D.z = _particleItem.display3D.center.z; 
				
				_particleItem.display3D.updatePosMatrix()
				_particleItem.display3D.updateAnimMatix()
					
			
					
				
			}
		}
		
		
		/**end***************/
	}
}
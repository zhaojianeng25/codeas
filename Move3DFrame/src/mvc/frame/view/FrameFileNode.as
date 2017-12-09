package mvc.frame.view
{
	import flash.display.Bitmap;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.core.Quaternion;
	
	import common.utils.ui.file.FileNode;
	
	import mvc.frame.lightbmp.LightBmpModel;
	import mvc.frame.line.FrameLineMc;
	import mvc.frame.line.FrameLinePointVo;
	
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.pan3d.roles.ProxyPan3DRole;
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	public class FrameFileNode extends FileNode
	{
		
		public static var Folder0:Number=0//文件夾
		public static var build1:Number=1//动画
			
		public var iModel:IModel;
		public var frameLineMc:FrameLineMc;
	//	public var prefabUrl:String

		public var pointitem:Vector.<FrameLinePointVo>
		public var type:Number=0;   //0为文件夹
		public var treeSelect:Boolean;
		public var lock:Boolean;
		public var hide:Boolean;
		public var select:Boolean;
		public var receiveShadow:Boolean;
		public var lightTexture:Texture
		public var lightuvSize:int;
		public function FrameFileNode()
		{
			super();
			this.lightuvSize=128
			this.frameLineMc=new FrameLineMc;
			this.frameLineMc.frameFileNode=this;
			this.pointitem=new Vector.<FrameLinePointVo>;
			for(var i:Number=0;i<2;i++){
			
				var $obj:FrameLinePointVo=new FrameLinePointVo ;
				
//				$obj.x=Math.random()*600-300;
//				$obj.y=Math.random()*600-300;
//				$obj.z=Math.random()*600-300;

				$obj.scale_x=1;
				$obj.scale_y=1;
				$obj.scale_z=1;
				if(i==0){
					$obj.time=0;
				}else{
			
					$obj.time=Math.floor(i*10+Math.random()*200);
				}
				
			

				this.pointitem.push($obj);
				this.url
			}
			
			this.url="content/finalscens/pan/基础/模型/ball_0.prefab"
			this.url="content/finalscens/pan/停车场/模型/白色立方体.prefab"
		}
		public function getPointItemObject():Array
		{
			var $arr:Array=new Array;
			var $timeDic:Dictionary=new Dictionary
			for(var i:Number=0;i<this.pointitem.length;i++){
				if(!$timeDic.hasOwnProperty(this.pointitem[i].time)){
					$arr.push(this.pointitem[i].getObject())
				}
				$timeDic[this.pointitem[i].time]=true
			}
			return $arr
		}
		
		public function setPointItemObject($arr:Array):void
		{
			this.pointitem.length=0
	
			for(var i:Number=0;$arr&&i<$arr.length;i++){
				
				var $ke:FrameLinePointVo=new FrameLinePointVo()
				$ke.writeObject($arr[i])
				this.pointitem.push($ke);
			}
		
		}
		
		public function getPintMaxTime():Number
		{

			var $num:Number=-1
			if(this.type==FrameFileNode.build1){
				for(var i:Number=0;i<this.pointitem.length;i++){
					$num=Math.max($num,this.pointitem[i].time)
				}
			}
			return $num
		
		}
		private function inKeyFrameTime($num:Number):Boolean
		{
			
			var $min:uint=this.pointitem[0].time;
			var $max:uint=this.pointitem[this.pointitem.length-1].time;
	
		   var dd:FrameLinePointVo=	this.getPreFrameLinePointVoByTime($num);
			if($num>=$min&&$num<=$max &&dd){
				return dd.iskeyFrame;
			}else{
				return false;
			}
		}
		public function isVisible($num:Number):Boolean
		{
			var $hide:Boolean=this.isPerentHide(this)
			return this.inKeyFrameTime($num) &&!$hide;
		
		}
		private function isPerentHide($fileNode:FileNode):Boolean
		{
			var $node:FrameFileNode=$fileNode  as FrameFileNode
			if($node.hide){
				return true
			}else{
				if($node.parentNode){
					return this.isPerentHide($node.parentNode)
				}else{
					return false
				}
			}
			
		}
	
		
		public function changeEvent():void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function getNextFrameLinePointVoByTime($time:Number):FrameLinePointVo  //包含当前
		{
			var $next:FrameLinePointVo;
			for(var i:Number=0;i<this.pointitem.length;i++){
				if(this.pointitem[i].time>=$time){
					if(!$next||$next.time>this.pointitem[i].time){
						$next=this.pointitem[i]
					}
				}
			}
			return $next
		}
		public function getPreFrameLinePointVoByTime($time:Number):FrameLinePointVo  //包含当前
		{
			var $pre:FrameLinePointVo;
			for(var i:Number=0;i<this.pointitem.length;i++){
				if(this.pointitem[i].time<=$time){
					if(!$pre||$pre.time<this.pointitem[i].time){
						$pre=this.pointitem[i]
					}
				}
			}
			return $pre
		}
		
		public function insetKey($time:Number):FrameLinePointVo
		{
			var $hase:Boolean=false
			var $obj:FrameLinePointVo=new FrameLinePointVo ;
			for(var i:Number=0;i<this.pointitem.length;i++){
                 if(this.pointitem[i].time==$time){
					 $hase=true
					 $obj=this.pointitem[i]
				 }
			}
			$obj.time=$time
			$obj.x=this.iModel.x
			$obj.y=this.iModel.y
			$obj.z=this.iModel.z
			
			$obj.scale_x=this.iModel.scaleX
			$obj.scale_y=this.iModel.scaleY
			$obj.scale_z=this.iModel.scaleZ
			
			$obj.rotationX=this.iModel.rotationX
			$obj.rotationY=this.iModel.rotationY
			$obj.rotationZ=this.iModel.rotationZ
			if(!$hase){
		

				this.pointitem.push($obj);
			}else{
			    trace("已有关键帧")
			}
			return $obj
		}

		public function upData():void
		{
			if(this.inKeyFrameTime(AppDataFrame.frameNum)&&this.iModel){
				this.setModelSprite(this.playFrameVoByTime(AppDataFrame.frameNum))
				LightBmpModel.getInstance().setLightBmpToNode(this)
			}
		}
		public function playFrameVoByTime($time:Number):FrameLinePointVo
		{
			var $keyC:FrameLinePointVo;
			var $a:FrameLinePointVo=this.getPreFrameLinePointVoByTime($time)
			var $b:FrameLinePointVo=this.getNextFrameLinePointVoByTime($time)
			for(var i:Number=0;i<this.pointitem.length;i++){
				if(this.pointitem[i].time==$time){
					$keyC=this.pointitem[i];
				}
			}
			if($keyC){
				if($keyC.iskeyFrame){
					return $keyC
				}
			}else{
				if($a&&!$a.isAnimation){
					return $a
				}else if($a&&$b){
					return this.setModelData($a,$b,$time)
				}
			}
			return null
		}
		private function setModelData($a:FrameLinePointVo,$b:FrameLinePointVo,$time:Number):FrameLinePointVo
		{
			var $num:Number=($time-$a.time)/( $b.time-$a.time);
			
			var $obj:FrameLinePointVo=new FrameLinePointVo
			$obj.x=	$a.x+($b.x-$a.x)*$num;
			$obj.y=	$a.y+($b.y-$a.y)*$num;
			$obj.z=	$a.z+($b.z-$a.z)*$num;
			
			$obj.scale_x=	$a.scale_x+($b.scale_x-$a.scale_x)*$num;
			$obj.scale_y=	$a.scale_y+($b.scale_y-$a.scale_y)*$num;
			$obj.scale_z=	$a.scale_z+($b.scale_z-$a.scale_z)*$num;
			
			var $eulerAngle:Vector3D=this.qtoq($a,$b,$num)
			$obj.rotationX=$eulerAngle.x
			$obj.rotationY=$eulerAngle.y
			$obj.rotationZ=$eulerAngle.z
			$obj.data=$a.data //存前面一个的数所有 
				
			if(!$b.iskeyFrame){
				return $a
			}else{
				return $obj
			}

		}
		private function qtoq($a:FrameLinePointVo,$b:FrameLinePointVo,$time:Number):Vector3D
		{
		
			var $m0:Matrix3D=new Matrix3D();
			$m0.appendRotation($a.rotationX,Vector3D.X_AXIS)
			$m0.appendRotation($a.rotationY,Vector3D.Y_AXIS)
			$m0.appendRotation($a.rotationZ,Vector3D.Z_AXIS)
			var q0:Quaternion=new Quaternion()
			q0.fromMatrix($m0)
			
			var $m1:Matrix3D=new Matrix3D();
			$m1.appendRotation($b.rotationX,Vector3D.X_AXIS)
			$m1.appendRotation($b.rotationY,Vector3D.Y_AXIS)
			$m1.appendRotation($b.rotationZ,Vector3D.Z_AXIS)
			var q1:Quaternion=new Quaternion()
			q1.fromMatrix($m1)
				
			var resultQ:Quaternion = new Quaternion;
			resultQ.slerp(q0,q1,$time);
			var $ve:Vector3D=resultQ.toEulerAngles();
			$ve.scaleBy(180/Math.PI)
			
			if(isNaN($ve.x)||isNaN($ve.y)||isNaN($ve.z)){
				$ve.x=$a.rotationX;
				$ve.y=$a.rotationY;
				$ve.z=$a.rotationZ;
			}
				
			return $ve
		
		
		}
		
		private function setModelSprite($obj:FrameLinePointVo):void
		{
			
			this.iModel.x=$obj.x;
			this.iModel.y=$obj.y;
			this.iModel.z=$obj.z;
				
			this.iModel.scaleX=$obj.scale_x;
			this.iModel.scaleY=$obj.scale_y;
			this.iModel.scaleZ=$obj.scale_z;
			
	
			if(this.iModel as ProxyPan3DRole){
				ProxyPan3DRole(this.iModel).sprite.fileScale=($obj.scale_x+$obj.scale_y+$obj.scale_z)/3;
				 if($obj.data&&$obj.data.action){
					if( ProxyPan3DRole(this.iModel).sprite.curentAction!=$obj.data.action){
						ProxyPan3DRole(this.iModel).sprite.play($obj.data.action)
					}
				 }
			}
			
			this.iModel.rotationX=$obj.rotationX;
			this.iModel.rotationY=$obj.rotationY;
			this.iModel.rotationZ=$obj.rotationZ;
			
			
		}
		
		public function writeObject($obj:Object):void
		{
		
			this.id=$obj.id;
			this.name=$obj.name;
			this.type=$obj.type;
			this.lock=$obj.lock;
			this.receiveShadow=$obj.receiveShadow;
			this.lightuvSize=$obj.lightuvSize;
			
			if(this.type==FrameFileNode.Folder0){
				this.children=new ArrayCollection()
				for(var i:Number=0;$obj.children&&i<$obj.children.length;i++){
					var $node:FrameFileNode=new FrameFileNode()
					$node.writeObject($obj.children[i])
					$node.parentNode=this
					this.children.addItem($node)
				}	
			
			}else{
				this.url=$obj.url;
				this.setPointItemObject($obj.pointitem);
				this.iModel=AppDataFrame.addModel(this.url);
				
				if(this.url.search(".prefab")!=-1){
					var $ProxyPan3dModel:ProxyPan3dModel=	this.iModel as ProxyPan3dModel;
					var $url:String=Render.lightUvRoot+this.id+".jpg"
					if($ProxyPan3dModel.sprite.material.noLight==false){
						BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
						//	$ProxyPan3dModel.sprite.lightMapTexture=TextureManager.getInstance().bitmapToTexture($bitmap.bitmapData)
						},{})	
					}
				}
	
			}
		
		}
		public function getObject():Object{
		
			var $obj:Object=new Object;
			$obj.id=this.id;
			$obj.name=this.name;
			$obj.type=this.type;
			$obj.lock=this.lock;
			$obj.receiveShadow=this.receiveShadow;
			$obj.lightuvSize=this.lightuvSize;
			
			$obj.children=wirteItem(this.children);
	
			if(this.iModel){
				$obj.pointitem=this.getPointItemObject();
				$obj.url=this.url;
			}

			return $obj
		}
		private function wirteItem(childItem:ArrayCollection):Array
		{
			var $item:Array=new Array
			for(var i:uint=0;childItem&&i<childItem.length;i++){
				var $FrameFileNode:FrameFileNode=childItem[i] as FrameFileNode
				var $obj:Object=$FrameFileNode.getObject()
				$item.push($obj)
			}
			if($item.length){
				return $item
			}
			return null
		}
		
		public function insetF5($num:uint):void
		{
			var $max:FrameLinePointVo
			for(var i:Number=0;i<this.pointitem.length;i++){
				if(this.pointitem[i].time>$num){
					this.pointitem[i].time++
				}
			}
			if(this.getPintMaxTime()<$num){
				var $vo:FrameLinePointVo=this.getEndKeyPoint();
				if($vo.iskeyFrame){
					var $newVo:FrameLinePointVo=$vo.cloneVo()
					$newVo.time=$num
					$newVo.iskeyFrame=false;
					this.pointitem.push($newVo);
				}else{
					$vo.time=$num
				}
			}
			this.frameLineMc.refrish()

		}
		
		public function deleF5($num:uint):void
		{
			var $max:FrameLinePointVo
			for(var i:Number=0;i<this.pointitem.length;i++){
				if(this.pointitem[i].time>=$num){
					if(this.pointitem[i].time==$num){
						this.pointitem.splice(i,1)
					}else{
						this.pointitem[i].time--;
					}
				}
			}
			this.frameLineMc.refrish()
		}
		public function insetF6($num:uint):void
		{
			if(this.getPintMaxTime()>$num){
				trace("插入")
				this.insetKey($num)
			}else{
				trace("后加")
				var $vo:FrameLinePointVo=this.getEndKeyPoint();
				$vo.cloneVo()
				$vo.time=$num
				$vo.iskeyFrame=true;
				this.pointitem.push($vo);
				
			}
			this.frameLineMc.refrish()
		}
		public function getEndKeyPoint():FrameLinePointVo
		{
			var $vo:FrameLinePointVo
			for(var i:Number=0;i<this.pointitem.length;i++){
				if(!$vo||$vo.time<this.pointitem[i].time){
					$vo=this.pointitem[i]
				}
			}
		
			return $vo
			
		}
		public function getPrePointByFrame($num:uint):FrameLinePointVo
		{
			var $vo:FrameLinePointVo
			for(var i:Number=0;i<this.pointitem.length;i++){
				if($vo.time<$num){
				
					if(!$vo||$vo.time<this.pointitem[i].time){
						$vo=this.pointitem[i]
					}
				
				}
				
			}
			
			return $vo
		}
		

	
	}
}
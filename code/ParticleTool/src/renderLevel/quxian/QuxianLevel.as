package renderLevel.quxian
{
	import flash.display3D.Program3D;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.core.BezierClass;
	import _Pan3D.core.MathHitModel;
	import _Pan3D.lineTri.LineTri3DShader;
	import _Pan3D.particle.locusball.Display3DLocusBallPartilce;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.triPoint.TriPoint3DShader;
	
	import _me.Scene_data;
	import _me.xyzPos.XyzPosData;
	
	import guiji.Guiji3DLineDSprite;
	import guiji.GuijiLevel;
	import guiji.GuijiPoint3DSprite;
	import guiji.Line3DArrDisplay3DLocusBallSprite;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.base.TooXyzPosData;
	import xyz.draw.TooXyzMoveData;

	public class QuxianLevel  
	{
		public var x:int;
		public var y:int;
		public var z:int;
		
		
		private var _bezierPoint3DSprite:GuijiPoint3DSprite;
		private var _basePointLine:Guiji3DLineDSprite;
		private var _PointArr:Array;
		private var _guijiLizhiVO:Display3DLocusBallPartilce;
		private static var instance:QuxianLevel;
		private var _choosePointItem:Array
		private var _keyobj : Object = new Object;
		private var _needUpToView:Boolean=false
		
		public function QuxianLevel()
		{
			super();
			addShaders()
			initData()
		}
		
		public function set needUpToView(value:Boolean):void
		{
			_needUpToView = value;
		}
		
		public function get needUpToView():Boolean
		{
			return _needUpToView;
		}
		protected function initData():void
		{
			addLine()
			addLine3D();
			addPont();
			addEvents();
		}
		public function get guijiLizhiVO():Display3DLocusBallPartilce
		{
			return _guijiLizhiVO;
		}
		
		public function  setGuijiLizhiVO(value:Display3DLocusBallPartilce,isMustShow:Boolean=false):void
		{
			//XyzPosLevel.Instance().xyzPosData=null;
			MoveScaleRotationLevel.getInstance().xyzMoveData=null
			_needUpToView=false
			
			if(_guijiLizhiVO)
			{
				if(_guijiLizhiVO.id!=value.id){
					_guijiLizhiVO.fun(_guijiLizhiVO);
				}else{
					_guijiLizhiVO=null
					_PointArr=null;
					if(!isMustShow){
						return;
					}
				}
			}
			
			_guijiLizhiVO = value;
			if(_guijiLizhiVO.pointArr){
				_PointArr=_guijiLizhiVO.pointArr
			}else{
				throw new Error("没有给出坐标数组")
			}
			upPointItem(_PointArr)
			
			
			
		}
		
		public function hide():void{
			//XyzPosLevel.Instance().xyzPosData=null;
			MoveScaleRotationLevel.getInstance().xyzMoveData=null
			_guijiLizhiVO=null
			_PointArr=null;
		}
		
		public function addNewPoint():void
		{
			if(_guijiLizhiVO&& _guijiLizhiVO.pointArr.length>=4)
			{
				var a:Object3D
				var b:Object3D
				var p0:Object3D=new Object3D;
				var p1:Object3D=new Object3D;
				var p2:Object3D=new Object3D;
				if(_choosePointItem&&_choosePointItem.length>0&&XyzPosData(_choosePointItem[0]).id<_guijiLizhiVO.pointArr.length-2)
				{
					
					
					var tempxyzPosData:XyzPosData=_choosePointItem[0];
					var keyId:uint=int((tempxyzPosData.id+1)/3)*3;
					var $dataArr:Array=_guijiLizhiVO.pointArr
					var  $A:Object3D=$dataArr[keyId];
					var  $B:Object3D=$dataArr[keyId+1];
					var  $C:Object3D=$dataArr[keyId+2];
					var  $D:Object3D=$dataArr[keyId+3];
					var  $E:Object3D=new Object3D(($C.x+$B.x)/2,($C.y+$B.y)/2,($C.z+$B.z)/2)
					
					
					var $posArr:Array=BezierClass.getFourPointBezier($A,$B,$C,$D,6,true)
					
					$B.x=($B.x+$A.x)/2
					$B.y=($B.y+$A.y)/2
					$B.z=($B.z+$A.z)/2
					$C.x=($D.x+$C.x)/2
					$C.y=($D.y+$C.y)/2
					$C.z=($D.z+$C.z)/2
					
					
					
					p0=new Object3D($posArr[2].x,$posArr[2].y,$posArr[2].z)
					p1=new Object3D($posArr[3].x,$posArr[3].y,$posArr[3].z)   //算到最中间的点
					p2=new Object3D($posArr[4].x,$posArr[4].y,$posArr[4].z)
					
					
					p0.x=($E.x+$B.x)/2
					p0.y=($E.y+$B.y)/2
					p0.z=($E.z+$B.z)/2
					p2.x=($C.x+$E.x)/2
					p2.y=($C.y+$E.y)/2
					p2.z=($C.z+$E.z)/2
					
					
					p1.angle_x=	($A.angle_x+$D.angle_x)/2
					p1.angle_y=	($A.angle_y+$D.angle_y)/2
					p1.angle_z=	($A.angle_z+$D.angle_z)/2
					
					_guijiLizhiVO.pointArr.splice(keyId+2,0,p0);   //插入第一个
					_guijiLizhiVO.pointArr.splice(keyId+3,0,p1);   //插入中间关键
					_guijiLizhiVO.pointArr.splice(keyId+4,0,p2);   //插入入另一个
					
					
					
				}else{
					//在最后加上新的位置
					a=_guijiLizhiVO.pointArr[_guijiLizhiVO.pointArr.length-2];
					b=_guijiLizhiVO.pointArr[_guijiLizhiVO.pointArr.length-1];
					p0.x=b.x+(b.x-a.x)
					p0.y=b.y+(b.y-a.y)
					p0.z=b.z+(b.z-a.z)
					p0.angle_x=a.angle_x
					p0.angle_y=a.angle_y
					p0.angle_z=a.angle_z
					
					p1.x=p0.x+(b.x-a.x)
					p1.y=p0.y+(b.y-a.y)
					p1.z=p0.z+(b.z-a.z)
					p1.angle_x=a.angle_x
					p1.angle_y=a.angle_y
					p1.angle_z=a.angle_z
					
					p2.x=p1.x+(b.x-a.x)
					p2.y=p1.y+(b.y-a.y)
					p2.z=p1.z+(b.z-a.z)
					p2.angle_x=a.angle_x
					p2.angle_y=a.angle_y
					p2.angle_z=a.angle_z
					
					_guijiLizhiVO.pointArr.push(p0,p1,p2);
					
					
				}
				_PointArr=_guijiLizhiVO.pointArr
				upPointItem(_PointArr)
				if(Boolean(_guijiLizhiVO.changeFun))
				{
					_guijiLizhiVO.changeFun();
				}
			}
		}
		public function delePoint():void
		{
			
			if(_guijiLizhiVO&& _guijiLizhiVO.pointArr.length>4&&_choosePointItem&&_choosePointItem.length==1)
			{
				var tempXyzPosData:XyzPosData=_choosePointItem[0];
				if(tempXyzPosData.id%3==0){
					
					if(tempXyzPosData.id>0){
						if(_guijiLizhiVO.pointArr.length>(tempXyzPosData.id+2)){
							_guijiLizhiVO.pointArr.splice(tempXyzPosData.id-1,3)
						}else{
							_guijiLizhiVO.pointArr.splice(tempXyzPosData.id-2,3)
						}
						_PointArr=_guijiLizhiVO.pointArr
						upPointItem(_PointArr)
						//XyzPosLevel.Instance().xyzPosData=null
						MoveScaleRotationLevel.getInstance().xyzMoveData=null
					}
					
				}
			}
		}
		private var _line3DArrSprite:Line3DArrDisplay3DLocusBallSprite;
		public var _pos:Vector3D=new Vector3D
		public function upData():void
		{
			if(!_guijiLizhiVO)return;

			_pos.x=isNaN(_guijiLizhiVO.x)?0:_guijiLizhiVO.x
			_pos.y=isNaN(_guijiLizhiVO.y)?0:_guijiLizhiVO.y
			_pos.z=isNaN(_guijiLizhiVO.z)?0:_guijiLizhiVO.z
			
			if(_line3DArrSprite){
				_line3DArrSprite.x=_pos.x
				_line3DArrSprite.y=_pos.y
				_line3DArrSprite.z=_pos.z
				_line3DArrSprite.scale_x=GuijiLevel.scaleNum
				_line3DArrSprite.scale_y=GuijiLevel.scaleNum
				_line3DArrSprite.scale_z=GuijiLevel.scaleNum
				_line3DArrSprite.update()
			}
		
			if(_bezierPoint3DSprite){
				_bezierPoint3DSprite.x=_pos.x
				_bezierPoint3DSprite.y=_pos.y
				_bezierPoint3DSprite.z=_pos.z
				_bezierPoint3DSprite.scale_x=GuijiLevel.scaleNum
				_bezierPoint3DSprite.scale_y=GuijiLevel.scaleNum
				_bezierPoint3DSprite.scale_z=GuijiLevel.scaleNum
				_bezierPoint3DSprite.update()
				
			}
			
			if(_basePointLine){
				_basePointLine.x=_pos.x
				_basePointLine.y=_pos.y
				_basePointLine.z=_pos.z
				_basePointLine.scale_x=GuijiLevel.scaleNum
				_basePointLine.scale_y=GuijiLevel.scaleNum
				_basePointLine.scale_z=GuijiLevel.scaleNum
				_basePointLine.update()
				
			}

		}

		public static  function  getInstance():QuxianLevel{
			if(!instance){
				instance = new QuxianLevel();
			}
			return instance;
		}
		
		private function addEvents():void
		{
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseDown)
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			Scene_data.stage.addEventListener("keyUp", keyupHandler);
			
		}
		private function chooseAllPoint():void
		{
			//全选顶点
			if(!_guijiLizhiVO)return;
			_choosePointItem=new Array
			for(var i:int=0;i<_PointArr.length;i++){	
				var tempPointObject3D:Object3D=_PointArr[i];
				var tempxyzPosData:XyzPosData=new XyzPosData();
				tempxyzPosData.x=tempPointObject3D.x*GuijiLevel.scaleNum+this.x
				tempxyzPosData.y=tempPointObject3D.y*GuijiLevel.scaleNum+this.y
				tempxyzPosData.z=tempPointObject3D.z*GuijiLevel.scaleNum+this.z
				tempxyzPosData.angle_x=tempPointObject3D.angle_x
				tempxyzPosData.angle_y=tempPointObject3D.angle_y
				tempxyzPosData.angle_z=tempPointObject3D.angle_z
				tempxyzPosData.id=i; 
				_choosePointItem.push(tempxyzPosData);
				
			}
			newMove(_choosePointItem)
			
		}
	
		private function stageMouseDown(event:MouseEvent):void
		{
			
			if(!_guijiLizhiVO)return;
			for(var i:int=0;i<_PointArr.length;i++){	
				var tempPointObject3D:Object3D=_PointArr[i];
				var hitit:Boolean=MathHitModel.mathHit3DPoint(new Vector3D(tempPointObject3D.x*	GuijiLevel.scaleNum,tempPointObject3D.y*	GuijiLevel.scaleNum,tempPointObject3D.z*	GuijiLevel.scaleNum),10);
				if(hitit){
					var tempxyzPosData:XyzPosData=new XyzPosData();
					tempxyzPosData.x=tempPointObject3D.x*GuijiLevel.scaleNum
					tempxyzPosData.y=tempPointObject3D.y*GuijiLevel.scaleNum
					tempxyzPosData.z=tempPointObject3D.z*GuijiLevel.scaleNum
					tempxyzPosData.angle_x=tempPointObject3D.angle_x
					tempxyzPosData.angle_y=tempPointObject3D.angle_y
					tempxyzPosData.angle_z=tempPointObject3D.angle_z
					tempxyzPosData.id=i; 
					if(!isDown(16)||!_choosePointItem)  //如果是按了SHIFT键将视为多个点移动
					{
						_choosePointItem=new Array
					}
					var canAdd:Boolean=true;
					for(var j:int=0;j<_choosePointItem.length;j++)
					{
						var temp:XyzPosData=XyzPosData(_choosePointItem[j])
						
						if(temp.id==tempxyzPosData.id)
						{//有了就不要添加
							canAdd=false;
						}
					}
					if(canAdd)
					{
						_choosePointItem.push(tempxyzPosData);
					}
		
					newMove(_choosePointItem)
					
					return ;
				}
			}
		}
		private function newMove(arr:Array):void
		{
			var $xyzPosData:TooXyzMoveData=new TooXyzMoveData
			if(arr&&arr.length){
				$xyzPosData.dataItem=new Vector.<TooXyzPosData>;
				$xyzPosData.modelItem=new Array
				for (var i:uint=0;i<arr.length;i++)
				{
					var tempxyzPosData:XyzPosData=arr[i]
					var k:TooXyzPosData=new TooXyzPosData;
					k.x=tempxyzPosData.x
					k.y=tempxyzPosData.y
					k.z=tempxyzPosData.z
					k.scale_x=1
					k.scale_y=1
					k.scale_z=1
					k.angle_x=tempxyzPosData.angle_x
					k.angle_y=tempxyzPosData.angle_y
					k.angle_z=tempxyzPosData.angle_z
					$xyzPosData.dataItem.push(k)
					$xyzPosData.modelItem.push(tempxyzPosData)
					
					
				}
				$xyzPosData.fun=xyzBfun
				$xyzPosData.isCenten=true
				MoveScaleRotationLevel.getInstance().xyzMoveData=$xyzPosData
				
			}
			function xyzBfun($XyzMoveData:xyz.draw.TooXyzMoveData):void
			{
				var a:Object3D
				var b:Object3D
				var tempXyzPosData:XyzPosData;
				var oldObject3D:Object3D;
				var newObject3D:Object3D;
				var $TooXyzPosData:TooXyzPosData
				if($XyzMoveData.modelItem.length==1){
					$TooXyzPosData=$XyzMoveData.dataItem[0]
					tempXyzPosData=$XyzMoveData.modelItem[0]
					oldObject3D=_PointArr[tempXyzPosData.id];
					newObject3D=new Object3D($TooXyzPosData.x/GuijiLevel.scaleNum-_pos.x,$TooXyzPosData.y/GuijiLevel.scaleNum-_pos.y,$TooXyzPosData.z/GuijiLevel.scaleNum-_pos.z)
					newObject3D.angle_x=$TooXyzPosData.angle_x
					newObject3D.angle_y=$TooXyzPosData.angle_y
					newObject3D.angle_z=$TooXyzPosData.angle_z
					_PointArr[tempXyzPosData.id]=newObject3D;
					
					
					if(tempXyzPosData.id%3==0){
						//如果是关键点，将也会同样移动两边的点，
						a=_PointArr[tempXyzPosData.id-1]
						b=_PointArr[tempXyzPosData.id+1]
						if(a){
							a=new Object3D(a.x+(newObject3D.x-oldObject3D.x),a.y+(newObject3D.y-oldObject3D.y),a.z+(newObject3D.z-oldObject3D.z))
							_PointArr[tempXyzPosData.id-1].x=a.x
							_PointArr[tempXyzPosData.id-1].y=a.y
							_PointArr[tempXyzPosData.id-1].z=a.z
						}
						if(b){
							b=new Object3D(b.x+(newObject3D.x-oldObject3D.x),b.y+(newObject3D.y-oldObject3D.y),b.z+(newObject3D.z-oldObject3D.z))
							_PointArr[tempXyzPosData.id+1].x=b.x
							_PointArr[tempXyzPosData.id+1].y=b.y
							_PointArr[tempXyzPosData.id+1].z=b.z
						}
					}else{
						//是次要的在这时就要
						var cenetenOjb:Object3D;
						var otherObj:Object3D;
						if(tempXyzPosData.id%3==1){
							//算次要的点的位置
							cenetenOjb=_PointArr[tempXyzPosData.id-1]
							otherObj=_PointArr[tempXyzPosData.id-2]
							
						}
						if(tempXyzPosData.id%3==2){
							//算次要的点的位置
							cenetenOjb=_PointArr[tempXyzPosData.id+1]
							otherObj=_PointArr[tempXyzPosData.id+2]
						}
						if(otherObj){
							var pp1:Vector3D=new Vector3D(newObject3D.x-cenetenOjb.x,newObject3D.y-cenetenOjb.y,newObject3D.z-cenetenOjb.z)
							var pp2:Vector3D=new Vector3D(otherObj.x-cenetenOjb.x,otherObj.y-cenetenOjb.y,otherObj.z-cenetenOjb.z)
							pp1.normalize();
							pp1.negate()
							var longer:Number=pp2.normalize()
							pp2=new Vector3D(pp1.x*longer,pp1.y*longer,pp1.z*longer)
							otherObj.x=pp2.x+cenetenOjb.x
							otherObj.y=pp2.y+cenetenOjb.y
							otherObj.z=pp2.z+cenetenOjb.z
						}else{
							trace("峭有对面");
						}
						
					}
					
					
					
				}else{
					
					for(var i:uint=0;i<$XyzMoveData.modelItem.length;i++){
						$TooXyzPosData=$XyzMoveData.dataItem[i]
						tempXyzPosData=$XyzMoveData.modelItem[i]
						
						_PointArr[tempXyzPosData.id].x=$TooXyzPosData.x/GuijiLevel.scaleNum-_pos.x
						_PointArr[tempXyzPosData.id].y=$TooXyzPosData.y/GuijiLevel.scaleNum-_pos.y
						_PointArr[tempXyzPosData.id].z=$TooXyzPosData.z/GuijiLevel.scaleNum-_pos.z
						
						_PointArr[tempXyzPosData.id].angle_x=$TooXyzPosData.angle_x
						_PointArr[tempXyzPosData.id].angle_y=$TooXyzPosData.angle_y
						_PointArr[tempXyzPosData.id].angle_z=$TooXyzPosData.angle_z
						
					}
					
				}
				upPointItem(_PointArr)
				if(Boolean(_guijiLizhiVO.changeFun))
				{
					if($XyzMoveData.dataItem&&$XyzMoveData.dataItem.length){
						_needUpToView=true
					}
					_guijiLizhiVO.changeFun();
				}
			}
		}
		
		
		private function upPointItem(_arr:Array):void
		{
			if(!_arr ||_arr.length<4){
				return ;
			}
			_bezierPoint3DSprite.setLineData({PointArr:_arr});
			var tempArr:Array=new Array();
			for(var i:int=0;i<int((_arr.length-1)/3);i++)
			{
				var isEnd:Boolean=(i==int((_arr.length-1)/3)-1)
				tempArr=tempArr.concat(BezierClass.getFourPointBezier(_arr[i*3+0],_arr[i*3+1],_arr[i*3+2],_arr[i*3+3],Math.ceil(_guijiLizhiVO.density/int(_arr.length/3)),isEnd))
			}
			if(tempArr.length>1){
				// tempArr.push(_arr[_arr.length-1])  //加入最后一个点，用于画线
				_line3DArrSprite.setLineData({PointArr:tempArr,guijiLizhiVO:_guijiLizhiVO})
			}
			_basePointLine.colorVector3d=new Vector3D(1,1,1,1);
			_basePointLine.setLineData({PointArr:tempArr});
			for(var j:int=0;j<int((_arr.length-1)/3);j++)
			{
				var a0:Vector3D=new Vector3D(_arr[j*3+0].x,_arr[j*3+0].y,_arr[j*3+0].z)
				var a1:Vector3D=new Vector3D(_arr[j*3+1].x,_arr[j*3+1].y,_arr[j*3+1].z)
				var a2:Vector3D=new Vector3D(_arr[j*3+2].x,_arr[j*3+2].y,_arr[j*3+2].z)
				var a3:Vector3D=new Vector3D(_arr[j*3+3].x,_arr[j*3+3].y,_arr[j*3+3].z)
				_basePointLine.makeLineMode(a0,a1,0.6,new Vector3D(0.4,0.4,0.4))
				_basePointLine.makeLineMode(a2,a3,0.6,new Vector3D(0.4,0.4,0.4))
			}
			_basePointLine.refreshGpu();
			
		}
		private function addLine3D():void
		{
			_line3DArrSprite=new Line3DArrDisplay3DLocusBallSprite(Scene_data.context3D);
			
			_line3DArrSprite.x=this.x;
			_line3DArrSprite.y=this.y;
			_line3DArrSprite.z=this.z;


			var tmpeProgram3d:Program3D = Program3DManager .getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_line3DArrSprite.setProgram3D(tmpeProgram3d)
			
		}

		private function addPont():void
		{
			_bezierPoint3DSprite =new GuijiPoint3DSprite(Scene_data.context3D);
			
			_bezierPoint3DSprite.x=this.x;
			_bezierPoint3DSprite.y=this.y;
			_bezierPoint3DSprite.z=this.z;

			var tmpeProgram3d:Program3D = Program3DManager .getInstance().getProgram(TriPoint3DShader.TRI_POINT3D_SHADER);
			_bezierPoint3DSprite.setProgram3D(tmpeProgram3d)
			
		}
		private function addLine():void
		{
			_basePointLine=new Guiji3DLineDSprite(Scene_data.context3D);
			_basePointLine.colorVector3d=new Vector3D(1,1,1,1)
			_basePointLine.x=this.x;
			_basePointLine.y=this.y;
			_basePointLine.z=this.z;

			var tmpeProgram3d:Program3D = Program3DManager .getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_basePointLine.setProgram3D(tmpeProgram3d)
		}
		
		protected function addShaders():void
		{
			// TODO Auto Generated method stub
			Program3DManager.getInstance().registe(TriPoint3DShader.TRI_POINT3D_SHADER,TriPoint3DShader);
			Program3DManager.getInstance().registe(LineTri3DShader.LINE_TRI3D_SHADER,LineTri3DShader);
			
		}
		
		private function isDown(key : Number) : Boolean {
			return _keyobj[key] ? true : false;
		}
		private function keyupHandler(event:KeyboardEvent):void
		{
			delete _keyobj[event.keyCode];
			
		}
		private function keydownHandler(event : KeyboardEvent) : void {
			_keyobj[event.keyCode] = true;
			if(event.keyCode == Keyboard.I){
				addNewPoint()
			}
			if(event.keyCode == Keyboard.O){
				delePoint();
			}
			if(event.keyCode == Keyboard.U){
				chooseAllPoint()
			}
			if(event.keyCode == Keyboard.T){
				_line3DArrSprite.visible=!_line3DArrSprite.visible
			}
			if(event.keyCode == 220){
				puping()
			}
		}
		private function puping():void
		{

			
		}
		
	}
}
package _me.xyzPos
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Program3D;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.BaseLevel;
	import _Pan3D.base.Object3D;
	import _Pan3D.base.ObjectHitBox;
	import _Pan3D.core.Groundposition;
	import _Pan3D.core.MathClass;
	import _Pan3D.core.MathCore;
	import _Pan3D.core.MathHitModel;
	import _Pan3D.lineTri.LineTri3DShader;
	import _Pan3D.lineTri.LineTri3DSprite;
	import _Pan3D.lineTri.box.BoxShader;
	import _Pan3D.lineTri.box.BoxSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class XyzPosLevel extends BaseLevel
	{

		private var _basePointLine:LineTri3DSprite;
		private var _PointArr:Array;
		private static var instance:XyzPosLevel;
		private var _xyzPosData:XyzPosData;
		private var _hitX:Boolean;
		private var _hitY:Boolean;
		private var _hitZ:Boolean;
		private var _movePos:Boolean=true

		
		public function XyzPosLevel()
		{
			super();
		}
		override protected function initData():void
		{
			_PointArr=new Array;
			_PointArr.push(new Object3D(0,0,0))
			_PointArr.push(new Object3D(0,100,-100))
			addLine3D();
			addBox3D();
			addEvents();
		}
		override public function resetStage():void
		{
			_context3D=Scene_data.context3D
			_basePointLine.resetStage()
			_basePointLine.program=Program3DManager .getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			
			
		}
		private function get xyzPosData():XyzPosData
		{
			return _xyzPosData;
		}

		private function set xyzPosData(value:XyzPosData):void
		{
			_xyzPosData = value;
			if(_xyzPosData&&!_xyzPosData.pointItem){
				_xyzPosData.pointItem=new Array
			     var temp:XyzPosData=new XyzPosData;
				 temp.x=_xyzPosData.x
				 temp.y=_xyzPosData.y
				 temp.z=_xyzPosData.z
				_xyzPosData.pointItem.push(temp)
			}

			changeDisPos();
		}

		public function get movePos():Boolean
		{
			return _movePos;
		}
		public function set movePos(value:Boolean):void
		{
			_movePos = value;
			drawXyzPosLine()
		}
		public static  function  Instance():XyzPosLevel{
			if(!instance){
				instance = new XyzPosLevel();
			}
			return instance;
		}
		public function get testCamMoveWorld():Boolean
		{
			if(_xyzPosData){
				if(_hitX||_hitY||_hitZ){
					return false;
				}
			}
			return true;
		}
		override public function upData():void
		{
			if(_xyzPosData){
				if(true){
					_context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
				}
				_basePointLine.x=_xyzPosData.x;
				_basePointLine.y=_xyzPosData.y;
				_basePointLine.z=_xyzPosData.z;
				
				_boxSprite.x=_xyzPosData.x;
				_boxSprite.y=_xyzPosData.y;
				_boxSprite.z=_xyzPosData.z;

				_display3DContainer.update();
			}
		}
		private function addEvents():void
		{
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseMove)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseUp)
			Scene_data.stage.addEventListener(MouseEvent.DOUBLE_CLICK,stageDoubleClik)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_WHEEL,stageMouseWheel)
			Scene_data.stage.doubleClickEnabled=true;
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN, stageKeyupHandler);
			
			
		}
		
		protected function stageMouseWheel(event:MouseEvent):void
		{
			
			drawXyzPosLine();
		}
		
		protected function stageKeyupHandler(event:KeyboardEvent):void
		{
			//
			if(event.keyCode == 80){
				_movePos=!_movePos;
				drawXyzPosLine()
			}
		}
		
		protected function stageMouseUp(event:MouseEvent):void
		{
			if(!_xyzPosData)return;
			if(_hitX||_hitY||_hitZ){
				_hitX=false;
				_hitY=false;
				_hitZ=false;
				
			}
			if(_hitCentre){
				_hitCentre=false
			}
			if(_hitRound){
				_hitRound=false
			}
		}
		
		protected function stageMouseMove(event:MouseEvent):void
		{
			if(!_xyzPosData)return;

			
			var i:int;
			var j:int;
			var tempXyzPosData:XyzPosData
			if(_hitX||_hitY||_hitZ){
				var newObj:Vector3D=new Vector3D;
				var _E:Object3D = Groundposition._getMouseMovePosition();
				newObj.x=_E.x-oldMouseObject3D.x
				newObj.y=_E.y-oldMouseObject3D.y
				newObj.z=_E.z-oldMouseObject3D.z
				if(_movePos){	
						for(  j=0;j<_xyzPosData.pointItem.length;j++)
						{
							 tempXyzPosData=_xyzPosData.pointItem[j];
							if(_hitX){
								tempXyzPosData.x=tempXyzPosData.oldx+newObj.x
							}else
							if(_hitY){
								tempXyzPosData.y=tempXyzPosData.oldy+newObj.y
							}else
							if(_hitZ){
								tempXyzPosData.z=tempXyzPosData.oldz+newObj.z
							}
						}
				}else
				{
					if(true &&_xyzPosData.pointItem&&_xyzPosData.pointItem.length>1){
						var rx:Number
						var ry:Number
						var rz:Number
						var P:Vector3D;
						for(  j=0;j<_xyzPosData.pointItem.length;j++)
						{
							tempXyzPosData=_xyzPosData.pointItem[j];
							P=new Vector3D(tempXyzPosData.oldx-_xyzPosData.x,tempXyzPosData.oldy-_xyzPosData.y,tempXyzPosData.oldz-_xyzPosData.z);
							if(_hitX){
								P=MathClass.math_change_point(P,newObj.x,0,0)
							}
							if(_hitY){
								P=MathClass.math_change_point(P,0,newObj.y,0)
							}
							if(_hitZ){
								P=MathClass.math_change_point(P,0,0,newObj.z)
							}
							tempXyzPosData.x=P.x+_xyzPosData.x;
							tempXyzPosData.y=P.y+_xyzPosData.y;
							tempXyzPosData.z=P.z+_xyzPosData.z;
							if(Math.abs(tempXyzPosData.x)>5000){
								trace("出错");
							}
							if(_hitX){
								tempXyzPosData.angle_x=tempXyzPosData.oldangle_x+newObj.x
							}
							if(_hitY){
								tempXyzPosData.angle_y=tempXyzPosData.oldangle_y+newObj.y
							}
							if(_hitZ){
								tempXyzPosData.angle_z=tempXyzPosData.oldangle_z+newObj.z
							}
						}

					}else{
						for(  j=0;j<_xyzPosData.pointItem.length;j++)
						{
							 tempXyzPosData=_xyzPosData.pointItem[j];
							if(_hitX){
								tempXyzPosData.angle_x=tempXyzPosData.oldangle_x+newObj.x
							}
							if(_hitY){
								tempXyzPosData.angle_y=tempXyzPosData.oldangle_y+newObj.y
							}
							if(_hitZ){
								tempXyzPosData.angle_z=tempXyzPosData.oldangle_z+newObj.z
							}
						}
					}
				}
	
			}else{
				if(_hitCentre){
					//如果是移动的是中心点，那将对其的位置进行所有移动
					var _addv:Vector3D=XyzPosMath.getHitViewPos()
					for(  j=0;j<_xyzPosData.pointItem.length;j++)
					{
						tempXyzPosData=_xyzPosData.pointItem[j];
						tempXyzPosData.x=tempXyzPosData.oldx+_addv.x
						tempXyzPosData.y=tempXyzPosData.oldy+_addv.y
						tempXyzPosData.z=tempXyzPosData.oldz+_addv.z	
					}
				}
				if(_hitRound){
				    //针对建筑的旋转
					for(  j=0;j<_xyzPosData.pointItem.length;j++)
					{
						tempXyzPosData=_xyzPosData.pointItem[j];
						tempXyzPosData.angle_y+=(Scene_data.stage.mouseX-_mouseLastPoint.x)/10
						_xyzPosData.hitBoxItem[i].angle_y=tempXyzPosData.angle_y*Math.PI/180
					}
					_mouseLastPoint=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
					drawXyzPosLine()
				}
			}
			if(_hitX||_hitY||_hitZ||_hitCentre||_hitRound){
				if(loopNum>upFunSkip){
					if(Boolean(xyzPosData.fun)){
						xyzPosData.fun(xyzPosData);
					}
					loopNum=0
				}
				loopNum++
				changeDisPos();
			}
		}
		private var _mouseLastPoint:Point
		public var upFunSkip:uint=3;//修改刷新频率
		private function changeDisPos():void
		{
			//重亲显示坐标位置
			if(!_xyzPosData||!_xyzPosData.pointItem)return;
			if(_xyzPosData.type==XyzPosMoveType.GUIJI_POINT_ITEM){
				//算出所有的点的加起来中间位置
				if(_xyzPosData.pointItem){
					_xyzPosData.x=0
					_xyzPosData.y=0
					_xyzPosData.z=0
					_xyzPosData.angle_x=0
					_xyzPosData.angle_y=0
					_xyzPosData.angle_z=0
					for( var i:int=0;i<_xyzPosData.pointItem.length;i++)
					{
						_xyzPosData.x=_xyzPosData.x+_xyzPosData.pointItem[i].x
						_xyzPosData.y=_xyzPosData.y+_xyzPosData.pointItem[i].y
						_xyzPosData.z=_xyzPosData.z+_xyzPosData.pointItem[i].z
							
						_xyzPosData.angle_x=_xyzPosData.angle_x+_xyzPosData.pointItem[i].angle_x
						_xyzPosData.angle_y=_xyzPosData.angle_y+_xyzPosData.pointItem[i].angle_y
						_xyzPosData.angle_z=_xyzPosData.angle_z+_xyzPosData.pointItem[i].angle_z
					}
					_xyzPosData.x=_xyzPosData.x/_xyzPosData.pointItem.length
					_xyzPosData.y=_xyzPosData.y/_xyzPosData.pointItem.length
					_xyzPosData.z=_xyzPosData.z/_xyzPosData.pointItem.length
						
					_xyzPosData.angle_x=_xyzPosData.angle_x/_xyzPosData.pointItem.length
					_xyzPosData.angle_y=_xyzPosData.angle_y/_xyzPosData.pointItem.length
					_xyzPosData.angle_z=_xyzPosData.angle_z/_xyzPosData.pointItem.length
					
				}else{
					throw new Error("没有传移动点的数组过来")
				}
				
			}

		}
		private var loopNum:int=0
		
		protected function stageDoubleClik(event:MouseEvent):void
		{
			_xyzPosData=null;
			
		}
		private var oldMouseObject3D:Object3D;
		
		private function stageMouseDown(event:MouseEvent):void
		{
			if(!_xyzPosData)return;
		    var i:int
		    var j:int
			var w:Number=lineLonger*_sizeNum;
			_hitX=MathHitModel.mathHit3DPoint(new Vector3D(_xyzPosData.x+w,_xyzPosData.y,_xyzPosData.z))
			_hitY=MathHitModel.mathHit3DPoint(new Vector3D(_xyzPosData.x,_xyzPosData.y+w,_xyzPosData.z))
			_hitZ=MathHitModel.mathHit3DPoint(new Vector3D(_xyzPosData.x,_xyzPosData.y,_xyzPosData.z+w))
			_hitCentre=MathHitModel.mathHit3DPoint(new Vector3D(_xyzPosData.x,_xyzPosData.y,_xyzPosData.z))
			if(_xyzPosData.type==XyzPosMoveType.GUIJI_POINT_ITEM){
				for(  i=0;i<_xyzPosData.pointItem.length;i++)
				{
					var tempXyzPosData:XyzPosData=_xyzPosData.pointItem[i];
					tempXyzPosData.oldx=tempXyzPosData.x;
					tempXyzPosData.oldy=tempXyzPosData.y;
					tempXyzPosData.oldz=tempXyzPosData.z;
					
					tempXyzPosData.oldangle_x=tempXyzPosData.angle_x;
					tempXyzPosData.oldangle_y=tempXyzPosData.angle_y;
					tempXyzPosData.oldangle_z=tempXyzPosData.angle_z;
				}
			}
			if(_hitCentre){
				_hitX=_hitY=_hitZ=false   //当为中心点的时间其它的就不管了
				XyzPosMath.makeViewTri(new Vector3D(_xyzPosData.x,_xyzPosData.y,_xyzPosData.z))
			}

			drawXyzPosLine()
			oldMouseObject3D = Groundposition._getMouseMovePosition();
		}
	    private function get isInElipse():Boolean
		{
			var pp:Point=MathCore.mathWorld3DPosto2DView(new Vector3D(_xyzPosData.x,_xyzPosData.y,_xyzPosData.z))
			var ww:Number=60;	
			var hh:Number=Math.abs(Math.sin(Scene_data.cam3D.angle_x*Math.PI/180)*lineLonger*_sizeNum)	
			var isInTuoQiu:int=pointInElipse(ww*2,hh*2,pp,new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY))
			if(isInTuoQiu==1){
				return true
			}else{
				return false
			}
		}
		public static  function pointInElipse(w:Number,h:Number,p:Point,hitp:Point):int
		{
			var a:Number=0;
			var b:Number=0;
			var num:Number=0;
			if(w>h)
			{
				// x轴
				a=w/2;
				b=h/2;
				num=((hitp.x-p.x)*(hitp.x-p.x))/(a*a)+((hitp.y-p.y)*(hitp.y-p.y))/(b*b);
			}
			else{
				// y 轴
				b=w/2;
				a=h/2;
				num=((hitp.x-p.x)*(hitp.x-p.x))/(a*a)+((hitp.y-p.y)*(hitp.y-p.y))/(b*b);
			}
			
			if(num==1)
			{
				return 0;
			}
			else if(num>1)
			{
				return -1;
			}
			else if(num<1)
			{
				return 1;
			}
			return 2;
		}
		
		
		



		public static var lineLonger:Number=50
		private var _jiantouSize:Number=5
		private var _lineSize:Number=1
		private var _sizeNum:Number=1;
		private var _boxSprite:BoxSprite;
		private var _hitCentre:Boolean;
		private var _hitRound:Boolean;

		private function drawXyzPosLine():void
		{
			_sizeNum=Scene_data.cam3D.distance/Scene_data.sceneViewHW
			_basePointLine.clear();	
			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(lineLonger*_sizeNum,0,0),_hitX?1.5:1,_hitX?new Vector3D(1,0,1,1):new Vector3D(1,0,0,1))
			_basePointLine.makeLineMode(new Vector3D((lineLonger-_jiantouSize)*_sizeNum,0,_jiantouSize*_sizeNum),new Vector3D(lineLonger*_sizeNum,0,0),_hitX?1.5:1,_hitX?new Vector3D(1,0,1,1):new Vector3D(1,0,0,1))
			_basePointLine.makeLineMode(new Vector3D((lineLonger-_jiantouSize)*_sizeNum,0,-_jiantouSize*_sizeNum),new Vector3D(lineLonger*_sizeNum,0,0),_hitX?1.5:1,_hitX?new Vector3D(1,0,1,1):new Vector3D(1,0,0,1))
			
			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,lineLonger*_sizeNum,0),_hitY?1.5:1,_hitY?new Vector3D(1,0,1,1):new Vector3D(0,1,0,1))
			_basePointLine.makeLineMode(new Vector3D(_jiantouSize*_sizeNum,(lineLonger-_jiantouSize)*_sizeNum,0),new Vector3D(0,lineLonger*_sizeNum,0),_hitY?1.5:1,_hitY?new Vector3D(1,0,1,1):new Vector3D(0,1,0,1))
			_basePointLine.makeLineMode(new Vector3D(-_jiantouSize*_sizeNum,(lineLonger-_jiantouSize)*_sizeNum,0),new Vector3D(0,lineLonger*_sizeNum,0),_hitY?1.5:1,_hitY?new Vector3D(1,0,1,1):new Vector3D(0,1,0,1))
			
			_basePointLine.makeLineMode(new Vector3D(0,0,0),new Vector3D(0,0,lineLonger*_sizeNum),_hitZ?1.5:1,_hitZ?new Vector3D(1,0,1,1):new Vector3D(0,0,1,1))
			_basePointLine.makeLineMode(new Vector3D(_jiantouSize*_sizeNum,0,(lineLonger-_jiantouSize)*_sizeNum),new Vector3D(0,0,lineLonger*_sizeNum),_hitZ?1.5:1,_hitZ?new Vector3D(1,0,1,1):new Vector3D(0,0,1,1))
			_basePointLine.makeLineMode(new Vector3D(-_jiantouSize*_sizeNum,0,(lineLonger-_jiantouSize)*_sizeNum),new Vector3D(0,0,lineLonger*_sizeNum),_hitZ?1.5:1,_hitZ?new Vector3D(1,0,1,1):new Vector3D(0,0,1,1))
				
			
			var Aanlgy:Number;
			var Banlgy:Number;
			var A:Vector3D;
			var B:Vector3D;
			if(!_movePos){//旋转时渲染
				for(var i:uint=0;i<30;i++)
				{
					 Aanlgy=(i+0)*(90/30)
					 Banlgy=(i+1)*(90/30)
					 A=new Vector3D(Math.sin(Aanlgy/180*Math.PI)*25, Math.cos(Aanlgy/180*Math.PI)*25,0);
					 B=new Vector3D(Math.sin(Banlgy/180*Math.PI)*25, Math.cos(Banlgy/180*Math.PI)*25,0);
					_basePointLine.makeLineMode(A,B,_hitX?1.5:1,_hitX?new Vector3D(1,0,1,1):new Vector3D(1,0,0,1))
						
					 Aanlgy=(i+0)*(90/30)
					 Banlgy=(i+1)*(90/30)
					 A=new Vector3D(0,Math.sin(Aanlgy/180*Math.PI)*30, Math.cos(Aanlgy/180*Math.PI)*30);
					 B=new Vector3D(0,Math.sin(Banlgy/180*Math.PI)*30, Math.cos(Banlgy/180*Math.PI)*30);
					_basePointLine.makeLineMode(A,B,_hitY?1.5:1,_hitY?new Vector3D(1,0,1,1):new Vector3D(0,1,0,1))
						
					 Aanlgy=(i+0)*(90/30)
					 Banlgy=(i+1)*(90/30)
					 A=new Vector3D(Math.sin(Aanlgy/180*Math.PI)*35,0, Math.cos(Aanlgy/180*Math.PI)*35);
					 B=new Vector3D(Math.sin(Banlgy/180*Math.PI)*35,0, Math.cos(Banlgy/180*Math.PI)*35);
					_basePointLine.makeLineMode(A,B,_hitZ?1.5:1,_hitZ?new Vector3D(1,0,1,1):new Vector3D(0,0,1,1))
				}
			}
			if(_xyzPosData&&_xyzPosData.hitBoxItem){
				_basePointLine.colorVector3d=new Vector3D(1,1,1,0.5)
				_basePointLine.thickness=0.5
			
				for(var k:uint;k<_xyzPosData.hitBoxItem.length;k++){
					var boxLinePoint:Array=new Array;
					var tempHitBox:ObjectHitBox=_xyzPosData.hitBoxItem[k];
					
					boxLinePoint.push(new Vector3D(tempHitBox.beginx,tempHitBox.beginy,tempHitBox.beginz),new Vector3D(tempHitBox.endx,tempHitBox.beginy,tempHitBox.beginz))
					boxLinePoint.push(new Vector3D(tempHitBox.beginx,tempHitBox.beginy,tempHitBox.beginz),new Vector3D(tempHitBox.beginx,tempHitBox.endy,tempHitBox.beginz))
					boxLinePoint.push(new Vector3D(tempHitBox.beginx,tempHitBox.beginy,tempHitBox.beginz),new Vector3D(tempHitBox.beginx,tempHitBox.beginy,tempHitBox.endz))
					
					boxLinePoint.push(new Vector3D(tempHitBox.endx,tempHitBox.endy,tempHitBox.endz),new Vector3D(tempHitBox.beginx,tempHitBox.endy,tempHitBox.endz))
					boxLinePoint.push(new Vector3D(tempHitBox.endx,tempHitBox.endy,tempHitBox.endz),new Vector3D(tempHitBox.endx,tempHitBox.beginy,tempHitBox.endz))
					boxLinePoint.push(new Vector3D(tempHitBox.endx,tempHitBox.endy,tempHitBox.endz),new Vector3D(tempHitBox.endx,tempHitBox.endy,tempHitBox.beginz))
					
					
					boxLinePoint.push(new Vector3D(tempHitBox.endx,tempHitBox.beginy,tempHitBox.beginz),new Vector3D(tempHitBox.endx,tempHitBox.beginy,tempHitBox.endz))
					boxLinePoint.push(new Vector3D(tempHitBox.endx,tempHitBox.beginy,tempHitBox.beginz),new Vector3D(tempHitBox.endx,tempHitBox.endy,tempHitBox.beginz))
					
					boxLinePoint.push(new Vector3D(tempHitBox.beginx,tempHitBox.endy,tempHitBox.beginz),new Vector3D(tempHitBox.endx,tempHitBox.endy,tempHitBox.beginz))
					boxLinePoint.push(new Vector3D(tempHitBox.beginx,tempHitBox.endy,tempHitBox.beginz),new Vector3D(tempHitBox.beginx,tempHitBox.endy,tempHitBox.endz))
					
					boxLinePoint.push(new Vector3D(tempHitBox.beginx,tempHitBox.beginy,tempHitBox.endz),new Vector3D(tempHitBox.endx,tempHitBox.beginy,tempHitBox.endz))
					boxLinePoint.push(new Vector3D(tempHitBox.beginx,tempHitBox.beginy,tempHitBox.endz),new Vector3D(tempHitBox.beginx,tempHitBox.endy,tempHitBox.endz))
					
					for(var j:int=0;j<boxLinePoint.length/2;j++){
						A=MathClass.math_change_point_Pi(boxLinePoint[j*2+0],new Vector3D(0,-tempHitBox.angle_y,0));
						B=MathClass.math_change_point_Pi(boxLinePoint[j*2+1],new Vector3D(0,-tempHitBox.angle_y,0));
						A.x=A.x+tempHitBox.x
						A.y=A.y+tempHitBox.y
						A.z=A.z+tempHitBox.z
						B.x=B.x+tempHitBox.x
						B.y=B.y+tempHitBox.y
						B.z=B.z+tempHitBox.z
						_basePointLine.makeLineMode(A,B)
					}
				}
			}
			_basePointLine.refreshGpu();
		}
		
		private function addLine3D():void
		{
			_basePointLine=new LineTri3DSprite(_context3D);
			_basePointLine.setLineData({PointArr:_PointArr});
			_basePointLine.x=0;
			_basePointLine.y=0;
			_basePointLine.z=0;
			_basePointLine.scale=1
			_display3DContainer.addChild(_basePointLine)
			var tmpeProgram3d:Program3D = Program3DManager .getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_basePointLine.setProgram3D(tmpeProgram3d)

			drawXyzPosLine();
		}
		private function addBox3D():void	
		{
			_boxSprite=new BoxSprite(_context3D);
			_boxSprite.x=0;
			_boxSprite.y=0;
			_boxSprite.z=0;
			_boxSprite.scale=1
			_boxSprite.boxSize=2
			_display3DContainer.addChild(_boxSprite)
			Program3DManager .getInstance().registe(BoxShader.BOX_SHADER,BoxShader)
			var tmpeProgram3d:Program3D = Program3DManager .getInstance().getProgram(BoxShader.BOX_SHADER);
			_boxSprite.setProgram3D(tmpeProgram3d)
		}


	}
}
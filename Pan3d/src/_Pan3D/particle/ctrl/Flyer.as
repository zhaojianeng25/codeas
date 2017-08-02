package _Pan3D.particle.ctrl
{
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.interfaces.IBind;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public class Flyer extends EventDispatcher implements IBind
	{
		//public static var FLYREACH:String = "flyReach"
		public var beginPos:Vector3D;
		public var endPos:Vector3D;
		public var offBeginPos:Vector3D;
		public var offEndPos:Vector3D;
		public var allTime:Number;
		public var speed:Number = 1;
		public var currentPos:Vector3D = new Vector3D;
		private var _beginDisplay3D:Display3D;
		private var _endDisplay3D:Display3D;

		private var vertical:Vector3D;
		public var amp:Number = 0;
		public var rotation:Number = 0;
		public var sec:int = 1;
		public var isComplete:Boolean;
		
		public function Flyer()
		{
		}
		
		public function getSocket(socketName:String,resultMatrix:Matrix3D):void{
			
		}
		
		public function updata(t:Number):void{
			if(t>allTime){
				if(!isComplete){
					var evt:FlyerEvent = new FlyerEvent(FlyerEvent.FLYREACH);
					evt.timeout = t-allTime;
					this.dispatchEvent(evt);
					//this.dispatchEvent(new Event(Flyer.FLYREACH));
					isComplete = true;
					currentPos.x = 1000000;
					currentPos.y = 1000000;
					currentPos.z = 1000000;
				}
				return;
			}
			var per:Number = t/allTime;
			var per2:Number = 1-per;
			currentPos.x = endPos.x * per + beginPos.x *per2;
			currentPos.y = endPos.y * per + beginPos.y *per2;
			currentPos.z = endPos.z * per + beginPos.z *per2;
			
			var xpos:Number = Math.PI * per * sec;
			xpos = Math.sin(xpos)*amp;
			currentPos.x += vertical.x * xpos;
			currentPos.y += vertical.y * xpos;
			currentPos.z += vertical.z * xpos;
		}
		
		public function getPosV3d(index:int,out:Vector3D):void
		{
			
		}
		
		public function getPosMatrix(index:int):Matrix3D
		{
			return null;
		}
		
		public function getOffsetPos(v3d:Vector3D, index:int):Vector3D
		{
			return null;
		}
		
		public function getRotation():Number{
			return 0;
		}
		
		public function getScale():Number{
			return 1;
		}
		
		public function setData(obj:Object):void{
			offBeginPos = objToV3c(obj.begin);
			offEndPos = objToV3c(obj.end);
			speed = obj.speed;
			amp = obj.amp;
			rotation = obj.rotation;
			sec = obj.sec;
		}
		
		public function bindFLyTarget(beginDisplay3D:Display3D,endDisplay3D:Display3D):void{
			_beginDisplay3D = beginDisplay3D;
			_endDisplay3D = endDisplay3D;
			
			if(offBeginPos){
				beginPos = new Vector3D(_beginDisplay3D.absoluteX + offBeginPos.x,_beginDisplay3D.absoluteY+offBeginPos.y,_beginDisplay3D.absoluteZ+offBeginPos.z);
			}else{
				beginPos = new Vector3D(_beginDisplay3D.absoluteX,_beginDisplay3D.absoluteY,_beginDisplay3D.absoluteZ);
			}
			
			if(_endDisplay3D){
				if(offEndPos){
					endPos = new Vector3D(_endDisplay3D.absoluteX+offEndPos.x,_endDisplay3D.absoluteY+offEndPos.y,_endDisplay3D.absoluteZ+offEndPos.z);
				}else{
					endPos = new Vector3D(_endDisplay3D.absoluteX,_endDisplay3D.absoluteY,_endDisplay3D.absoluteZ);
				}
			}else{
				endPos = beginPos;
			}
			
			getVertical();
			
			var distance:Number = Vector3D.distance(beginPos,endPos);
			allTime = distance/speed;
		}
		public function getVertical():void{
			var vbe:Vector3D = new Vector3D(endPos.x-beginPos.x,endPos.y-beginPos.y,endPos.z-beginPos.z);
			vertical = new Vector3D(1,1,(-vbe.x-vbe.y)/vbe.z);
			if(vbe.z == 0){
				vertical.z = 0;
			}
			vertical.normalize();
			var matrix:Matrix3D = new Matrix3D;
			matrix.appendRotation(rotation,vbe);
			vertical = matrix.transformVector(vertical);
		}
		
		private function objToV3c(obj:Object):Vector3D{
			if(obj is Vector3D){
				return Vector3D(obj);
			}else{
				return new Vector3D(obj.x,obj.y,obj.z);
			}
		}
		public function reset():void{
			isComplete = false;
			currentPos.x = 1000000;
			currentPos.y = 1000000;
			currentPos.z = 1000000;
		}
		
		public function getBindAlpha():Number{
			return 1;
		}
		
		public function clone():Flyer{
			var flyer:Flyer = new Flyer();
			flyer.offBeginPos = this.offBeginPos;
			flyer.offEndPos = this.offEndPos;
			flyer.speed = this.speed;
			flyer.amp = this.amp;
			flyer.rotation = this.rotation;
			flyer.sec = this.sec;
			return flyer;
		}
	}
}
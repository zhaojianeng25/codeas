package _Pan3D.core
{
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class BezierClass
	{
		public function BezierClass()
		{
		}
		public static  function drawbezier(_array:Array, _time:Number):Object {
			var _newarray:Array = new Array()
			if(_array.length==0){
				return {x:0,y:0,z:0}
			}
			for (var i:* in _array) {
				_newarray.push({x:_array[i].x,y:_array[i].y,z:_array[i].z})
			}
			while (_newarray.length > 1) {
				for (var j:int = 0; j < _newarray.length - 1;j++ ) {
					mathmidpoint(_newarray[j],_newarray[j+1],_time)
				}
				_newarray.pop()
			}
			
			return _newarray[0]
			
		}
		private  static function mathmidpoint(a:Object, b:Object, t:Number):void {
			var _nx:Number,_ny:Number, _nz:Number;
			_nx = a.x + (b.x - a.x) * t;
			_ny = a.y + (b.y - a.y) * t;
			_nz = a.z + (b.z - a.z) * t;
			a.x = _nx;
			a.y = _ny;
			a.z = _nz;
			
		}
		public static function getFourPointBezier(a:*,b:*,c:*,d:*,num:uint,end:Boolean=false,eageAry:Array=null,isRandom:Boolean=false):Array
		{
			if(num==0){
				num=1
			}
			var pointArr:Array=new Array
			var anglyArr:Array=new Array
			var backArr:Array=new Array;
			pointArr.push(new Vector3D(a.x,a.y,a.z))
			pointArr.push(new Vector3D(b.x,b.y,b.z))
			pointArr.push(new Vector3D(c.x,c.y,c.z))
			pointArr.push(new Vector3D(d.x,d.y,d.z))
			
			anglyArr.push(new Vector3D(a.angle_x,a.angle_y,a.angle_z))
			//anglyArr.push(new Vector3D(b.angle_x,b.angle_y,b.angle_z))
			//anglyArr.push(new Vector3D(c.angle_x,c.angle_y,c.angle_z))
			anglyArr.push(new Vector3D(d.angle_x,d.angle_y,d.angle_z))
				
			var posPer:Array = new Array;
			for(var j:int;j<num;j++){
				if(isRandom){
					posPer.push(Math.random());
				}else{
					posPer.push(j/num);
				}
				
			}
			
			if(isRandom){
				posPer.sort(Array.NUMERIC);
			}
			
			posPer.push(1);

			
			for(var i:uint=0;i<num||(i==num&&end);i++){
				var pos:Object=BezierClass.drawbezier(pointArr,posPer[i]);
				var angle:Object=BezierClass.drawbezier(anglyArr,posPer[i]);
				var pointObje:Object3D=new Object3D(pos.x,pos.y,pos.z);
				
				if(eageAry){
					var pre1:Number = posPer[i] - 0.001;
					var pre2:Number = posPer[i] + 0.001;
					if(pre1 < 0){
						pre1 = 0;
					}
					if(pre2 > 1){
						pre2 = 1;
					}
					if(pre1 == pre2){
						trace("error");
					}
					var pos1:Object=BezierClass.drawbezier(pointArr,posPer[i] - 0.001);
					var pos2:Object=BezierClass.drawbezier(pointArr,posPer[i] + 0.001);
					
					var v3d:Vector3D = new Vector3D(pos2.x - pos1.x,pos2.y - pos1.y,pos2.z - pos1.z);
					v3d.normalize();
					eageAry.push(v3d);
				}
				
				
//				pointObje.angle_x=angle.x
//				pointObje.angle_y=angle.y
//				pointObje.angle_z=angle.z
	
				if((i==num&&end)){
					pointObje.angle_y=d.angle_x
					pointObje.angle_z=d.angle_z
				}else{
					if(i==0){
						pointObje.angle_y=a.angle_x
						pointObje.angle_z=a.angle_z
					}else{
						var $otherA:Object=BezierClass.drawbezier(pointArr,posPer[i-1]);
						var $otherB:Object=BezierClass.drawbezier(pointArr,posPer[i+1]);
						pointObje.angle_y=angle.y+MathClass.math_angle(pos.x,pos.z,$otherA.x,$otherA.z)
						pointObje.angle_z=angle.z+MathClass.math_angle(pos.x,pos.y,$otherA.x,$otherA.y)	
					}
				}
				
					pointObje.angle_x=angle.x
					pointObje.angle_y=angle.y
					pointObje.angle_z=angle.z

				backArr.push(pointObje);

			}
			return backArr;
		}
	}
}
package  xyz.base
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class TooMakeModelData
	{
		public static function makeBoxTampData(hitbox:TooObjectHitBox,scale:Number=1):TooObjData
		{
			
			var objData:TooObjData=new TooObjData;
			
			var Vitem:Array=new Array();
            
			var w:Number=Math.max(Math.abs(hitbox.beginx),Math.abs(hitbox.endx))*scale
			var h:Number=Math.max(Math.abs(hitbox.beginz),Math.abs(hitbox.endz))*scale

			
			var bx:Number=-10;
			var by:Number=-10;
			var bz:Number=-10;
			var ex:Number=10;
			var ey:Number=10;
			var ez:Number=10;
			
			bx=-w;
			ex=w;
			by=hitbox.beginy*scale;
			ey=hitbox.endy*scale;
			bz=-h;
			ez=h;
			
			
			

			//手工写入一个盒子的模型
			Vitem.push(new Vector3D(bx,by,ez));
			Vitem.push(new Vector3D(bx,by,bz));
			Vitem.push(new Vector3D(ex,by,bz));
			Vitem.push(new Vector3D(ex,by,ez));
			
			Vitem.push(new Vector3D(bx,ey,ez));
			Vitem.push(new Vector3D(bx,ey,bz));
			Vitem.push(new Vector3D(ex,ey,bz));
			Vitem.push(new Vector3D(ex,ey,ez));
			
			/*
			Vitem.push(new Vector3D(-10,0,10));
			Vitem.push(new Vector3D(-10,0,-10));
			Vitem.push(new Vector3D(10,0,-10));
			Vitem.push(new Vector3D(10,0,10));
			
			Vitem.push(new Vector3D(-10,20,10));
			Vitem.push(new Vector3D(-10,20,-10));
			Vitem.push(new Vector3D(10,20,-10));
			Vitem.push(new Vector3D(10,20,10));
			
			*/

			//不考虑是否是正面
			var Iitem:Array=new Array();
			Iitem.push(0,1,2);
			Iitem.push(0,2,3);
			
			Iitem.push(4,5,6);
			Iitem.push(4,6,7);
		
			Iitem.push(5,1,2);
			Iitem.push(5,2,6);
			
			Iitem.push(6,2,3);
			Iitem.push(6,3,7);

			Iitem.push(4,0,1);
			Iitem.push(4,1,5);
			
			Iitem.push(4,3,0);
			Iitem.push(4,7,3);

			objData.vertices=new Vector.<Number>;
			objData.uvs=new Vector.<Number>
			objData.indexs=new Vector.<uint>;
			for(var i:int=0;i<Iitem.length;i++)
			{
				var P:Vector3D=Vitem[Iitem[i]];
				objData.vertices.push(P.x,P.y,P.z);
				objData.uvs.push(0,0)
				objData.indexs.push(i);
				
			}
			return objData;
            
		}
		public static function makeJuXinTampData(a:Vector3D=null,b:Vector3D=null):TooObjData
		{
			var _objData:TooObjData=new TooObjData;
			if(!a){

				a=new Vector3D(-100,100,0);
			}
			if(!b){

				b=new Vector3D(100,-100,0);
			}
			var v : Array=
				[a.x, a.y, a.z,
				 a.x, b.y, b.z, 
				 b.x, b.y, b.z, 
				 b.x, a.y, a.z];
			var u : Array=
				[0, 0,
				 0, 1,  
				 1, 1,  
				 1, 0];
			var k : Array = [0, 2, 3, 0, 1, 2];

			_objData.vertices=new Vector.<Number>;
			var id:uint=0;
			for(id=0;id<v.length;id++){
				_objData.vertices.push(v[id])
			}
			_objData.uvs=new Vector.<Number>;
			for(id=0;id<u.length;id++){
				_objData.uvs.push(u[id])
			}
			_objData.indexs=new Vector.<uint>;
			for(id=0;id<k.length;id++){
				_objData.indexs.push(k[id])
			}

			return _objData;
		}
		public static function makeRectangleData(width:Number,height:Number,offsetX:Number=0.5,offsetY:Number=0.5,isUV:Boolean=false,isU:Boolean=false,isV:Boolean=false,animLine:int=1,animRow:int=1):TooObjData{
			var _objData:TooObjData=new TooObjData;
			
			var uvAry:Vector.<Number> = _objData.uvs = new Vector.<Number>;
			var indexAry:Vector.<uint> = _objData.indexs = new Vector.<uint>;
			var verterList:Vector.<Number> = _objData.vertices = new Vector.<Number>;
			
			
			verterList.push(-offsetX*width,height-offsetY*height,0);
			verterList.push(width-offsetX*width,height-offsetY*height,0);
			verterList.push(width-offsetX*width,-offsetY*height,0);
			verterList.push(-offsetX*width,-offsetY*height,0);
			
			var ary:Array = new Array;
			ary.push(new Point(0,0));
			ary.push(new Point(0,1/animRow));
			ary.push(new Point(1/animLine,1/animRow));
			ary.push(new Point(1/animLine,0));
			
			if(isU){
				for(var i:int=0;i<ary.length;i++){
					ary[i].x = - ary[i].x;
				}
			}
			
			if(isV){
				for(i=0;i<ary.length;i++){
					ary[i].y = - ary[i].y;
				}
			}
			
			if(isUV){
				ary.push(ary.shift());
			}
			
			for(i=0;i<ary.length;i++){
				uvAry.push(ary[i].x,ary[i].y);
			}
			
			indexAry.push(0,1,2,0,2,3);
			
			
			return _objData;
		}
		
		public static function makeRectangleMaskData(width:Number,height:Number,offsetX:Number=0.5,offsetY:Number=0.5,isUV:Boolean=false,isU:Boolean=false,isV:Boolean=false,animLine:int=1,animRow:int=1):TooObjData{
			var _objData:TooObjData=new TooObjData;
			
			var uvAry:Vector.<Number> = _objData.uvs = new Vector.<Number>;
			var indexAry:Vector.<uint> = _objData.indexs = new Vector.<uint>;
			var verterList:Vector.<Number> = _objData.vertices = new Vector.<Number>;
			
			
			verterList.push(-offsetX*width,height-offsetY*height,0);
			verterList.push(width-offsetX*width,height-offsetY*height,0);
			verterList.push(width-offsetX*width,-offsetY*height,0);
			verterList.push(-offsetX*width,-offsetY*height,0);
			
			var ary:Array = new Array;
			ary.push(new Point(0,0));
			ary.push(new Point(0,1/animRow));
			ary.push(new Point(1/animLine,1/animRow));
			ary.push(new Point(1/animLine,0));
			
			var ary2:Array = new Array;
			ary2.push(new Point(0,0));
			ary2.push(new Point(0,1));
			ary2.push(new Point(1,1));
			ary2.push(new Point(1,0));
			
			if(isU){
				for(var i:int=0;i<ary.length;i++){
					ary[i].x = - ary[i].x;
				}
			}
			
			if(isV){
				for(i=0;i<ary.length;i++){
					ary[i].y = - ary[i].y;
				}
			}
			
			if(isUV){
				ary.push(ary.shift());
			}
			
			for(i=0;i<ary.length;i++){
				uvAry.push(ary[i].x,ary[i].y,ary2[i].x,ary2[i].y);
			}
			
			indexAry.push(0,1,2,0,2,3);
			
			
			return _objData;
		}
		
		public static function makeObjDataToHitBox(objData:TooObjData,scale:Number=1,scale_y:Number=0,scale_z:Number=0):TooObjectHitBox
		{
			if(scale_y == 0)
			{
				scale_y = scale;
			}
			if(scale_z == 0)
			{
				scale_z = scale;
			}
    		var objectHitBox:TooObjectHitBox=new TooObjectHitBox;

			var A:Vector3D=new Vector3D
			var B:Vector3D=new Vector3D
			var P:Vector3D=new Vector3D
			for(var i:uint=0;i<objData.vertices.length/3;i++)
			{
				P=new Vector3D(objData.vertices[i*3+0],objData.vertices[i*3+1],objData.vertices[i*3+2])
				if(A.x>P.x)
				{
					A.x=P.x
				}
				if(A.y>P.y)
				{
					A.y=P.y
				}
				if(A.z>P.z)
				{
					A.z=P.z
				}
				if(B.x<P.x)
				{
					B.x=P.x
				}
				if(B.y<P.y)
				{
					B.y=P.y
				}
				if(B.z<P.z)
				{
					B.z=P.z
				}
			}
			objectHitBox.beginx=scale*A.x
			objectHitBox.beginy=scale_y*A.y
			objectHitBox.beginz=scale_z*A.z
			objectHitBox.endx=scale*B.x
			objectHitBox.endy=scale_y*B.y
			objectHitBox.endz=scale_z*B.z
			return objectHitBox;
			
			
			
		}
		/**
		 * 
		 * @param objData
		 * @param posMatrix3D
		 * @return 
		 * 
		 */
		public static function makeSpriteModelHitBox(objData:TooObjData,posMatrix3D:Matrix3D=null):TooObjectHitBox
		{

			var objectHitBox:TooObjectHitBox=new TooObjectHitBox;
			
			var A:Vector3D=new Vector3D
			var B:Vector3D=new Vector3D
			var P:Vector3D=new Vector3D
			for(var i:uint=0;i<objData.vertices.length/3;i++)
			{
				P=new Vector3D(objData.vertices[i*3+0],objData.vertices[i*3+1],objData.vertices[i*3+2])
				if(posMatrix3D){
					P=posMatrix3D.deltaTransformVector(P)
				}
				if(A.x>P.x)
				{
					A.x=P.x
				}
				if(A.y>P.y)
				{
					A.y=P.y
				}
				if(A.z>P.z)
				{
					A.z=P.z
				}
				if(B.x<P.x)
				{
					B.x=P.x
				}
				if(B.y<P.y)
				{
					B.y=P.y
				}
				if(B.z<P.z)
				{
					B.z=P.z
				}
			}
			objectHitBox.beginx=A.x
			objectHitBox.beginy=A.y
			objectHitBox.beginz=A.z
			objectHitBox.endx=B.x
			objectHitBox.endy=B.y
			objectHitBox.endz=B.z
			return objectHitBox;
			
		}
		
		public static function makeLinkData(width:Number,height:Number,offsetX:Number=0.5,offsetY:Number=0.5,isUV:Boolean=false,isU:Boolean=false,isV:Boolean=false,animLine:int=1,animRow:int=1):TooObjData{
			var _objData:TooObjData=new TooObjData;
			
			var uvAry:Vector.<Number> = _objData.uvs = new Vector.<Number>;
			var indexAry:Vector.<uint> = _objData.indexs = new Vector.<uint>;
			var verterList:Vector.<Number> = _objData.vertices = new Vector.<Number>;
			/*
			verterList.push(-offsetX*width,height-offsetY*height,0);
			verterList.push(width-offsetX*width,height-offsetY*height,0);
			verterList.push(width-offsetX*width,-offsetY*height,0);
			verterList.push(-offsetX*width,-offsetY*height,0);
			*/
			verterList.push(0,height,0);
			verterList.push(width,height,0);
			verterList.push(width,-height,0);
			verterList.push(0,-height,0);
			
			
			
			var ary:Array = new Array;
			ary.push(new Point(0,0));
			ary.push(new Point(0,1/animRow));
			ary.push(new Point(1/animLine,1/animRow));
			ary.push(new Point(1/animLine,0));
			
			if(isU){
				for(var i:int=0;i<ary.length;i++){
					ary[i].x = - ary[i].x;
				}
			}
			
			if(isV){
				for(i=0;i<ary.length;i++){
					ary[i].y = - ary[i].y;
				}
			}
			
			if(isUV){
				ary.push(ary.shift());
			}
			
			for(i=0;i<ary.length;i++){
				uvAry.push(ary[i].x,ary[i].y);
			}
			
			indexAry.push(0,1,2,0,2,3);
			
			
			return _objData;
		}
		
		public static function makeDoubleRectangleData(width:Number,height:Number,offsetX:Number=0.5,offsetY:Number=0.5,isUV:Boolean=false,isU:Boolean=false,isV:Boolean=false,animLine:int=1,animRow:int=1,num:int=2,$scale:Number=1):TooObjData{
			var _objData:TooObjData=new TooObjData;
			
			var uvAry:Vector.<Number> = _objData.uvs = new Vector.<Number>;
			var indexAry:Vector.<uint> = _objData.indexs = new Vector.<uint>;
			var verterList:Vector.<Number> = _objData.vertices = new Vector.<Number>;
			
			
//			verterList.push(-offsetX*width,height-offsetY*height,0);
//			verterList.push(width-offsetX*width,height-offsetY*height,0);
//			verterList.push(width-offsetX*width,-offsetY*height,0);
//			verterList.push(-offsetX*width,-offsetY*height,0);
			
			//var num:int = 4;
			for(var j:int;j<num;j++){
				var angle:Number = j/num * Math.PI;
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);
				
				verterList.push(-offsetX*width*sin,height-offsetY*height,-offsetX*width*cos);
				verterList.push((width-offsetX*width)*sin,height-offsetY*height,(width-offsetX*width)*cos);
				verterList.push((width-offsetX*width)*sin*$scale,-offsetY*height,(width-offsetX*width)*cos*$scale);
				verterList.push(-offsetX*width*sin*$scale,-offsetY*height,-offsetX*width*cos*$scale);
			}
			
//			verterList.push(0,height-offsetY*height,-offsetX*width);
//			verterList.push(0,height-offsetY*height,width-offsetX*width);
//			verterList.push(0,-offsetY*height,width-offsetX*width);
//			verterList.push(0,-offsetY*height,-offsetX*width);
			
			var ary:Array = new Array;
			ary.push(new Point(0,0));
			ary.push(new Point(0,1/animRow));
			ary.push(new Point(1/animLine,1/animRow));
			ary.push(new Point(1/animLine,0));
			
			if(isU){
				for(var i:int=0;i<ary.length;i++){
					ary[i].x = - ary[i].x;
				}
			}
			
			if(isV){
				for(i=0;i<ary.length;i++){
					ary[i].y = - ary[i].y;
				}
			}
			
			if(isUV){
				ary.push(ary.shift());
			}
			
			for(j = 0;j<num;j++){
				for(i=0;i<ary.length;i++){
					uvAry.push(ary[i].x,ary[i].y);
				}
			}
//			for(i=0;i<ary.length;i++){
//				uvAry.push(ary[i].x,ary[i].y);
//			}
//			
//			for(i=0;i<ary.length;i++){
//				uvAry.push(ary[i].x,ary[i].y);
//			}
			
			for(j = 0;j<num;j++){
				indexAry.push(j*4,1+j*4,2+j*4,j*4,2+j*4,3+j*4);
			}
			
//			indexAry.push(0,1,2,0,2,3,4,5,6,4,6,7);
			
			
			return _objData;
		}

		
		
	}
}
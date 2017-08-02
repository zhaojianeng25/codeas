class CannonLineSprite extends LineDisplaySprite
{
    private static ballLineSprite: LineDisplaySprite;
    private static boxLineSprite: LineDisplaySprite;
    private static cylinderLineSprite: LineDisplaySprite;
    private static coneLineSprite: LineDisplaySprite;
    public body: CANNON.Body
    constructor() {
        super();
        if (!CannonLineSprite.ballLineSprite) {
            this.mathBallSptre();
        }
        if (!CannonLineSprite.boxLineSprite) {
            this.mathBoxSprite();
        }
        if (!CannonLineSprite.cylinderLineSprite) {
            this.mathCylinderSprite();
        }
        if (!CannonLineSprite.coneLineSprite) {
            this.mathConeSprite();
        }
    }

    private mathConeSprite() {
        var tempSprite: LineDisplaySprite = new LineDisplaySprite();
        tempSprite.clear();
        tempSprite.baseColor = new Vector3D(1, 0, 1, 1)

        var w: number = 100;
        var h: number = 100;
        this.clear();
        var jindu: number = 12;
        var lastA: Vector3D;

        var i: number;


        for (i = 0; i < jindu; i++) {
            var a: Vector3D = new Vector3D(w, -h / 2, 0);
            var m: Matrix3D = new Matrix3D;
            m.appendRotation(i * (360 / jindu), Vector3D.Y_AXIS);

            var A: Vector3D = m.transformVector(a);


            tempSprite.makeLineMode(A, new Vector3D(0, -h / 2, 0))
            tempSprite.makeLineMode(A, new Vector3D(0, +h / 2, 0))


            if (i == (jindu - 1)) {
                tempSprite.makeLineMode(A, a)
            }

            if (lastA) {
                tempSprite.makeLineMode(A, lastA)

            }

            lastA = A.clone();


        }


        tempSprite.upToGpu()
        CannonLineSprite.coneLineSprite = tempSprite;
    }
    private mathCylinderSprite() {
        var tempSprite: LineDisplaySprite = new LineDisplaySprite();
        tempSprite.clear();
        tempSprite.baseColor = new Vector3D(0, 0, 1, 1)

        var w: number = 100;
        var h: number = 100;
        var jindu: number = 12;
        var lastA: Vector3D;
        var lastB: Vector3D;
        var i: number;


        for (i = 0; i < jindu; i++) {
            var a: Vector3D = new Vector3D(w, -h / 2, 0);
            var b: Vector3D = new Vector3D(w, +h / 2, 0);
            var m: Matrix3D = new Matrix3D;
            m.appendRotation(i * (360 / jindu), Vector3D.Y_AXIS);

            var A: Vector3D = m.transformVector(a);
            var B: Vector3D = m.transformVector(b);

            tempSprite.makeLineMode(A, B)

            tempSprite.makeLineMode(A, new Vector3D(0, -h / 2, 0))
            tempSprite.makeLineMode(B, new Vector3D(0, +h / 2, 0))


            if (i == (jindu - 1)) {
                tempSprite.makeLineMode(A, a)
                tempSprite.makeLineMode(B, b)
            }

            if (lastA || lastB) {
                tempSprite.makeLineMode(A, lastA)
                tempSprite.makeLineMode(B, lastB)
            }

            lastA = A.clone();
            lastB = B.clone();

        }
			
		

        tempSprite.upToGpu()
        CannonLineSprite.cylinderLineSprite = tempSprite;
    }
    private mathBoxSprite() {
        var tempSprite: LineDisplaySprite = new LineDisplaySprite();
        tempSprite.clear();
        tempSprite.baseColor = new Vector3D(0, 1, 0, 1)
        var p: Vector3D = new Vector3D(100 , 100 , 100);
        tempSprite.makeLineMode(new Vector3D(-p.x, -p.y, -p.z), new Vector3D(+p.x, -p.y, -p.z))
        tempSprite.makeLineMode(new Vector3D(+p.x, -p.y, -p.z), new Vector3D(+p.x, -p.y, +p.z))
        tempSprite.makeLineMode(new Vector3D(+p.x, -p.y, +p.z), new Vector3D(-p.x, -p.y, +p.z))
        tempSprite.makeLineMode(new Vector3D(-p.x, -p.y, +p.z), new Vector3D(-p.x, -p.y, -p.z))


        tempSprite.makeLineMode(new Vector3D(-p.x, +p.y, -p.z), new Vector3D(+p.x, +p.y, -p.z))
        tempSprite.makeLineMode(new Vector3D(+p.x, +p.y, -p.z), new Vector3D(+p.x, +p.y, +p.z))
        tempSprite.makeLineMode(new Vector3D(+p.x, +p.y, +p.z), new Vector3D(-p.x, +p.y, +p.z))
        tempSprite.makeLineMode(new Vector3D(-p.x, +p.y, +p.z), new Vector3D(-p.x, +p.y, -p.z))


        tempSprite.makeLineMode(new Vector3D(-p.x, -p.y, -p.z), new Vector3D(-p.x, +p.y, -p.z))
        tempSprite.makeLineMode(new Vector3D(+p.x, -p.y, -p.z), new Vector3D(+p.x, +p.y, -p.z))
        tempSprite.makeLineMode(new Vector3D(+p.x, -p.y, +p.z), new Vector3D(+p.x, +p.y, +p.z))
        tempSprite.makeLineMode(new Vector3D(-p.x, -p.y, +p.z), new Vector3D(-p.x, +p.y, +p.z))

        tempSprite.upToGpu()
        CannonLineSprite.boxLineSprite = tempSprite;
    }
    private mathBallSptre() {
        var tempSprite: LineDisplaySprite = new LineDisplaySprite();
        var radiusNum100: number = 100;
        tempSprite.clear();
        tempSprite.baseColor = new Vector3D(1, 0, 0, 1)
        var num: number = 12;
        var p: Vector3D
        var m: Matrix3D
        var lastPos: Vector3D;
        var i: number
        var j: number;
        var bm: Matrix3D
        var bp: Vector3D

        for (j = 0; j <= num; j++) {

            lastPos = null;
            for (i = 0; i < num; i++) {
                p = new Vector3D(radiusNum100, 0, 0)
                m = new Matrix3D;
                m.appendRotation((360 / num) * i, Vector3D.Z_AXIS)
                p = m.transformVector(p)
                bm = new Matrix3D;
                bm.appendRotation((360 / num) * j, Vector3D.Y_AXIS)
                p = bm.transformVector(p)
                if (lastPos) {
                    tempSprite.makeLineMode(lastPos, p)
                }

                lastPos = p.clone();
            }
        }

        for (j = 0; j <= 4; j++) {
            bm = new Matrix3D;
            bm.appendRotation(j * 20, Vector3D.Z_AXIS);
            bp = bm.transformVector(new Vector3D(radiusNum100, 0, 0))


            lastPos = null;
            for (i = 0; i < num; i++) {
                p = bp.clone();
                m = new Matrix3D;
                m.appendRotation((360 / num) * i, Vector3D.Y_AXIS)
                p = m.transformVector(p)
                if (lastPos) {
                    tempSprite.makeLineMode(lastPos, p)
                }
                if (i == num - 1) {
                    tempSprite.makeLineMode(bp, p)
                }
                lastPos = p.clone();
            }
        }
        for (j = 1; j <= 4; j++) {
            bm = new Matrix3D;
            bm.appendRotation(j * -20, Vector3D.Z_AXIS);
            bp = bm.transformVector(new Vector3D(radiusNum100, 0, 0))


            lastPos = null;
            for (i = 0; i < num; i++) {
                p = bp.clone();
                m = new Matrix3D;
                m.appendRotation((360 / num) * i, Vector3D.Y_AXIS)
                p = m.transformVector(p)
                if (lastPos) {
                    tempSprite.makeLineMode(lastPos, p)
                }
                if (i == num - 1) {
                    tempSprite.makeLineMode(bp, p)
                }
                lastPos = p.clone();
            }
        }
        tempSprite.upToGpu()
        CannonLineSprite.ballLineSprite = tempSprite;
    }

    public setCollsionType($collisionVo: CollisionVo): void
    {
        switch ($collisionVo.type) {
            case CollisionType.BOX:
                this.objData = CannonLineSprite.boxLineSprite.objData;
                break;
            case CollisionType.BALL:
                this.objData = CannonLineSprite.ballLineSprite.objData;
                break;
            case CollisionType.Cylinder:
                this.objData = CannonLineSprite.cylinderLineSprite.objData;
                break;
            case CollisionType.Cone:
                this.objData = CannonLineSprite.coneLineSprite.objData;
                break;
            case CollisionType.Polygon:
                this.objData=this.makePolygonObjData($collisionVo.data)
                break;
            default:
                break;

        }
    
  

    }
    public visible: boolean = true
    public static showCollisionLine: boolean = true
    public update(): void {
        if (this.visible && CannonLineSprite.showCollisionLine) {
      
            if ( this.body) {
                var $ma: Matrix3D = new Matrix3D
                Physics.MathBody2WMatrix3D(this.body, $ma)
                this.posMatrix.m = $ma.m;
                this.posMatrix.prependScale(this.scaleX, this.scaleY, this.scaleZ);

                /*
                var mt3: CANNON.Mat3 = new CANNON.Mat3();
                mt3.setRotationFromQuaternion(this.body.quaternion);
                this.posMatrix.identity()
                this.posMatrix.m[0] = mt3.elements[0]
                this.posMatrix.m[1] = mt3.elements[1]
                this.posMatrix.m[2] = mt3.elements[2]
                this.posMatrix.m[4] = mt3.elements[3]
                this.posMatrix.m[5] = mt3.elements[4]
                this.posMatrix.m[6] = mt3.elements[5]
                this.posMatrix.m[8] = mt3.elements[6]
                this.posMatrix.m[9] = mt3.elements[7]
                this.posMatrix.m[10] = mt3.elements[8]

                var $pos: Vector3D = Physics.getV3D(this.body.position);
                this.posMatrix.appendTranslation($pos.x, $pos.y, $pos.z);
                this.posMatrix.prependScale(this.scaleX, this.scaleY, this.scaleZ);
                */

            }
            super.update();
        }
    }
   
    private makePolygonObjData($data: any): ObjData {
        var tempSprite: LineDisplaySprite = new LineDisplaySprite();
        tempSprite.clear();
        tempSprite.baseColor = new Vector3D(0, 1, 1, 1)

        var a: number;
        var b: number;
        var c: number;
        var A: Vector3D;
        var B: Vector3D;
        var C: Vector3D;
        for (var i: number = 0; i < $data.indexs.length / 3; i++) {
            a = $data.indexs[i * 3 + 0];
            b = $data.indexs[i * 3 + 1];
            c = $data.indexs[i * 3 + 2];
            A = new Vector3D($data.vertices[a * 3 + 0], $data.vertices[a * 3 + 1], $data.vertices[a * 3 + 2])
            B = new Vector3D($data.vertices[b * 3 + 0], $data.vertices[b * 3 + 1], $data.vertices[b * 3 + 2])
            C = new Vector3D($data.vertices[c * 3 + 0], $data.vertices[c * 3 + 1], $data.vertices[c * 3 + 2])

             tempSprite.makeLineMode(A, B)
             tempSprite.makeLineMode(B, C)
             tempSprite.makeLineMode(C, A)

        }
        tempSprite.upToGpu();


        return tempSprite.objData;

    }
    public changeBodyPosion: boolean = false
    public setBody($body: CANNON.Body): void
    {
        this.changeBodyPosion = true
        this.body = $body;
        var tempSprite: LineDisplaySprite = this
        tempSprite.clear();


        var arr: Array<number> = null
        for (var i: number = 0; i < $body.shapes.length; i++) {
            var $shapePos: Vector3D = Physics.Vect3dC2W($body.shapeOffsets[i])
     
            var $shapeQua: Quaternion = Physics.QuaternionCollisionToH5($body.shapeOrientations[i]);

            switch ($body.shapes[i].type) {
                case 1:
                    var $sphere: CANNON.Sphere = <CANNON.Sphere> $body.shapes[i];
                    $shapePos.scaleBy($sphere.radius)
                    this.drawSphereConvexPolyh($sphere.radius, $shapePos, $shapeQua);
                    break;
                case 4:
                    var $box: CANNON.Box = <CANNON.Box> $body.shapes[i];
                    var $boxSize: Vector3D = Physics.Vect3dC2W($box.halfExtents)
                    this.drawBoxConvexPolyh($boxSize, $shapePos, $shapeQua)
                    break;
                case 16:
                    var $cylinder: CANNON.Cylinder = <CANNON.Cylinder>  $body.shapes[i];
                    this.drawCylinderConvexPolyh($cylinder, $shapePos, $shapeQua);
                    break;
                case 32:
                    var $heightField: CANNON.Heightfield = <CANNON.Heightfield>  $body.shapes[i];
                    this.drawFieldPolyh($heightField, $shapePos, $shapeQua);
                    break;
                default:

                    console.log($body.shapes[i].type)
                    break;
            }
        }
        tempSprite.upToGpu()

    }
    private drawFieldPolyh($heightField: CANNON.Heightfield, $pos: Vector3D, $qua: Quaternion): void
    {
        var tempSprite: LineDisplaySprite = this;
        var m: Matrix3D = new Matrix3D;
        $qua.toMatrix3D(m);
        m.invert()
        m.appendTranslation($pos.x, $pos.y, $pos.z)

        var posItem: any = $heightField.data;
        var $scaleNum = $heightField.elementSize

        var sizeX: number = posItem.length;
        var sizeY: number = posItem[0].length;
        var num10: number = $scaleNum*10
      

        var $objData: ObjData = new ObjData;
        $objData.vertices = new Array;
        $objData.uvs = new Array;
        $objData.lightuvs = new Array;
        $objData.normals = new Array;
        $objData.indexs = new Array;


       // console.log(posItem)

        for (var i = 0; i < sizeX - 1; i++) {
            for (var j = 0; j < sizeY - 1; j++) {
                var a: Vector2D = new Vector2D(i + 0, j + 0);
                var b: Vector2D = new Vector2D(i + 1, j + 0);
                var c: Vector2D = new Vector2D(i + 1, j + 1);
                var d: Vector2D = new Vector2D(i + 0, j + 1);

                var A: Vector3D = new Vector3D(a.x * num10, posItem[a.x][a.y] * 10, a.y * num10);
                var B: Vector3D = new Vector3D(b.x * num10, posItem[b.x][b.y] * 10, b.y * num10);
                var C: Vector3D = new Vector3D(c.x * num10, posItem[c.x][c.y] * 10, c.y * num10);
                var D: Vector3D = new Vector3D(d.x * num10, posItem[d.x][d.y] * 10, d.y * num10);
                


                A = m.transformVector(A);
                B = m.transformVector(B);
                C = m.transformVector(C);
                D = m.transformVector(D);


               

                tempSprite.makeLineMode(A, B)
                tempSprite.makeLineMode(A, D)
                tempSprite.makeLineMode(C, B)
                tempSprite.makeLineMode(C, D)
            }
        }

      //  tempSprite.upToGpu()
    }
    private drawCylinderConvexPolyh($cylinder: CANNON.Cylinder, $pos: Vector3D, $qua: Quaternion): void {
        var tempSprite: LineDisplaySprite = this;
        var m: Matrix3D = new Matrix3D;
        $qua.toMatrix3D(m);
        m.invert()
        m.appendTranslation($pos.x, $pos.y, $pos.z)
       // m.appendScale(1 / Physics.baseScale10, 1 / Physics.baseScale10, 1 / Physics.baseScale10)

        for (var i: number = 0; i < $cylinder.faces.length; i++) {
            var a: number = $cylinder.faces[i][0];
            var b: number = $cylinder.faces[i][1];
            var c: number = $cylinder.faces[i][2];
            var d: number = $cylinder.faces[i][3];

            var A: Vector3D = Physics.Vect3dC2W($cylinder.vertices[a])
            var B: Vector3D = Physics.Vect3dC2W($cylinder.vertices[b])
            var C: Vector3D = Physics.Vect3dC2W($cylinder.vertices[c])
            var D: Vector3D = Physics.Vect3dC2W($cylinder.vertices[d])

  

            A = m.transformVector(A);
            B = m.transformVector(B);
            C = m.transformVector(C);
            D = m.transformVector(D);

            tempSprite.makeLineMode(A, B)
            tempSprite.makeLineMode(A, D)
            tempSprite.makeLineMode(C, B)
            tempSprite.makeLineMode(C, D)

        }
  
    }
    private drawSphereConvexPolyh($radius: number, $pos: Vector3D, $qua: Quaternion): void {
        var tempSprite: LineDisplaySprite = this;
        var m: Matrix3D = new Matrix3D;
        $qua.toMatrix3D(m);
        m.invert()
        m.appendTranslation($pos.x, $pos.y, $pos.z)

        var $LineDisplaySprite: LineDisplaySprite = CannonLineSprite.ballLineSprite;

        for (var i: number = 0; i < $LineDisplaySprite.lineVecPos.length/6; i++)
        {
            var a: Vector3D = new Vector3D($LineDisplaySprite.lineVecPos[i * 6 + 0], $LineDisplaySprite.lineVecPos[i * 6 + 1], $LineDisplaySprite.lineVecPos[i * 6 + 2])
            var b: Vector3D = new Vector3D($LineDisplaySprite.lineVecPos[i * 6 + 3], $LineDisplaySprite.lineVecPos[i * 6 + 4], $LineDisplaySprite.lineVecPos[i * 6 + 5])
            a.scaleBy($radius * Physics.baseScale10/ 100 );
            b.scaleBy($radius * Physics.baseScale10/ 100 );
            a=m.transformVector(a);
            b=m.transformVector(b);
            tempSprite.makeLineMode(a, b);
        }


    }
    private drawBoxConvexPolyh($size: Vector3D, $pos: Vector3D, $qua: Quaternion): void {
  
        var tempSprite: LineDisplaySprite = this;
        var m: Matrix3D = new Matrix3D;
        $qua.toMatrix3D(m);
        m.invert()
        m.appendTranslation($pos.x, $pos.y, $pos.z)

        var $LineDisplaySprite: LineDisplaySprite = CannonLineSprite.boxLineSprite;

        for (var i: number = 0; i < $LineDisplaySprite.lineVecPos.length / 6; i++) {
            var a: Vector3D = new Vector3D($LineDisplaySprite.lineVecPos[i * 6 + 0], $LineDisplaySprite.lineVecPos[i * 6 + 1], $LineDisplaySprite.lineVecPos[i * 6 + 2])
            var b: Vector3D = new Vector3D($LineDisplaySprite.lineVecPos[i * 6 + 3], $LineDisplaySprite.lineVecPos[i * 6 + 4], $LineDisplaySprite.lineVecPos[i * 6 + 5])
            a.x = a.x * $size.x / 100;
            a.y = a.y * $size.y / 100;
            a.z = a.z * $size.z / 100;

            b.x = b.x * $size.x / 100;
            b.y = b.y * $size.y / 100;
            b.z = b.z * $size.z / 100;

            a = m.transformVector(a);
            b = m.transformVector(b);
            tempSprite.makeLineMode(a, b)
        }


    }

}
class CanonPrefabSprite extends ScenePerfab {
 
    public _bodyLineSprite: CannonLineSprite;
    public constructor(value: CANNON.Body) {
        super();
        this.body = value;
    }
    public set body(value: CANNON.Body) {
        this._body = value;
 

        this._bodyLineSprite = new CannonLineSprite()
        this._bodyLineSprite.baseColor = new Vector3D(Math.random() * 0.5 + 0.5, Math.random() * 0.5 + 0.5, Math.random() * 0.5 + 0.5, 1)
        this._bodyLineSprite.setBody(this._body);


        this.mathBodyScale();

    }
    private mathBodyScale(): void
    {
        var $body: CANNON.Body = this._body;
        var arr: Array<number> = null
        for (var i: number = 0; i < $body.shapes.length; i++) {
            var $shapePos: Vector3D = Physics.Vect3dC2W($body.shapeOffsets[i])

            var $shapeQua: Quaternion = Physics.QuaternionCollisionToH5($body.shapeOrientations[i]);

            switch ($body.shapes[i].type) {
                case 1:
                    var $sphere: CANNON.Sphere = <CANNON.Sphere>$body.shapes[i];
                    $shapePos.scaleBy(100 / $sphere.radius)
                  //  this.drawSphereConvexPolyh($sphere.radius, $shapePos, $shapeQua);

                    this.scaleX = $sphere.radius * 1;
                    this.scaleY = $sphere.radius * 1;
                    this.scaleZ = $sphere.radius * 1;


                    this.setModelById(9001);
                    break;
                case 4:
                    var $box: CANNON.Box = <CANNON.Box>$body.shapes[i];
                    var $boxSize: Vector3D = Physics.Vect3dC2W($box.halfExtents);
                    this.scaleX = $boxSize.x * 0.4;
                    this.scaleY = $boxSize.y * 0.4;
                    this.scaleZ = $boxSize.z * 0.4;
                
                    this.setModelById(9002);
                   // this.drawBoxConvexPolyh($boxSize, $shapePos, $shapeQua)
                    break;
                case 16:
                    var $cylinder: CANNON.Cylinder = <CANNON.Cylinder>$body.shapes[i];
                    var $scaleVec:Vector2D=this.drawCylinderConvexPolyh($cylinder, $shapePos, $shapeQua);
   
                    this.scaleX = $scaleVec.x * 1;
                    this.scaleY = $scaleVec.y * 1;
                    this.scaleZ = $scaleVec.x * 1;

                    this.setModelById(9003);
                    break;
                case 32:
                    var $heightField: CANNON.Heightfield = <CANNON.Heightfield>$body.shapes[i];
                     //  this.drawFieldPolyh($heightField, $shapePos, $shapeQua);
                    break;
                case 64:
         
                    this.scaleX = 0.05;
                    this.scaleY = 0.05;
                    this.scaleZ = 0.05;
                    this.setModelById(9001);

                    break;
                default:

                    console.log("mathBodyScale", $body.shapes[i].type)
                    break;
            }
        }
    }
    private drawCylinderConvexPolyh($cylinder: CANNON.Cylinder, $pos: Vector3D, $qua: Quaternion): Vector2D {

        var m: Matrix3D = new Matrix3D;
        $qua.toMatrix3D(m);
        m.invert()
        m.appendTranslation($pos.x, $pos.y, $pos.z)
        var $radius: number = 0;
        var $height:number=0
        for (var i: number = 0; i < $cylinder.faces.length; i++) {
            var a: number = $cylinder.faces[i][0];
            var b: number = $cylinder.faces[i][1];
            var c: number = $cylinder.faces[i][2];
            var d: number = $cylinder.faces[i][3];

            var A: Vector3D = Physics.Vect3dC2W($cylinder.vertices[a])
            var B: Vector3D = Physics.Vect3dC2W($cylinder.vertices[b])
            var C: Vector3D = Physics.Vect3dC2W($cylinder.vertices[c])
            var D: Vector3D = Physics.Vect3dC2W($cylinder.vertices[d])


            $height = Math.max($height, A.y, B.y, C.y, D.y);
         
            $radius = Math.max($radius, A.x * A.x + A.z * A.z)
            $radius = Math.max($radius, B.x * B.x + B.z * B.z)
            $radius = Math.max($radius, C.x * C.x + C.z * C.z)

        }
        return new Vector2D(Math.sqrt($radius) / Physics.baseScale10, $height / Physics.baseScale10)

    }
    public updateMatrix(): void {
    }
    public update(): void {
    }
    protected setModelById($id:number): void
    {
 
        this.addPart("abcdef", "abcdef", getModelUrl(String($id)));
    }
    private _body: CANNON.Body
    public get body(): CANNON.Body {
        return this._body
    }
    public addToWorld(): void
    {
        if (this._body) {
            SceneManager.getInstance().addMovieDisplay(this)
            SceneManager.getInstance().addDisplay(this._bodyLineSprite)
            Physics.world.addBody(this._body)
        }
    }
    public updateFrame(t: number): void {
        super.updateFrame(t);
        if (this._body) {
            this.mathPosMatrix();
        }
    

    
    }
    public mathPosMatrix(): void
    {
        var $ma: Matrix3D = new Matrix3D
        Physics.MathBody2WMatrix3D(this._body, $ma)
        this.posMatrix.m = $ma.m;
        var $shapeQua: Quaternion = Physics.QuaternionCollisionToH5(this._body.shapeOrientations[0]);
        var $m: Matrix3D = $shapeQua.toMatrix3D()
        this.posMatrix.prepend($m);
        this.posMatrix.prependScale(this.scaleX, this.scaleY, this.scaleZ);

    }

 

}

class Physics {
    public static world: CANNON.World;
    private static cannonLast: number = 0;



    constructor() {

    }
    //创建一个世界
    public static creatWorld(): void {
        Physics.world = new CANNON.World();
        Physics.world.gravity = this.Vec3dW2C(new Vector3D(0, -100, 0))
        Physics.materialDic = new Object;

    }

    public static dynamicMaterial: CANNON.Material;
    private static materialDic: Object;
    private static dynamicBodyList: Array<CANNON.Body>;
    private static bodyGameRoleType: number = 1;
    private static bodyGameGroundType: number = 2;

    public static makeGround($pos: Vector3D): void {

        var groundShape = new CANNON.Plane();
        var groundBody = new CANNON.Body({ mass: 0 });
        Physics.bodyAddShape(groundBody, groundShape)
        Physics.world.addBody(groundBody);



    }


    public static bodyAddShape($body: CANNON.Body, $shape: any, $pos: Vector3D = null, $h5q: Vector3D = null) {
        var $angly: CANNON.Quaternion = new CANNON.Quaternion();
        var $setPos: CANNON.Vec3 = new CANNON.Vec3()
        if ($h5q) {
            $angly.x = $h5q.x;
            $angly.y = $h5q.z;
            $angly.z = $h5q.y;
        }
        if ($pos) {
            $setPos = this.Vec3dW2C($pos)
        }
        $body.addShape($shape, $setPos, $angly);
    }
    public static baseScale10: number = 10
    public static Vec3dW2C($pos: Vector3D): CANNON.Vec3 {
        return new CANNON.Vec3($pos.x / this.baseScale10, $pos.z / this.baseScale10, $pos.y / this.baseScale10)
    }
    public static Vect3dC2W($pos: CANNON.Vec3): Vector3D {
        return new Vector3D($pos.x * this.baseScale10, $pos.z * this.baseScale10, $pos.y * this.baseScale10);
    }

    public static QuaternionW2C($q: Quaternion): CANNON.Quaternion {
        return new CANNON.Quaternion($q.x, $q.z, $q.y, $q.w)
    }
    public static setMatrix3DToBody($body: CANNON.Body, $m: Matrix3D): void {
        var q: Quaternion = new Quaternion
        q.fromMatrix($m);
        $body.quaternion = this.QuaternionW2C(q);
    }
    //只有旋转和位移的矩阵
    public static MathBody2WMatrix3D($body: CANNON.Body, $m: Matrix3D = null): Matrix3D {
        if (!$m) {
            $m = new Matrix3D;
        }
        $m.identity();
        var $pos: Vector3D = Physics.Vect3dC2W($body.position);
        if (true) {



            var mt3: CANNON.Mat3 = new CANNON.Mat3();
            var q: CANNON.Quaternion = new CANNON.Quaternion($body.quaternion.x, $body.quaternion.z, $body.quaternion.y, $body.quaternion.w)
            mt3.setRotationFromQuaternion(q);
            $m.m[0] = mt3.elements[0]
            $m.m[1] = mt3.elements[1]
            $m.m[2] = mt3.elements[2]
            $m.m[4] = mt3.elements[3]
            $m.m[5] = mt3.elements[4]
            $m.m[6] = mt3.elements[5]
            $m.m[8] = mt3.elements[6]
            $m.m[9] = mt3.elements[7]
            $m.m[10] = mt3.elements[8]
            $m.appendTranslation($pos.x, $pos.y, $pos.z);
        }
        return $m;





    }
    public static QuaternionSetW2C($q: CANNON.Quaternion, $x: number, $y: number, $z: number, $w: number): void {
        $q.set($x, $z, $y, $w);
    }
    public static QuaternionCollisionToH5($q: CANNON.Quaternion): Quaternion {
        return new Quaternion($q.x, $q.z, $q.y, $q.w)
    }
    public static QuaternionC2Vec3dW($q: CANNON.Quaternion): Vector3D {
        var $v: CANNON.Vec3 = new CANNON.Vec3(0, 0, 0)
        $q.toEuler($v);
        return new Vector3D($v.x, $v.z, $v.y);
    }
    //获取多凸边形Shape
    public static makePolyhedronShape($hitobj: any, $scale: Vector3D): CANNON.ConvexPolyhedron {
        var rawVerts = $hitobj.vertices
        var rawFaces = $hitobj.indexs
        var verts = [], faces = [];
        var bodySize: number = 1;
        var collisionSize: CANNON.Vec3 = Physics.Vec3dW2C($scale)
        for (var j = 0; j < rawVerts.length; j += 3) {
            verts.push(new CANNON.Vec3(
                rawVerts[j + 0] * collisionSize.x,
                rawVerts[j + 2] * collisionSize.y,  //坐标关联，+2为z.和编辑器出来的顶点数据z,y,兑换
                rawVerts[j + 1] * collisionSize.z
            ));
        }
        for (var j = 0; j < rawFaces.length; j += 3) {
            faces.push([rawFaces[j + 0], rawFaces[j + 1], rawFaces[j + 2]]);
        }
        var $polyhedronShape = new CANNON.ConvexPolyhedron(verts, faces);
        return $polyhedronShape;
    }


    public static makeBoxShape($scale: Vector3D): CANNON.Box {
        return new CANNON.Box(Physics.Vec3dW2C($scale))
    }

    public static makeSphereShape($radius: number): CANNON.Sphere {
        return new CANNON.Sphere($radius)
    }

    public static makeCylinderShape($radius: number, $height: number, numSegments: number = 10): CANNON.Cylinder {
        return new CANNON.Cylinder($radius, $radius, $height, numSegments);
    }

    public static getBodyMesh($pos: Vector3D, $mass: number): CANNON.Body {
        var $body: CANNON.Body = new CANNON.Body({
            mass: $mass, // kg
            position: Physics.Vec3dW2C($pos)
        });
        Physics.world.addBody($body)
        return $body;
    }

    public static addDynamicCapsulePhysics($pos: Vector3D, $radius: number, $height: number): CANNON.Body {
        var body: CANNON.Body = Physics.getBodyMesh($pos, 100);
        var sphere: CANNON.Sphere = Physics.makeSphereShape($radius);
        //var cylinder: CANNON.Sphere = Physics.makeCylinderShape($radius, $height);
        Physics.bodyAddShape(body, sphere, new Vector3D(0, $radius, 0));
        // Physics.bodyAddShape(body, cylinder, new Vector3D(0, $radius + $height / 2, 0));
   
        body.material = this.dynamicMaterial;

        body.type = CANNON.Body.DYNAMIC;
        // body.name = "role";
        // body.gameType = this.bodyGameRoleType;

        body.fixedRotation = true;
        body.updateMassProperties();


        Physics.world.addBody(body);

        this.dynamicBodyList.push(body);
        return body;


    }

    public static addStaticPhysics($dis: Display3D, $collisionItemVo: CollisionItemVo): CANNON.Body {

        var body: CANNON.Body = Physics.makeBuildBodyMesh($dis, $collisionItemVo);

        var key: string = String(float2int($collisionItemVo.friction * 100));


        var $buildMaterial: CANNON.Material;

        if (this.materialDic[key]) {
            $buildMaterial = this.materialDic[key];
        } else {
            $buildMaterial = new CANNON.Material();
            $buildMaterial.friction = $collisionItemVo.friction * 0.001;
            $buildMaterial.restitution = $collisionItemVo.restitution;

            var $contactMaterial = new CANNON.ContactMaterial(this.dynamicMaterial, $buildMaterial, {
                friction: $collisionItemVo.friction, restitution: $collisionItemVo.restitution,
                contactEquationStiffness: 1e7, contactEquationRelaxation: 500,
                frictionEquationStiffness: 1e7, frictionEquationRelaxation: 3
            });
            this.world.addContactMaterial($contactMaterial);

            this.materialDic[key] = $buildMaterial;
        }

        body.material = $buildMaterial;

        body.type = CANNON.Body.KINEMATIC;
        Physics.world.addBody(body);
        return body;
    }

    public static removePhysics($body: CANNON.Body): void {
        Physics.world.removeBody($body);
    }

    public static removeAll(): void {
        var bodys: Array<any> = this.world.bodies;
        while (bodys.length) {
            this.removePhysics(bodys[0]);
        }

    }

    //通过objs的数据来生存一个body
    public static makeBuildBodyMesh($dis: Display3D, $collisionItemVo: CollisionItemVo): CANNON.Body {
        var $bodyMesh: CANNON.Body = Physics.getBodyMesh(new Vector3D($dis.x, $dis.y, $dis.z), 100);
        var m: Matrix3D = new Matrix3D;
        m.appendRotation(-$dis.rotationZ, Vector3D.Z_AXIS)
        m.appendRotation(-$dis.rotationY, Vector3D.Y_AXIS)
        m.appendRotation(-$dis.rotationX, Vector3D.X_AXIS)
        var q: Quaternion = new Quaternion;
        q.fromMatrix(m);
        Physics.QuaternionSetW2C($bodyMesh.quaternion, q.x, q.y, q.z, q.w)
        $bodyMesh.type = CANNON.Body.KINEMATIC;
        for (var i: number = 0; i < $collisionItemVo.collisionItem.length; i++) {
            var $vo: CollisionVo = $collisionItemVo.collisionItem[i]
            var $basePos: Vector3D = new Vector3D($vo.x * $dis.scaleX, $vo.y * $dis.scaleY, $vo.z * $dis.scaleZ);
            var $voM: Matrix3D = new Matrix3D
            $voM.appendRotation(-$vo.rotationZ, Vector3D.Z_AXIS)
            $voM.appendRotation(-$vo.rotationY, Vector3D.Y_AXIS)
            $voM.appendRotation(-$vo.rotationX, Vector3D.X_AXIS)
            var $voQ: Quaternion = new Quaternion;
            $voQ.fromMatrix($voM);

            switch ($vo.type) {
                case CollisionType.BOX:
                    var $scale: Vector3D = new Vector3D;
                    $scale.x = $vo.scaleX * $dis.scaleX * 100;
                    $scale.y = $vo.scaleY * $dis.scaleY * 100;
                    $scale.z = $vo.scaleZ * $dis.scaleZ * 100;
                    Physics.bodyAddShape($bodyMesh, Physics.makeBoxShape($scale), $basePos, new Vector3D($voQ.x, $voQ.y, $voQ.z))
                    break;
                case CollisionType.BALL:
                    var radiusNum: number = ($dis.scaleX + $dis.scaleY + $dis.scaleZ) / 3//0.17
                    radiusNum = (radiusNum * $vo.radius)
                    Physics.bodyAddShape($bodyMesh, Physics.makeSphereShape(radiusNum), $basePos, new Vector3D($voQ.x, $voQ.y, $voQ.z))
                    break;
                case CollisionType.Polygon:
                    var $scaleVec: Vector3D = new Vector3D($dis.scaleX * $vo.scaleX, $dis.scaleY * $vo.scaleY, $dis.scaleZ * $vo.scaleZ);
                    var $polyhed: CANNON.ConvexPolyhedron = Physics.makePolyhedronShape($vo.data, $scaleVec)
                    //$bodyMesh.addShape($polyhed, Physics.getPhysicsV3D($basePos))

                    Physics.bodyAddShape($bodyMesh, $polyhed, $basePos, new Vector3D($voQ.x, $voQ.y, $voQ.z))
                    break;
                default:
                    break;

            }
        }

        return $bodyMesh

    }
    //创建整个场景的静态碰撞体
    public static makeSceneCollision(arr: Array<any>): Array<CANNON.Body> {

        var $bodyItem: Array<CANNON.Body> = new Array()
        for (var i: number = 0; i < arr.length; i++) {

            var $bodyMesh: CANNON.Body = Physics.getBodyMesh(new Vector3D(), 100);
            $bodyItem.push($bodyMesh)

            var $buildMaterial: CANNON.Material;

            /*
            var key: string = String(float2int(Number(arr[i].friction) * 100));
            if (this.materialDic[key]) {
                $buildMaterial = this.materialDic[key];
            } else {
                $buildMaterial = new CANNON.Material();
                $buildMaterial.friction = Number(arr[i].friction)* 0.001;
                $buildMaterial.restitution = Number(arr[i].restitution);

                var $contactMaterial = new CANNON.ContactMaterial(this.dynamicMaterial, $buildMaterial, {
                    friction: Number(arr[i].friction), restitution: Number(arr[i].restitution),
                    contactEquationStiffness: 1e7, contactEquationRelaxation: 500,
                    frictionEquationStiffness: 1e7, frictionEquationRelaxation: 3
                });
           
                this.world.addContactMaterial($contactMaterial);

                this.materialDic[key] = $buildMaterial;
            }
            $bodyMesh.material = $buildMaterial;
            */
            $bodyMesh.type = CANNON.Body.KINEMATIC;


            // $h5CollistionVo.friction = $spriet.objData.friction;
            // $h5CollistionVo.restitution = $spriet.objData.restitution;

            var $dis: any = new Object;
            $dis.x = Number(arr[i].x);
            $dis.y = Number(arr[i].y);
            $dis.z = Number(arr[i].z);
            $dis.scaleX = Number(arr[i].scale_x);
            $dis.scaleY = Number(arr[i].scale_y);
            $dis.scaleZ = Number(arr[i].scale_z);
            $dis.rotationX = Number(arr[i].rotationX);
            $dis.rotationY = Number(arr[i].rotationY);
            $dis.rotationZ = Number(arr[i].rotationZ);

            $dis.posMatrix = new Matrix3D
            $dis.posMatrix.appendScale($dis.scaleX, $dis.scaleY, $dis.scaleZ);
            $dis.posMatrix.appendRotation($dis.rotationX, Vector3D.X_AXIS);
            $dis.posMatrix.appendRotation($dis.rotationY, Vector3D.Y_AXIS);
            $dis.posMatrix.appendRotation($dis.rotationZ, Vector3D.Z_AXIS);
            $dis.posMatrix.appendTranslation($dis.x, $dis.y, $dis.z);


            var $vo: any = arr[i].collisionVo;
            var $collisionVo: CollisionVo = new CollisionVo()
            $collisionVo.x = Number($vo.x);
            $collisionVo.y = Number($vo.y);
            $collisionVo.z = Number($vo.z);
            $collisionVo.scaleX = Number($vo.scale_x);
            $collisionVo.scaleY = Number($vo.scale_y);
            $collisionVo.scaleZ = Number($vo.scale_z);
            $collisionVo.rotationX = Number($vo.rotationX);
            $collisionVo.rotationY = Number($vo.rotationY);
            $collisionVo.rotationZ = Number($vo.rotationZ);

            $collisionVo.type = Number($vo.type);


            var $voM: Matrix3D = new Matrix3D;

            $voM.appendRotation(-$collisionVo.rotationZ, Vector3D.Z_AXIS);
            $voM.appendRotation(-$collisionVo.rotationY, Vector3D.Y_AXIS);
            $voM.appendRotation(-$collisionVo.rotationX, Vector3D.X_AXIS);


            $voM.appendRotation(-$dis.rotationZ, Vector3D.Z_AXIS);
            $voM.appendRotation(-$dis.rotationY, Vector3D.Y_AXIS);
            $voM.appendRotation(-$dis.rotationX, Vector3D.X_AXIS);


            var $voQ: Quaternion = new Quaternion;
            $voQ.fromMatrix($voM);

            var $basePos: Vector3D = $dis.posMatrix.transformVector(new Vector3D($collisionVo.x, $collisionVo.y, $collisionVo.z));
            $bodyMesh.position = Physics.Vec3dW2C($basePos);
            $bodyMesh.quaternion = Physics.QuaternionW2C($voQ)
            switch ($collisionVo.type) {
                case CollisionType.BOX:
                    var $scale: Vector3D = new Vector3D;
                    $scale.x = $dis.scaleX * $collisionVo.scaleX * 100;
                    $scale.y = $dis.scaleY * $collisionVo.scaleY * 100;
                    $scale.z = $dis.scaleZ * $collisionVo.scaleZ * 100;
                    Physics.bodyAddShape($bodyMesh, Physics.makeBoxShape($scale))
                    break;
                case CollisionType.BALL:
                    $collisionVo.radius = $vo.radius;
                    var radiusNum: number = ($dis.scaleX + $dis.scaleY + $dis.scaleZ) / 3
                    radiusNum = (radiusNum * $collisionVo.radius)
                    Physics.bodyAddShape($bodyMesh, Physics.makeSphereShape(radiusNum))
                    break;
                case CollisionType.Cylinder:
                    Physics.bodyAddShape($bodyMesh, Physics.makeCylinderShape(($collisionVo.scaleX * $dis.scaleX) * 100, $collisionVo.scaleY * $dis.scaleY * 100))
                    break;
                case CollisionType.Cone:
                    //  Physics.bodyAddShape($bodyMesh, Physics.make(($collisionVo.scaleX * $dis.scaleX) * 100, $collisionVo.scaleY * $dis.scaleY * 100), $basePos, $voQ)
                    break;
                case CollisionType.Polygon:
                    $collisionVo.data = $vo.data;
                    var $scaleVec: Vector3D = new Vector3D($collisionVo.scaleX * $dis.scaleX, $collisionVo.scaleY * $dis.scaleY, $collisionVo.scaleZ * $dis.scaleZ);
                    var $polyhed: CANNON.ConvexPolyhedron = Physics.makePolyhedronShape($collisionVo.data, $scaleVec)
                    Physics.bodyAddShape($bodyMesh, $polyhed)
                    break;
                default:
                    break;

            }


        }
        return $bodyItem;
    }
    public static makeFieldForArr(posItem: Array<any>, $scaleNum: number): CANNON.Body {

        var sizeX: number = posItem.length;
        var sizeY: number = posItem[0].length;
        var num10: number = $scaleNum
        var hfShape: CANNON.Heightfield = new CANNON.Heightfield(posItem, {
            elementSize: num10
        });
        var hfBody: CANNON.Body = new CANNON.Body({ mass: 0 });
        var fieldPos: Vector3D = new Vector3D(-(sizeX * num10 / 2) + num10 / 2, 0, -(sizeY * num10 / 2) + num10 / 2)
        //  hfBody.addShape(hfShape, fieldPos);

        hfBody.gameType = 2


        hfBody.type = CANNON.Body.KINEMATIC;
        Physics.bodyAddShape(hfBody, hfShape, fieldPos)
        Physics.world.addBody(hfBody);
        return hfBody
    }
    public static ready: boolean = false;
    public static update(): void {
        if (this.world && this.ready) {
            var $nowData: Date = new Date;
            var $timeNum: number = $nowData.getTime() - this.cannonLast;
            var dt = $timeNum / 1000;
            var maxSubSteps = 1;
            //Physics.world.step(1 / 60, dt, maxSubSteps);
            Physics.world.step(1 / 60, 1 / 60, maxSubSteps);
            this.cannonLast = $nowData.getTime();

        }
    }




}
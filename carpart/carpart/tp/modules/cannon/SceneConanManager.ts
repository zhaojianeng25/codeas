
class SceneConanManager {

    private static _instance: SceneConanManager;
    public static getInstance(): SceneConanManager {
        if (!this._instance) {
            this._instance = new SceneConanManager();
        }
        return this._instance;
    }
    constructor() {
     
    }
    private addMoveBox($pos: Vector3D, $scale: number = 10): void {

        var $box: CANNON.Shape = new CANNON.Box(Physics.Vec3dW2C(new Vector3D($scale, $scale, $scale)));
        var $body: CANNON.Body = new CANNON.Body({ mass: 1 });
        $body.addShape($box);
        $body.position = Physics.Vec3dW2C($pos)
        $body.linearDamping = $body.angularDamping = 0.5;
        var $dis: CanonPrefabSprite = new CanonPrefabSprite($body)
        $dis.addToWorld();
    }
    public addMoveSphere($pos: Vector3D, $scale: number = 10): void {

        var $sphere: CANNON.Shape = new CANNON.Sphere($scale / Physics.baseScale10)
        var $body: CANNON.Body = new CANNON.Body({ mass: 1 });
        $body.addShape($sphere);
        // $body.position.set($pos.x, $pos.z, $pos.y)
        $body.position = Physics.Vec3dW2C($pos)
        $body.linearDamping = $body.angularDamping = 0.5;
        var $dis: CanonPrefabSprite = new CanonPrefabSprite($body)
        $dis.addToWorld();
    }

    public addMoveCylinder($pos: Vector3D, $scale: number = 10): void {

        var kkk: CANNON.Vec3 = Physics.Vec3dW2C(new Vector3D($scale, $scale, $scale))
        var $box: CANNON.Cylinder = new CANNON.Cylinder(kkk.x, kkk.y, kkk.z, 20)
        var $body: CANNON.Body = new CANNON.Body({ mass: 1 });
        $body.addShape($box);
        $body.position = Physics.Vec3dW2C($pos)
        $body.linearDamping = $body.angularDamping = 0.5;
        var $dis: CanonPrefabSprite = new CanonPrefabSprite($body)
        $dis.addToWorld();
    }


    private creatWorld(): void {

        Physics.world = new CANNON.World();
        Physics.world.gravity = Physics.Vec3dW2C(new Vector3D(0, -1000, 0))
        Physics.world.broadphase = new CANNON.NaiveBroadphase();


    }
    public makeGround($pos: Vector3D): void {

        var groundShape: CANNON.Plane = new CANNON.Plane();
        var groundBody: CANNON.Body = new CANNON.Body({ mass: 0 });
        groundBody.addShape(groundShape);
        groundBody.position.set(0, 0, 0);
        groundBody.gameType = 2
        Physics.world.addBody(groundBody);


    }
    public makeExpSceneCollisionItem($arr: Array<any>): void {
        if ($arr) {
            var $bodyItem: Array<CANNON.Body> = Physics.makeSceneCollision($arr)
            if (true) {
                for (var i: number = 0; i < $bodyItem.length; i++) {
                    var $dis: CanonPrefabSprite = new CanonPrefabSprite($bodyItem[i]);
                    $dis.addToWorld();
                    Physics.world.addBody($bodyItem[i]);
                }
            }
        }
    }
   
  
   
}
class Collisions_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {



      //  this.Sphere_sphere();
    //    this.Sphere_box()
        this.Sphere_boxcorner()
    }
    private Sphere_boxcorner(): void
    {
        var world: CANNON.World = Physics.world;
        world.gravity.set(0, 0, -0);

        var boxShape = new CANNON.Box(new CANNON.Vec3(1, 1, 1));
        var sphereShape = new CANNON.Sphere(1);

        // Box
        var b1 = new CANNON.Body({ mass: 5 });
        b1.addShape(boxShape);
        b1.position.set(5, 0, 2);
        b1.velocity.set(-5, 0, 0);
        b1.linearDamping = 0;
        var q1 = new CANNON.Quaternion();
        q1.setFromAxisAngle(new CANNON.Vec3(0, 0, 1), Math.PI * 0.25);
        var q2 = new CANNON.Quaternion();
        q2.setFromAxisAngle(new CANNON.Vec3(0, 1, 0), Math.PI * 0.25);
        var q = q1.mult(q2);
        b1.quaternion.set(q.x, q.y, q.z, q.w);
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(b1)
        $disLock.addToWorld();

        // Sphere
        var b2 = new CANNON.Body({ mass: 5 });
        b2.addShape(sphereShape);
        b2.position.set(-5, 0, 2);
        b2.velocity.set(5, 0, 0);
        b2.linearDamping = 0;
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(b2)
        $disLock.addToWorld();
    }
    private Sphere_box(): void
    {
        var world: CANNON.World = Physics.world;
        world.gravity.set(0, 0, -0);


        var boxShape = new CANNON.Box(new CANNON.Vec3(1, 1, 1));
        var sphereShape = new CANNON.Sphere(1);

        // Box
        var b1 = new CANNON.Body({ mass: 5 });
        b1.addShape(boxShape);
        b1.position.set(5, 0, 2);
        b1.velocity.set(-5, 0, 0);
        b1.linearDamping = 0;
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(b1)
        $disLock.addToWorld();

        // Sphere
        var b2 = new CANNON.Body({ mass: 5 });
        b2.addShape(sphereShape);
        b2.position.set(-5, 0, 2);
        b2.velocity.set(5, 0, 0);
        b2.linearDamping = 0;
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(b2)
        $disLock.addToWorld();

    } 
    private Sphere_sphere(): void
    {
        var world: CANNON.World = Physics.world;
        world.gravity.set(0, 0, -0);
        var sphereShape = new CANNON.Sphere(1);
        var b1 = new CANNON.Body({ mass: 5 });
        b1.addShape(sphereShape);
        b1.position.set(5, 0, 1);
        b1.velocity.set(-5, 0, 0);
        b1.linearDamping = 0;
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(b1)
        $disLock.addToWorld();

        // Sphere 2
        var b2 = new CANNON.Body({ mass: 5 });
        b2.addShape(sphereShape);
        b2.linearDamping = 0;
        b2.position.set(-5, 0, 1);
        b2.velocity.set(5, 0, 0);
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(b2)
        $disLock.addToWorld();
    }

}
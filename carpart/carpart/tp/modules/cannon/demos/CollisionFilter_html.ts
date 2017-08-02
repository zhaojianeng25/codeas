class CollisionFilter_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {
        var size = 1;
        var mass = 1;

        // Collision filter groups - must be powers of 2!
        var GROUP1 = 1;
        var GROUP2 = 2;
        var GROUP3 = 4;

        var world: CANNON.World = Physics.world;

        world.gravity.set(0, 0, 0); // no gravity
        world.broadphase = new CANNON.NaiveBroadphase();
     //   world.solver.iterations = 5;

        // Sphere
        var sphereShape = new CANNON.Sphere(size);
        var sphereBody = new CANNON.Body({
            mass: mass,
            position: new CANNON.Vec3(5, 0, 5),
            velocity: new CANNON.Vec3(-5, 0, 0),
            collisionFilterGroup: GROUP1, // Put the sphere in group 1
            collisionFilterMask: GROUP2 | GROUP3, // It can only collide with group 2 and 3
            shape: sphereShape
        });

        // Box
        var boxBody = new CANNON.Body({
            mass: mass,
            position: new CANNON.Vec3(0, 0, 5),
            shape: new CANNON.Box(new CANNON.Vec3(size, size, size)),
            collisionFilterGroup: GROUP2, // Put the box in group 2
            collisionFilterMask: GROUP1 // It can only collide with group 1 (the sphere)
        });

        // Cylinder
        var cylinderShape = new CANNON.Cylinder(size, size, size * 2.2, 10);
        var cylinderBody = new CANNON.Body({
            mass: mass,
            shape: cylinderShape,
            position: new CANNON.Vec3(-5, 0, 5),
            collisionFilterGroup: GROUP3, // Put the cylinder in group 3
            collisionFilterMask: GROUP1 // It can only collide with group 1 (the sphere)
        });

        // Add everything to the world and demo
    

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(sphereBody)
        $disLock.addToWorld();

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxBody)
        $disLock.addToWorld();

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(cylinderBody)
        $disLock.addToWorld();


    }

}
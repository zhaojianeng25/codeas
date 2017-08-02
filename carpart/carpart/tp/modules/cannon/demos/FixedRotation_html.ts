class FixedRotation_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {
        var world: CANNON.World = Physics.world;

         var    size = 1.0;

        world.broadphase = new CANNON.NaiveBroadphase();

        // ground plane


        // Create a box with fixed rotation
        var shape = new CANNON.Box(new CANNON.Vec3(size, size, size));
        var boxBody = new CANNON.Body({ mass: 1 });
        boxBody.addShape(shape);
        boxBody.position.set(0, 0, size);
        boxBody.fixedRotation = true;
        boxBody.updateMassProperties();
 

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxBody)
        $disLock.addToWorld();

        // Another one
        var shape2 = new CANNON.Box(new CANNON.Vec3(size, size, size));
        var boxBody2 = new CANNON.Body({ mass: 1, });
        boxBody2.addShape(shape2);
        boxBody2.position.set(size * 3 / 2, 0, size * 4);
        boxBody2.fixedRotation = true;
        boxBody2.updateMassProperties();


        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxBody2)
        $disLock.addToWorld();

        // Change gravity so the boxes will slide along x axis
        world.gravity.set(0, 0, -10);



    }
}
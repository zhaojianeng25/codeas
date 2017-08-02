class Friction_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {
        var world: CANNON.World = Physics.world;
        var size:number=1.0
        var shape = new CANNON.Box(new CANNON.Vec3(size, size, size));

        // Create world
 
        world.broadphase = new CANNON.NaiveBroadphase();
        world.iterations = 10;

        // Materials
        var groundMaterial = new CANNON.Material("groundMaterial");

        // Adjust constraint equation parameters for ground/ground contact
        var ground_ground_cm = new CANNON.ContactMaterial(groundMaterial, groundMaterial, {
            friction: 0.4,
            restitution: 0.3,
            contactEquationStiffness: 1e8,
            contactEquationRelaxation: 3,
            frictionEquationStiffness: 1e8,
            frictionEquationRegularizationTime: 3,
        });

        // Add contact material to the world
        world.addContactMaterial(ground_ground_cm);

        // ground plane
        var groundShape = new CANNON.Plane();
        var groundBody = new CANNON.Body({ mass: 0, material: groundMaterial });
        groundBody.addShape(groundShape);
        world.addBody(groundBody);
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(groundBody)
        $disLock.addToWorld();

        // Create a slippery material (friction coefficient = 0.0)
        var slipperyMaterial = new CANNON.Material("slipperyMaterial");

        // The ContactMaterial defines what happens when two materials meet.
        // In this case we want friction coefficient = 0.0 when the slippery material touches ground.
        var slippery_ground_cm = new CANNON.ContactMaterial(groundMaterial, slipperyMaterial, {
            friction: 0,
            restitution: 0.3,
            contactEquationStiffness: 1e8,
            contactEquationRelaxation: 3
        });

        // We must add the contact materials to the world
        world.addContactMaterial(slippery_ground_cm);


        // Create slippery box
        var boxBody = new CANNON.Body({ mass: 1, material: slipperyMaterial });
        boxBody.addShape(shape);
        boxBody.position.set(0, 5, 5);
        world.addBody(boxBody);
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxBody)
        $disLock.addToWorld();

        // Create box made of groundMaterial
        var boxBody2 = new CANNON.Body({ mass: 10, material: groundMaterial });
        boxBody2.addShape(shape);
        boxBody2.position.set(size * 4, 0, 5);
        world.addBody(boxBody2);
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxBody2)
        $disLock.addToWorld();

        // Change gravity so the boxes will slide along x axis
        world.gravity.set(-1, 0, -60);



        /*
        var  size = 1.0;

        var shape = new CANNON.Box(new CANNON.Vec3(size, size, size));

        // Create world

        world.broadphase = new CANNON.NaiveBroadphase();
        world.iterations = 10;

        // Materials
        var groundMaterial = new CANNON.Material("groundMaterial");

        // Adjust constraint equation parameters for ground/ground contact
        var ground_ground_cm = new CANNON.ContactMaterial(groundMaterial, groundMaterial, {
            friction: 0.4,
            restitution: 0.3,
            contactEquationStiffness: 1e8,
            contactEquationRelaxation: 3,
            frictionEquationStiffness: 1e8,
            frictionEquationRegularizationTime: 3,
        });

        // Add contact material to the world
        world.addContactMaterial(ground_ground_cm);

        // ground plane
        var groundShape = new CANNON.Plane();
        var groundBody = new CANNON.Body({ mass: 0, material: groundMaterial });
       
        groundBody.addShape(groundShape);
     
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(groundBody)
        $disLock.addToWorld();

        // Create a slippery material (friction coefficient = 0.0)
        var slipperyMaterial = new CANNON.Material("slipperyMaterial");

        // The ContactMaterial defines what happens when two materials meet.
        // In this case we want friction coefficient = 0.0 when the slippery material touches ground.
        var slippery_ground_cm = new CANNON.ContactMaterial(groundMaterial, slipperyMaterial, {
            friction: 0.001,
            restitution: 0.3,
            contactEquationStiffness: 1e8,
            contactEquationRelaxation: 3
        });

        // We must add the contact materials to the world
        world.addContactMaterial(slippery_ground_cm);

        // Create slippery box
        var boxBody = new CANNON.Body({ mass: 1, material: slipperyMaterial });
        boxBody.addShape(shape);
        boxBody.position.set(0, 0, 5);
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxBody)
        $disLock.addToWorld();

        // Create box made of groundMaterial
        var boxBody2 = new CANNON.Body({ mass: 10, material: groundMaterial });
        boxBody2.addShape(shape);
        boxBody2.position.set(size * 4, 0, 5);
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxBody2)
        $disLock.addToWorld();

        // Change gravity so the boxes will slide along x axis
        world.gravity.set(-0, 0, -60);
        */

    }
}
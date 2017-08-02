class Heightfield_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {

        var world: CANNON.World = Physics.world;
        world.gravity.set(0, 0, -10);

        // Create a matrix of height values
        var matrix = [];
        var sizeX = 15,
            sizeY = 15;
        for (var i = 0; i < sizeX; i++) {
            matrix.push([]);
            for (var j = 0; j < sizeY; j++) {
                var height = Math.cos(i / sizeX * Math.PI * 2) * Math.cos(j / sizeY * Math.PI * 2) + 2;
                if (i === 0 || i === sizeX - 1 || j === 0 || j === sizeY - 1)
                    height = 3;
                matrix[i].push(height);
            }
        }

        // Create the heightfield
        var hfShape = new CANNON.Heightfield(matrix, {
            elementSize: 1
        });
        var hfBody = new CANNON.Body({ mass: 0 });
        hfBody.addShape(hfShape);
        hfBody.position.set(0,0,0);


        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(hfBody)
        $disLock.addToWorld();

   

        // Add spheres
        var mass = 1;
        for (var i = 0; i < sizeX - 1; i++) {
            for (var j = 0; j < sizeY - 1; j++) {
                if (i === 0 || i >= sizeX - 2 || j === 0 || j >= sizeY - 2)
                    continue;
                var sphereShape = new CANNON.Sphere(0.1);
                var sphereBody = new CANNON.Body({ mass: mass });
                sphereBody.addShape(sphereShape);
                sphereBody.position.set(0.25 + i, 0.25 + j, 3);
                sphereBody.position.vadd(hfBody.position, sphereBody.position);
                console.log(sphereBody.position)
                var $disLock: CanonPrefabSprite = new CanonPrefabSprite(sphereBody)
                $disLock.addToWorld();
            }
        }

        
    }
}
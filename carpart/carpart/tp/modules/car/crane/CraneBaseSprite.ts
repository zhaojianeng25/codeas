class CraneBaseSprite extends CarBodySprite {


    private modelScenePerfab: ScenePerfab;
    constructor($x: number = 0, $y: number = 0, $z: number = 0) {
        super($x, $y, $z);
    }
    protected initData(): void {
        super.initData();
        this.addEvent();
        this.inidModel();
    }
    private inidModel(): void
    {
        this.modelScenePerfab = new ScenePerfab()
        SceneManager.getInstance().addMovieDisplay(this.modelScenePerfab);
        this.modelScenePerfab.setPerfabName("6409")


    }
    public upData(): void {
        super.upData();
        if (this.carvehicle) {
            var $ma: Matrix3D = new Matrix3D
            Physics.MathBody2WMatrix3D(this.carvehicle.chassisBody, $ma)
            this.modelScenePerfab.posMatrix.m = $ma.m;
            var $shapeQua: Quaternion = Physics.QuaternionCollisionToH5(this.carvehicle.chassisBody.shapeOrientations[0]);
            var $m: Matrix3D = $shapeQua.toMatrix3D();
            this.modelScenePerfab.posMatrix.prepend($m);


            var $vo0: CarOptions = <CarOptions>this.carvehicle.wheelInfos[0];
            var $vo1: CarOptions = <CarOptions>this.carvehicle.wheelInfos[1];
          //  console.log($vo0.worldTransform.position);
          //  console.log($vo1.worldTransform.position);


            var a0: CANNON.Vec3 = new CANNON.Vec3;
            this.carvehicle.getVehicleAxisWorld(1, a0);
       //     console.log(a0)

            var t: any = this.carvehicle.wheelInfos[1].worldTransform;
      
            


       
        }

    }

    private addEvent(): void {

        document.addEventListener(MouseType.KeyDown, ($evt: KeyboardEvent) => { this.onKeyDown($evt) })
        document.addEventListener(MouseType.KeyUp, ($evt: KeyboardEvent) => { this.onKeyDown($evt) })
    }
    private onKeyDown($evt: KeyboardEvent): void {
        if (this.carvehicle) {
            this.keyCodeTo($evt)
        }
    }
   
    public clearForce(): void
    {
        this.carvehicle.chassisBody.velocity.set(0, 0, 0);
    }
    private keyCodeTo(event: KeyboardEvent): void {
        var maxSteerVal = 0.5;
        var maxForce = 3 * 100;
        var brakeForce = 1000000;
        var vehicle = this.carvehicle;

        var up = (event.type == 'keyup');

        if (!up && event.type !== 'keydown') {
            return;
        }

        vehicle.setBrake(0, 0);
        vehicle.setBrake(0, 1);
        vehicle.setBrake(0, 2);
        vehicle.setBrake(0, 3);

        switch (event.keyCode) {

            case 38: // forward
                vehicle.applyEngineForce(up ? 0 : -maxForce, 2);
                vehicle.applyEngineForce(up ? 0 : -maxForce, 3);
                break;

            case 40: // backward
                vehicle.applyEngineForce(up ? 0 : maxForce, 2);
                vehicle.applyEngineForce(up ? 0 : maxForce, 3);
                break;

            case 66: // b
                vehicle.setBrake(brakeForce, 0);
                vehicle.setBrake(brakeForce, 1);
                vehicle.setBrake(brakeForce, 2);
                vehicle.setBrake(brakeForce, 3);
                break;

            case 39: // right
                vehicle.setSteeringValue(up ? 0 : -maxSteerVal, 0);
                vehicle.setSteeringValue(up ? 0 : -maxSteerVal, 1);
                break;

            case 37: // left
                vehicle.setSteeringValue(up ? 0 : maxSteerVal, 0);
                vehicle.setSteeringValue(up ? 0 : maxSteerVal, 1);
                break;

        }
    }
}
interface Imachine {
    upData();
}

class BaseMachine extends Object3D  implements  Imachine {
    constructor($x: number = 0, $y: number = 0, $z: number = 0) {
        super($x, $y, $z);
        this.initData();
    }
    protected initData(): void {

    }
    public upData(): void {

    }



}
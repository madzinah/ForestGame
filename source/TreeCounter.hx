package ;
class TreeCounter {

    public static var counter(default,default):Int;

    public function new() {
        counter = 1;
    }

    public function get_counter() {
        return counter++;
    }

    public function look_counter() {
        return counter;
    }

    public function reset() {
        counter = 1;
    }

}

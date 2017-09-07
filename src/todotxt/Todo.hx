package todotxt;

class Todo {
    private var source:String;
    public var tasks:Array<Task>;

    public function new(?source:String) {
        this.source = source;
        load(this.source);
    }

    public function load(source:String):Void {
        tasks = new Array<Task>();
        if(source == null) return;
        this.source = source;

        for(line in source.split('\n')) {
            tasks.push(new Task(line));
        }
    }
}
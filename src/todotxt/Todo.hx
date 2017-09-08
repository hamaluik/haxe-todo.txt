package todotxt;

import haxe.Unserializer;
import haxe.Serializer;
using Lambda;

/**
 *  A todo.txt list of tasks
 */
class Todo {
    /**
       The list of parsed tasks
     */
    public var tasks:Array<Task>;

    private var source:String;

    private static var newLine:String = {
        #if sys
        if(Sys.systemName() == "Windows") '\r\n';
        else #end '\n';
    };

    /**
       Constructs a todo list
       @param source If this parameter is given, it is passed to `parse()` and parsed immediately
     */
    public function new(?source:String) {
        this.source = source;
        parse(this.source);
    }

    /**
       Reads a newline-delimited string of todo.txt tasks
       @param source The list of tasks to read
     */
    public function parse(source:String):Void {
        tasks = new Array<Task>();
        if(source == null) return;
        this.source = source;
        tasks = source.split('\n').map(function(l:String):Task { return new Task(l); });
    }

    /**
       Converts the internal task list to a plain string to be stored in a todo.txt
       @return String
     */
    public function render():String {
        return tasks.map(function(t:Task):String { return t.render(); }).join(newLine);
    }

    /**
       Convenience utility for `render()`
       @return String
     */
    public function toString():String {
        return render();
    }

    @:keep
    function hxSerialize(s:Serializer) {
        s.serialize(render());
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        var content:String = u.unserialize();
        parse(content);
    }
}